UnitInfosSubStory = {}

function HANDLER.hero_detail_substory_item()
end

function HANDLER.hero_detail_substory(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_storylist" then
		local var_2_0 = UnitInfosSubStory:getSelectedItem()
		
		SubStoryEntrance:show("SYSTEM_STORY", nil, nil, {
			id = var_2_0.id
		})
	elseif arg_2_1 == "btn_book" then
		Dialog:msgBox(T("collection_move"), {
			yesno = true,
			handler = function()
				local var_3_0 = {
					mode = "story",
					parent_id = "story7",
					select_item = UnitInfosSubStory:getSelectedItem()
				}
				
				if not Account:checkQueryEmptyDungeonData("collection", var_3_0) then
					SceneManager:reserveResetSceneFlow()
					SceneManager:nextScene("collection", var_3_0)
				end
			end
		})
	end
end

function HANDLER.hero_detail_substory_detail(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_close" then
		UnitInfosSubStory:closeDetail()
	end
	
	if arg_4_1 == "btn_play_brown" then
		UnitInfosSubStory:startStory(arg_4_0)
	end
	
	if arg_4_1 == "btn_battle" then
		SubStoryViewerBattle:onBattle()
	end
end

function UnitInfosSubStory.openDetail(arg_5_0)
	if not arg_5_0.vars.selected_item then
		return 
	end
	
	if not SubStoryViewerUtil:checkIsActive(arg_5_0.vars.selected_item) then
		balloon_message_with_sound("hero_detail_story_cast_desc")
		
		return 
	end
	
	local var_5_0 = load_dlg("hero_detail_substory_detail", true, "wnd")
	
	if_set(var_5_0, "title", T(arg_5_0.vars.selected_item.name))
	if_set(var_5_0, "txt_desc", T(arg_5_0.vars.selected_item.desc))
	
	arg_5_0.vars.detail_listView = ItemListView_v2:bindControl(var_5_0:findChildByName("ListView"))
	
	local var_5_1 = load_control("wnd/dict_substory_bar.csb")
	local var_5_2 = {
		onUpdate = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			arg_5_0:onItemUpdate(arg_6_1, arg_6_3)
		end
	}
	local var_5_3 = SubStoryViewerDB:getSubStory(arg_5_0.vars.selected_item.id)
	
	arg_5_0.vars.detail_listView:setRenderer(var_5_1, var_5_2)
	arg_5_0.vars.detail_listView:setListViewCascadeEnabled(true)
	arg_5_0.vars.detail_listView:setDataSource(var_5_3)
	
	arg_5_0.vars.detail_popup = var_5_0
	
	BackButtonManager:push({
		check_id = "SubStoryDetail",
		back_func = function()
			UnitInfosSubStory:closeDetail()
		end
	})
	SceneManager:getRunningPopupScene():addChild(arg_5_0.vars.detail_popup)
end

function UnitInfosSubStory.closeDetail(arg_8_0)
	BackButtonManager:pop("SubStoryDetail")
	arg_8_0.vars.detail_popup:removeFromParent()
end

function UnitInfosSubStory.startStory(arg_9_0, arg_9_1)
	if not arg_9_1.data.isCanShow then
		if arg_9_1.data.unlock_msg then
			balloon_message_with_sound(arg_9_1.data.unlock_msg)
		else
			balloon_message_with_sound("ui_dict_story_yet")
		end
		
		return 
	end
	
	local var_9_0 = SceneManager:getRunningPopupScene()
	
	arg_9_0.vars.wnd_detail = cc.Layer:create()
	
	var_9_0:addChild(arg_9_0.vars.wnd_detail)
	arg_9_0.vars.wnd_detail:setCascadeOpacityEnabled(true)
	arg_9_0.vars.wnd_detail:setVisible(false)
	arg_9_0.vars.wnd_detail:setOpacity(0)
	
	local var_9_1 = 500
	
	UIAction:Add(SEQ(FADE_OUT(var_9_1), SHOW(false)), arg_9_0.vars.dlg, "block")
	UIAction:Add(SEQ(SHOW(true), FADE_IN(var_9_1)), arg_9_0.vars.wnd_detail, "block")
	UIAction:Add(SEQ(SHOW(false)), arg_9_0.vars.detail_popup, "block")
	CollectionStoryDetail:play(arg_9_0.vars.wnd_detail, arg_9_1.data, function()
		UIAction:Add(SEQ(FADE_OUT(var_9_1), SHOW(false), REMOVE()), arg_9_0.vars.wnd_detail, "block")
		UIAction:Add(SEQ(SHOW(true), FADE_IN(var_9_1)), arg_9_0.vars.dlg, "block")
		UIAction:Add(SEQ(SHOW(true), FADE_IN(var_9_1)), arg_9_0.vars.detail_popup, "block")
	end)
	
	arg_9_0.vars.wnd_bg = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	arg_9_0.vars.wnd_bg:setAnchorPoint(0.5, 0.5)
	arg_9_0.vars.wnd_bg:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	arg_9_0.vars.wnd_bg:setPositionX(VIEW_BASE_LEFT)
	arg_9_0.vars.wnd_detail:addChild(arg_9_0.vars.wnd_bg)
end

function UnitInfosSubStory.onItemUpdate(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = SubStoryViewerUtil:checkIsActive(arg_11_0.vars.selected_item)
	
	SubStoryViewerUtil:onSubStoryItemUpdate(arg_11_1, arg_11_2, var_11_0)
end

function UnitInfosSubStory.getSelectedItem(arg_12_0)
	return arg_12_0.vars.selected_item
end

function UnitInfosSubStory.onCreate(arg_13_0, arg_13_1)
	arg_13_0.vars = {}
	arg_13_0.vars.dlg = load_dlg("hero_detail_substory", true, "wnd")
	arg_13_0.vars.scrollView = arg_13_0.vars.dlg:findChildByName("ScrollView")
	
	local var_13_0 = UnitInfosController:getUnit()
	
	if not var_13_0 then
		return 
	end
	
	local var_13_1 = var_13_0.db.code
	local var_13_2 = arg_13_0:getCharacterSubStories(var_13_0)
	local var_13_3 = table.count(var_13_2 or {}) > 0
	
	if_set_visible(arg_13_0.vars.dlg, "btn_storylist", var_13_3)
	
	if not var_13_3 then
		local var_13_4 = arg_13_0.vars.dlg:findChildByName("btn_story")
		
		if_set_visible(var_13_4, nil, false)
		if_set_visible(arg_13_0.vars.dlg, "n_cast", false)
	end
	
	if_set_visible(arg_13_0.vars.dlg, "n_info", not var_13_3)
	SubStoryViewerScroll:create(var_13_1, 358, 194, "hero_detail_substory_item", arg_13_0.vars.scrollView, {
		select_callback = function(arg_14_0)
			arg_13_0.vars.selected_item = arg_14_0
			
			SubStoryViewerUtil:setHeroes(arg_13_0.vars.dlg:findChildByName("n_hero"), arg_14_0)
			
			local var_14_0 = SubStoryViewerUtil:checkIsActive(arg_13_0.vars.selected_item) and 255 or 76.5
			
			if_set_opacity(arg_13_0.vars.dlg, "btn_story", var_14_0)
		end
	})
	
	local var_13_5 = arg_13_0.vars.dlg:findChildByName("LEFT")
	local var_13_6 = arg_13_0.vars.dlg:findChildByName("RIGHT")
	
	var_13_5:setOpacity(0)
	var_13_6:setOpacity(0)
	UnitInfosUtil:setUnitDetail(arg_13_0.vars.dlg, var_13_5)
	if_set(var_13_5, "txt_story", T(DB("character", var_13_1, "story")))
	UIAction:Add(SEQ(SLIDE_IN(300, 600)), var_13_5, "block")
	UIAction:Add(SEQ(SLIDE_IN(300, -600)), var_13_6, "block")
	UnitMain:movePortrait("SubStory")
	arg_13_1:addChild(arg_13_0.vars.dlg)
	UnlockSystem:setUnlockUIState(arg_13_0.vars.dlg, "btn_storylist", UNLOCK_ID.SYSTEM_SUBSTORY, {
		icon_name = "n_locked",
		no_opacity = true
	})
end

function UnitInfosSubStory.isShow(arg_15_0)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.dlg) then
		return false
	end
	
	return true
end

function UnitInfosSubStory.updateItems(arg_16_0)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.dlg) or not get_cocos_refid(arg_16_0.vars.scrollView) then
		return 
	end
	
	if not arg_16_0.vars.selected_item then
		return 
	end
	
	SubStoryViewerScroll:updateItems()
end

function UnitInfosSubStory.onLeave(arg_17_0)
	if not arg_17_0.vars or not get_cocos_refid(arg_17_0.vars.dlg) then
		return 
	end
	
	local var_17_0 = arg_17_0.vars.dlg:findChildByName("LEFT")
	local var_17_1 = arg_17_0.vars.dlg:findChildByName("RIGHT")
	
	UIAction:Add(SEQ(SLIDE_OUT(200, -600)), var_17_0, "block")
	UIAction:Add(SEQ(SLIDE_OUT(200, 600)), var_17_1, "block")
	UIAction:Add(SEQ(DELAY(200), CALL(SubStoryViewerScroll.destroy, SubStoryViewerScroll), REMOVE()), arg_17_0.vars.dlg, "block")
end
