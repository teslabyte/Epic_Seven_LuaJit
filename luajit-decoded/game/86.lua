GrowthGuideBase = {}
GrowthGuideBase.group_ui = {}
GrowthGuideBase.group_ui.scroll_view = {}
GrowthGuideBase.quest_ui = {}
GrowthGuideBase.quest_ui.scroll_view = {}

function HANDLER.growth_guide_base(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_tracking" then
		GrowthGuideBase:toggleTrackingButton()
		
		return 
	end
	
	if not GrowthGuideBase.group_ui.select_id then
		return 
	end
	
	local var_1_0 = GrowthGuideBase.group_ui.select_id
	
	if arg_1_1 == "btn_move_reward" then
		GrowthGuideBase.quest_ui:scrollToFirstNotRewardedQuest(var_1_0)
	elseif arg_1_1 == "btn_move_quest" then
		GrowthGuideBase.quest_ui:scrollToCurrentQuest(var_1_0)
	elseif arg_1_1 == "btn_group_reward" then
		GrowthGuideBase:onBtnGroupReward()
	end
end

function GrowthGuideBase.onBtnGroupReward(arg_2_0)
	local var_2_0 = arg_2_0.group_ui.select_id
	
	if not var_2_0 then
		return 
	end
	
	arg_2_0.quest_ui:scrollToFirstNotRewardedQuest(var_2_0)
	
	local var_2_1 = GrowthGuide:getFirstNotRewardedQuestIDByGroupID(var_2_0)
	
	if var_2_1 then
		GrowthGuide:reqRewardGrowthQuest(var_2_1)
		
		return 
	end
	
	if GrowthGuide:reqRewardGrowthGroup(var_2_0) then
		return 
	end
	
	balloon_message_with_sound_raw_text(T("reward_get_failed"))
end

function HANDLER.growth_guide_detail(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		GrowthGuideBase:closeQuestDetail()
		
		return 
	end
	
	if arg_3_1 == "btn_help" then
		if arg_3_0.quest and arg_3_0.quest.detail then
			HelpGuide:open({
				menu = arg_3_0.quest.detail
			})
		end
		
		return 
	end
	
	if arg_3_1 == "btn_move" then
		local var_3_0 = arg_3_0.quest.btn_move
		
		if var_3_0 == "epic7://unit_ui?mode=Skill" then
			local var_3_1 = Account:getMainUnit()
			
			if var_3_1 and var_3_1.inst and var_3_1.inst.uid then
				var_3_0 = var_3_0 .. "&unit_uid=" .. var_3_1.inst.uid
			end
		end
		
		GrowthGuideBase:closeQuestDetail()
		movetoPath(var_3_0)
		
		return 
	end
	
	if arg_3_1 == "btn_reward" then
		if arg_3_0.quest_id then
			query("get_reward_growth_quest", {
				contents_id = arg_3_0.quest_id
			})
		end
		
		return 
	end
end

function HANDLER.growth_guide_group_item(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_select" then
		local var_4_0 = arg_4_0.item.group_id
		
		if GrowthGuideBase.group_ui.select_id == var_4_0 then
			return 
		end
		
		if GrowthGuide:isGroupLockedByID(var_4_0) then
			local var_4_1 = GrowthGuide:getGroupDB(var_4_0)
			
			Dialog:msgBox(T(var_4_1.req_unlock_msg), {
				title = T(var_4_1.group_name)
			})
		else
			GrowthGuideBase:selectGroup(arg_4_0.item)
		end
	end
end

function HANDLER.growth_guide_quest_item(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_detail" then
		TutorialGuide:procGuide()
		GrowthGuideBase:openQuestDetail(arg_5_0.item)
	end
	
	if arg_5_1 == "btn_reward" and arg_5_0.item and arg_5_0.item.id then
		query("get_reward_growth_quest", {
			contents_id = arg_5_0.item.id
		})
	end
end

function GrowthGuideBase.onLoad(arg_6_0)
	GrowthGuide.onGetRewardGrowthQuest:add("growth_guide_base", function(arg_7_0)
		arg_6_0:onGetRewardGrowthQuest(arg_7_0)
	end)
	GrowthGuide.onGetRewardGrowthChapter:add("growth_guide_base", function(arg_8_0)
		arg_6_0:onGetRewardGrowthChapter(arg_8_0)
	end)
end

function GrowthGuideBase.onUnload(arg_9_0)
	GrowthGuide.onGetRewardGrowthQuest:remove("growth_guide_base")
	GrowthGuide.onGetRewardGrowthChapter:remove("growth_guide_base")
end

function GrowthGuideBase.procFinish(arg_10_0)
	if GrowthGuide:isFinish() then
		GrowthGuideInfo:openFinishDialog()
		
		return 
	end
	
	if GrowthGuide:isFinish(true) then
		Dialog:msgBox(T("guidequest_comingsoon_desc"), {
			title = T("guidequest_comingsoon_title"),
			handler = function()
				SceneManager:nextScene("lobby")
			end
		})
	end
end

function GrowthGuideBase.onGetRewardGrowthQuest(arg_12_0, arg_12_1)
	arg_12_0.quest_ui:updateQuestUI(arg_12_1)
	arg_12_0:updateQuestDetailButtonByID(arg_12_1)
	arg_12_0:updateGroupUI()
	arg_12_0:procFinish()
end

function GrowthGuideBase.onGetRewardGrowthChapter(arg_13_0, arg_13_1)
	arg_13_0:updateGroupReward()
	arg_13_0.group_ui:updateUI(arg_13_1)
	arg_13_0:procFinish()
end

function GrowthGuideBase.toggleTrackingButton(arg_14_0)
	local var_14_0 = arg_14_0.vars.wnd:getChildByName("n_btn_tracking_on_off"):getChildByName("icon_on")
	
	arg_14_0:setTrackingButton(not var_14_0:isVisible())
end

function GrowthGuideBase.setTrackingButton(arg_15_0, arg_15_1)
	arg_15_1 = not GrowthGuide:isClearAllQuests(arg_15_0.group_ui.select_id) and arg_15_1 or false
	
	GrowthGuide:setTrackingGroupID(arg_15_1 and arg_15_0.group_ui.select_id or nil)
	arg_15_0:updateTrackingButton()
end

function GrowthGuideBase.openQuestDetailByID(arg_16_0, arg_16_1)
	arg_16_0:openQuestDetail(GrowthGuide:getQuestDB(arg_16_1))
end

function GrowthGuideBase.openQuestDetail(arg_17_0, arg_17_1)
	if not GrowthGuide:isOpenQuest(arg_17_1) then
		return 
	end
	
	local var_17_0 = GrowthGuide:getGroupDB()[arg_17_0.group_ui.select_id]
	local var_17_1 = load_dlg("growth_guide_detail", true, "wnd", function()
		GrowthGuideBase:closeQuestDetail()
	end)
	
	arg_17_0.vars.quest_detail_dlg = var_17_1
	
	arg_17_0.vars.wnd:addChild(arg_17_0.vars.quest_detail_dlg)
	arg_17_0.vars.quest_detail_dlg:bringToFront()
	
	local var_17_2 = var_17_1:getChildByName("btn_help")
	
	if get_cocos_refid(var_17_2) then
		if_set_visible(var_17_2, nil, arg_17_1.detail)
		
		var_17_2.quest = arg_17_1
	end
	
	local var_17_3 = var_17_1:getChildByName("n_portrait")
	local var_17_4 = arg_17_1.guide_char or var_17_0 and var_17_0.guide_char or "npc1003"
	local var_17_5 = DB("character", var_17_4, "face_id") or "no_image"
	local var_17_6 = UIUtil:getPortraitAni(var_17_5, {
		pin_sprite_position_y = true
	})
	
	if var_17_6 then
		var_17_6:setScale(1)
		var_17_6:setAnchorPoint(0.5, 0)
		var_17_3:removeAllChildren()
		var_17_3:addChild(var_17_6)
	end
	
	if var_17_0 then
		if_set(var_17_1, "label_title", T(var_17_0.group_name))
	end
	
	if_set(var_17_1, "txt_balloon", T(arg_17_1.npc_balloon))
	if_set(var_17_1, "label_count", T(arg_17_1.quest_name))
	
	local var_17_7 = ConditionContentsManager:getGrowthGuideQuest():getScore(arg_17_1.id)
	local var_17_8 = tonumber(totable(GrowthGuide:getQuestDB(arg_17_1.id).value).count)
	
	var_17_1:getChildByName("progress_bar"):setPercent(var_17_7 / var_17_8 * 100)
	if_set(var_17_1, "t_percent", var_17_7 .. " / " .. var_17_8)
	if_set(var_17_1, "label_desc", T(arg_17_1.desc))
	arg_17_0:showRewardItem(var_17_1:getChildByName("n_item1"), arg_17_1.reward_id1, arg_17_1.reward_count1, arg_17_1.grade_rate1)
	arg_17_0:showRewardItem(var_17_1:getChildByName("n_item2"), arg_17_1.reward_id2, arg_17_1.reward_count2, arg_17_1.grade_rate2)
	arg_17_0:updateQuestDetailButton(arg_17_1)
end

function GrowthGuideBase.updateQuestDetailButtonByID(arg_19_0, arg_19_1)
	local var_19_0 = GrowthGuide:getQuestDB(arg_19_1)
	
	if var_19_0 then
		arg_19_0:updateQuestDetailButton(var_19_0)
	end
end

function GrowthGuideBase.updateQuestDetailButton(arg_20_0, arg_20_1)
	if not get_cocos_refid(arg_20_0.vars.quest_detail_dlg) then
		return 
	end
	
	local var_20_0 = GrowthGuide:isClearedAndPrevQuest(arg_20_1.group_id, arg_20_1.id)
	local var_20_1 = GrowthGuide:isRewardedQuest(arg_20_1.group_id, arg_20_1.id)
	local var_20_2 = var_20_0 and not var_20_1
	local var_20_3 = arg_20_1.id == arg_20_0.quest_ui.current_id and not var_20_1
	local var_20_4 = not var_20_3 and not var_20_2 and not var_20_1
	
	arg_20_0.vars.quest_detail_dlg:getChildByName("btn_move").quest = arg_20_1
	
	if_set_visible(arg_20_0.vars.quest_detail_dlg, "btn_move", var_20_3)
	if_set_visible(arg_20_0.vars.quest_detail_dlg, "btn_reward", var_20_2)
	
	local var_20_5 = arg_20_0.vars.quest_detail_dlg:getChildByName("btn_reward")
	
	if var_20_5 then
		var_20_5.quest_id = arg_20_1.id
	end
	
	if_set_visible(arg_20_0.vars.quest_detail_dlg, "n_complete", var_20_1)
	
	local var_20_6 = getChildByPath(arg_20_0.vars.quest_detail_dlg, "n_window/n_info")
	
	if_set_visible(var_20_6, nil, var_20_4)
end

function GrowthGuideBase.closeQuestDetail(arg_21_0)
	if not get_cocos_refid(arg_21_0.vars.wnd) then
		return 
	end
	
	if not get_cocos_refid(arg_21_0.vars.quest_detail_dlg) then
		return 
	end
	
	BackButtonManager:pop("growth_guide_detail")
	arg_21_0.vars.wnd:removeChild(arg_21_0.vars.quest_detail_dlg)
	
	arg_21_0.vars.quest_detail_dlg = nil
end

function GrowthGuideBase.close(arg_22_0)
	SceneManager:popScene()
	BackButtonManager:pop("TopBarNew." .. T("guidequest_title"))
end

function GrowthGuideBase.open(arg_23_0, arg_23_1)
	arg_23_0.vars = {}
	arg_23_0.vars.opts = arg_23_1
	
	local var_23_0 = arg_23_0.vars.opts.group_id
	local var_23_1 = arg_23_0.vars.opts.quest_id
	
	var_23_0 = var_23_0 or arg_23_0:getPriorityGroupID()
	arg_23_0.vars.wnd = load_dlg("growth_guide_base", true, "wnd")
	arg_23_0.base_layer = SceneManager:getRunningUIScene()
	
	arg_23_0.base_layer:addChild(arg_23_0.vars.wnd)
	TopBarNew:create(T("guidequest_title"), arg_23_0.vars.wnd, function()
		arg_23_0:close()
	end, nil, nil, "infogrowth")
	ConditionContentsManager:updateConditionDispatch({
		growth_guide = true
	})
	copy_functions(ScrollView, arg_23_0.quest_ui.scroll_view)
	
	local var_23_2 = arg_23_0.vars.wnd:getChildByName("scrollview_quest")
	
	var_23_2.STRETCH_INFO = nil
	
	arg_23_0.quest_ui.scroll_view:initScrollView(var_23_2, 298, 540, {
		force_horizontal = true,
		fit_height = true
	})
	copy_functions(ScrollView, arg_23_0.group_ui.scroll_view)
	arg_23_0.group_ui.scroll_view:initScrollView(arg_23_0.vars.wnd:getChildByName("scrollview_group"), 156, 195, {
		fit_height = true
	})
	
	local var_23_3, var_23_4 = GrowthGuide:getGroupDB()
	
	arg_23_0.group_ui.scroll_view:createScrollViewItems(var_23_4)
	arg_23_0:selectGroupByID(var_23_0)
	arg_23_0:updateGroupUI()
	arg_23_0.group_ui:scrollToCurrentGroup()
	
	if var_23_1 then
		arg_23_0:openQuestDetailByID(var_23_1)
	end
	
	if TutorialGuide:isPlayingTutorial("guide_quest") then
		arg_23_0.quest_ui.scroll_view:setTouchEnabled(false)
		TutorialGuide:setOnFinish(function()
			if not arg_23_0.quest_ui then
				return 
			end
			
			if not arg_23_0.quest_ui.scroll_view then
				return 
			end
			
			if not get_cocos_refid(arg_23_0.quest_ui.scroll_view.scrollview) then
				return 
			end
			
			arg_23_0.quest_ui.scroll_view:setTouchEnabled(true)
		end)
	end
	
	TutorialGuide:procGuide("guide_quest")
	GrowthGuideInfo:procUnlock()
	callButtonEvent(arg_23_0.vars.opts.ui_event, arg_23_0.vars.opts.btn)
	
	if arg_23_0.vars.opts.main_tab and arg_23_0.vars.opts.btn and arg_23_0.vars.opts.btn == "btn_top_inventory" then
		Inventory:selectMainTab(tonumber(arg_23_0.vars.opts.main_tab))
	end
end

function GrowthGuideBase.getPriorityGroupID(arg_26_0)
	local var_26_0 = GrowthGuide:getTrackingGroupID()
	
	if var_26_0 and not GrowthGuide:isGroupLockedByID(var_26_0) then
		return var_26_0
	end
	
	local var_26_1, var_26_2 = GrowthGuide:getGroupDB()
	
	for iter_26_0, iter_26_1 in pairs(var_26_2) do
		if not GrowthGuide:isGroupLockedByID(iter_26_1.group_id) and not GrowthGuide:isClearAllQuests(iter_26_1.group_id) then
			return iter_26_1.group_id
		end
	end
	
	for iter_26_2, iter_26_3 in pairs(var_26_2) do
		if not GrowthGuide:isGroupLockedByID(iter_26_3.group_id) and GrowthGuide:getCountRewardableQuests(iter_26_3.group_id) ~= 0 then
			return iter_26_3.group_id
		end
	end
	
	return nil
end

function GrowthGuideBase.selectGroupByID(arg_27_0, arg_27_1)
	local var_27_0, var_27_1 = GrowthGuide:getGroupDB()
	
	arg_27_0:selectGroup(var_27_0[arg_27_1])
end

function GrowthGuideBase.showRewardItem(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	if_set_visible(arg_28_1, nil, arg_28_2)
	
	if not arg_28_2 then
		return 
	end
	
	local var_28_0 = false
	
	if string.starts(arg_28_2, "e") then
		local var_28_1 = DB("equip_item", arg_28_2, {
			"type"
		})
		
		if var_28_1 and var_28_1 == "artifact" then
			var_28_0 = true
		end
	end
	
	UIUtil:getRewardIcon(arg_28_3, arg_28_2, {
		hero_multiply_scale = 1.08,
		artifact_multiply_scale = 0.75,
		show_equip_count = true,
		scale = 1,
		use_badge = true,
		parent = arg_28_1,
		grade_rate = arg_28_4,
		use_gCount = var_28_0
	})
end

function GrowthGuideBase.group_ui.updateScrollView(arg_29_0)
	local var_29_0 = {}
	
	for iter_29_0, iter_29_1 in pairs(arg_29_0.scroll_view.ScrollViewItems) do
		local var_29_1 = iter_29_1.item
		
		if GrowthGuide:isGroupClear(var_29_1.group_id) then
			var_29_1.sort = var_29_1.sort + 10000
		end
		
		if GrowthGuide:isCategoryHide(var_29_1.questgroup_category) then
			table.insert(var_29_0, var_29_1)
		end
	end
	
	arg_29_0.scroll_view:sort(function(arg_30_0, arg_30_1)
		return arg_30_0.item.sort < arg_30_1.item.sort
	end)
	
	for iter_29_2, iter_29_3 in pairs(var_29_0) do
		arg_29_0.scroll_view:removeScrollViewItem(iter_29_3, true)
	end
	
	for iter_29_4, iter_29_5 in pairs(arg_29_0.scroll_view.ScrollViewItems) do
		arg_29_0:updateGroupItemUI(iter_29_5.control, iter_29_5.item)
	end
end

function GrowthGuideBase.group_ui.scrollToCurrentGroup(arg_31_0)
	if not arg_31_0.select_id then
		return 
	end
	
	arg_31_0.scroll_view:scrollToIndex(arg_31_0:getGroupIndexByID(arg_31_0.select_id) or 1)
end

function GrowthGuideBase.group_ui.getGroupIndexByID(arg_32_0, arg_32_1)
	if arg_32_0.scroll_view.ScrollViewItems == nil or #arg_32_0.scroll_view.ScrollViewItems == 0 then
		Log.e("GrowthGuideBase.group_ui.scroll_view is not initialized.")
		
		return nil
	end
	
	for iter_32_0, iter_32_1 in pairs(arg_32_0.scroll_view.ScrollViewItems) do
		if iter_32_1.item.group_id == arg_32_1 then
			return iter_32_0
		end
	end
	
	return nil
end

function GrowthGuideBase.updateGroupReward(arg_33_0)
	local var_33_0 = arg_33_0.group_ui.select_id
	local var_33_1 = GrowthGuide:getGroupDB(var_33_0)
	local var_33_2 = GrowthGuide:isRewadableState(var_33_0)
	local var_33_3 = GrowthGuide:isGroupRewarded(arg_33_0.group_ui.select_id)
	local var_33_4 = var_33_2 and 255 or 76.5
	local var_33_5 = arg_33_0.vars.wnd:getChildByName("btn_group_reward")
	
	if_set_opacity(var_33_5, nil, var_33_4)
	if_set_visible(var_33_5, "icon_noti", var_33_2)
	
	local var_33_6 = var_33_3 and T("guidequest_complite") or T("guidequest_main_get_total_reward")
	
	if_set(getChildByPath(arg_33_0.vars.wnd, "RIGHT/btn_group_reward/txt"), nil, var_33_6)
	
	local var_33_7 = getChildByPath(arg_33_0.vars.wnd, "LEFT/reward")
	
	if_set_opacity(var_33_7, nil, var_33_4)
	
	local var_33_8 = var_33_7:getChildByName("n_item1")
	
	arg_33_0:showRewardItem(var_33_8, var_33_1.achv_reward_id1, var_33_1.achv_reward_count1)
	
	local var_33_9 = var_33_7:getChildByName("n_item2")
	
	arg_33_0:showRewardItem(var_33_9, var_33_1.achv_reward_id2, var_33_1.achv_reward_count2)
	
	local var_33_10 = var_33_7:getChildByName("label_title")
	
	if_set(var_33_10, nil, T("guidequest_group_reward_info", {
		guidequest_group_name = T(var_33_1.group_name)
	}))
end

function GrowthGuideBase.updateTrackingButton(arg_34_0)
	local var_34_0 = arg_34_0.group_ui.select_id == GrowthGuide:getTrackingGroupID()
	local var_34_1 = not GrowthGuide:isClearAllQuests(arg_34_0.group_ui.select_id)
	local var_34_2 = arg_34_0.vars.wnd:getChildByName("n_btn_tracking_on_off")
	
	var_34_0 = var_34_1 and var_34_0 or false
	
	if_set_visible(var_34_2, "icon_on", var_34_0)
	if_set_visible(var_34_2, "icon_off", not var_34_0)
	if_set(var_34_2, "label", T(var_34_0 and "growth_guide_tracking_on" or "growth_guide_tracking_off"))
	if_set_visible(var_34_2, nil, var_34_1)
	var_34_2:getChildByName("icon_on"):bringToFront()
	var_34_2:getChildByName("icon_off"):bringToFront()
end

function GrowthGuideBase.onUpdateUI(arg_35_0)
	Lobby:updateGrowthGuide()
	
	if not arg_35_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_35_0.vars.wnd) then
		return 
	end
	
	arg_35_0:updateGroupUI()
	arg_35_0.quest_ui:updateScrollView(arg_35_0.group_ui.select_id)
	GrowthGuideInfo:procUnlock()
end

function GrowthGuideBase.updateGroupUI(arg_36_0)
	if not arg_36_0.group_ui.select_id then
		return 
	end
	
	local var_36_0 = arg_36_0.group_ui.select_id
	local var_36_1 = GrowthGuide:getGroupDB(var_36_0)
	
	if_set_sprite(arg_36_0.vars.wnd, "bg", var_36_1.image)
	arg_36_0.group_ui:updateScrollView()
	
	local var_36_2 = arg_36_0.vars.wnd:getChildByName("btn_move_reward")
	local var_36_3 = GrowthGuide:getFirstNotRewardedQuestIDByGroupID(var_36_0)
	
	if_set_opacity(var_36_2, nil, var_36_3 and 255 or 76.5)
	if_set_visible(var_36_2, "icon_noti", var_36_3)
	
	local var_36_4 = arg_36_0.vars.wnd:getChildByName("btn_move_quest")
	local var_36_5 = GrowthGuide:getCurrentQuestIDByGroupID(var_36_0)
	
	if_set_opacity(var_36_4, nil, var_36_5 and 255 or 76.5)
	arg_36_0:updateTrackingButton()
	
	local var_36_6, var_36_7 = GrowthGuide:getGroupProgress(arg_36_0.group_ui.select_id)
	
	if_set(getChildByPath(arg_36_0.vars.wnd, "RIGHT/label_count"), nil, var_36_6 .. " / " .. var_36_7)
	arg_36_0:updateGroupReward()
end

function GrowthGuideBase.selectGroup(arg_37_0, arg_37_1)
	if not arg_37_1 then
		return 
	end
	
	if GrowthGuide:isGroupLocked(arg_37_1) then
		return 
	end
	
	arg_37_0.group_ui.select_id = arg_37_1.group_id
	
	arg_37_0:updateGroupUI()
	
	arg_37_0.quest_ui.last_index = 1
	
	arg_37_0:setQuests()
	
	local var_37_0 = arg_37_0.vars.wnd:getChildByName("scrollview_quest")
	
	arg_37_0.quest_ui:setMainUnit(var_37_0, arg_37_1.running_char)
	arg_37_0.quest_ui:updateScrollView(arg_37_0.group_ui.select_id)
end

function GrowthGuideBase.setQuests(arg_38_0)
	local var_38_0 = GrowthGuide:getDBQuestListByGroupID(arg_38_0.group_ui.select_id)
	
	arg_38_0.quest_ui.scroll_view:createScrollViewItems(var_38_0)
	ConditionContentsManager:checkState(CONTENTS_TYPE.GROWTH_GUIDE_QUEST, {
		db_data = var_38_0
	})
end

function GrowthGuideBase.group_ui.updateGroupItemUI(arg_39_0, arg_39_1, arg_39_2)
	if_set_sprite(arg_39_1, "emblem", arg_39_2.group_icon)
	
	local var_39_0 = arg_39_1:findChildByName("t_title")
	local var_39_1 = var_39_0:getContentSize().width
	local var_39_2 = T(arg_39_2.group_name)
	local var_39_3 = string.split(var_39_2, "[ -]", false)
	local var_39_4 = 0
	
	for iter_39_0, iter_39_1 in pairs(var_39_3) do
		var_39_0:setString(iter_39_1)
		
		var_39_4 = math.max(var_39_4, var_39_0:getAutoRenderSize().width)
	end
	
	if var_39_1 < var_39_4 then
		var_39_0.origin_scale_x = var_39_0.origin_scale_x or var_39_0:getScaleX()
		
		var_39_0:setScaleX(var_39_0.origin_scale_x * (var_39_1 / var_39_4))
	end
	
	if_set(var_39_0, nil, var_39_2)
	
	local var_39_5 = arg_39_0.select_id == arg_39_2.group_id
	
	if_set_visible(arg_39_1, "select", var_39_5)
	
	local var_39_6 = GrowthGuide:isGroupLocked(arg_39_2)
	
	if_set_visible(arg_39_1, "icon_locked", var_39_6)
	if_set_visible(arg_39_1, "progress_bar", not var_39_6)
	if_set_visible(arg_39_1, "reward_count", not var_39_6)
	if_set_visible(arg_39_1, "t_count", not var_39_6)
	if_set_opacity(arg_39_1, "n_card", var_39_6 and 76.5 or 255)
	
	if var_39_6 then
		return 
	end
	
	local var_39_7 = arg_39_1:getChildByName("n_progress")
	local var_39_8, var_39_9 = GrowthGuide:getGroupProgress(arg_39_2.group_id)
	
	if_set(arg_39_1, "t_count", var_39_8 .. " / " .. var_39_9)
	
	local var_39_10 = var_39_7:getChildByName("progress_bar")
	
	var_39_10:setVisible(false)
	
	local var_39_11 = WidgetUtils:createCircleProgress("img/_hero_s_frame_w.png")
	
	var_39_11:setScale(var_39_10:getScale())
	var_39_11:setOpacity(var_39_10:getOpacity())
	var_39_11:setColor(var_39_10:getColor())
	var_39_11:setReverseDirection(false)
	var_39_11:setPercentage(var_39_8 / var_39_9 * 100)
	var_39_11:setName("@progress")
	var_39_7:addChild(var_39_11)
	
	local var_39_12 = GrowthGuide:isGroupRewardableState(arg_39_2.group_id)
	local var_39_13 = GrowthGuide:getCountRewardableQuests(arg_39_2.group_id) + (var_39_12 and 1 or 0)
	
	if_set_visible(arg_39_1, "reward_count", var_39_13 ~= 0)
	if_set(arg_39_1, "label_count", var_39_13)
end

function GrowthGuideBase.group_ui.updateUI(arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0:getIndexByID(arg_40_1)
	
	if not var_40_0 then
		return 
	end
	
	local var_40_1 = arg_40_0.scroll_view.ScrollViewItems[var_40_0]
	
	arg_40_0:updateGroupItemUI(var_40_1.control, var_40_1.item)
end

function GrowthGuideBase.group_ui.getIndexByID(arg_41_0, arg_41_1)
	if arg_41_0.scroll_view.ScrollViewItems == nil or #arg_41_0.scroll_view.ScrollViewItems == 0 then
		Log.e("GrowthGuideBase.group_ui.scroll_view is not initialized.")
		
		return nil
	end
	
	for iter_41_0, iter_41_1 in pairs(arg_41_0.scroll_view.ScrollViewItems) do
		if iter_41_1.item.group_id == arg_41_1 then
			return iter_41_0
		end
	end
	
	return nil
end

function GrowthGuideBase.group_ui.scroll_view.getScrollViewItem(arg_42_0, arg_42_1)
	local var_42_0 = load_dlg("growth_guide_group_item", nil, "wnd")
	
	var_42_0:getChildByName("btn_select").item = arg_42_1
	
	if_set_sprite(var_42_0, "emblem", arg_42_1.group_icon)
	GrowthGuideBase.group_ui:updateGroupItemUI(var_42_0, arg_42_1)
	
	local var_42_1 = GrowthGuide:isGroupLocked(arg_42_1)
	
	if_set_visible(var_42_0, "icon_locked", var_42_1)
	if_set_opacity(var_42_0, "n_card", var_42_1 and 76.5 or 255)
	
	return var_42_0
end

function GrowthGuideBase.quest_ui.scroll_view.getScrollViewItem(arg_43_0, arg_43_1)
	local var_43_0 = load_dlg("growth_guide_quest_item", nil, "wnd")
	
	var_43_0:getChildByName("btn_detail").item = arg_43_1
	
	if_set_visible(var_43_0, "Img_line", #arg_43_0.ScrollViewItems == 0)
	
	return var_43_0
end

function GrowthGuideBase.quest_ui.getQuestByIndex(arg_44_0, arg_44_1)
	if arg_44_0.scroll_view.ScrollViewItems == nil or #arg_44_0.scroll_view.ScrollViewItems == 0 then
		Log.e("GrowthGuideBase.quest_ui.scroll_view is not initialized.")
		
		return nil
	end
	
	return arg_44_0.scroll_view.ScrollViewItems[arg_44_1].item
end

function GrowthGuideBase.quest_ui.getQuestIndexByID(arg_45_0, arg_45_1)
	if arg_45_0.scroll_view.ScrollViewItems == nil or #arg_45_0.scroll_view.ScrollViewItems == 0 then
		Log.e("GrowthGuideBase.quest_ui.scroll_view is not initialized.")
		
		return nil
	end
	
	for iter_45_0, iter_45_1 in pairs(arg_45_0.scroll_view.ScrollViewItems) do
		if iter_45_1.item.id == arg_45_1 then
			return iter_45_0
		end
	end
	
	return nil
end

function GrowthGuideBase.quest_ui.scrollToFirstNotRewardedQuest(arg_46_0, arg_46_1)
	local var_46_0 = GrowthGuideBase.group_ui.select_id
	
	if not var_46_0 then
		return 
	end
	
	local var_46_1 = GrowthGuide:getFirstNotRewardedQuestIDByGroupID(var_46_0)
	
	if not var_46_1 then
		return 
	end
	
	local var_46_2 = arg_46_0:getQuestIndexByID(var_46_1)
	
	arg_46_0.scroll_view:scrollToIndex(var_46_2)
end

function GrowthGuideBase.quest_ui.scrollToCurrentQuest(arg_47_0, arg_47_1)
	local var_47_0 = GrowthGuideBase.group_ui.select_id
	
	if not var_47_0 then
		return 
	end
	
	local var_47_1 = GrowthGuide:getCurrentQuestIDByGroupID(var_47_0)
	
	if not var_47_1 then
		return 
	end
	
	local var_47_2 = arg_47_0:getQuestIndexByID(var_47_1)
	
	arg_47_0.scroll_view:scrollToIndex(var_47_2)
end

function GrowthGuideBase.quest_ui.updateScrollView(arg_48_0, arg_48_1)
	if GrowthGuide:isClearAllQuests(arg_48_1) then
		if_set_visible(arg_48_0.unit, nil, false)
		
		local var_48_0 = GrowthGuide:isRewardedAllQuests(arg_48_1) and GrowthGuide:getGroupLastQuest(arg_48_1).id or GrowthGuide:getFirstNotRewardedQuestIDByGroupID(arg_48_1)
		local var_48_1 = arg_48_0:getQuestIndexByID(var_48_0)
		
		arg_48_0.scroll_view:jumpToIndex(var_48_1)
	else
		arg_48_0.prev_id = GrowthGuide:getLastClearQuestID(arg_48_1) or arg_48_0:getQuestByIndex(1).id
		arg_48_0.current_id = GrowthGuide:getCurrentQuestIDByGroupID(arg_48_1)
		
		GrowthGuide:setLastClearQuestID(arg_48_1, arg_48_0.current_id)
		
		arg_48_0.group_id = arg_48_1
		
		local var_48_2 = arg_48_0:getQuestIndexByID(arg_48_0.prev_id)
		local var_48_3 = arg_48_0:getQuestIndexByID(arg_48_0.current_id)
		
		if var_48_2 and var_48_3 then
			arg_48_0.scroll_view:jumpToIndex(var_48_2)
			arg_48_0.scroll_view:scrollToIndex(var_48_3, 10)
			arg_48_0:moveMainUnit()
		end
	end
	
	for iter_48_0, iter_48_1 in pairs(arg_48_0.scroll_view.ScrollViewItems) do
		arg_48_0:setQuestItemByIndex(iter_48_0)
	end
end

function GrowthGuideBase.quest_ui.updateQuestUI(arg_49_0, arg_49_1)
	local var_49_0 = arg_49_0:getQuestIndexByID(arg_49_1)
	
	if not var_49_0 then
		return 
	end
	
	local var_49_1 = arg_49_0.scroll_view.ScrollViewItems[var_49_0]
	
	arg_49_0:setQuestItem(var_49_1.control, var_49_1.item)
end

function GrowthGuideBase.quest_ui.getQuestIndexByItem(arg_50_0, arg_50_1)
	return arg_50_0:getQuestIndexByID(arg_50_1.id)
end

function GrowthGuideBase.quest_ui.setQuestItemByIndex(arg_51_0, arg_51_1)
	arg_51_0:setQuestItem(arg_51_0.scroll_view.ScrollViewItems[arg_51_1].control, arg_51_0.scroll_view.ScrollViewItems[arg_51_1].item)
end

function GrowthGuideBase.quest_ui.setQuestItem(arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = GrowthGuide:isExpectedUpdateQuest(arg_52_2)
	local var_52_1 = GrowthGuide:isUnknownQuest(arg_52_2)
	local var_52_2 = arg_52_2.id == arg_52_0.current_id
	local var_52_3 = GrowthGuide:isClearedAndPrevQuest(arg_52_2.group_id, arg_52_2.id)
	local var_52_4 = GrowthGuide:isClearedAndAfterQuest(arg_52_2.group_id, arg_52_2.id)
	local var_52_5 = GrowthGuide:isRewardedQuest(arg_52_2.group_id, arg_52_2.id)
	local var_52_6 = GrowthGuide:isRewardableQuest(arg_52_2.group_id, arg_52_2.id)
	local var_52_7 = arg_52_2.reward_id2 and arg_52_2.reward_id2 ~= ""
	local var_52_8 = arg_52_1:findChildByName("bg_area")
	local var_52_9 = arg_52_1:findChildByName("label_title")
	local var_52_10 = arg_52_1:findChildByName("n_lock")
	local var_52_11 = arg_52_1:findChildByName("t_disc")
	
	if_set(var_52_9, nil, T(arg_52_2.name))
	if_set(var_52_11, nil, var_52_1 and T("mission_name_desc") or T(arg_52_2.quest_name))
	if_set_visible(var_52_11, nil, not var_52_0)
	if_set_visible(var_52_10, nil, var_52_0)
	if_set_opacity(var_52_10, nil, var_52_2 and 255 or 76.5)
	
	if var_52_3 then
		if_set_color(var_52_8, nil, cc.c3b(107, 193, 27, 255))
		if_set_opacity(var_52_8, nil, 255)
		if_set_color(var_52_9, nil, cc.c3b(107, 193, 27, 255))
		if_set_opacity(var_52_11, nil, 76.5)
	elseif var_52_4 then
		if_set_color(var_52_8, nil, cc.c3b(107, 193, 27, 255))
		if_set_opacity(var_52_8, nil, 102)
		if_set_color(var_52_9, nil, cc.c3b(107, 193, 27, 255))
		if_set_opacity(var_52_11, nil, 76.5)
	elseif var_52_2 then
		if_set_color(var_52_8, nil, cc.c3b(255, 255, 255))
		if_set_opacity(var_52_8, nil, 102)
		if_set_color(var_52_9, nil, cc.c4b(255, 255, 255, 255))
		if_set_opacity(var_52_11, nil, 255)
	else
		if_set_opacity(var_52_8, nil, 0)
		if_set_opacity(var_52_9, nil, 102)
		if_set_opacity(var_52_11, nil, 76.5)
	end
	
	if_set_visible(arg_52_1, "icon_check", var_52_5)
	
	local var_52_12 = arg_52_1:getChildByName("n_reward_1/1")
	local var_52_13 = arg_52_1:getChildByName("n_reward_2/2")
	local var_52_14 = var_52_0 or var_52_1 or not var_52_7
	
	arg_52_1.n_reward = var_52_14 and var_52_12 or var_52_13
	
	local var_52_15 = arg_52_1.n_reward:getChildByName("btn_reward")
	
	var_52_15.item = arg_52_2
	
	if_set_visible(var_52_15, nil, var_52_6)
	if_set_visible(var_52_12, nil, var_52_14)
	if_set_visible(var_52_13, nil, not var_52_14)
	if_set_opacity(arg_52_1.n_reward, nil, var_52_5 and 127.5 or 255)
	
	if var_52_0 or var_52_1 then
		local var_52_16 = arg_52_1:findChildByName("n_item1/1"):findChildByName("n_unknown")
		
		if_set_visible(var_52_16, nil, true)
	elseif var_52_7 then
		GrowthGuideBase:showRewardItem(arg_52_1:getChildByName("n_item1/2"), arg_52_2.reward_id1, arg_52_2.reward_count1, arg_52_2.grade_rate1)
		GrowthGuideBase:showRewardItem(arg_52_1:getChildByName("n_item2/2"), arg_52_2.reward_id2, arg_52_2.reward_count2, arg_52_2.grade_rate2)
	else
		GrowthGuideBase:showRewardItem(arg_52_1:getChildByName("n_item1/1"), arg_52_2.reward_id1, arg_52_2.reward_count1, arg_52_2.grade_rate1)
	end
	
	if var_52_6 then
		if not UIAction:Find(arg_52_2.id) then
			UIAction:Add(LOOP(SEQ(MOVE_TO(600, 150, 105), MOVE_TO(600, 150, 115))), arg_52_1.n_reward, arg_52_2.id)
		end
	else
		UIAction:Remove(arg_52_2.id)
	end
	
	if arg_52_0.scroll_view:getScrollViewItemIndex(arg_52_1:getPosition()) == arg_52_0.scroll_view:getScrollViewItemIndex(arg_52_0.unit:getPosition()) then
		arg_52_1.n_reward:setPositionY(350)
	end
end

function GrowthGuideBase.quest_ui.getUnitXPositionByID(arg_53_0, arg_53_1)
	local var_53_0 = arg_53_0:getQuestIndexByID(arg_53_1)
	local var_53_1, var_53_2 = arg_53_0.scroll_view:getScrollViewItemPosition(var_53_0 - 1, 0)
	
	return var_53_1
end

function GrowthGuideBase.quest_ui.setMainUnit(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = 1.2
	local var_54_1 = arg_54_2 and UNIT:create({
		code = arg_54_2
	}) or Account:getMainUnit()
	
	arg_54_0.unit = ur.ModelStage:create(CACHE:getModel(var_54_1.db))
	
	arg_54_0.unit:setScaleFactor(var_54_0)
	arg_54_0.unit:setAnimation(0, "idle", true)
	arg_54_1:addChild(arg_54_0.unit)
	arg_54_0.unit:bringToFront()
end

function GrowthGuideBase.quest_ui.moveMainUnit(arg_55_0)
	local var_55_0 = CHARACTER_SPEED * 2
	local var_55_1 = "character_move"
	local var_55_2 = 110
	
	UIAction:Remove(var_55_1)
	
	local var_55_3 = arg_55_0:getUnitXPositionByID(arg_55_0.prev_id)
	local var_55_4 = arg_55_0:getUnitXPositionByID(arg_55_0.current_id)
	local var_55_5 = var_55_4 - var_55_3
	
	arg_55_0.unit:setPosition(var_55_3, var_55_2)
	
	if var_55_5 < math.epsilon then
		arg_55_0.unit:setAnimation(0, "idle", true)
		
		return 
	end
	
	local function var_55_6(arg_56_0)
		UIAction:Remove(arg_55_0:getQuestByIndex(arg_56_0).id)
		
		local var_56_0 = arg_55_0.scroll_view.ScrollViewItems[arg_56_0].control.n_reward
		
		if not UIAction:Find(var_56_0) then
			UIAction:Add(LOG(MOVE_TO(250, 150, 350)), var_56_0)
		end
	end
	
	local function var_55_7(arg_57_0)
		local var_57_0 = arg_55_0.scroll_view.ScrollViewItems[arg_57_0].control.n_reward
		
		UIAction:Add(SEQ(MOVE_TO(700, 150, 105), CALL(function()
			arg_55_0:setQuestItemByIndex(arg_57_0)
		end)), var_57_0)
	end
	
	arg_55_0.unit:setAnimation(0, "run", true)
	
	arg_55_0.unit:getCurrent().timeScale = CHARACTER_ANI_TIMESCALE
	
	local var_55_8 = arg_55_0.unit:getPosition()
	
	set_high_fps_tick()
	
	if not UIAction:Find(var_55_1) then
		UIAction:Add(SPAWN(SEQ(MOVE_TO(var_55_5 * var_55_0, var_55_4, var_55_2), CALL(function()
			arg_55_0.unit:setAnimation(0, "idle", true)
		end), CALL(function()
			UIAction:Remove(var_55_1)
		end)), LOOP(SEQ(DELAY(5), CALL(function()
			local var_61_0 = arg_55_0.scroll_view:getScrollViewItemIndex(var_55_8)
			local var_61_1 = arg_55_0.scroll_view:getScrollViewItemIndex(arg_55_0.unit:getPosition())
			
			if var_61_0 == var_61_1 then
				return 
			end
			
			var_55_6(var_61_1)
			var_55_7(var_61_0)
			
			var_55_8 = arg_55_0.unit:getPosition()
		end)))), arg_55_0.unit, var_55_1)
	end
end

function GrowthGuideBase.quest_ui.getMainUnit(arg_62_0)
	return arg_62_0.unit
end

function GrowthGuideBase.quest_ui.getCurrentReward(arg_63_0)
	local var_63_0 = arg_63_0.scroll_view:getScrollViewItemIndex(arg_63_0.unit:getPosition())
	
	return arg_63_0.scroll_view.ScrollViewItems[var_63_0].control.n_reward
end
