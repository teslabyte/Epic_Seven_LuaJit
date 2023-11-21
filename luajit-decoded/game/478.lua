function MsgHandler.get_reward_character_system(arg_1_0)
	Account:addReward(arg_1_0.result, {
		content = "chrrwd"
	})
	
	if arg_1_0.destiny_id then
		Destiny:playStory({
			dupl_token = arg_1_0.dupl_token
		})
		Account:setDestinyData(arg_1_0.destiny_id)
		DestinyCategory:updateCompletRewardedUI(arg_1_0.destiny_id)
		Destiny:updateData()
		Destiny:updateInfo()
		DestinyAchieveList:ItemListRefresh()
		DestinyCategory:updateSelectUI()
		TutorialGuide:procGuide("c3026_destiny")
	end
	
	Destiny:updateUI()
end

function MsgHandler.clear_destiny_achievement(arg_2_0)
	local var_2_0 = {
		title = T("clear_destiny_title"),
		desc = T("clear_destiny_reward_msg")
	}
	
	Account:addReward(arg_2_0.rewards, {
		play_reward_data = var_2_0,
		handler = function()
			TutorialGuide:procGuide("c3026_destiny")
		end
	})
	Account:setDestinyAchieve(arg_2_0.contents_id, arg_2_0.achieve_doc)
	Destiny:updateData()
	Destiny:updateInfo()
	DestinyCategory:updateSelectUI()
	DestinyAchieveList:ItemListRefresh()
	Destiny:playBalloonMsg(arg_2_0.contents_id)
	TutorialGuide:procGuide("c3026_destiny")
end

function MsgHandler.give_destiny_achievement(arg_4_0)
	Account:addReward(arg_4_0.result)
	Account:setDestinyAchieve(arg_4_0.contents_id, arg_4_0.achieve_doc)
	
	if arg_4_0.conditions and arg_4_0.conditions.clear_conditions then
		for iter_4_0, iter_4_1 in pairs(arg_4_0.conditions.clear_conditions) do
			ConditionContentsManager:setConditionGroupData(iter_4_1)
		end
		
		for iter_4_2, iter_4_3 in pairs(arg_4_0.conditions.update_conditions or {}) do
			ConditionContentsManager:setConditionGroupData(iter_4_3)
		end
	end
	
	Destiny:updateData()
	Destiny:updateInfo()
	DestinyCategory:updateSelectUI()
	DestinyAchieveList:ItemListRefresh()
	balloon_message_with_sound("success_give_destiny")
end

function HANDLER.destiny(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_bbs" then
		Destiny:showReview()
	end
	
	if arg_5_1 == "btn__book" then
		Destiny:showCollectionDetail()
	end
	
	if arg_5_1 == "btn_complete" then
		if arg_5_0.state == 0 then
			balloon_message_with_sound("destiny_mission_ing")
		elseif arg_5_0.state == 1 then
			query("get_reward_character_system", {
				destiny_id = arg_5_0.destiny_id
			})
		elseif arg_5_0.state == 2 then
			balloon_message_with_sound("destiny_already_clear")
		end
	end
	
	if arg_5_1 ~= "btn_go" or arg_5_0.state >= 2 then
	elseif arg_5_0.state == 1 then
		query("clear_destiny_achievement", {
			contents_id = arg_5_0.contents_id
		})
	elseif arg_5_0.state == 0 then
		if arg_5_0.give_code then
			Destiny:showPresentWnd(nil, arg_5_0.contents_id, arg_5_0.give_code, arg_5_0.give_count)
		else
			movetoPath(arg_5_0.btn_move)
		end
	end
end

function HANDLER.destiny_present(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_close" or arg_6_1 == "btn_cancel" then
		Dialog:close("destiny_present")
	end
	
	if arg_6_1 == "btn_present" then
		if arg_6_0.parent and arg_6_0.parent.giveItem then
			arg_6_0.parent:giveItem(arg_6_0)
		elseif arg_6_0.contents_type then
			local var_6_0 = ConditionContentsManager:getContents(arg_6_0.contents_type)
			
			if var_6_0 then
				var_6_0:giveQuery(arg_6_0)
			end
		end
	end
end

Destiny = Destiny or {}

function Destiny.isVisible(arg_7_0)
	return arg_7_0.vars and get_cocos_refid(arg_7_0.vars.wnd)
end

function Destiny.show(arg_8_0, arg_8_1, arg_8_2)
	arg_8_2 = arg_8_2 or {}
	
	if SceneManager:getCurrentSceneName() ~= "lobby" then
		arg_8_2.hide_parent = true
		
		SceneManager:nextScene("lobby", {
			open_destiny = {
				char_code = arg_8_1,
				opts = arg_8_2
			}
		})
		
		return 
	end
	
	arg_8_0.vars = {}
	arg_8_0.vars.class_change_turn_back_id = arg_8_2.class_change_turn_back_id
	
	arg_8_0:updateData(arg_8_1)
	arg_8_0:checkNew()
	
	for iter_8_0, iter_8_1 in pairs(arg_8_0.vars.category_db) do
		if arg_8_1 and arg_8_1 == iter_8_1.char_id then
			arg_8_0.vars.select_info = iter_8_1
			
			break
		elseif arg_8_1 == nil and iter_8_1.is_start then
			arg_8_0.vars.select_info = iter_8_1
			
			break
		end
	end
	
	if not arg_8_0.vars.select_info then
		arg_8_0.vars = {}
		
		return 
	end
	
	arg_8_0.vars.wnd = load_dlg("destiny", true, "wnd")
	
	arg_8_0:_customSetupForPub()
	
	if arg_8_2.hide_parent then
		arg_8_0:hideParent()
	end
	
	if_set_opacity(arg_8_0.vars.wnd, nil, 0)
	UIAction:Add(SEQ(FADE_IN(200), CALL(arg_8_0.hideParent, arg_8_0)), arg_8_0.vars.wnd, "block")
	DestinyCategory:create(arg_8_0.vars.wnd, arg_8_1, arg_8_0.vars.category_db, arg_8_0.vars.select_info)
	arg_8_0:updateUI()
	SceneManager:getRunningPopupScene():addChild(arg_8_0.vars.wnd)
	
	if not arg_8_2.enter then
		local var_8_0 = arg_8_0.vars.wnd:getChildByName("LEFT")
		local var_8_1 = arg_8_0.vars.wnd:getChildByName("RIGHT")
		local var_8_2 = arg_8_0.vars.wnd:getChildByName("CENTER")
		
		var_8_0:setPositionX(-400)
		
		local var_8_3 = var_8_2:getPositionX()
		local var_8_4 = var_8_2:getPositionY()
		
		var_8_2:setPositionY(-800)
		
		local var_8_5 = var_8_1:getPositionX()
		
		var_8_1:setPositionX(VIEW_BASE_RIGHT + 300)
		UIAction:Add(SEQ(DELAY(100), LOG(MOVE_TO(250, NotchStatus:getNotchBaseLeft()))), var_8_0, "block")
		UIAction:Add(LOG(MOVE_TO(250, var_8_5)), var_8_1, "block")
		UIAction:Add(SEQ(DELAY(100), LOG(MOVE_TO(250, var_8_3, var_8_4))), var_8_2, "block")
	end
	
	ConditionContentsManager:updateConditionDispatch()
	ConditionContentsManager:destinyForceUpdateConditions()
	TopBarNew:createFromPopup(T("destiny"), arg_8_0.vars.wnd:getChildByName("n_topbar"), function()
		Destiny:close()
	end)
	GrowthGuideNavigator:proc()
end

function Destiny.checkNew(arg_10_0)
	NewNotice:checkNew(NewNotice.ID.DESTINY)
end

function Destiny._customSetupForPub(arg_11_0)
	if not get_cocos_refid(arg_11_0.vars.wnd) then
		return 
	end
	
	local var_11_0 = arg_11_0.vars.wnd:getChildByName("n_btn")
	
	if get_cocos_refid(var_11_0) then
		arg_11_0.vars.n_complete = var_11_0:getChildByName("n_complete")
	end
	
	if IS_PUBLISHER_ZLONG then
		local var_11_1 = arg_11_0.vars.wnd:getChildByName("n_btn_zl")
		
		if_set_visible(var_11_0, nil, false)
		if_set_visible(var_11_1, nil, true)
		
		if get_cocos_refid(var_11_1) then
			arg_11_0.vars.n_complete = var_11_1:getChildByName("n_complete")
		end
	end
end

function Destiny.isNew(arg_12_0)
	return UnlockSystem:isUnlockSystem(UNLOCK_ID.DESTINY) and NewNotice:isNew(NewNotice.ID.DESTINY)
end

function Destiny.updateMissionData(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = DBT("destiny_mission", arg_13_1, {
		"id",
		"condition",
		"value",
		"category_name",
		"mission_name",
		"mission_icon_1",
		"mission_icon_2",
		"mission_desc",
		"give_code",
		"give_count",
		"reward_id",
		"reward_value",
		"clear_desc",
		"btn_move"
	})
	
	if not var_13_0 or not var_13_0.id then
		return false
	end
	
	if var_13_0.condition and var_13_0.value then
		table.insert(arg_13_2.datas, {
			category_id = arg_13_2.id,
			achieve_id = var_13_0.id,
			achieve_db = var_13_0,
			arg_13_3
		})
	end
	
	if not arg_13_2.rewardable_achieve and (arg_13_3 == 1 or arg_13_3 == "clear") then
		arg_13_2.rewardable_achieve = true
	end
	
	if arg_13_0.vars.select_info and arg_13_0.vars.select_info.id == arg_13_2.id then
		arg_13_0.vars.select_info = arg_13_2
	end
	
	return true
end

function Destiny.updateData(arg_14_0)
	arg_14_0.vars = arg_14_0.vars or {}
	arg_14_0.vars.category_db = arg_14_0.vars.category_db or arg_14_0:loadCategoryDB()
	
	local var_14_0 = false
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.category_db) do
		iter_14_1.datas = {}
		iter_14_1.rewardable_achieve = nil
		
		local var_14_1 = 0
		
		if Account:getDestinyDataById(iter_14_1.id) then
			iter_14_1.is_rewarded = true
		end
		
		for iter_14_2 = 1, GAME_STATIC_VARIABLE.destiny_mission_count_limit do
			local var_14_2 = string.format(iter_14_1.id .. "_%02d", iter_14_2)
			local var_14_3 = Account:getDestinyAchieve(var_14_2).state
			
			if var_14_3 >= 2 then
				var_14_1 = var_14_1 + 1
			end
			
			if not arg_14_0:updateMissionData(var_14_2, iter_14_1, var_14_3) then
				break
			end
		end
		
		iter_14_1.progress = var_14_1
		iter_14_1.max = #iter_14_1.datas
		iter_14_1.is_complete = iter_14_1.max <= iter_14_1.progress
		
		if not iter_14_1.con_stage or iter_14_1.con_stage and Account:isMapCleared(iter_14_1.con_stage) then
			iter_14_1.is_unlock = true
		end
		
		if iter_14_1.is_unlock and (iter_14_1.rewardable_achieve or not iter_14_1.is_rewarded and iter_14_1.is_complete) then
			var_14_0 = true
		end
	end
	
	table.sort(arg_14_0.vars.category_db, function(arg_15_0, arg_15_1)
		local var_15_0 = tonumber(arg_15_0.sort) or 999
		local var_15_1 = tonumber(arg_15_1.sort) or 999
		
		var_15_0 = arg_15_0.is_rewarded and var_15_0 + 10000 or var_15_0
		var_15_1 = arg_15_1.is_rewarded and var_15_1 + 10000 or var_15_1
		
		return var_15_0 < var_15_1
	end)
	
	var_14_0 = var_14_0 and UnlockSystem:isUnlockSystem(UNLOCK_ID.DESTINY)
	
	return var_14_0
end

function Destiny.showCollectionDetail(arg_16_0)
	if_set_visible(arg_16_0.vars.wnd, "n_topbar", false)
	if_set_visible(arg_16_0.vars.wnd, "n_content", false)
	CollectionNewHero:show(arg_16_0.vars.wnd:getChildByName("n_collection"), Destiny:getSelectItemCharacterCode(), {
		topbar_title = T("destiny"),
		close_callback = function()
			Destiny:closeCollectionDetail()
		end
	})
	
	arg_16_0.vars.is_collection_mode = true
end

function Destiny.closeCollectionDetail(arg_18_0)
	if_set_visible(arg_18_0.vars.wnd, "n_topbar", true)
	if_set_visible(arg_18_0.vars.wnd, "n_content", true)
	arg_18_0.vars.wnd:getChildByName("n_collection"):removeAllChildren()
	
	arg_18_0.vars.is_collection_mode = false
	
	BackButtonManager:pop("TopBarNew." .. T("destiny"))
	TopBarNew:pop()
end

function Destiny.getSelectItemCharacterCode(arg_19_0)
	if not arg_19_0.vars.select_info then
		return 
	end
	
	return arg_19_0.vars.select_info.char_id
end

function Destiny.getSelectItemStory(arg_20_0)
	if not arg_20_0.vars.select_info then
		return 
	end
	
	return arg_20_0.vars.select_info.story
end

function Destiny.showReview(arg_21_0)
	arg_21_0.vars.is_review_mode = true
	
	local var_21_0 = UIUtil:openReview(Destiny:getSelectItemCharacterCode(), arg_21_0.vars.wnd)
	
	var_21_0:setPositionX(var_21_0:getPositionX() - 1)
	
	local var_21_1 = arg_21_0.vars.wnd:findChildByName("hero_detail_vote")
	local var_21_2 = var_21_1:getChildByName("LEFT")
	local var_21_3 = var_21_1:getChildByName("port_pos")
	
	var_21_2:setOpacity(0)
	var_21_3:setOpacity(0)
	UIAction:Add(SEQ(SLIDE_IN(200, 600)), var_21_2, "block")
	UIAction:Add(SEQ(SLIDE_IN_Y(200, 1200)), var_21_3, "block")
	
	arg_21_0.vars.review_wnd = var_21_0
	
	TopBarNew:createFromPopup(T("destiny"), var_21_0, function()
		Destiny:closeReview()
	end, {
		"crystal",
		"gold",
		"stamina"
	}, nil, "destiny")
end

function Destiny.closeReview(arg_23_0)
	local var_23_0 = arg_23_0.vars.wnd:findChildByName("hero_detail_vote")
	
	UIAction:Add(SEQ(DELAY(160), SLIDE_OUT(200, -600)), var_23_0:findChildByName("LEFT"), "block")
	UIAction:Add(SEQ(DELAY(160), SLIDE_OUT_Y(200, -1200)), var_23_0:getChildByName("port_pos"), "block")
	UIAction:Add(SEQ(DELAY(160), SLIDE_OUT(200, 600)), var_23_0:getChildByName("RIGHT"), "block")
	UIAction:Add(SEQ(DELAY(360), REMOVE()), arg_23_0.vars.review_wnd, "block")
	
	arg_23_0.vars.is_review_mode = false
	
	BackButtonManager:pop({
		check_id = "destiny",
		dlg = arg_23_0.vars.review_wnd
	})
	TopBarNew:pop()
end

function Destiny.hideParent(arg_24_0)
	SceneManager:getRunningNativeScene():setVisible(false)
	SceneManager:getRunningUIScene():setVisible(false)
end

function Destiny.playStory(arg_25_0, arg_25_1)
	arg_25_1 = arg_25_1 or {}
	
	if Destiny:getSelectItemStory() then
		start_new_story(arg_25_0.vars.wnd, Destiny:getSelectItemStory(), {
			force = true,
			on_finish = function()
				Destiny:playCharacterGetEffect(arg_25_1)
			end
		})
	else
		arg_25_0:playCharacterGetEffect()
	end
end

function Destiny.onReward(arg_27_0)
	local var_27_0 = CharacterRewardsList:getSelectInfo()
	
	query("get_reward_character_system", {
		system_id = var_27_0.id,
		units = json.encode(var_27_0.complete_unit_ids),
		equips = json.encode(var_27_0.complete_equip_ids)
	})
end

function Destiny.playCharacterGetEffect(arg_28_0, arg_28_1)
	arg_28_1 = arg_28_1 or {}
	
	local var_28_0 = DB("character", Destiny:getSelectItemCharacterCode(), {
		"model_id"
	})
	
	UIAction:Add(SEQ(CALL(function()
		SoundEngine:play(string.format("event:/voc/character/%s/evt/get", var_28_0))
	end)), arg_28_0.vars.wnd, "block")
	
	arg_28_1.bg = "img/base_unit.png"
	
	UnitSummonResult:ShowCharGet(Destiny:getSelectItemCharacterCode(), arg_28_0.vars.wnd, function()
		Destiny:checkTutorial_afterSummon()
	end, arg_28_1)
end

function Destiny.checkTutorial_afterSummon(arg_31_0)
	if Destiny:getSelectItemCharacterCode() == "c3026" and not TutorialGuide:isClearedTutorial("c3026_get") then
		TutorialGuide:startGuide("c3026_get")
	end
end

function Destiny.fin_close(arg_32_0)
	SceneManager:getRunningNativeScene():setVisible(true)
	SceneManager:getRunningUIScene():setVisible(true)
	
	arg_32_0.vars = nil
end

function Destiny.close(arg_33_0, arg_33_1)
	if ClassChange.vars then
		ClassChangeMainList:refresh(arg_33_0.vars.class_change_turn_back_id)
	end
	
	if arg_33_0.vars.is_review_mode then
		arg_33_0:closeReview()
		
		if not arg_33_1 then
			return 
		end
	end
	
	if arg_33_0.vars.is_collection_mode then
		arg_33_0:closeCollectionDetail()
		
		if not arg_33_1 then
			return 
		end
	end
	
	BackButtonManager:pop({
		check_id = "TopBarNew." .. T("destiny"),
		dlg = arg_33_0.vars.wnd:getChildByName("n_topbar")
	})
	TopBarNew:pop()
	TopBarNew:checkUnlockIcon()
	arg_33_0.vars.wnd:removeFromParent()
	arg_33_0:fin_close()
	
	if SceneManager:getCurrentSceneName() == "lobby" then
		Lobby:updateTopBar()
		TopBarNew:updateFeedButton()
		Lobby:setupRandomRewardSysCharacter()
	end
end

function Destiny.playBalloonMsg(arg_34_0, arg_34_1)
	local var_34_0 = DB("destiny_mission", arg_34_1, "clear_desc")
	
	if not var_34_0 then
		return 
	end
	
	local var_34_1 = T(var_34_0)
	local var_34_2 = 3000 + utf8len(var_34_1) * 20
	local var_34_3 = arg_34_0.vars.wnd:getChildByName("n_balloon")
	local var_34_4 = var_34_3:getChildByName("txt_balloon")
	local var_34_5 = var_34_4:getFontSize() * 0.2
	
	if_set(var_34_4, nil, "")
	if_set_opacity(var_34_3, nil, 0)
	UIAction:Add(SEQ(SPAWN(LOG(FADE_IN(150)), TARGET(var_34_4, SOUND_TEXT(var_34_1, true))), DELAY(var_34_2), FADE_OUT(300)), var_34_3, "talk_balloon")
	UIUtil:updateTextWrapMode(var_34_4, var_34_1, 30)
	if_set_visible(var_34_3, nil, true)
end

function Destiny.updateUI(arg_35_0)
	if_set(arg_35_0.vars.wnd, "txt_count_max", T("rel_count_and_complet_score", {
		score = Destiny:getRewardedCount(),
		max = Destiny:getListCount()
	}))
end

function Destiny.getCategoryDB(arg_36_0)
	return arg_36_0.vars.category_db
end

function Destiny.loadCategoryDB(arg_37_0)
	local var_37_0 = {}
	
	for iter_37_0 = 1, 9999 do
		local var_37_1 = DBNFields("destiny_category", iter_37_0, {
			"id",
			"char_id",
			"con_stage",
			"story",
			"is_start",
			"hide",
			"sort",
			"recommend_tag",
			"update_date"
		})
		
		if not var_37_1.id then
			break
		end
		
		if not var_37_1.hide then
			table.insert(var_37_0, var_37_1)
		end
	end
	
	return var_37_0
end

function Destiny.getCategoryDBById(arg_38_0, arg_38_1)
	return DBT("destiny_category", arg_38_1, {
		"id",
		"char_id",
		"con_stage",
		"story",
		"is_start",
		"hide",
		"sort"
	})
end

function Destiny.getProgress(arg_39_0, arg_39_1)
	arg_39_0:updateData()
	
	local var_39_0
	
	for iter_39_0, iter_39_1 in pairs(arg_39_0.vars.category_db) do
		if arg_39_1 and arg_39_1 == iter_39_1.char_id then
			var_39_0 = iter_39_1
			
			break
		elseif arg_39_1 == nil and iter_39_1.is_start then
			var_39_0 = iter_39_1
			
			break
		end
	end
	
	local var_39_1 = var_39_0.progress or 0
	local var_39_2 = #var_39_0.datas
	
	return var_39_1, var_39_2
end

function Destiny.updateInfo(arg_40_0, arg_40_1)
	arg_40_1 = arg_40_0:getSelectInfo()
	
	local var_40_0, var_40_1 = DB("character", arg_40_1.char_id, {
		"grade",
		"face_id"
	})
	local var_40_2 = UNIT:create({
		code = var_40_1,
		g = var_40_0
	})
	
	UIUtil:setUnitAllInfo(arg_40_0.vars.wnd:getChildByName("n_char_info"), var_40_2)
	
	local var_40_3 = arg_40_0.vars.wnd:getChildByName("txt_char_name")
	
	if_set(var_40_3, nil, T(var_40_2.db.name))
	if_call(arg_40_0.vars.wnd:getChildByName("n_char_info"), "star1", "setPositionX", 10 + var_40_3:getContentSize().width * var_40_3:getScaleX() + var_40_3:getPositionX())
	
	local var_40_4 = arg_40_0.vars.wnd:getChildByName("n_portrait")
	
	if get_cocos_refid(arg_40_0.vars.portrait) then
		var_40_4:removeChild(arg_40_0.vars.portrait)
	end
	
	local var_40_5 = arg_40_0.vars.select_info.progress or 0
	local var_40_6 = #arg_40_0.vars.select_info.datas
	local var_40_7 = 0
	
	if arg_40_1.is_rewarded then
		var_40_7 = 2
	elseif var_40_6 <= var_40_5 then
		var_40_7 = 1
	end
	
	local var_40_8 = arg_40_0.vars.wnd:getChildByName("btn_complete")
	local var_40_9 = arg_40_0.vars.n_complete
	
	if get_cocos_refid(var_40_8) and get_cocos_refid(var_40_9) then
		UIUtil:setColorRewardButtonState(var_40_7, var_40_9, var_40_8, {
			no_btn_hide = true,
			no_btn_text = true
		})
		
		var_40_8.state = var_40_7
		var_40_8.destiny_id = arg_40_1.id
		
		if var_40_7 == 1 then
			if_set(arg_40_0.vars.wnd, "txt_comlet", T("re_mission_clear"))
			var_40_9:setOpacity(255)
			var_40_8:setOpacity(255)
		elseif var_40_7 == 2 then
			if_set(arg_40_0.vars.wnd, "txt_comlet", T("re_mission_end"))
			var_40_9:setOpacity(100)
			var_40_8:setOpacity(255)
		else
			if_set(arg_40_0.vars.wnd, "txt_comlet", T("re_mission_ing"))
			var_40_9:setOpacity(255)
			var_40_8:setOpacity(100)
		end
		
		if_set_percent(var_40_9, "progress", var_40_5 / var_40_6)
		if_set(var_40_9, "t_percent", math.floor(var_40_5 / var_40_6 * 100) .. "%")
	end
	
	local var_40_10 = UIUtil:getPortraitAni(var_40_1, {
		parent_pos_y = var_40_4:getPositionY()
	})
	
	if var_40_10 then
		var_40_10:setAnchorPoint(0.5, 0)
		var_40_4:removeAllChildren()
		var_40_10:setScale(1)
		var_40_4:addChild(var_40_10)
		
		arg_40_0.vars.portrait = var_40_10
	end
	
	if_set_visible(arg_40_0.vars.wnd, "btn_get_on", arg_40_1.complete and not arg_40_1.is_rewarded)
	if_set_visible(arg_40_0.vars.wnd, "n_ing", not arg_40_1.complete or arg_40_1.is_rewarded)
	
	if not arg_40_1.complete then
		if_set(arg_40_0.vars.wnd, "txt_sys_desc", T("re_mission_ing"))
	elseif arg_40_1.is_rewarded then
		if_set(arg_40_0.vars.wnd, "txt_sys_desc", T("re_mission_end"))
	end
end

function Destiny.getRandomCharacter(arg_41_0)
	local var_41_0 = {}
	
	for iter_41_0 = 1, 99 do
		local var_41_1, var_41_2, var_41_3, var_41_4, var_41_5, var_41_6 = DBN("destiny_category", iter_41_0, {
			"id",
			"char_id",
			"is_start",
			"hide",
			"con_stage",
			"lobby_text"
		})
		
		if not var_41_1 then
			break
		end
		
		if not var_41_4 and not Account:getDestinyDataById(var_41_1) and var_41_5 and Account:isMapCleared(var_41_5) then
			if var_41_3 then
				return {
					code = var_41_2,
					lobby_text = var_41_6
				}
			end
			
			table.insert(var_41_0, {
				code = var_41_2,
				lobby_text = var_41_6
			})
		end
	end
	
	local var_41_7 = #var_41_0
	
	if var_41_7 <= 0 then
		return 
	end
	
	return var_41_0[math.random(1, var_41_7)]
end

function Destiny.setSelectInfo(arg_42_0, arg_42_1)
	arg_42_0.vars.select_info = arg_42_1
end

function Destiny.getSelectInfo(arg_43_0)
	return arg_43_0.vars.select_info
end

function Destiny.getListCount(arg_44_0)
	return #arg_44_0.vars.category_db
end

function Destiny.getRewardedCount(arg_45_0)
	local var_45_0 = 0
	
	for iter_45_0, iter_45_1 in pairs(arg_45_0.vars.category_db) do
		if iter_45_1.is_rewarded then
			var_45_0 = var_45_0 + 1
		end
	end
	
	return var_45_0
end

function Destiny.showPresentWnd(arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4)
	local var_46_0 = Dialog:open("wnd/destiny_present", arg_46_0)
	
	arg_46_1 = arg_46_1 or SceneManager:getRunningPopupScene()
	
	arg_46_1:addChild(var_46_0)
	UIUtil:getRewardIcon(arg_46_4, arg_46_3, {
		txt_name_width = 240,
		show_name = true,
		detail = true,
		parent = var_46_0:getChildByName("n_item")
	})
	UIUtil:getRewardIcon(nil, arg_46_3, {
		no_frame = true,
		scale = 0.6,
		parent = var_46_0:getChildByName("n_pay_token")
	})
	if_set(var_46_0, "txt_price", comma_value(arg_46_4))
	if_set(var_46_0, "txt_item_hoiding", T("text_item_have_count", {
		count = comma_value(Account:getPropertyCount(arg_46_3) or 0)
	}))
	if_set(var_46_0, "txt_title", T("ui_destiny_present_title"))
	if_set(var_46_0, "txt_disc", T("ui_destiny_present_desc"))
	
	local var_46_1 = var_46_0:getChildByName("btn_present")
	
	var_46_1.give_code = arg_46_3
	var_46_1.give_count = arg_46_4
	var_46_1.contents_id = arg_46_2
	var_46_1.parent = arg_46_0
end

function Destiny.giveItem(arg_47_0, arg_47_1)
	if not arg_47_1 or not arg_47_1.give_code or not arg_47_1.give_code then
		return Log.e("destiny", "giveItem.null")
	end
	
	if Account:getPropertyCount(arg_47_1.give_code) < arg_47_1.give_count then
		balloon_message_with_sound("lack_give_currencies_count")
		
		return 
	end
	
	ConditionContentsManager:setIgnoreQuery(true)
	ConditionContentsManager:dispatch("destiny.give", {
		give = arg_47_1.contents_id
	})
	ConditionContentsManager:setIgnoreQuery(false)
	
	local var_47_0 = ConditionContentsManager:getUpdateConditions()
	
	if var_47_0 then
		query("give_destiny_achievement", {
			contents_id = arg_47_1.contents_id,
			update_condition_groups = json.encode(var_47_0)
		})
	end
	
	Dialog:close("destiny_present")
end

DestinyCategory = DestinyCategory or {}

copy_functions(ScrollView, DestinyCategory)

function DestinyCategory.create(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
	local var_48_0 = arg_48_1:getChildByName("RIGHT")
	
	arg_48_0.vars = {}
	arg_48_0.vars.scrollview = var_48_0:getChildByName("scrollview")
	arg_48_0.vars.parent = arg_48_1
	
	arg_48_0:initScrollView(arg_48_0.vars.scrollview, 122, 90)
	arg_48_0:createScrollViewItems(arg_48_3)
	DestinyAchieveList:show(arg_48_1)
	Destiny:updateInfo()
	arg_48_0:updateSelectUI()
end

function DestinyCategory.getScrollViewItem(arg_49_0, arg_49_1)
	local var_49_0 = load_dlg("destiny_unit_item", true, "wnd")
	
	var_49_0.guide_tag = arg_49_1.id
	
	local var_49_1 = 0
	
	if arg_49_1.is_rewarded then
		local var_49_2 = 1
	end
	
	local var_49_3, var_49_4 = DB("character", arg_49_1.char_id, {
		"grade",
		"face_id"
	})
	
	if_set_sprite(var_49_0, "face", "face/" .. var_49_4 .. "_s.png")
	if_set_visible(var_49_0, "icon_alert", arg_49_1.is_unlock and (arg_49_1.is_complete and not arg_49_1.is_rewarded or arg_49_1.rewardable_achieve))
	if_set_visible(var_49_0, "icon_check_1", arg_49_1.is_rewarded)
	if_set_visible(var_49_0, "icon_locked", arg_49_1.lock)
	if_set(var_49_0, "txt_progress", math.floor(arg_49_1.progress / arg_49_1.max * 100) .. "%")
	
	if not arg_49_1.is_unlock then
		if_set_visible(var_49_0, "icon_locked", true)
		if_set_visible(var_49_0, "txt_progress", false)
		if_set_color(var_49_0, "n_tint", cc.c3b(130, 130, 130))
	end
	
	if arg_49_1.recommend_tag and arg_49_1.recommend_tag == "y" and not arg_49_1.is_rewarded then
		if_set_visible(var_49_0, "icon_hot", true)
	end
	
	if arg_49_1.is_rewarded then
		if_set_color(var_49_0, "n_tint", cc.c3b(130, 130, 130))
	end
	
	return var_49_0
end

function DestinyCategory.updateCompletRewardedUI(arg_50_0, arg_50_1)
	for iter_50_0, iter_50_1 in pairs(arg_50_0.ScrollViewItems) do
		if iter_50_1.item.id == arg_50_1 then
			if_set_visible(iter_50_1.control, "icon_alert", false)
			if_set_visible(iter_50_1.control, "icon_check_1", true)
			if_set_color(iter_50_1.control, "n_tint", cc.c3b(130, 130, 130))
			
			break
		end
	end
end

function DestinyCategory.updateSelectUI(arg_51_0)
	local var_51_0 = Destiny:getSelectInfo().id
	
	for iter_51_0, iter_51_1 in pairs(arg_51_0.ScrollViewItems) do
		if_set_visible(iter_51_1.control, "selected", iter_51_1.item.id == var_51_0)
		
		for iter_51_2, iter_51_3 in pairs(Destiny:getCategoryDB()) do
			if iter_51_3.id == iter_51_1.item.id and iter_51_1.item.is_unlock then
				if_set(iter_51_1.control, "txt_progress", math.floor(iter_51_3.progress / iter_51_3.max * 100) .. "%")
			end
			
			if_set_visible(iter_51_1.control, "icon_alert", iter_51_1.item.is_unlock and (iter_51_1.item.rewardable_achieve or iter_51_1.item.is_complete and not iter_51_1.item.is_rewarded))
		end
	end
end

function DestinyCategory.onSelectScrollViewItem(arg_52_0, arg_52_1, arg_52_2)
	if UIAction:Find("block") then
		return 
	end
	
	if not TutorialGuide:isAllowEvent() then
		return 
	end
	
	if Destiny:getSelectInfo().id == arg_52_2.item.id then
		return 
	end
	
	if not arg_52_2.item.is_unlock and not DEBUG.MAP_DEBUG then
		local var_52_0, var_52_1, var_52_2 = DB("level_enter", arg_52_2.item.con_stage, {
			"name",
			"episode",
			"type"
		})
		local var_52_3 = T("destiny_unlock_msg", {
			map = T(var_52_0)
		})
		local var_52_6
		
		if var_52_1 then
			local var_52_4 = {
				adventure_ep5 = "ep_select_num5",
				adventure_ep2 = "ep_select_num2",
				adventure_ep6 = "ep_select_num6",
				adventure_ep3 = "ep_select_num3",
				adventure_ep4 = "ep_select_num4",
				adventure_ep1 = "ep_select_num1"
			}
			local var_52_5 = T(var_52_4[var_52_1] or "")
			
			var_52_3 = T("destiny_unlock_msg", {
				map = T(var_52_0),
				episode = var_52_5
			})
		elseif arg_52_2.item.con_stage and var_52_2 and var_52_2 == "dungeon" then
			var_52_6 = string.sub(arg_52_2.item.con_stage, 1, 6)
			
			if var_52_6 then
				for iter_52_0 = 1, 999 do
					local var_52_7, var_52_8, var_52_9 = DBN("level_battlemenu_dungeon", iter_52_0, {
						"id",
						"name",
						"key_enter"
					})
					
					if not var_52_7 then
						break
					end
					
					if var_52_9 and var_52_9 == var_52_6 and var_52_8 then
						var_52_3 = T("destiny_unlock_msg", {
							map = T(var_52_0),
							episode = T(var_52_8)
						})
						
						break
					end
				end
			end
		end
		
		Dialog:msgBox(var_52_3, {
			fade_in = 250,
			title = T("destiny_unlock_msg_title")
		})
		
		return 
	end
	
	SoundEngine:play("event:/ui/btn_small")
	Destiny:setSelectInfo(arg_52_2.item)
	Destiny:updateInfo()
	arg_52_0:updateSelectUI()
	DestinyAchieveList:ItemListRefresh()
	
	local var_52_10 = DestinyAchieveList:getDataList()
	
	if var_52_10 then
		ConditionContentsManager:checkState(CONTENTS_TYPE.DESTINY, {
			db_data = var_52_10
		})
	end
end

function DestinyCategory.updateSelected(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0
	
	for iter_53_0, iter_53_1 in pairs(arg_53_0.ScrollViewItems) do
		if iter_53_1.item.id == arg_53_1 then
			if_set_visible(iter_53_1.control, "selected", true)
			
			var_53_0 = iter_53_0
		else
			if_set_visible(iter_53_1.control, "selected", false)
		end
	end
	
	if arg_53_2 and var_53_0 and arg_53_0.ScrollViewItems[var_53_0] then
		local var_53_1 = math.floor(var_53_0 / 5)
	end
end

DestinyAchieveList = DestinyAchieveList or {}

function DestinyAchieveList.show(arg_54_0, arg_54_1)
	local var_54_0 = Destiny:getSelectInfo().datas
	local var_54_1 = arg_54_1:getChildByName("CENTER")
	
	arg_54_0.vars = {}
	
	local var_54_2 = arg_54_1:getChildByName("listview")
	
	arg_54_0.vars.itemView = ItemListView_v2:bindControl(var_54_2)
	arg_54_0.vars.data = var_54_0
	
	local var_54_3 = load_control("wnd/destiny_achieve_item.csb")
	
	if var_54_2.STRETCH_INFO then
		local var_54_4 = var_54_2:getContentSize()
		
		resetControlPosAndSize(var_54_3, var_54_4.width, var_54_2.STRETCH_INFO.width_prev)
	end
	
	local var_54_5 = {
		onUpdate = function(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
			DestinyAchieveList:updateItem(arg_55_1, arg_55_3)
			
			return arg_55_3.achieve_id
		end
	}
	
	arg_54_0.vars.itemView:setRenderer(var_54_3, var_54_5)
	arg_54_0.vars.itemView:removeAllChildren()
	arg_54_0.vars.itemView:setDataSource(arg_54_0.vars.data)
	ConditionContentsManager:checkState(CONTENTS_TYPE.DESTINY, {
		db_data = arg_54_0.vars.data
	})
	SoundEngine:play("event:/ui/main_hud/btn_relation")
end

function DestinyAchieveList.ItemListRefresh(arg_56_0)
	arg_56_0.vars.data = Destiny:getSelectInfo().datas
	
	arg_56_0.vars.itemView:setDataSource(arg_56_0.vars.data)
end

function DestinyAchieveList.getDataList(arg_57_0)
	if not arg_57_0.vars then
		return 
	end
	
	return arg_57_0.vars.data
end

function DestinyAchieveList.onUpdateUI(arg_58_0)
	if not arg_58_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_58_0.vars.itemView) then
		return 
	end
	
	arg_58_0:ItemListRefresh()
end

function DestinyAchieveList.updateItem(arg_59_0, arg_59_1, arg_59_2)
	local var_59_0
	
	for iter_59_0, iter_59_1 in pairs(Destiny:getCategoryDB()) do
		if arg_59_2.category_id == iter_59_1.id then
			local var_59_1 = iter_59_1
		end
	end
	
	local var_59_2 = Account:getDestinyAchieve(arg_59_2.achieve_id).state
	local var_59_3 = arg_59_1:getChildByName("btn_go")
	local var_59_4 = 255
	
	if var_59_2 == 2 then
		var_59_4 = 150
	end
	
	UIUtil:setColorRewardButtonState(var_59_2, arg_59_1, var_59_3, {
		give = arg_59_2.achieve_db.give_code
	})
	
	if arg_59_2.achieve_db.mission_icon_1 then
		local var_59_5 = 1.5
		
		if not DB("character", arg_59_2.achieve_db.mission_icon_1, "id") then
			var_59_5 = 1.3
		end
		
		local var_59_6 = UIUtil:getRewardIcon(nil, arg_59_2.achieve_db.mission_icon_1, {
			no_popup = true,
			no_grade = true,
			parent = arg_59_1:getChildByName("n_face"),
			scale = var_59_5
		})
		
		if_set_opacity(var_59_6, nil, var_59_4)
		if_set_visible(arg_59_1, "spr_icon", false)
	elseif arg_59_2.achieve_db.mission_icon_2 then
		arg_59_1:getChildByName("n_face"):removeAllChildren()
		if_set_visible(arg_59_1, "spr_icon", true)
		if_set_sprite(arg_59_1, "spr_icon", arg_59_2.achieve_db.mission_icon_2 .. ".png")
	end
	
	if_set_opacity(arg_59_1, "n_normal", var_59_4)
	if_set_opacity(arg_59_1, "n_right", var_59_4)
	
	local var_59_7 = arg_59_2.condition_group_db
	local var_59_8 = ConditionContentsManager:getDestinyAchievement():getScore(arg_59_2.achieve_id)
	local var_59_9 = totable(arg_59_2.achieve_db.value).count
	local var_59_10 = math.min(var_59_8, var_59_9)
	
	if var_59_2 >= 1 then
		var_59_10 = var_59_9
	end
	
	if_set(arg_59_1, "txt_kind", T(arg_59_2.achieve_db.category_name))
	if_set(arg_59_1, "txt_title_1", T(arg_59_2.achieve_db.mission_name))
	set_scale_fit_width_node(arg_59_1:getChildByName("txt_title_1"), arg_59_1:getChildByName("progress"))
	if_set(arg_59_1, "txt_name", T(arg_59_2.achieve_db.mission_desc))
	if_set_percent(arg_59_1, "progress", var_59_10 / var_59_9)
	if_set(arg_59_1, "txt_progress", comma_value(math.min(var_59_10, var_59_9)) .. " / " .. comma_value(var_59_9))
	
	if var_59_2 == 0 and not arg_59_2.achieve_db.btn_move and not arg_59_2.achieve_db.give_code then
		if_set_visible(arg_59_1, "btn_go", false)
	end
	
	local var_59_11 = arg_59_1:getChildByName("btn_go")
	
	var_59_11.contents_id = arg_59_2.achieve_id
	var_59_11.state = var_59_2
	var_59_11.give_code = arg_59_2.achieve_db.give_code
	var_59_11.give_count = arg_59_2.achieve_db.give_count
	var_59_11.btn_move = arg_59_2.achieve_db.btn_move
	
	var_59_11:getChildByName("noti"):setVisible(arg_59_2.achieve_db.give_code and var_59_2 == 0 and Account:getPropertyCount(arg_59_2.achieve_db.give_code) >= arg_59_2.achieve_db.give_count)
end

function DestinyAchieveList.setTouchEnabled(arg_60_0, arg_60_1)
	if arg_60_0.vars and get_cocos_refid(arg_60_0.vars.itemView) then
		arg_60_0.vars.itemView:setTouchEnabled(arg_60_1)
	end
end
