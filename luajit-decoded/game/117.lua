SubStoryDlcLobby = SubStoryDlcLobby or {}

function HANDLER.story_dlc_dungeon(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_prologue" then
		SubstoryManager:playPrologue()
	elseif arg_1_1 == "btn_go" then
		SubstoryManager:nextContent_type1()
	elseif arg_1_1 == "btn_achieve" then
		SubstoryAchievePopup:show()
	elseif arg_1_1 == "btn_contents2" then
		SubstoryManager:nextContent_type2()
	elseif arg_1_1 == "btn_help" then
		if arg_1_0.help_id then
			HelpGuide:open({
				contents_id = arg_1_0.help_id .. "_1_1"
			})
		end
	elseif arg_1_1 == "btn_core_reward" then
		SubstoryManager:showDLCCoreRewardPopup(arg_1_0.popup_parent)
	elseif arg_1_1 == "btn_storyplay" then
		local var_1_0 = SubstoryManager:getInfo()
		local var_1_1 = Account:getSubStory(var_1_0.id)
		
		SubStoryDLCStoryViewPopUp:open(nil, var_1_0.id, {
			clearStory = var_1_1.end_dlc == 1
		})
	elseif arg_1_1 == "btn_end" then
		SubStoryDlcLobby:showResetPopup()
	elseif arg_1_1 == "btn_video" then
		SubstoryUIUtil:onBtnVideo(arg_1_0)
	end
end

function HANDLER.story_dlc_end(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_end" then
		local var_2_0 = SubstoryManager:getInfo()
		
		SubStoryDlc:queryEndDlc(var_2_0.id)
		Dialog:close("story_dlc_end")
	elseif arg_2_1 == "btn_cancel" then
		Dialog:close("story_dlc_end")
	end
end

function SubStoryDlcLobby.show(arg_3_0, arg_3_1, arg_3_2)
	arg_3_2 = arg_3_2 or {}
	arg_3_0.vars = {}
	arg_3_1 = arg_3_1 or SceneManager:getDefaultLayer()
	arg_3_0.vars.layer = arg_3_1
	arg_3_0.vars.wnd = load_dlg("story_dlc_dungeon", true, "wnd")
	
	arg_3_0.vars.layer:addChild(arg_3_0.vars.wnd)
	
	if arg_3_2.substory_id then
		SubstoryManager:setInfo(arg_3_2.substory_id)
	end
	
	local var_3_0 = SubstoryManager:getInfo()
	
	if not var_3_0 then
		Log.e("SubStoryLobby.show", "invalid_info")
		SceneManager:nextScene("lobby")
		
		return 
	end
	
	SubstoryManager:initLobbyCond()
	
	local var_3_1 = SubstoryUIUtil:getBackground(var_3_0.id, var_3_0.background_summary, {
		isEnter = true,
		is_dlc = true
	})
	
	var_3_1:setAnchorPoint(0.5, 0.5)
	var_3_1:setLocalZOrder(-1)
	arg_3_0.vars.wnd:addChild(var_3_1)
	
	for iter_3_0, iter_3_1 in pairs({
		"n_quest_progress",
		"n_achieve_progress"
	}) do
		local var_3_2 = arg_3_0.vars.wnd:getChildByName(iter_3_1)
		
		if get_cocos_refid(var_3_2) then
			if_set_percent(var_3_2, "progress_bar", 0)
			if_set(var_3_2, "t_percent", "0%")
		end
	end
	
	if_set_visible(arg_3_0.vars.wnd, "icon_achieve_noti", false)
	TopBarNew:create(T("substory_title"), arg_3_0.vars.wnd, function()
		arg_3_0:onPushBack()
	end, nil, nil, "infosubs")
	TutorialGuide:onEnterSubstory()
	if_set_visible(arg_3_0.vars.wnd, "btn_prologue", var_3_0.prologue_story)
	
	local var_3_3 = arg_3_0.vars.wnd:getChildByName("n_core_reward")
	
	if get_cocos_refid(var_3_3) then
		local var_3_4 = {
			artifact_multiply_scale = 0.76,
			hero_multiply_scale = 1.06
		}
		local var_3_5 = SubstoryManager:setCoreRewardIcons(var_3_3, var_3_0.id, var_3_4)
		
		var_3_3:setVisible(var_3_5 and #var_3_5 > 0)
		
		local var_3_6 = var_3_3:getChildByName("btn_core_reward")
		
		var_3_6.substory_id = var_3_0.id
		var_3_6.popup_parent = arg_3_0.vars.wnd:getChildByName("n_reward_popup")
	end
	
	if var_3_0.achieve_flag == nil then
		local var_3_7 = arg_3_0.vars.wnd:getChildByName("n_cast_hero")
		
		var_3_7:setPositionY(var_3_7:getPositionY() + 32)
		
		local var_3_8 = arg_3_0.vars.wnd:getChildByName("scrollview")
		
		var_3_8:setContentSize(var_3_8:getContentSize().width, var_3_8:getContentSize().height + 32)
	end
	
	local var_3_9 = Account:getSubStoryScheduleDBById(var_3_0.id)
	local var_3_10 = SubstoryUIUtil:load_link_url(var_3_9, "link")
	local var_3_11 = SubstoryUIUtil:setLayoutData(arg_3_0.vars.wnd, "btn_video", var_3_10, "link")
	local var_3_12 = arg_3_0.vars.wnd:getChildByName("n_btn_video_move")
	local var_3_13 = arg_3_1:getChildByName("n_btn_video")
	
	if var_3_0.prologue_story == nil and get_cocos_refid(var_3_11) then
		var_3_11:setPositionX(var_3_12:getPositionX())
	end
	
	SubStoryDlcCastHero:show(arg_3_0.vars.wnd)
	arg_3_0:updateUI(var_3_0.id)
end

function SubStoryDlcLobby.updateUI(arg_5_0, arg_5_1)
	if not arg_5_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_5_0.vars.wnd) then
		return 
	end
	
	local var_5_0 = SubstoryManager:getInfo()
	
	arg_5_1 = arg_5_1 or var_5_0.id
	
	local var_5_1 = Account:getSubStory(arg_5_1)
	local var_5_2 = SubstoryManager:isEndAble()
	local var_5_3 = var_5_1.end_dlc == 1
	
	if_set_visible(arg_5_0.vars.wnd, "btn_go", not var_5_2 and not var_5_3)
	
	local var_5_4 = arg_5_0.vars.wnd:getChildByName("contents_dlc")
	
	if get_cocos_refid(var_5_4) then
		local var_5_5 = getChildByPath(var_5_4, "n_reward")
		
		if get_cocos_refid(var_5_5) then
			var_5_5:setVisible(var_5_2 and not var_5_3)
		end
	end
	
	if_set_visible(arg_5_0.vars.wnd, "n_end", var_5_3)
	
	if not DB("substory_dlc_story_ui", arg_5_1, {
		"id"
	}) then
		if_set_visible(arg_5_0.vars.wnd, "btn_storyplay", false)
	end
	
	if_set_visible(arg_5_0.vars.wnd, "btn_achieve", var_5_0.achieve_flag and not var_5_3)
	SubstoryUIUtil:updateAchieveUI(arg_5_0.vars.wnd, var_5_3)
	SubstoryUIUtil:updateQuestUI(arg_5_0.vars.wnd, var_5_3)
end

function SubStoryDlcLobby.getWnd(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.wnd) then
		return 
	end
	
	return arg_6_0.vars.wnd
end

function SubStoryDlcLobby.onPushBack(arg_7_0, arg_7_1)
	SceneManager:popScene()
end

function SubStoryDlcLobby.showResetPopup(arg_8_0, arg_8_1)
	arg_8_1 = arg_8_1 or SceneManager:getDefaultLayer()
	
	local var_8_0 = Dialog:open("wnd/story_dlc_end", arg_8_0)
	
	arg_8_1:addChild(var_8_0)
	
	local var_8_1 = SubstoryManager:getInfo()
	
	if var_8_1.icon_enter then
		local var_8_2 = totable(DB("substory_bg", var_8_1.icon_enter, "logo")).img or var_8_1.banner_icon
		
		if_set_sprite(var_8_0, "img_bi", var_8_2 .. ".png")
	end
	
	local var_8_3 = var_8_1.id
	local var_8_4 = var_8_0:getChildByName("n_reward")
	local var_8_5 = {}
	local var_8_6 = 0
	
	for iter_8_0 = 1, 99 do
		local var_8_7 = DBT("substory_dlc_reward", var_8_3 .. "_c_" .. iter_8_0, {
			"id",
			"reward_type",
			"item_id",
			"item_count",
			"grade_rate",
			"set_rate"
		})
		
		if not var_8_7 or not var_8_7.id then
			break
		end
		
		local var_8_8 = var_8_0:getChildByName("reward_item" .. iter_8_0)
		
		if get_cocos_refid(var_8_8) then
			local var_8_9 = {
				hero_multiply_scale = 1,
				artifact_multiply_scale = 0.7,
				multiply_scale = 0.9,
				parent = var_8_8,
				grade_rate = var_8_7.grade_rate,
				set_drop = var_8_7.set_rate
			}
			
			UIUtil:getRewardIcon(var_8_7.item_count, var_8_7.item_id, var_8_9)
			
			var_8_6 = var_8_6 + 1
		end
	end
	
	if var_8_6 >= 4 then
		var_8_4:setPositionY(var_8_4:getPositionY() + 45)
	end
	
	if var_8_0:getChildByName("infor") then
		upgradeLabelToRichLabel(var_8_0, "infor", true)
		if_set(var_8_0, "infor", T("ui_customdlc_clear_desc"))
	end
end

SubStoryDlcCastHero = SubStoryDlcCastHero or {}

copy_functions(ScrollView, SubStoryDlcCastHero)

function SubStoryDlcCastHero.show(arg_9_0, arg_9_1)
	arg_9_0.vars = {}
	
	local var_9_0 = SubstoryManager:getInfo().cast_hero
	
	if not var_9_0 then
		return 
	end
	
	arg_9_0.vars.scrollview = arg_9_1:getChildByName("scrollview")
	
	arg_9_0:initScrollView(arg_9_0.vars.scrollview, 84, 84)
	
	local var_9_1 = string.split(var_9_0, ",")
	
	arg_9_0:createScrollViewItems(var_9_1)
end

function SubStoryDlcCastHero.getScrollViewItem(arg_10_0, arg_10_1)
	return (UIUtil:getRewardIcon(nil, arg_10_1, {
		name = false,
		scale = 0.9,
		no_grade = true
	}))
end
