CollectionMainUI = {}
CollectionController = {}

local var_0_0 = {
	"hero",
	"arti",
	"monster",
	"story",
	"pet",
	"illust"
}
local var_0_1 = {
	"all",
	"fire",
	"ice",
	"wind",
	"dark",
	"light"
}

function MsgHandler.story_chapter_reward(arg_1_0)
	if arg_1_0.reward then
		Account:addReward(arg_1_0.reward, {
			single = true,
			effect = true
		})
		CollectionMainUI:onReceiveReward()
	end
end

function HANDLER.dict_main(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		CollectionController:release()
		
		return 
	end
	
	if string.starts(arg_2_1, "btn_book_") then
		local var_2_0 = string.sub(arg_2_1, #"btn_book_" + 1)
		
		if var_2_0 == "pet" and ContentDisable:byAlias("pet") then
			balloon_message(T("content_disable"))
			
			return 
		end
		
		CollectionController:openBook(var_2_0)
	end
end

function HANDLER.dict_base_renew(arg_3_0, arg_3_1)
	if string.starts(arg_3_1, "btn_open") then
		CollectionController:setLayerVisible(string.sub(arg_3_1, #"btn_open_" + 1), true)
	elseif string.starts(arg_3_1, "btn_close") then
		CollectionController:setLayerVisible(string.sub(arg_3_1, #"btn_close_" + 1), false)
	elseif string.starts(arg_3_1, "btn_sort") then
		CollectionController:setSort(string.sub(arg_3_1, #"btn_sort" + 1))
	elseif string.starts(arg_3_1, "btn_checkbox") then
		CollectionController:setToggleFilter(string.sub(arg_3_1, #"btn_checkbox_" + 1))
	elseif string.starts(arg_3_1, "btn_check") then
		CollectionController:setToggle(string.sub(arg_3_1, #"btn_check" + 1))
	elseif arg_3_1 == "btn_up" then
		CollectionController:setUpDown("up")
	elseif arg_3_1 == "btn_down" then
		CollectionController:setUpDown("down")
	elseif arg_3_1 == "btn_movie" then
		CollectionController:movieStart(arg_3_0.data)
	elseif arg_3_1 == "btn_illust" then
		CollectionController:openDetail(arg_3_0.data)
	elseif arg_3_1 == "btn_play_brown" then
		CollectionController:openDetail(arg_3_0.data)
	elseif arg_3_1 == "btn_select" then
		CollectionController:openDetail(arg_3_0.info)
	elseif arg_3_1 == "btn_play_all" then
		CollectionController:story_play_all()
	elseif arg_3_1 == "btn_search" then
		CollectionController:search()
	elseif arg_3_1 == "btn_all_hero_off" then
		CollectionController:onStoryCategoryOff()
	elseif arg_3_1 == "btn_by_story_off" then
		CollectionController:onStoryCategoryOn()
	elseif arg_3_1 == "btn_all_artifact_off" then
		CollectionController:onArtifactStoryCategoryOff()
	elseif arg_3_1 == "btn_story_artifact_off" then
		CollectionController:onArtifactStoryCategoryOn()
	elseif arg_3_1 == "btn_reward" then
		CollectionController:getChapterReward(arg_3_0.data)
	else
		arg_3_1 = arg_3_1 == "btn_book_illust" and "illust" or string.sub(arg_3_1, #"btn_" + 1)
		
		if arg_3_1 == "pet" and ContentDisable:byAlias("pet") then
			balloon_message(T("content_disable"))
			
			return 
		end
		
		for iter_3_0, iter_3_1 in pairs(var_0_0) do
			if arg_3_1 == iter_3_1 then
				CollectionController:openBook(arg_3_1)
				
				return 
			end
		end
	end
end

function CollectionController._debug_show_char_code()
	CollectionArtifactList:_debug_show_char_code()
	CollectionUnitList:_debug_show_char_code()
	CollectionMonsterList:_debug_show_char_code()
	CollectionPetList:_debug_show_char_code()
end

function CollectionController.isShow(arg_5_0)
	return CollectionMainUI:isShow()
end

function CollectionController.init(arg_6_0, arg_6_1)
	arg_6_0.vars = {}
	arg_6_0.vars.cur_mode = arg_6_1 or "main"
	arg_6_0.vars.mode = {
		main = "main",
		arti = CollectionArtifactList,
		hero = CollectionUnitList,
		monster = CollectionMonsterList,
		story = CollectionStoryList,
		pet = CollectionPetList,
		illust = CollectionIllustList
	}
	
	CollectionDB:init()
	
	for iter_6_0, iter_6_1 in pairs(arg_6_0.vars.mode) do
		if type(iter_6_1) == "table" then
			iter_6_1:init(CollectionDB:getModeDB(iter_6_0))
		end
	end
end

function CollectionController.open(arg_7_0)
	arg_7_0:init()
	CollectionMainUI:open(CollectionDB:getAllCountDB(), CollectionDB:getHaveCountDB())
end

function CollectionController.initScene(arg_8_0, arg_8_1)
	if not arg_8_1 then
		SoundEngine:play("event:/ui/main_hud/btn_dict")
	end
	
	arg_8_1 = arg_8_1 or {}
	
	SoundEngine:playBGM("event:/bgm/default")
	
	local var_8_0 = true
	
	if not arg_8_0.vars then
		local var_8_1 = arg_8_1.mode or "hero"
		
		if var_8_1 == "unit" then
			var_8_1 = "hero"
		end
		
		arg_8_0:init(var_8_1)
		CollectionMainUI:init(CollectionDB:getAllCountDB(), CollectionDB:getHaveCountDB())
	end
	
	arg_8_0.vars.enter_by_substory_home = arg_8_1.enter_by_substory_home
	arg_8_0.vars.dlc_enter = arg_8_1.dlc_enter
	
	local var_8_2 = CollectionMainUI:initScene()
	
	CollectionScrollView:init(var_8_2, function(arg_9_0)
		CollectionMainUI:onChangeName(arg_9_0)
	end)
	CollectionStoryChapterView:init(CollectionMainUI:getChapterScrollView(), function(arg_10_0, arg_10_1)
		CollectionMainUI:onChangeName(arg_10_0, arg_10_1)
	end)
	arg_8_0:openBook(arg_8_0.vars.cur_mode, true, arg_8_1)
end

function CollectionController.isSubStoryHomeMode(arg_11_0)
	if not arg_11_0.vars then
		return 
	end
	
	return arg_11_0.vars.enter_by_substory_home
end

function CollectionController.isDLCMode(arg_12_0)
	if not arg_12_0.vars then
		return 
	end
	
	return arg_12_0.vars.dlc_enter
end

function CollectionController.releaseEnterMode(arg_13_0)
	if not arg_13_0.vars then
		return 
	end
	
	arg_13_0.vars.enter_by_substory_home = nil
	arg_13_0.vars.dlc_enter = nil
end

function CollectionController.release(arg_14_0)
	if not arg_14_0.vars then
		return 
	end
	
	local var_14_0 = arg_14_0:isSubStoryHomeMode()
	local var_14_1 = arg_14_0:isDLCMode()
	
	CollectionMainUI:close()
	
	arg_14_0.vars = nil
	
	if var_14_0 then
		if var_14_0 == "theater" then
		elseif var_14_0 == "home" then
			SubStoryEntrance:show("HOME")
		end
	elseif var_14_1 then
		Account:showServerResUI("chronicle")
	end
end

function CollectionController.openDetail(arg_15_0, arg_15_1)
	CollectionMainUI:openDetail(arg_15_1)
end

function CollectionController.onStoryCategoryOn(arg_16_0)
	if not arg_16_0.vars.cur_mode == "hero" then
		return 
	end
	
	arg_16_0.vars.unit_category_sort_mode = "story"
	
	CollectionMainUI:onChangeStoryButton("story")
	CollectionUnitList:resetSortMode("story")
	SAVE:set("app.last_hero_category", "story")
end

function CollectionController.onStoryCategoryOff(arg_17_0)
	if not arg_17_0.vars.cur_mode == "hero" then
		return 
	end
	
	arg_17_0.vars.unit_category_sort_mode = "all"
	
	CollectionMainUI:onChangeStoryButton("all")
	CollectionUnitList:resetSortMode("all")
	SAVE:set("app.last_hero_category", "all")
end

function CollectionController.onArtifactStoryCategoryOn(arg_18_0)
	if not arg_18_0.vars.cur_mode == "arti" then
		return 
	end
	
	arg_18_0.vars.arti_category_sort_mode = "story"
	
	CollectionMainUI:onChangeArtifactStoryButton("story")
	CollectionArtifactList:resetSortMode("story")
	SAVE:set("app.last_artifact_category", "story")
end

function CollectionController.onArtifactStoryCategoryOff(arg_19_0)
	if not arg_19_0.vars.cur_mode == "arti" then
		return 
	end
	
	arg_19_0.vars.arti_category_sort_mode = "all"
	
	CollectionMainUI:onChangeArtifactStoryButton("all")
	CollectionArtifactList:resetSortMode("all")
	SAVE:set("app.last_artifact_category", "all")
	arg_19_0:setUpDown("up")
end

function CollectionController.storyStart(arg_20_0, arg_20_1)
	CollectionStoryDetail:play(arg_20_1)
end

function CollectionController.movieStart(arg_21_0, arg_21_1)
	CollectionStoryDetail:play_movie(arg_21_1)
end

function CollectionController.openBook(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	if arg_22_0.vars.cur_mode == arg_22_1 and not arg_22_2 then
		return 
	end
	
	if arg_22_0.vars.cur_mode == "main" then
		BackButtonManager:pop()
		SceneManager:nextScene("collection")
	elseif arg_22_1 == "story" then
		Account:showServerResUI("collection_story", arg_22_3)
	else
		arg_22_0:onSelectLeftSelectBooks(arg_22_1, arg_22_3)
	end
	
	arg_22_0.vars.cur_mode = arg_22_1
end

function CollectionController.onSelectLeftSelectBooks(arg_23_0, arg_23_1, arg_23_2)
	arg_23_2 = arg_23_2 or {}
	arg_23_2.mode = arg_23_2.mode or arg_23_1
	
	local var_23_0
	
	if arg_23_2.mode == "story" then
		Account:checkIncludeServerData("substory_progress")
		
		var_23_0 = CollectionMainUI:getStoryListView()
		
		local var_23_1 = CollectionMainUI:getSubStoryScrollView()
		
		arg_23_2.n_belt_substory = CollectionMainUI:getSubStoryBelt()
		arg_23_2.n_belt_chapter = CollectionMainUI:getChapterBelt()
		arg_23_2.chapter_scrollView = CollectionStoryChapterView
		arg_23_2.substory_scrollView = var_23_1
		arg_23_2.n_list_substory = CollectionMainUI:getSubStoryList()
		arg_23_2.n_list_story = CollectionMainUI:getStoryList()
		
		arg_23_2.chapter_scrollView:setOnChangeName(function(arg_24_0, arg_24_1)
			CollectionMainUI:onChangeName(arg_24_0, arg_24_1)
		end)
		
		function arg_23_2.onChangeChapter(arg_25_0, arg_25_1)
			CollectionMainUI:onChangeChapter(arg_25_0, arg_25_1)
		end
		
		CollectionScrollView:setOnChangeName(function(arg_26_0)
			CollectionMainUI:onChangeSubName(arg_26_0)
		end)
	else
		var_23_0 = CollectionMainUI:getListView()
		
		CollectionScrollView:setOnChangeName(function(arg_27_0)
			CollectionMainUI:onChangeName(arg_27_0)
		end)
	end
	
	if not var_23_0 then
		return 
	end
	
	if arg_23_2.mode == "unit" and arg_23_2.code then
		CollectionMainUI:openDetail({
			type = arg_23_2.mode,
			id = arg_23_2.code
		}, true)
		
		arg_23_1 = "hero"
	end
	
	CollectionMainUI:changeSelect(arg_23_0.vars.cur_mode, arg_23_1)
	CollectionMainUI:setSorterVisible(arg_23_0.vars.cur_mode, false)
	arg_23_0.vars.mode[arg_23_1]:open(var_23_0, CollectionScrollView, arg_23_2)
	
	arg_23_0.vars.cur_mode = arg_23_1
	arg_23_0.vars.unit_category_sort_mode = "story"
	arg_23_0.vars.arti_category_sort_mode = "all"
	
	if arg_23_1 == "hero" then
		if SAVE:get("app.last_hero_category", "story") == "story" then
			CollectionController:onStoryCategoryOn()
		else
			CollectionController:onStoryCategoryOff()
		end
	end
	
	if arg_23_1 == "arti" then
		if SAVE:get("app.last_artifact_category", "all") == "story" then
			CollectionController:onArtifactStoryCategoryOn()
		else
			CollectionController:onArtifactStoryCategoryOff()
		end
	end
	
	if arg_23_2.page then
		CollectionScrollView:setToIndex(arg_23_2.page)
	end
	
	if arg_23_2.sub_page then
		CollectionStoryChapterView:setToIndex(arg_23_2.sub_page)
	end
	
	if arg_23_1 == "hero" and arg_23_2.search_keyword then
		local var_23_2 = arg_23_0.vars.mode[arg_23_1]:search(arg_23_2.search_keyword)
		
		if var_23_2 then
			CollectionMainUI:onSearch(var_23_2)
		end
	end
end

function CollectionController.setLayerVisible(arg_28_0, arg_28_1, arg_28_2)
	if arg_28_0.vars.cur_mode == "story" then
		CollectionStoryList:setLayerVisible(arg_28_1, arg_28_2)
	elseif arg_28_1 == "sort" or arg_28_1 == "sort_active" then
		CollectionMainUI:setSorterVisible(arg_28_0.vars.cur_mode, arg_28_2)
	else
		CollectionMainUI:setLayerVisible(arg_28_1, arg_28_2)
	end
end

function CollectionController.getChapterReward(arg_29_0, arg_29_1)
	if not arg_29_1.reward_con_state then
		local var_29_0 = arg_29_1.reward_con == "maze" and "ui_dict_not_unlock_yet_maze" or "ui_dict_not_unlock_yet"
		
		balloon_message_with_sound(var_29_0)
		
		return 
	end
	
	query("story_chapter_reward", {
		dic_ui_id = arg_29_1.id
	})
end

function CollectionController.getSceneState(arg_30_0)
	if not arg_30_0.vars then
		return {}
	end
	
	local var_30_0 = CollectionScrollView:getLastSelectItem() or {}
	
	if arg_30_0.vars.cur_mode == "story" and var_30_0.id == "story7" then
		return {
			mode = arg_30_0.vars.cur_mode,
			parent_id = var_30_0.id,
			select_item = SubStoryViewerScrollListView:getSelectedItem()
		}
	elseif arg_30_0.vars.cur_mode == "story" then
		return {
			mode = arg_30_0.vars.cur_mode,
			page = CollectionScrollView:getIndex(),
			sub_page = CollectionStoryChapterView:getIndex()
		}
	end
	
	if arg_30_0.vars.cur_mode == "hero" then
		local var_30_1 = CollectionNewHero:getCurrentUnitCode()
		
		if var_30_1 then
			local var_30_2 = CollectionUnitList:getSceneStateInfo() or {}
			local var_30_3 = {
				mode = "unit",
				code = var_30_1
			}
			
			table.merge(var_30_3, var_30_2)
			
			return var_30_3
		end
	end
	
	if arg_30_0.vars.cur_mode then
		return {
			mode = arg_30_0.vars.cur_mode,
			page = CollectionScrollView:getIndex()
		}
	end
	
	return {}
end

function CollectionController.setUpDown(arg_31_0, arg_31_1)
	CollectionMainUI:setUpDown(arg_31_1)
	arg_31_0.vars.mode[arg_31_0.vars.cur_mode]:setAscending(arg_31_1)
	arg_31_0.vars.mode[arg_31_0.vars.cur_mode]:resort()
	CollectionMainUI:setSorterVisible(arg_31_0.vars.cur_mode, false)
end

function CollectionController.setSort(arg_32_0, arg_32_1)
	local var_32_0 = tonumber(arg_32_1)
	
	arg_32_0.vars.sort_index = var_32_0
	
	local var_32_1
	
	if arg_32_0.vars.cur_mode == "arti" and arg_32_0.vars.arti_category_sort_mode == "all" then
		var_32_1 = {
			"artifact_grade",
			"role",
			"name"
		}
	end
	
	if not var_32_1 or not var_32_1[var_32_0] then
		return 
	end
	
	CollectionMainUI:setSort(arg_32_1)
	
	local var_32_2, var_32_3 = CollectionMainUI:getAcquiredStat()
	
	arg_32_0.vars.mode[arg_32_0.vars.cur_mode]:sort(var_32_1[var_32_0], var_32_2, var_32_3)
	arg_32_0:setLayerVisible("sort", false)
end

function CollectionController.setToggle(arg_33_0, arg_33_1)
	local var_33_0 = tonumber(arg_33_1)
	local var_33_1 = false
	local var_33_2 = arg_33_0.vars.mode[arg_33_0.vars.cur_mode]
	
	if var_33_0 == 2 then
		var_33_1 = not var_33_2:getShowNotEarnedHero()
		
		var_33_2:setShowNotEarnedHero(var_33_1)
	elseif var_33_0 == 1 then
		var_33_1 = not var_33_2:getShowEarnedHero()
		
		var_33_2:setShowEarnedHero(var_33_1)
	end
	
	CollectionMainUI:setCheckboxUI(var_33_0, var_33_1)
	var_33_2:resort()
	CollectionMainUI:updateSortButton()
	CollectionMainUI:if_set_noData(var_33_2:getCurrentDB())
end

function CollectionController.setToggleFilter(arg_34_0, arg_34_1)
	local var_34_0 = string.split(arg_34_1, "_")
	local var_34_1 = var_34_0[1]
	local var_34_2 = to_n(var_34_0[2])
	local var_34_3 = arg_34_0.vars.mode[arg_34_0.vars.cur_mode]
	
	if var_34_2 == 0 then
		local var_34_4 = not var_34_3:isFiltering(var_34_1)
		local var_34_5 = var_34_3:getFilterLength(var_34_1)
		
		for iter_34_0 = 1, var_34_5 do
			var_34_3:setFilter(var_34_1, iter_34_0, var_34_4)
			CollectionMainUI:setFilterUI(var_34_1, iter_34_0, var_34_4)
		end
		
		CollectionMainUI:setFilterUI(var_34_1, "all", not var_34_4)
	else
		local var_34_6 = var_34_3:getFilter(var_34_1, var_34_2)
		
		var_34_3:setFilter(var_34_1, var_34_2, not var_34_6)
		CollectionMainUI:setFilterUI(var_34_1, var_34_2, not var_34_6)
		
		local var_34_7 = not var_34_3:isFiltering(var_34_1)
		
		CollectionMainUI:setFilterUI(var_34_1, "all", var_34_7)
	end
	
	var_34_3:applyFilter()
	CollectionMainUI:updateSortButton()
	CollectionMainUI:if_set_noData(var_34_3:getCurrentDB())
end

function CollectionController.story_play_all(arg_35_0)
	local var_35_0 = CollectionStoryList:getCurrentEpisodeData()
	
	if #var_35_0 == 0 then
		return 
	end
	
	var_35_0.type = "story_play_all"
	
	CollectionMainUI:openDetail(var_35_0)
end

function CollectionController.search(arg_36_0)
	if arg_36_0.vars.cur_mode == "main" then
		return 
	end
	
	local var_36_0 = ""
	
	if arg_36_0.vars.cur_mode == "story" then
		var_36_0 = CollectionStoryList:getSearchKeyword()
	else
		var_36_0 = CollectionMainUI:getSearchKeyword()
	end
	
	local var_36_1 = arg_36_0.vars.mode[arg_36_0.vars.cur_mode]:search(var_36_0)
	
	if var_36_1 then
		CollectionMainUI:onSearch(var_36_1)
	end
	
	arg_36_0:setSort(arg_36_0.vars.sort_index or 1)
	CollectionController:setLayerVisible("search", false)
end

function CollectionController.open_unitStory(arg_37_0, arg_37_1)
	if arg_37_1 == nil then
		return 
	end
	
	SceneManager:popScene()
	SceneManager:nextScene("collection", {
		mode = "unit",
		code = arg_37_1
	})
	CollectionNewHero:showStory()
	CollectionNewHero:hideButtons()
end

function CollectionMainUI.hideCollection(arg_38_0)
	arg_38_0.vars.dict_base:setVisible(false)
end

function CollectionMainUI.setLayerVisible(arg_39_0, arg_39_1, arg_39_2)
	if not arg_39_0.vars or not arg_39_0.vars.dict_base then
		return 
	end
	
	if_set_visible(arg_39_0.vars.dict_base, "layer_" .. arg_39_1, arg_39_2)
	arg_39_0.vars.dict_base:getChildByName("input_search"):setString("")
end

function CollectionMainUI.setSorterVisible(arg_40_0, arg_40_1, arg_40_2)
	if not arg_40_0.vars or not arg_40_0.vars.dict_base then
		return 
	end
	
	if arg_40_1 == "hero" then
		CollectionUnitList.Sorter:show(arg_40_2)
	end
	
	if_set_visible(arg_40_0.vars.dict_base, "n_" .. arg_40_1 .. "_sort", arg_40_2)
	arg_40_0.vars.dict_base:getChildByName("input_search"):setString("")
end

function CollectionMainUI.openDetail(arg_41_0, arg_41_1, arg_41_2)
	if not arg_41_0.vars or not arg_41_0.vars.dict_base then
		return 
	end
	
	if arg_41_1.isCanShow == false then
		if arg_41_1.unlock_msg then
			local var_41_0 = string.split(arg_41_1.unlock_msg or "", ",")
			
			if var_41_0 and table.count(var_41_0) > 1 then
				local var_41_1 = var_41_0[1]
				local var_41_2 = var_41_0[2]
				local var_41_3 = DB("character", var_41_2, "name")
				
				if not var_41_3 then
					Log.e("Not Exist TID CHAR NAME!!!", var_41_2)
				end
				
				balloon_message_with_sound(var_41_1, {
					char_name = T(var_41_3)
				})
			else
				balloon_message_with_sound(arg_41_1.unlock_msg)
			end
		else
			balloon_message_with_sound("ui_dict_story_yet")
		end
		
		return 
	end
	
	arg_41_0.vars.wnd_detail = cc.Layer:create()
	
	arg_41_0.vars.parent:addChild(arg_41_0.vars.wnd_detail)
	arg_41_0.vars.wnd_detail:setCascadeOpacityEnabled(true)
	
	if arg_41_1.type == "unit" then
		CollectionNewHero:show(arg_41_0.vars.wnd_detail, arg_41_1.id, {
			topbar_title = T("system_051_title"),
			close_callback = function()
				arg_41_0:closeDetail()
			end
		})
	elseif arg_41_1.type == "artifact" then
		CollectionNewHero:showArtifact(arg_41_0.vars.wnd_detail, arg_41_1.id, {
			topbar_title = T("system_051_title"),
			close_callback = function()
				arg_41_0:closeDetail()
			end
		})
	elseif arg_41_1.type == "illust" then
		CollectionImageViewer:open(arg_41_0.vars.wnd_detail, arg_41_1, {
			topbar_title = T("system_051_title"),
			close_callback = function()
				arg_41_0:closeDetail("illust")
			end
		})
	elseif arg_41_1.type == "story" then
		CollectionStoryDetail:play(arg_41_0.vars.wnd_detail, arg_41_1, function()
			arg_41_0:closeDetail("ignore")
		end)
	elseif arg_41_1.type == "story_play_all" then
		CollectionStoryDetail:play_all(arg_41_0.vars.wnd_detail, arg_41_1, function()
			arg_41_0:closeDetail("ignore")
		end)
	elseif arg_41_1.type == "pet" then
		CollectionPetDetail:open(arg_41_0.vars.wnd_detail, arg_41_1, function()
			arg_41_0:closeDetail()
		end)
	else
		return 
	end
	
	local var_41_4 = arg_41_2 and 0 or 250
	
	arg_41_0.vars.wnd_detail:setVisible(false)
	arg_41_0.vars.wnd_detail:setOpacity(0)
	UIAction:Add(SEQ(FADE_OUT(var_41_4), SHOW(false)), arg_41_0.vars.dict_base, "block")
	UIAction:Add(SEQ(DELAY(var_41_4), SHOW(true), FADE_IN(var_41_4)), arg_41_0.vars.wnd_detail, "block")
	set_scene_fps(10)
end

function CollectionMainUI.closeDetail(arg_48_0, arg_48_1, arg_48_2)
	arg_48_2 = arg_48_2 or {}
	
	if not arg_48_0.vars or not arg_48_0.vars.dict_base then
		return 
	end
	
	if arg_48_1 ~= "ignore" then
		TopBarNew:pop()
		BackButtonManager:pop("CollectionNewHero")
	end
	
	local var_48_0 = 250
	
	if arg_48_2.no_delay then
		var_48_0 = 0
	end
	
	UIAction:Add(SEQ(FADE_OUT(var_48_0), REMOVE()), arg_48_0.vars.wnd_detail, "block")
	UIAction:Add(SEQ(DELAY(var_48_0), SHOW(true), FADE_IN(var_48_0)), arg_48_0.vars.dict_base, "block")
	
	if arg_48_1 == "illust" then
		UIAction:Add(SEQ(DELAY(var_48_0), CALL(function()
			SceneManager:getCurrentScene():showLetterBox(true)
		end)), "block")
	end
	
	set_scene_fps(10)
end

function CollectionMainUI.if_set_noData(arg_50_0, arg_50_1)
	if not arg_50_0.vars or not arg_50_0.vars.dict_base then
		return 
	end
	
	local var_50_0 = #arg_50_0.vars.listView:getChildren()
	local var_50_1 = "ui_dict_list_none"
	
	if_set_visible(arg_50_0.vars.dict_base, "n_nodata", var_50_0 == 0)
	
	if type(arg_50_1) == "table" and arg_50_1[1] and table.count(arg_50_1[1]) == 0 then
		var_50_1 = "ui_clan_join_base_no_result"
	end
	
	if_set(arg_50_0.vars.dict_base, "txt_nodata", T(var_50_1))
end

function CollectionMainUI._setDictMainTopButtonVisible(arg_51_0, arg_51_1, arg_51_2)
	arg_51_2 = arg_51_2 or false
	
	local var_51_0 = {
		btn_open_search = true,
		btn_open_sort = false
	}
	
	for iter_51_0, iter_51_1 in pairs(var_51_0) do
		if arg_51_1 == "story" then
			iter_51_1 = false
		end
		
		if arg_51_1 == "illust" then
			iter_51_1 = false
		end
		
		if_set_visible(arg_51_0.vars.dict_base, iter_51_0, iter_51_1 or arg_51_2)
	end
	
	if_set_visible(arg_51_0.vars.dict_base, "btn_open_sort_active", false)
end

function CollectionMainUI._setDictMainVisible(arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = arg_52_2 == "hero"
	local var_52_1 = arg_52_2 == "arti"
	local var_52_2 = arg_52_0.vars.dict_base
	local var_52_3 = arg_52_0.vars.dict_base:findChildByName("n_book")
	
	if_set_visible(var_52_3, "n_hero", var_52_0)
	if_set_visible(var_52_3, "n_arti", var_52_1)
	
	local var_52_4 = var_52_2:getChildByName("n_select_" .. arg_52_1)
	
	if_set_visible(var_52_4, "selected", false)
	
	local var_52_5 = var_52_2:getChildByName("n_select_" .. arg_52_2)
	
	if_set_visible(var_52_5, "selected", true)
	if_set_visible(var_52_2, "layer_sort", false)
	if_set_visible(var_52_2, "layer_search", false)
	if_set_visible(var_52_2, "layer_element", false)
	
	if var_52_0 then
		arg_52_0:onChangeStoryButton("story")
	end
	
	arg_52_0:_setDictMainTopButtonVisible(arg_52_2)
	
	local var_52_6 = false
	
	if arg_52_2 == "story" then
		var_52_6 = true
	end
	
	if_set_visible(var_52_2, "n_list_substory", false)
	if_set_visible(var_52_2, "n_belt_substory", false)
	if_set_visible(var_52_2, "n_belt_chapter", var_52_6)
	if_set_visible(var_52_2, "n_list_story", var_52_6)
	if_set_visible(var_52_2, "n_list", not var_52_6)
end

function CollectionMainUI._bookSwap(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = {
		illust = "book_thumb_illust",
		pet = "book_thumb_pet",
		arti = "book_thumb_arti",
		hero = "book_thumb_hero",
		monster = "book_thumb_monster",
		story = "book_thumb_story"
	}
	local var_53_1 = arg_53_0.vars.dict_base:getChildByName(var_53_0[arg_53_2])
	local var_53_2
	
	if var_53_0[arg_53_1] then
		var_53_2 = arg_53_0.vars.dict_base:getChildByName(var_53_0[arg_53_1])
	end
	
	if not arg_53_0.vars.book_origin_x then
		arg_53_0.vars.book_origin_x = var_53_1:getPositionX()
	end
	
	local var_53_3 = arg_53_0.vars.book_origin_x
	
	var_53_1:setPositionX(var_53_3 + 120)
	var_53_1:setOpacity(0)
	UIAction:Add(SEQ(SHOW(true), SPAWN(LOG(MOVE_TO(250, var_53_3)), LOG(SCALE(250, 0.2, 0.49)), LOG(OPACITY(100, 0, 1)))), var_53_1, "block")
	
	if var_53_2 and arg_53_1 ~= arg_53_2 then
		UIAction:Add(SEQ(SPAWN(LOG(MOVE_TO(250, var_53_3 - 120)), LOG(SCALE(250, 0.49, 0.2)), LOG(OPACITY(100, 1, 0))), SHOW(false)), var_53_2, "block")
	end
end

function CollectionMainUI._setDictMainPercentUI(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = {
		illust = "dict_name_illust",
		pet = "dict_name_pet",
		arti = "dict_name_artifact",
		hero = "dict_name_hero",
		monster = "dict_name_monster",
		story = "dict_name_story"
	}
	local var_54_1 = tostring(arg_54_0.vars.all_count[arg_54_2])
	local var_54_2 = 1
	
	if arg_54_0.vars.have_count[arg_54_2] then
		var_54_1 = arg_54_0.vars.have_count[arg_54_2] .. "/" .. arg_54_0.vars.all_count[arg_54_2]
		var_54_2 = arg_54_0.vars.have_count[arg_54_2] / arg_54_0.vars.all_count[arg_54_2]
	end
	
	if_set(arg_54_0.vars.dict_base, "t_percent", var_54_1)
	
	if arg_54_2 ~= "monster" then
		if_set_percent(arg_54_0.vars.dict_base, "progress_bar", var_54_2)
		if_set(arg_54_0.vars.dict_base, "txt_book_title", T(var_54_0[arg_54_2]))
		if_set_visible(arg_54_0.vars.dict_base, "progress_book", true)
		if_set_visible(arg_54_0.vars.dict_base, "txt_count_monster", false)
	else
		if_set(arg_54_0.vars.dict_base, "txt_count_monster", var_54_1)
		if_set(arg_54_0.vars.dict_base, "txt_book_title", T(var_54_0[arg_54_2]))
		if_set_visible(arg_54_0.vars.dict_base, "progress_book", false)
		if_set_visible(arg_54_0.vars.dict_base, "txt_count_monster", true)
	end
end

function CollectionMainUI.changeSelect(arg_55_0, arg_55_1, arg_55_2)
	if not arg_55_0.vars or not arg_55_0.vars.dict_base then
		return 
	end
	
	arg_55_0.vars.cur_name = arg_55_2
	
	if arg_55_2 == "story" then
		arg_55_0.vars.listView = arg_55_0:getStoryListView()
	else
		arg_55_0.vars.listView = arg_55_0:getListView()
	end
	
	arg_55_0:_bookSwap(arg_55_1, arg_55_2)
	arg_55_0:_setDictMainVisible(arg_55_1, arg_55_2)
	arg_55_0:_setDictMainPercentUI(arg_55_1, arg_55_2)
end

function CollectionMainUI.setTitle(arg_56_0, arg_56_1)
	if not arg_56_0.vars or not arg_56_0.vars.dict_base then
		return 
	end
	
	if not (arg_56_0.vars.cur_name == "story") then
		if_set_visible(arg_56_0.vars.dict_base, "title_chapter", false)
		if_set_visible(arg_56_0.vars.dict_base, "txt_title", true)
		if_set(arg_56_0.vars.dict_base, "txt_title", arg_56_1)
	else
		if_set_visible(arg_56_0.vars.dict_base, "title_chapter", true)
		if_set_visible(arg_56_0.vars.dict_base, "txt_title", false)
		if_set(arg_56_0.vars.dict_base, "title_chapter", arg_56_1)
	end
end

function CollectionMainUI.onChangeStoryButton(arg_57_0, arg_57_1)
	local var_57_0 = {
		btn_all_hero_on = false,
		btn_all_hero_off = true,
		btn_by_story_off = false,
		btn_by_story_on = true
	}
	local var_57_1 = arg_57_1 == "story"
	
	arg_57_0.vars.mode = arg_57_1
	
	arg_57_0:_setDictMainTopButtonVisible(arg_57_0.vars.cur_name, arg_57_1 == "all")
	
	for iter_57_0, iter_57_1 in pairs(var_57_0) do
		if not var_57_1 then
			iter_57_1 = not iter_57_1
		end
		
		if_set_visible(arg_57_0.vars.dict_base, iter_57_0, iter_57_1)
	end
end

function CollectionMainUI.onChangeArtifactStoryButton(arg_58_0, arg_58_1)
	local var_58_0 = {
		btn_all_artifact_on = false,
		btn_all_artifact_off = true,
		btn_story_artifact_off = false,
		btn_story_artifact_on = true
	}
	local var_58_1 = arg_58_1 == "story"
	
	arg_58_0.vars.mode = arg_58_1
	
	local var_58_2 = arg_58_0.vars.dict_base:findChildByName("n_book"):findChildByName("n_arti")
	
	arg_58_0:_setDictMainTopButtonVisible(arg_58_0.vars.cur_name, arg_58_1 == "all")
	
	for iter_58_0, iter_58_1 in pairs(var_58_0) do
		if not var_58_1 then
			iter_58_1 = not iter_58_1
		end
		
		if_set_visible(var_58_2, iter_58_0, iter_58_1)
	end
	
	if arg_58_1 == "all" then
		arg_58_0:setSort(1)
	end
end

function CollectionMainUI.onChangeName(arg_59_0, arg_59_1, arg_59_2)
	arg_59_0:setTitle(arg_59_1)
	
	if arg_59_0.vars.cur_name == "story" then
		local var_59_0 = arg_59_0.vars.dict_base:findChildByName("title_chapter")
		local var_59_1 = arg_59_0.vars.dict_base:findChildByName("txt_sub_title")
		
		if not arg_59_0.vars.title_chapter_origin_pos then
			arg_59_0.vars.title_chapter_origin_pos = var_59_0:getPositionY()
		end
		
		local var_59_2 = arg_59_0.vars.title_chapter_origin_pos
		
		var_59_1:setString(arg_59_2)
		
		if arg_59_2 ~= "" then
			var_59_0:setPositionY(var_59_2)
		else
			var_59_0:setPositionY((var_59_1:getPositionY() - var_59_2) / 2 + var_59_2)
		end
	end
	
	if_set_sprite(arg_59_0.vars.dict_base, "icon_all", "img/icon_menu_all.png")
	
	if arg_59_0.vars.mode == "all" and arg_59_0.vars.cur_name == "arti" then
		arg_59_0:resetFilterUI()
	end
	
	arg_59_0.vars.listView:jumpToPercentVertical(0)
	arg_59_0:if_set_noData()
end

function CollectionMainUI.setStoryListViewSize(arg_60_0, arg_60_1)
	local var_60_0 = arg_60_0:getStoryListView()
	local var_60_1 = var_60_0:getContentSize()
	
	var_60_0:setContentSize(var_60_1.width, arg_60_1)
end

function CollectionMainUI.onChangeChapter(arg_61_0, arg_61_1, arg_61_2)
	local var_61_0 = arg_61_0.vars.dict_base:findChildByName("n_bottom")
	local var_61_1 = var_61_0:getChildByName("btn_reward")
	local var_61_2, var_61_3, var_61_4 = DB("dic_ui", arg_61_1, {
		"reward",
		"reward_check",
		"reward_con"
	})
	
	if not arg_61_2 then
		if_set_opacity(arg_61_0.vars.dict_base, "btn_play_all", 76.5)
	else
		if_set_opacity(arg_61_0.vars.dict_base, "btn_play_all", 255)
	end
	
	arg_61_0.vars.last_isUnlock = arg_61_2
	
	if not var_61_2 or Account:getItemCount(var_61_2) > 0 then
		if_set_visible(var_61_0, nil, false)
		arg_61_0:setStoryListViewSize(562 * (VIEW_HEIGHT / DESIGN_HEIGHT))
		
		return 
	else
		arg_61_0:setStoryListViewSize(465)
	end
	
	if_set_visible(var_61_0, nil, true)
	
	local function var_61_5(arg_62_0)
		local var_62_0 = arg_62_0 and arg_61_1 or nil
		local var_62_1 = var_61_1:getChildByName("icon_lock")
		local var_62_2 = not arg_62_0 and 76.5 or 255
		
		var_62_1:setVisible(not arg_62_0)
		var_61_1:setCascadeOpacityEnabled(false)
		var_61_1:setOpacity(var_62_2)
		var_61_1:getChildByName("label"):setOpacity(var_62_2)
		if_set_visible(var_61_1, "icon_noti", arg_62_0)
		
		var_61_1.data = {
			reward_con_state = arg_62_0,
			id = var_62_0,
			reward_con = var_61_4
		}
		
		if arg_62_0 then
			arg_61_0.vars.last_chapter = arg_61_1
		end
	end
	
	if CollectionUtil:isRewardConditionStateCheckType(var_61_4) then
		var_61_5(CollectionUtil:isRewardConditionState(var_61_4, var_61_3))
	end
	
	local var_61_6, var_61_7 = DB("item_material", var_61_2, {
		"name",
		"icon"
	})
	local var_61_8 = "item/" .. (var_61_7 or "") .. ".png"
	
	if_set_sprite(var_61_0, "icon_bg_base", var_61_8)
	if_set(var_61_0, "txt_bg_item", T(var_61_6))
end

function CollectionMainUI.updateNotifyBgPackOnLeftList(arg_63_0)
	if not arg_63_0.vars or not get_cocos_refid(arg_63_0.vars.dict_base) then
		return 
	end
	
	local var_63_0 = arg_63_0.vars.dict_base:findChildByName("n_select_story")
	
	if_set_visible(var_63_0, "icon_noti", CollectionDB:isRemainReceivableBgPack())
end

function CollectionMainUI.onReceiveReward(arg_64_0)
	arg_64_0:onChangeChapter(arg_64_0.vars.last_chapter, arg_64_0.vars.last_isUnlock)
	CollectionScrollView:updateReward()
	CollectionStoryChapterView:updateReward()
	arg_64_0:updateNotifyBgPackOnLeftList()
end

function CollectionMainUI.onChangeSubName(arg_65_0, arg_65_1)
	if_set(arg_65_0.vars.dict_base, "title_episode", arg_65_1)
end

function CollectionMainUI.onSearch(arg_66_0, arg_66_1)
	if_set_sprite(arg_66_0.vars.dict_base, "icon_all", "img/icon_menu_all.png")
	arg_66_0:setTitle(T("dic_search_title", {
		search = ""
	}))
	arg_66_0:if_set_noData(arg_66_1)
end

function CollectionMainUI.onChangeRole(arg_67_0, arg_67_1)
	if arg_67_1 == "all" then
		arg_67_0:_setDictMainTopButtonVisible(arg_67_0.vars.cur_name, true)
		arg_67_0:setSort(1)
	else
		arg_67_0:_setDictMainTopButtonVisible(arg_67_0.vars.cur_name, false)
	end
end

function CollectionMainUI.setSort(arg_68_0, arg_68_1)
	if not arg_68_0.vars or not arg_68_0.vars.dict_base then
		return 
	end
	
	local var_68_0 = arg_68_0:getSortUI()
	
	if not var_68_0 then
		return 
	end
	
	local var_68_1 = var_68_0:getChildByName("btn_sort" .. arg_68_1)
	
	if not var_68_1 then
		return 
	end
	
	local var_68_2 = arg_68_0.vars.dict_base:getChildByName("btn_open_sort")
	local var_68_3 = arg_68_0.vars.dict_base:getChildByName("btn_open_sort_active")
	
	if_set(var_68_2, "txt_sort", var_68_1:getChildByName("txt_sort" .. arg_68_1):getString())
	if_set(var_68_3, "txt_sort", var_68_1:getChildByName("txt_sort" .. arg_68_1):getString())
	
	for iter_68_0 = 1, 4 do
		local var_68_4 = var_68_0:getChildByName("btn_sort" .. iter_68_0)
		
		if not var_68_4 then
			break
		end
		
		var_68_4:setEnabled(true)
	end
	
	var_68_1:setEnabled(false)
	
	local var_68_5 = var_68_1:getPositionY()
	
	var_68_0:getChildByName("n_sort_cursor"):setPositionY(var_68_5)
end

function CollectionMainUI.setCheckboxUI(arg_69_0, arg_69_1, arg_69_2, arg_69_3)
	if not arg_69_0.vars or not arg_69_0.vars.dict_base then
		return 
	end
	
	arg_69_3 = arg_69_3 or arg_69_0:getSortUI()
	
	local var_69_0 = arg_69_3:getChildByName("checkbox" .. arg_69_1)
	
	if not var_69_0 then
		return 
	end
	
	var_69_0:setSelected(arg_69_2)
end

function CollectionMainUI.setFilterUI(arg_70_0, arg_70_1, arg_70_2, arg_70_3, arg_70_4)
	if not arg_70_0.vars or not arg_70_0.vars.dict_base then
		return 
	end
	
	arg_70_4 = arg_70_4 or arg_70_0:getSortUI()
	
	local var_70_0 = arg_70_1 .. "_" .. arg_70_2
	local var_70_1 = arg_70_4:getChildByName("checkbox_" .. var_70_0)
	
	if not var_70_1 then
		return 
	end
	
	if_set_visible(arg_70_4, "select_bg_" .. var_70_0, arg_70_3)
	var_70_1:setSelected(arg_70_3)
	
	if arg_70_2 == "all" then
		local var_70_2 = arg_70_4:getChildByName("n_" .. arg_70_1)
		
		if_set_color(var_70_2, "icon_all", arg_70_3 and tocolor("#6BC11B") or tocolor("#FFFFFF"))
	elseif arg_70_1 == "role" then
		local var_70_3 = arg_70_4:getChildByName("n_role")
		local var_70_4 = CollectionUtil.ARTI_ROLE_UNHASH_TABLE
		
		if_set_color(var_70_3, "icon_" .. var_70_4[arg_70_2], arg_70_3 and tocolor("#6BC11B") or tocolor("#888888"))
	end
end

function CollectionMainUI.resetFilterUI(arg_71_0)
	if not arg_71_0.vars or not arg_71_0.vars.dict_base then
		return 
	end
	
	if not CollectionArtifactList.vars then
		return 
	end
	
	local var_71_0 = arg_71_0:getSortUI()
	
	for iter_71_0, iter_71_1 in pairs(CollectionArtifactList.vars.filters or {}) do
		arg_71_0:setFilterUI(iter_71_0, "all", true, var_71_0)
		
		local var_71_1 = CollectionArtifactList:getFilterLength(iter_71_0)
		
		for iter_71_2 = 1, var_71_1 do
			arg_71_0:setFilterUI(iter_71_0, iter_71_2, false, var_71_0)
		end
	end
	
	for iter_71_3 = 1, 4 do
		arg_71_0:setCheckboxUI(iter_71_3, true, var_71_0)
	end
end

function CollectionMainUI.updateSortButton(arg_72_0)
	local var_72_0 = CollectionArtifactList:isFiltering()
	
	if_set_visible(arg_72_0.vars.dict_base, "btn_open_sort_active", var_72_0)
	if_set_visible(arg_72_0.vars.dict_base, "btn_open_sort", not var_72_0)
end

function CollectionMainUI.setUpDown(arg_73_0, arg_73_1)
	if not arg_73_1 then
		return 
	end
	
	local var_73_0 = arg_73_1 == "up" and "down" or "up"
	local var_73_1 = arg_73_0:getSortUI()
	
	if_set_visible(var_73_1, "btn_" .. arg_73_1, false)
	if_set_visible(var_73_1, "btn_" .. var_73_0, true)
end

function CollectionMainUI.createUI(arg_74_0)
	local var_74_0 = SceneManager:getRunningPopupScene()
	
	arg_74_0.vars.wnd = load_dlg("dict_main", true, "wnd")
	
	var_74_0:addChild(arg_74_0.vars.wnd)
	arg_74_0.vars.wnd:bringToFront()
	arg_74_0.vars.wnd:setOpacity(0)
end

function CollectionMainUI.initDictMain(arg_75_0, arg_75_1, arg_75_2)
	local var_75_0 = arg_75_0.vars.wnd:getChildByName("n_book_hero")
	local var_75_1 = arg_75_0.vars.wnd:getChildByName("n_book_arti")
	local var_75_2 = arg_75_0.vars.wnd:getChildByName("n_book_monster")
	local var_75_3 = arg_75_0.vars.wnd:getChildByName("n_book_story")
	local var_75_4 = arg_75_0.vars.wnd:getChildByName("n_book_illust")
	local var_75_5 = arg_75_0.vars.wnd:getChildByName("n_book_pet")
	local var_75_6 = {
		hero = var_75_0,
		arti = var_75_1,
		story = var_75_3,
		pet = var_75_5,
		illust = var_75_4
	}
	
	for iter_75_0, iter_75_1 in pairs(var_75_6) do
		local var_75_7 = arg_75_2[iter_75_0] / arg_75_1[iter_75_0] * 100
		local var_75_8 = math.if_nan_or_inf(var_75_7, 0)
		
		UIAction:Add(LOG(INC_NUMBER(1500, var_75_8, "%", 0)), iter_75_1:getChildByName("complet"), "dict_main_inc" .. iter_75_0)
		if_set(iter_75_1, "t_count", arg_75_2[iter_75_0] .. "/" .. arg_75_1[iter_75_0])
	end
	
	if_set(var_75_2, "t_count", arg_75_1.monster)
	
	for iter_75_2, iter_75_3 in pairs(var_75_6) do
		local var_75_9 = iter_75_3:getChildByName("progress_bar")
		local var_75_10 = iter_75_3:getChildByName("n_progress")
		
		var_75_9:setVisible(false)
		
		local var_75_11 = WidgetUtils:createCircleProgress("img/_hero_s_frame_w.png")
		
		var_75_11:setCascadeOpacityEnabled(true)
		var_75_11:setScale(var_75_9:getScale())
		var_75_11:setPosition(var_75_9:getPosition())
		var_75_11:setOpacity(var_75_9:getOpacity())
		var_75_11:setColor(var_75_9:getColor())
		var_75_11:setReverseDirection(false)
		var_75_11:setName("@progress")
		UIAction:Add(LOG(PERCENTAGE(1500, 0, arg_75_2[iter_75_2] / arg_75_1[iter_75_2] * 100)), var_75_11)
		var_75_10:addChild(var_75_11)
	end
	
	local var_75_12 = UnlockSystem:isUnlockSystem(UNLOCK_ID.PET)
	
	if_set_visible(arg_75_0.vars.wnd, "n_book_pet", var_75_12)
	
	if not var_75_12 then
		local var_75_13 = arg_75_0.vars.wnd:getChildByName("n_book_monster")
		local var_75_14 = arg_75_0.vars.wnd:getChildByName("n_book_illust")
		
		var_75_13:setPositionX(var_75_13:getPositionX() + 100)
		var_75_14:setPositionX(var_75_14:getPositionX() - 100)
	end
	
	if_set_visible(var_75_3, "icon_noti", CollectionDB:isRemainReceivableBgPack())
end

function CollectionMainUI.init(arg_76_0, arg_76_1, arg_76_2)
	arg_76_0.vars = {}
	arg_76_0.vars.all_count = arg_76_1
	arg_76_0.vars.have_count = arg_76_2
end

function CollectionMainUI.open(arg_77_0, arg_77_1, arg_77_2)
	arg_77_0:init(arg_77_1, arg_77_2)
	arg_77_0:createUI()
	arg_77_0:initDictMain(arg_77_1, arg_77_2)
	UIAction:Add(SPAWN(FADE_IN(500)), arg_77_0.vars.wnd)
	BackButtonManager:push({
		check_id = "dict_main",
		back_func = function()
			CollectionController:release()
		end
	})
end

function CollectionMainUI.isShowDictMain(arg_79_0)
	if not arg_79_0.vars then
		return 
	end
	
	return get_cocos_refid(arg_79_0.vars.dict_base)
end

function CollectionMainUI.initScene(arg_80_0)
	arg_80_0.vars.wnd = nil
	arg_80_0.vars.dict_base = load_dlg("dict_base_renew", true, "wnd")
	arg_80_0.vars.listView = arg_80_0.vars.dict_base:getChildByName("listview")
	
	if_set_visible(arg_80_0.vars.dict_base, nil, false)
	
	arg_80_0.vars.parent = SceneManager:getDefaultLayer()
	
	arg_80_0.vars.parent:addChild(arg_80_0.vars.dict_base)
	if_set_visible(arg_80_0.vars.dict_base, nil, true)
	TopBarNew:create(T("system_051_title"), arg_80_0.vars.dict_base, function()
		local var_81_0 = CollectionController:isSubStoryHomeMode()
		local var_81_1 = CollectionController:isDLCMode()
		
		CollectionController:release()
		
		if not var_81_0 and not var_81_1 then
			SceneManager:popScene()
		end
	end)
	
	local var_80_0 = UnlockSystem:isUnlockSystem(UNLOCK_ID.PET)
	
	if_set_visible(arg_80_0.vars.dict_base, "n_select_pet", var_80_0)
	
	if not var_80_0 then
		local var_80_1 = arg_80_0.vars.dict_base:findChildByName("n_select_illust")
		
		var_80_1:setPositionY(var_80_1:getPositionY() + 54)
	end
	
	arg_80_0:updateNotifyBgPackOnLeftList()
	arg_80_0:initSorter()
	
	return arg_80_0.vars.dict_base
end

function CollectionMainUI.initSorter(arg_82_0)
	if not arg_82_0.vars or not arg_82_0.vars.dict_base then
		return 
	end
	
	local var_82_0 = arg_82_0.vars.dict_base:findChildByName("n_arti_sort")
	local var_82_1 = {
		"dict_have_artifact",
		"dict_none_artifact"
	}
	local var_82_2 = {
		"ui_unit_list_sort_1_label",
		"ui_unit_list_sort_6_label",
		"ui_unit_list_sort_7_label"
	}
	
	for iter_82_0 = 1, #var_82_2 do
		if_set(var_82_0, "txt_sort" .. iter_82_0, T(var_82_2[iter_82_0]))
	end
	
	for iter_82_1 = 1, #var_82_1 do
		if_set(var_82_0, "txt_check" .. iter_82_1, T(var_82_1[iter_82_1]))
	end
end

function CollectionMainUI.isShow(arg_83_0)
	if not arg_83_0.vars then
		return false
	end
	
	return get_cocos_refid(arg_83_0.vars.wnd)
end

function CollectionMainUI.getDictionaryBase(arg_84_0)
	return arg_84_0.vars.dict_base
end

function CollectionMainUI.getListView(arg_85_0)
	if not get_cocos_refid(arg_85_0.vars.listView) then
		return 
	end
	
	return arg_85_0.vars.dict_base:getChildByName("listview")
end

function CollectionMainUI.getStoryListView(arg_86_0)
	if not get_cocos_refid(arg_86_0.vars.dict_base) then
		return 
	end
	
	return arg_86_0.vars.dict_base:getChildByName("listview_story")
end

function CollectionMainUI.getSubStoryScrollView(arg_87_0)
	if not get_cocos_refid(arg_87_0.vars.dict_base) then
		return 
	end
	
	return arg_87_0.vars.dict_base:getChildByName("scrollview_substory")
end

function CollectionMainUI.getSubStoryBelt(arg_88_0)
	if not get_cocos_refid(arg_88_0.vars.dict_base) then
		return 
	end
	
	return arg_88_0.vars.dict_base:getChildByName("n_belt_substory")
end

function CollectionMainUI.getChapterBelt(arg_89_0)
	if not get_cocos_refid(arg_89_0.vars.dict_base) then
		return 
	end
	
	return arg_89_0.vars.dict_base:getChildByName("n_belt_chapter")
end

function CollectionMainUI.getSubStoryList(arg_90_0)
	if not get_cocos_refid(arg_90_0.vars.dict_base) then
		return 
	end
	
	return arg_90_0.vars.dict_base:findChildByName("n_list_substory")
end

function CollectionMainUI.getStoryList(arg_91_0)
	if not get_cocos_refid(arg_91_0.vars.dict_base) then
		return 
	end
	
	return arg_91_0.vars.dict_base:findChildByName("n_list_story")
end

function CollectionMainUI.getChapterScrollView(arg_92_0)
	if not get_cocos_refid(arg_92_0.vars.dict_base) then
		return 
	end
	
	return arg_92_0.vars.dict_base:getChildByName("scrollview_chapter")
end

function CollectionMainUI.getSortUI(arg_93_0)
	if not get_cocos_refid(arg_93_0.vars.dict_base) then
		return 
	end
	
	return arg_93_0.vars.dict_base:getChildByName("n_" .. arg_93_0.vars.cur_name .. "_sort")
end

function CollectionMainUI.getSearchKeyword(arg_94_0)
	if not get_cocos_refid(arg_94_0.vars.dict_base) then
		return 
	end
	
	local var_94_0 = arg_94_0.vars.dict_base:getChildByName("input_search"):getString()
	
	return (CollectionUtil:removeRegexCharacters(var_94_0))
end

function CollectionMainUI.getAcquiredStat(arg_95_0)
	if not get_cocos_refid(arg_95_0.vars.dict_base) then
		return 
	end
	
	local var_95_0 = arg_95_0:getSortUI() or arg_95_0.vars.dict_base
	local var_95_1 = var_95_0:getChildByName("checkbox1"):isSelected()
	local var_95_2 = var_95_0:getChildByName("checkbox2"):isSelected()
	
	return var_95_1, var_95_2
end

function CollectionMainUI.close(arg_96_0)
	if arg_96_0.vars and arg_96_0.vars.wnd then
		UIAction:Add(SEQ(FADE_OUT(500), REMOVE()), arg_96_0.vars.wnd, "block")
		BackButtonManager:pop()
	end
	
	if arg_96_0.vars and get_cocos_refid(arg_96_0.vars.dict_base) then
		CollectionNewHero:closeAll()
	end
	
	local var_96_0 = {
		arti = CollectionArtifactList,
		hero = CollectionUnitList,
		monster = CollectionMonsterList,
		story = CollectionStoryList,
		pet = CollectionPetList,
		illust = CollectionIllustList
	}
	
	for iter_96_0, iter_96_1 in pairs(var_96_0) do
		iter_96_1:close()
	end
	
	CollectionDB:close()
	
	arg_96_0.vars = nil
end
