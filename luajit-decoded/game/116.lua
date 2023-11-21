SubStoryDlcMain = {}

copy_functions(ScrollView, SubStoryDlcMain)

function MsgHandler.buy_substory_dlc(arg_1_0)
	SubStoryDlcMain:resBuyDLC(arg_1_0)
end

function HANDLER.story_dlc_main(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_core_reward" then
		SubstoryManager:showDLCCoreRewardPopup(SubStoryDlcMain.vars.wnd, SubStoryDlcMain:getCurrentSubStoryID())
	elseif arg_2_1 == "btn_prologue" then
		SubStoryDlcMain:playPrologue()
	elseif arg_2_1 == "btn_zoom_poster" then
		SubStoryDlcMain:openIllust()
	elseif arg_2_1 == "btn_video" then
		SubStoryDlcMain:showVideo()
	elseif arg_2_1 == "btn_buy" then
		SubStoryDlcMain:reqBuyDLC()
	elseif arg_2_1 == "btn_go" then
		SubStoryDlcMain:enterDlcLobby()
	end
end

local var_0_0 = {
	"already_buy",
	"can_buy",
	"lack_currency",
	"lock"
}

function SubStoryDlcMain.init(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_1
	
	arg_3_0.vars = {}
	arg_3_0.vars.substory_list = {}
	arg_3_0.vars.wnd = load_dlg("story_dlc_main", true, "wnd")
	
	var_3_0:addChild(arg_3_0.vars.wnd)
	TopBarNew:create(T("ui_title_custom_dlc"), arg_3_0.vars.wnd, function()
		SubStoryDlcMain:onLeave()
	end, nil, nil, "infosubs_8_1")
	TopBarNew:setCurrencies({
		"crystal",
		"gold",
		"stamina",
		"dlcticket"
	})
	arg_3_0:updateSubStoryList()
	TutorialGuide:startGuide("substory_dlc")
	SubstoryManager:updateNewDlcOrder()
	
	if arg_3_2 and not TutorialGuide:isPlayingTutorial() then
		SubStoryDlcMain:moveToItem(arg_3_2)
	end
end

function SubStoryDlcMain.playPrologue(arg_5_0)
	if not arg_5_0.vars or not arg_5_0.vars.last_selected_substory_id then
		return 
	end
	
	local var_5_0 = arg_5_0:getSubStoryData(arg_5_0.vars.last_selected_substory_id)
	
	if not var_5_0 then
		return 
	end
	
	if not var_5_0.prologue_story then
		Log.e("Err: no Prologue Data")
		
		return 
	end
	
	SubstoryManager:playPrologue(var_5_0)
end

function SubStoryDlcMain.openIllust(arg_6_0)
	if not arg_6_0.vars or not arg_6_0.vars.last_selected_substory_id then
		return 
	end
	
	local var_6_0 = arg_6_0:getSubStoryData(arg_6_0.vars.last_selected_substory_id)
	
	if not var_6_0 then
		return 
	end
	
	local var_6_1 = var_6_0.bg
	
	if not var_6_1 or not var_6_1.img then
		return 
	end
	
	local var_6_2 = {
		isCanShow = false,
		unlock_msg = "ui_dict_story_yet",
		type = "illust",
		illust = var_6_1.img
	}
	
	local function var_6_3()
		TopBarNew:pop()
		BackButtonManager:pop("CollectionNewHero")
		UIAction:Add(SEQ(FADE_OUT(250), REMOVE()), arg_6_0.vars.wnd_detail, "block")
		UIAction:Add(SEQ(DELAY(250), SHOW(true), FADE_IN(250)), arg_6_0.vars.wnd, "block")
		UIAction:Add(SEQ(DELAY(250), CALL(function()
			SceneManager:getCurrentScene():showLetterBox(true)
		end)), "block")
	end
	
	arg_6_0.vars.wnd_detail = cc.Layer:create()
	
	SceneManager:getRunningNativeScene():addChild(arg_6_0.vars.wnd_detail)
	arg_6_0.vars.wnd_detail:setCascadeOpacityEnabled(true)
	CollectionImageViewer:open(arg_6_0.vars.wnd_detail, var_6_2, {
		is_dlc = true,
		topbar_title = T("ui_title_custom_dlc"),
		close_callback = function()
			var_6_3()
		end
	})
	
	local var_6_4 = 250
	
	arg_6_0.vars.wnd_detail:setVisible(false)
	arg_6_0.vars.wnd_detail:setOpacity(0)
	UIAction:Add(SEQ(FADE_OUT(var_6_4), SHOW(false)), arg_6_0.vars.wnd, "block")
	UIAction:Add(SEQ(DELAY(var_6_4), SHOW(true), FADE_IN(var_6_4)), arg_6_0.vars.wnd_detail, "block")
end

function SubStoryDlcMain.getCurrentSubStoryID(arg_10_0)
	if not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.wnd) or table.empty(arg_10_0.vars.substory_list) then
		return 
	end
	
	return arg_10_0.vars.last_selected_substory_id
end

function SubStoryDlcMain.getSubStoryListID(arg_11_0, arg_11_1)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.wnd) then
		return nil
	end
	
	if not arg_11_0.vars.substory_list or not arg_11_1 then
		return nil
	end
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0.vars.substory_list) do
		if iter_11_1.id == arg_11_1 then
			return iter_11_0
		end
	end
	
	return nil
end

function SubStoryDlcMain.getSubStoryData(arg_12_0, arg_12_1)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.wnd) then
		return nil
	end
	
	if not arg_12_0.vars.substory_list or not arg_12_1 then
		return nil
	end
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0.vars.substory_list) do
		if iter_12_1.id == arg_12_1 then
			return iter_12_1
		end
	end
	
	return nil
end

function SubStoryDlcMain.updateSubStoryList(arg_13_0)
	arg_13_0.vars.substory_list = {}
	
	local var_13_0 = {}
	
	for iter_13_0 = 1, 999 do
		local var_13_1, var_13_2, var_13_3, var_13_4, var_13_5 = DBN("substory_main", iter_13_0, {
			"id",
			"type",
			"jpn_hide",
			"dlc_hide",
			"sort"
		})
		
		if not var_13_1 then
			break
		end
		
		local var_13_6
		
		var_13_6 = var_13_5 or 1
		
		local var_13_7 = true
		
		if DEBUG.MAP_DEBUG then
			var_13_3 = nil
			var_13_4 = nil
		end
		
		if Account:isJPN() and var_13_3 or var_13_2 ~= "dlc" or var_13_4 == "y" then
			var_13_7 = false
		end
		
		if var_13_7 then
			local var_13_8 = SubStoryUtil:getSubstoryDB(var_13_1)
			
			if var_13_8.background_summary then
				local var_13_9 = SubstoryUIUtil:getBGInfo(var_13_8.background_summary, var_13_8.id)
				
				table.merge(var_13_8, var_13_9)
			end
			
			if var_13_8.dlc_open then
				var_13_8.is_lock = true
			else
				var_13_8.is_lock = false
			end
			
			table.insert(arg_13_0.vars.substory_list, var_13_8)
		end
	end
	
	if table.empty(arg_13_0.vars.substory_list) then
		Log.e("Empty DLC List")
		
		return 
	end
	
	arg_13_0:sortSubstoryList()
	arg_13_0:initScrollView(arg_13_0.vars.wnd:getChildByName("scroll_view"), 372, 180)
	arg_13_0:createScrollViewItems(arg_13_0.vars.substory_list)
	
	local var_13_10 = arg_13_0:getSubStoryListID(arg_13_0.vars.last_selected_substory_id) or 1
	
	arg_13_0:onSelectScrollViewItem(var_13_10, {
		item = arg_13_0.vars.substory_list[var_13_10]
	})
	arg_13_0:jumpToIndex(var_13_10)
	
	if arg_13_0.ScrollViewItems then
		for iter_13_1, iter_13_2 in pairs(arg_13_0.ScrollViewItems) do
			if iter_13_2.control then
				iter_13_2.control:setPositionY(iter_13_2.control:getPositionY() - 7)
			end
		end
	end
end

function SubStoryDlcMain.sortSubstoryList(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.wnd) or table.empty(arg_14_0.vars.substory_list) then
		return 
	end
	
	local var_14_0 = {}
	local var_14_1 = {}
	local var_14_2 = {}
	local var_14_3 = {}
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.substory_list) do
		local var_14_4 = iter_14_1.is_lock
		local var_14_5 = arg_14_0:checkSubstoryHave(iter_14_1.id)
		local var_14_6 = false
		
		if iter_14_1.dlc_open then
			var_14_6 = not Account:isSysAchieveCleared(iter_14_1.dlc_open)
		end
		
		local var_14_7 = SubstoryManager:isEndStory(iter_14_1.id)
		local var_14_8, var_14_9 = arg_14_0:getSubStoryState(iter_14_1.id)
		
		if var_14_5 then
			if var_14_7 then
				table.insert(var_14_3, iter_14_1)
			elseif var_14_9 and (var_14_9 == 1 or var_14_9 == 2) then
				table.insert(var_14_0, iter_14_1)
			end
		elseif var_14_4 and var_14_6 then
			table.insert(var_14_2, iter_14_1)
		else
			table.insert(var_14_1, iter_14_1)
		end
	end
	
	local var_14_10 = {
		var_14_0,
		var_14_1,
		var_14_2,
		var_14_3
	}
	local var_14_11 = {}
	
	for iter_14_2, iter_14_3 in pairs(var_14_10) do
		if not table.empty(iter_14_3) then
			table.sort(iter_14_3, function(arg_15_0, arg_15_1)
				return arg_15_0.sort < arg_15_1.sort
			end)
		end
		
		for iter_14_4, iter_14_5 in pairs(iter_14_3) do
			table.insert(var_14_11, iter_14_5)
		end
	end
	
	arg_14_0.vars.substory_list = var_14_11
end

function SubStoryDlcMain.getScrollViewItem(arg_16_0, arg_16_1)
	local var_16_0 = load_control("wnd/story_dlc_item.csb")
	
	if_set_visible(var_16_0, "btn_select", false)
	
	local var_16_1 = var_16_0:getChildByName("n_banner")
	
	if var_16_1 then
		local var_16_2 = SubstoryUIUtil:createBanner(arg_16_1.icon_enter, arg_16_1.banner_icon, arg_16_1.logo_position)
		
		if var_16_2 then
			var_16_1:addChild(var_16_2)
			var_16_2:setAnchorPoint(0.5, 0.5)
			var_16_2:getChildByName("panel_clipping"):setTouchEnabled(false)
		end
	end
	
	local var_16_3 = arg_16_1.is_lock
	local var_16_4 = not var_16_3 and arg_16_0:checkSubstoryHave(arg_16_1.id)
	local var_16_5 = false
	
	if arg_16_1.dlc_open then
		var_16_5 = not Account:isSysAchieveCleared(arg_16_1.dlc_open)
	end
	
	if_set_visible(var_16_0, "n_possession", false)
	if_set_visible(var_16_0, "n_buy_possible", false)
	if_set_visible(var_16_0, "n_lock", var_16_3)
	
	if var_16_4 then
		arg_16_1.state = 1
		
		local var_16_6, var_16_7 = arg_16_0:getSubStoryState(arg_16_1.id)
		
		if SubstoryManager:isEndStory(arg_16_1.id) then
			if_set(var_16_0, "txt_progress", T("ui_customdlc_b_comp"))
		elseif var_16_7 then
			local var_16_8 = ""
			
			if var_16_7 == 1 or var_16_7 == 2 then
				var_16_8 = T("ui_customdlc_b_ing")
			end
			
			if_set(var_16_0, "txt_progress", var_16_8)
		end
		
		if_set_visible(var_16_0, "n_possession", true)
	elseif var_16_3 and var_16_5 then
		if_set(var_16_0, "label_library", T(arg_16_1.dlc_open))
		
		arg_16_1.state = 4
		
		if_set_opacity(var_16_0, "n_banner", 76.5)
	else
		if_set_visible(var_16_0, "n_buy_possible", true)
		
		if arg_16_1.dlc_token and arg_16_1.dlc_value then
			if Account:getCurrency(arg_16_1.dlc_token) >= tonumber(arg_16_1.dlc_value) then
				arg_16_1.state = 2
			else
				arg_16_1.state = 3
			end
		end
	end
	
	if false then
	end
	
	if arg_16_1.tag then
		if_set_visible(var_16_0, "badge", true)
		if_set_sprite(var_16_0, "badge", "img/shop_icon_" .. arg_16_1.tag .. ".png")
	end
	
	if_set_visible(var_16_0, "select", false)
	
	return var_16_0
end

function SubStoryDlcMain.getSubStoryState(arg_17_0, arg_17_1)
	if not arg_17_1 then
		return 
	end
	
	local var_17_0 = Account:getSubStory(arg_17_1)
	
	if table.empty(var_17_0) then
		return 
	end
	
	local var_17_1 = var_17_0.quest_reward_state or 0
	local var_17_2 = var_17_0.ach_reward_state or 0
	
	return var_17_1, var_17_2
end

function SubStoryDlcMain.moveToItem(arg_18_0, arg_18_1)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.wnd) or not arg_18_0.vars.substory_list or not arg_18_1 then
		return 
	end
	
	for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.substory_list) do
		if iter_18_1.id == arg_18_1 then
			arg_18_0:onSelectScrollViewItem(iter_18_0, {
				item = iter_18_1
			})
			
			return true
		end
	end
end

function SubStoryDlcMain.onSelectScrollViewItem(arg_19_0, arg_19_1, arg_19_2)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.wnd) or not arg_19_2.item then
		return 
	end
	
	local var_19_0 = arg_19_2.item
	
	if var_19_0.is_lock and var_19_0.state == 4 then
		balloon_message_with_sound("ui_customdlc_banner_lock")
		
		return 
	end
	
	SoundEngine:play("event:/ui/btn_small")
	
	for iter_19_0, iter_19_1 in pairs(arg_19_0.ScrollViewItems) do
		if arg_19_1 == iter_19_0 then
			iter_19_1.control:getChildByName("select"):setVisible(true)
		else
			iter_19_1.control:getChildByName("select"):setVisible(false)
		end
	end
	
	arg_19_0.vars.last_selected_substory_id = var_19_0.id
	
	arg_19_0:updateMainUI(arg_19_2)
end

function SubStoryDlcMain.updateMainUI(arg_20_0, arg_20_1)
	local var_20_0 = SceneManager:getRunningNativeScene():findChildByName("@curtain")
	
	if get_cocos_refid(var_20_0) then
		var_20_0:removeFromParent()
	end
	
	arg_20_0.vars.wnd:getChildByName("n_poster"):removeAllChildren()
	
	local var_20_1 = arg_20_1.item
	local var_20_2 = var_0_0[var_20_1.state]
	
	if not var_20_2 then
		Log.e("Wrong Item State", var_20_1.id, var_20_1.state)
		
		return 
	end
	
	if_set_visible(arg_20_0.vars.wnd, "btn_go", var_20_2 == "already_buy")
	
	local var_20_3 = arg_20_0.vars.wnd:getChildByName("btn_buy")
	
	if var_20_2 == "already_buy" or var_20_2 == "lock" then
		if_set_visible(var_20_3, nil, false)
	elseif var_20_2 == "can_buy" or var_20_2 == "lack_currency" then
		if_set_visible(var_20_3, nil, true)
		UIUtil:getRewardIcon(nil, var_20_1.dlc_token, {
			no_bg = true,
			scale = 0.65,
			parent = var_20_3:getChildByName("n_pay_token")
		})
		if_set(var_20_3, "label_0", var_20_1.dlc_value)
	end
	
	if_set(arg_20_0.vars.wnd, "txt_title_custom", T(var_20_1.name))
	
	if var_20_1.desc and var_20_1.desc.txt then
		if_set(arg_20_0.vars.wnd, "t_disc", T(var_20_1.desc.txt))
	end
	
	local var_20_4 = arg_20_0.vars.wnd:getChildByName("btn_zoom_poster")
	local var_20_5 = arg_20_0.vars.wnd:getChildByName("btn_video")
	
	if var_20_1.prologue_story then
		if_set_visible(arg_20_0.vars.wnd, "btn_prologue", true)
		var_20_4:setPositionX(286)
		var_20_5:setPositionX(364)
	else
		if_set_visible(arg_20_0.vars.wnd, "btn_prologue", false)
		var_20_4:setPositionX(72)
		var_20_5:setPositionX(150)
	end
	
	local var_20_6 = var_20_1.bg or {}
	local var_20_7 = arg_20_0.vars.wnd:getChildByName("n_poster")
	local var_20_8 = SubstoryUIUtil:addImageFromData(var_20_7, var_20_6)
	
	if var_20_1.logo and var_20_8 then
		local var_20_9 = cc.Node:create()
		
		var_20_8:getChildByName("n_bg"):addChild(var_20_9)
		var_20_9:setAnchorPoint(0.5, 0.5)
		var_20_9:setPosition(210, 190)
		
		var_20_1.logo.logo_position = var_20_1.logo_position and var_20_1.logo_position.poster_bi_x and var_20_1.logo_position or nil
		
		local var_20_10 = cc.Node:create()
		
		var_20_8:getChildByName("n_bg"):addChild(var_20_10)
		var_20_10:setPosition(222.84, 157.83)
		var_20_10:setAnchorPoint(0.5, 0.5)
		
		local var_20_11 = SpriteCache:getSprite(var_20_1.logo.img)
		
		var_20_10:addChild(var_20_11)
		var_20_8:setAnchorPoint(0, 0)
		var_20_8:setScale(0.5)
		
		if var_20_11 and var_20_1.logo_position and var_20_1.logo_position.poster_bi_x then
			var_20_11:setPositionX(var_20_1.logo_position.poster_bi_x or 0)
			var_20_11:setPositionY(var_20_1.logo_position.poster_bi_y or 0)
			var_20_11:setScale(var_20_1.logo_position.poster_bi_scale or 1)
		end
	end
	
	for iter_20_0 = 1, 99 do
		local var_20_12 = arg_20_0.vars.wnd:getChildByName("mob_icon" .. iter_20_0)
		
		if not var_20_12 then
			break
		end
		
		var_20_12:removeAllChildren()
	end
	
	local var_20_15
	
	if var_20_1.cast_hero then
		local var_20_13 = string.split(var_20_1.cast_hero, ",")
		local var_20_14 = var_20_1
		
		var_20_15 = var_20_14.powerup_hero_open_schedule
		
		if not var_20_14.powerup_hero_unkown_icon then
			local var_20_16 = "m0000"
		end
		
		for iter_20_1, iter_20_2 in pairs(var_20_13) do
			local var_20_17 = false
			local var_20_18 = DB("character", iter_20_2, {
				"id"
			})
			local var_20_19 = arg_20_0.vars.wnd:getChildByName("mob_icon" .. iter_20_1)
			
			if var_20_18 == nil then
				var_20_17 = true
			end
			
			if not var_20_17 and (not var_20_15 or SubstoryManager:isHeroOpen(var_20_15, iter_20_2)) and var_20_19 then
				UIUtil:getRewardIcon(nil, iter_20_2, {
					hide_level = true,
					no_grade = true,
					parent = var_20_19
				})
			else
				UIUtil:getRewardIcon(nil, "m0000", {
					hide_level = true,
					no_grade = true,
					parent = var_20_19
				})
			end
		end
	end
	
	for iter_20_3 = 1, 2 do
		local var_20_20 = arg_20_0.vars.wnd:getChildByName("n_core_reward" .. iter_20_3)
		
		if var_20_20 then
			var_20_20:removeAllChildren()
		end
	end
	
	local var_20_21 = {
		hero_multiply_scale = 0.85,
		artifact_multiply_scale = 0.63,
		multiply_scale = 0.8
	}
	local var_20_22 = SubstoryManager:setCoreRewardIcons(arg_20_0.vars.wnd:getChildByName("n_core_reward"), var_20_1.id, var_20_21)
	
	arg_20_0:setVideo(var_20_1.id)
end

function SubStoryDlcMain.setVideo(arg_21_0, arg_21_1)
	if not arg_21_1 then
		return 
	end
	
	local var_21_0 = Account:getSubStoryScheduleDBById(arg_21_1)
	local var_21_1 = SubstoryUIUtil:load_link_url(var_21_0, "link")
	local var_21_2 = arg_21_0.vars.wnd:getChildByName("btn_video")
	
	if get_cocos_refid(var_21_2) and var_21_1 and var_21_1.link then
		var_21_2:setVisible(true)
		
		arg_21_0.vars.link = var_21_1.link
	else
		var_21_2:setVisible(false)
		
		arg_21_0.vars.link = nil
	end
end

function SubStoryDlcMain.showVideo(arg_22_0)
	if arg_22_0.vars.link then
		Stove:openVideoPage(arg_22_0.vars.link)
	end
end

function SubStoryDlcMain.enterDlcLobby(arg_23_0)
	if not arg_23_0.vars or not get_cocos_refid(arg_23_0.vars.wnd) or not arg_23_0.vars.last_selected_substory_id then
		return 
	end
	
	local var_23_0 = arg_23_0:getSubStoryData(arg_23_0.vars.last_selected_substory_id)
	
	if not var_23_0 or not var_23_0.id then
		return 
	end
	
	if not arg_23_0:checkSubstoryHave(var_23_0.id) then
		Log.e("Err: do not have DLC story")
		
		return 
	end
	
	SubStoryDlc:queryEnterSubstoryDlc(var_23_0.id)
end

function SubStoryDlcMain.checkSubstoryHave(arg_24_0, arg_24_1)
	if not arg_24_1 then
		return 
	end
	
	return not table.empty(Account:getSubStory(arg_24_1))
end

function SubStoryDlcMain.reqBuyDLC(arg_25_0)
	if not arg_25_0.vars or not get_cocos_refid(arg_25_0.vars.wnd) or not arg_25_0.vars.last_selected_substory_id then
		return 
	end
	
	local var_25_0 = arg_25_0:getSubStoryData(arg_25_0.vars.last_selected_substory_id)
	
	if not var_25_0 or not var_25_0.id or not var_25_0.dlc_token or not var_25_0.dlc_value then
		return 
	end
	
	if var_25_0.is_lock and var_25_0.state == 4 then
		return 
	end
	
	local var_25_1 = var_25_0.dlc_token
	local var_25_2 = var_25_0.dlc_value
	local var_25_3 = Account:getCurrency(var_25_1)
	
	if arg_25_0:checkSubstoryHave(var_25_0.id) then
		balloon_message_with_sound("Err: already have")
		
		return 
	end
	
	local var_25_4 = Dialog:msgBox(nil, {
		yesno = true,
		handler = function()
			if (Account:isCurrencyType(var_25_1) or Account:isMaterialCurrencyType(var_25_1)) and UIUtil:checkCurrencyDialog(var_25_1, var_25_2) ~= true then
				return 
			end
			
			query("buy_substory_dlc", {
				substory_id = var_25_0.id
			})
		end,
		dlg = load_dlg("story_dlc_buy", nil, "wnd"),
		title = T("ui_customdlc_buy_title")
	})
	
	if var_25_0.logo and var_25_0.logo.img then
		if_set_sprite(var_25_4, "img_bi", var_25_0.logo.img .. ".png")
	end
	
	if_set(var_25_4, "txt_buy", T("ui_customdlc_buy_title"))
	if_set(var_25_4, "infor", T("ui_customdlc_buy_desc"))
	if_set(var_25_4, "txt_price", var_25_2)
	UIUtil:getRewardIcon(nil, var_25_1, {
		no_bg = true,
		scale = 0.65,
		parent = var_25_4:getChildByName("n_pay_token")
	})
	
	local var_25_5 = var_25_0.id
	local var_25_6 = {}
	
	for iter_25_0 = 1, 99 do
		local var_25_7 = DBT("substory_dlc_reward", var_25_5 .. "_b_" .. iter_25_0, {
			"id",
			"reward_type",
			"item_id",
			"item_count",
			"grade_rate",
			"set_rate"
		})
		
		if not var_25_7 or not var_25_7.id then
			break
		end
		
		table.insert(var_25_6, var_25_7)
	end
	
	for iter_25_1 = 1, 99 do
		local var_25_8 = var_25_4:getChildByName("reward_item" .. iter_25_1)
		
		if not var_25_8 or not var_25_6[iter_25_1] then
			break
		end
		
		local var_25_9 = var_25_6[iter_25_1]
		local var_25_10 = var_25_9.item_id
		local var_25_11 = 0.9
		
		if string.starts(var_25_10, "c") then
			var_25_11 = 1
		elseif string.starts(var_25_10, "e") then
			local var_25_12 = DB("equip_item", var_25_10, {
				"type"
			})
			
			if var_25_12 and var_25_12 == "artifact" then
				var_25_11 = 0.7
			end
		end
		
		local var_25_13 = {
			parent = var_25_8,
			grade_rate = var_25_9.grade_rate,
			set_drop = var_25_9.set_rate,
			scale = var_25_11
		}
		
		UIUtil:getRewardIcon(var_25_9.item_count, var_25_9.item_id, var_25_13)
	end
end

function SubStoryDlcMain.resBuyDLC(arg_27_0, arg_27_1)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.vars.wnd) or not arg_27_0.vars.last_selected_substory_id then
		return 
	end
	
	Account:setSubStory(arg_27_1.substory_info.substory_id, arg_27_1.substory_info)
	
	if arg_27_1.rewards and not table.empty(arg_27_1.rewards) then
		local var_27_0 = {
			title = T("ui_msgbox_rewards_title"),
			desc = T("ui_customdlc_rewards_desc")
		}
		
		Account:addReward(arg_27_1.rewards, {
			play_reward_data = var_27_0
		})
		arg_27_0:showBuyRewardPopup(arg_27_1.rewards)
	end
	
	Account:updateCurrencies(arg_27_1.dec_result)
	TopBarNew:topbarUpdate(true)
	
	local var_27_1 = arg_27_0:getSubStoryData(arg_27_0.vars.last_selected_substory_id)
	
	if var_27_1 then
		var_27_1.state = 1
	end
	
	arg_27_0:updateSubStoryList()
end

function SubStoryDlcMain.showBuyRewardPopup(arg_28_0, arg_28_1)
	if not arg_28_1 then
		return 
	end
end

function SubStoryDlcMain.openStoryViewPopup(arg_29_0)
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.vars.wnd) or not arg_29_0.vars.last_selected_substory_id then
		return 
	end
	
	SubStoryDLCStoryViewPopUp:open(arg_29_0.vars.wnd, arg_29_0.vars.last_selected_substory_id)
end

function SubStoryDlcMain.onLeave(arg_30_0)
	arg_30_0.vars = nil
	
	SceneManager:nextScene("lobby", {
		open_sub_story = {
			mode = "HOME"
		}
	})
end

SubStoryChronicle = {}

copy_functions(ScrollView, SubStoryChronicle)

function HANDLER.story_dlc_item(arg_31_0, arg_31_1)
	if arg_31_1 == "btn_select" and arg_31_0.item then
		SubStoryChronicle:moveToItem(arg_31_0.item)
	end
end

function HANDLER.story_dlc_chronicle(arg_32_0, arg_32_1)
	if arg_32_1 == "btn_movie" and arg_32_0.item and arg_32_0.item.video_id then
		Stove:openVideoPage(arg_32_0.item.video_id)
	end
end

local var_0_1 = 100
local var_0_2 = 100
local var_0_3 = 370

function SubStoryChronicle.show(arg_33_0, arg_33_1)
	local var_33_0 = arg_33_1 or SceneManager:getRunningPopupScene()
	
	arg_33_0.vars = {}
	arg_33_0.vars.wnd = load_dlg("story_dlc_chronicle", true, "wnd")
	
	arg_33_0.vars.wnd:setPositionX(var_33_0:getContentSize().width / 2)
	var_33_0:addChild(arg_33_0.vars.wnd)
	TopBarNew:createFromPopup(T("substory_title"), arg_33_0.vars.wnd, function()
		SubStoryEntrance:setMode("HOME")
	end, nil, "infosubs")
	TopBarNew:setCurrencies({
		"crystal",
		"gold",
		"stamina"
	})
	arg_33_0:init()
	
	local var_33_1 = arg_33_0.vars.wnd:getChildByName("scrollview")
	
	arg_33_0.vars.itemView = ItemListView_v2:bindControl(var_33_1)
	
	local var_33_2 = load_control("wnd/story_dlc_chronicle_card.csb")
	
	if var_33_1.STRETCH_INFO then
		local var_33_3 = var_33_1:getContentSize()
		
		resetControlPosAndSize(var_33_2, var_33_3.width, var_33_1.STRETCH_INFO.width_prev)
	end
	
	local var_33_4 = {
		onUpdate = function(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
			SubStoryChronicle:updateItem(arg_35_1, arg_35_3)
			
			return arg_35_3.id
		end
	}
	
	arg_33_0.vars.itemView:setRenderer(var_33_2, var_33_4)
	arg_33_0.vars.itemView:removeAllChildren()
	arg_33_0.vars.itemView:setDataSource(arg_33_0.vars.datas)
	arg_33_0:setListViewSetting()
end

function SubStoryChronicle.setListViewSetting(arg_36_0)
	local var_36_0 = var_0_3 * table.count(arg_36_0.vars.datas)
	local var_36_1 = arg_36_0.vars.wnd:getChildByName("scrollview"):getInnerContainerSize()
	
	var_36_1.width = var_36_0 + var_0_1 + var_0_2
	
	arg_36_0.vars.wnd:getChildByName("scrollview"):setInnerContainerSize(var_36_1)
end

local function var_0_4(arg_37_0)
	arg_37_0.logo_position = DB("substory_bg", arg_37_0.background_battle, "logo_position")
	
	if arg_37_0.logo_position then
		arg_37_0.logo_position = totable(arg_37_0.logo_position)
	end
	
	if arg_37_0.icon_enter then
		local var_37_0 = arg_37_0.icon_enter
		
		arg_37_0.icon_enter = DB("substory_bg", var_37_0, "icon_enter")
		arg_37_0.banner_icon = totable(DB("substory_bg", var_37_0, "logo")).img or arg_37_0.banner_icon
		arg_37_0.logo_position = DB("substory_bg", var_37_0, "logo_position")
		
		if arg_37_0.logo_position then
			arg_37_0.logo_position = totable(arg_37_0.logo_position)
		end
	end
	
	return arg_37_0
end

function SubStoryChronicle.init(arg_38_0)
	arg_38_0.vars.datas = {}
	
	local var_38_0 = getUserLanguage() or ""
	local var_38_1 = "video_" .. var_38_0
	
	for iter_38_0 = 1, 99 do
		local var_38_2, var_38_3, var_38_4, var_38_5, var_38_6, var_38_7, var_38_8, var_38_9, var_38_10, var_38_11, var_38_12, var_38_13 = DBN("substory_dlc_chronicle", iter_38_0, {
			"id",
			"type",
			"chronicle_open_type",
			"chronicle_open_condition",
			"chronicle_lock_desc",
			"chronicle_title",
			"chronicle_desc",
			var_38_1,
			"substory_id",
			"position_x",
			"position_y",
			"sort"
		})
		
		if not var_38_2 then
			break
		end
		
		var_38_13 = var_38_13 or 1
		
		local var_38_14
		
		if (var_38_3 == "custom" or var_38_3 == "substory") and var_38_10 then
			var_38_14 = SubStoryUtil:getSubstoryDB(var_38_10, {
				is_lite = true
			})
			var_38_14 = var_0_4(var_38_14)
			
			if var_38_14 then
				if var_38_14.dlc_open then
					var_38_14.is_lock = not Account:isSysAchieveCleared(var_38_14.dlc_open)
				else
					var_38_14.is_lock = false
				end
			end
		end
		
		local var_38_15, var_38_16 = DBN("substory_dlc_chronicle", iter_38_0 + 1, {
			"id",
			"position_x"
		})
		local var_38_17 = 0
		
		if var_38_15 and var_38_16 then
			var_38_17 = var_38_16 or 0
		end
		
		table.insert(arg_38_0.vars.datas, {
			id = var_38_2,
			type = var_38_3,
			chronicle_open_type = var_38_4,
			chronicle_open_condition = var_38_5,
			chronicle_title = var_38_7,
			chronicle_desc = var_38_8,
			chronicle_lock_desc = var_38_6,
			video_id = var_38_9,
			substory_id = var_38_10,
			position_x = var_38_11,
			position_y = var_38_12,
			sort = var_38_13,
			custom_story_data = var_38_14,
			next_x = var_38_17
		})
	end
	
	if table.empty(arg_38_0.vars.datas) then
		Log.e("Empty chronicle data!!")
		
		return 
	end
end

function SubStoryChronicle.isVisibleVideoButton(arg_39_0, arg_39_1)
	if not arg_39_1 then
		return false
	end
	
	if not arg_39_1.video then
		return false
	end
	
	if IS_PUBLISHER_ZLONG then
		return false
	end
	
	return true
end

function SubStoryChronicle.updateItem(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0
	local var_40_1
	local var_40_2 = arg_40_2.type == "chronicle"
	local var_40_3 = arg_40_2.position_y == "top"
	local var_40_4
	
	if var_40_2 then
		if_set_visible(arg_40_1, "n_story_text", true)
		if_set_visible(arg_40_1, "n_banner", false)
		
		var_40_0 = "n_story_text"
		var_40_1 = arg_40_1:getChildByName(var_40_0)
		var_40_4 = var_40_1:getChildByName("line")
		
		if var_40_3 then
			if_set_visible(var_40_1, "n_under", false)
			
			var_40_1 = var_40_1:getChildByName("n_over")
			
			if not arg_40_0:isVisibleVideoButton(arg_40_2) then
				local var_40_5 = var_40_1:getChildByName("story_title_over")
				local var_40_6 = var_40_1:getChildByName("t_disc_over")
				
				if var_40_5 and var_40_6 then
					var_40_5:setPositionY(var_40_5:getPositionY() - 40)
					var_40_6:setPositionY(var_40_6:getPositionY() - 40)
				end
			end
		else
			if_set_visible(var_40_1, "n_over", false)
			
			var_40_1 = var_40_1:getChildByName("n_under")
		end
	else
		if_set_visible(arg_40_1, "n_story_text", false)
		if_set_visible(arg_40_1, "n_banner", true)
		
		var_40_0 = "n_banner"
		var_40_1 = arg_40_1:getChildByName(var_40_0)
		var_40_4 = var_40_1:getChildByName("line")
		
		if var_40_3 then
			if_set_visible(var_40_1, "n_under", false)
			
			var_40_1 = var_40_1:getChildByName("n_over")
		else
			if_set_visible(var_40_1, "n_over", false)
			
			var_40_1 = var_40_1:getChildByName("n_under")
		end
	end
	
	if var_40_4 then
		arg_40_2.n_line = var_40_4
		
		local var_40_7 = var_40_4:getContentSize()
		
		var_40_4:setContentSize(var_0_3 + arg_40_2.next_x - arg_40_2.position_x, var_40_7.height)
	end
	
	if var_40_2 then
		local var_40_8
		local var_40_9
		local var_40_10 = 0
		local var_40_11 = 0
		local var_40_12 = T(arg_40_2.chronicle_title)
		local var_40_13 = T(arg_40_2.chronicle_desc)
		
		if arg_40_2.chronicle_open_type and arg_40_2.chronicle_open_condition then
			local var_40_14 = SubStoryUtil:getLockChronicleDesc(arg_40_2.chronicle_open_type, arg_40_2.chronicle_open_condition, arg_40_2.chronicle_lock_desc)
			
			if var_40_14 then
				var_40_12 = T("chronicle_lock_title")
				var_40_13 = var_40_14
			end
		end
		
		if var_40_3 then
			if_set_visible(var_40_1, "n_over", true)
			if_set_visible(var_40_1, "n_under", false)
			if_set(var_40_1, "story_title_over", var_40_12)
			if_set(var_40_1, "t_disc_over", var_40_13)
			
			var_40_8 = var_40_1:getChildByName("t_disc_over")
			var_40_9 = var_40_1:getChildByName("story_title_over")
		else
			if_set_visible(var_40_1, "n_over", false)
			if_set_visible(var_40_1, "n_under", true)
			if_set(var_40_1, "story_title_under", var_40_12)
			if_set(var_40_1, "t_disc_under", var_40_13)
			
			var_40_8 = var_40_1:getChildByName("t_disc_under")
			var_40_9 = var_40_1:getChildByName("story_title_under")
		end
		
		if_set_visible(var_40_1, "btn_movie", arg_40_0:isVisibleVideoButton(arg_40_2))
		
		local var_40_15 = var_40_1:getChildByName("btn_movie")
		
		if var_40_15 and arg_40_2.video_id then
			var_40_15.item = arg_40_2
		end
		
		if var_40_8 then
			if not var_40_3 then
				local var_40_16 = var_40_9:getStringNumLines()
				
				if var_40_16 >= 2 and not var_40_8.origin_pos_y then
					var_40_8.origin_pos_y = var_40_8:getPositionY()
					
					var_40_8:setPositionY(var_40_8.origin_pos_y - (var_40_16 - 1) * 30)
				end
				
				local var_40_17 = var_40_8:getStringNumLines() or 0
				local var_40_18 = var_40_1:getChildByName("btn_movie")
				
				if var_40_17 >= 2 and var_40_18 then
					local var_40_19 = var_40_17 - 1
					
					var_40_18:setPositionY(var_40_18:getPositionY() - var_40_19 * 20)
				end
			elseif var_40_3 then
				local var_40_20 = var_40_8:getStringNumLines()
				
				if var_40_20 > 1 and not var_40_9.origin_height then
					var_40_9.origin_height = var_40_9:getPositionY()
					
					var_40_9:setPositionY(var_40_9.origin_height + (var_40_20 - 1) * 20)
				end
			end
		end
	end
	
	if not var_40_2 and arg_40_2.substory_id and arg_40_2.custom_story_data then
		local var_40_21 = arg_40_2.substory_id
		local var_40_22 = arg_40_2.custom_story_data
		local var_40_23 = var_40_22.is_lock
		local var_40_24 = load_control("wnd/story_dlc_item.csb")
		
		var_40_1:getChildByName("n_dlc_item"):addChild(var_40_24)
		if_set_visible(var_40_24, "select", false)
		
		local var_40_25 = var_40_24:getChildByName("btn_select")
		
		if var_40_25 then
			var_40_25.item = arg_40_2
		end
		
		local var_40_26 = not var_40_23 and SubStoryDlcMain:checkSubstoryHave(var_40_21)
		
		if_set_visible(var_40_24, "n_possession", false)
		if_set_visible(var_40_24, "n_buy_possible", not var_40_26 and not var_40_23)
		if_set_visible(var_40_24, "n_lock", var_40_23)
		
		if arg_40_2.type == "substory" then
			if_set_visible(var_40_24, "n_possession", false)
			if_set_visible(var_40_24, "n_buy_possible", false)
			if_set_visible(var_40_24, "n_lock", false)
			
			local var_40_27 = arg_40_1:getChildByName(var_40_0)
			
			if var_40_27 then
				if_set_visible(var_40_27, "sub_slot", true)
				if_set_visible(var_40_27, "slot", false)
			end
		elseif arg_40_2.type == "custom" then
			if_set_visible(var_40_24, "n_possession", var_40_26)
			if_set_visible(var_40_24, "n_buy_possible", not var_40_26 and not var_40_23)
			if_set_visible(var_40_24, "n_lock", var_40_23)
		end
		
		local var_40_28 = var_40_24:getChildByName("n_banner")
		
		if var_40_28 then
			local var_40_29 = SubstoryUIUtil:createBanner(var_40_22.icon_enter, var_40_22.banner_icon, var_40_22.logo_position)
			
			if var_40_29 then
				var_40_28:addChild(var_40_29)
				var_40_29:setAnchorPoint(0.5, 0.5)
				var_40_29:getChildByName("panel_clipping"):setTouchEnabled(false)
			end
		end
		
		if var_40_23 then
			var_40_28:setOpacity(76.5)
		end
		
		if var_40_26 and arg_40_2.type == "custom" then
			if_set_visible(var_40_24, "n_possession", true)
			
			local var_40_30, var_40_31 = SubStoryDlcMain:getSubStoryState(var_40_21)
			
			if SubstoryManager:isEndStory(arg_40_2.id) then
				if_set(arg_40_1, "txt_progress", T("ui_customdlc_b_comp"))
			elseif var_40_31 then
				local var_40_32 = ""
				
				if var_40_31 == 1 then
					var_40_32 = T("ui_customdlc_b_ing")
				end
				
				if_set(arg_40_1, "txt_progress", var_40_32)
			end
		end
	end
	
	if arg_40_2.position_x then
		arg_40_1:setPositionX(arg_40_1:getPositionX() + arg_40_2.position_x)
	end
end

function SubStoryChronicle.checkDLCUnlock(arg_41_0)
	local var_41_0 = "vcudlc"
	local var_41_1, var_41_2 = DB("substory_main", var_41_0, {
		"id",
		"unlock"
	})
	
	if not var_41_1 or not var_41_2 then
		return 
	end
	
	return UnlockSystem:isUnlockSystem(var_41_2), var_41_2
end

function SubStoryChronicle.moveToItem(arg_42_0, arg_42_1)
	if not arg_42_1 or arg_42_1.type ~= "custom" and arg_42_1.type ~= "substory" then
		return 
	end
	
	local var_42_0 = arg_42_1.custom_story_data.is_lock
	
	if arg_42_1.type == "substory" then
		arg_42_0:_moveToDict(arg_42_1.substory_id)
	end
	
	if not var_42_0 then
		SoundEngine:play("event:/ui/btn_small")
		
		if arg_42_1.type == "custom" then
			local var_42_1, var_42_2 = arg_42_0:checkDLCUnlock()
			
			if not var_42_1 and var_42_2 then
				UnlockSystem:isUnlockSystemAndMsg({
					id = var_42_2
				})
				
				return 
			end
			
			if arg_42_0:_moveToItem(arg_42_1.substory_id) then
				arg_42_0:close()
			end
		end
	elseif var_42_0 then
		balloon_message_with_sound("ui_customdlc_banner_lock")
		
		return 
	end
end

function SubStoryChronicle._moveToItem(arg_43_0, arg_43_1)
	SubStoryDlc:enterQuery({
		move_item_id = arg_43_1
	})
end

function SubStoryChronicle._moveToDict(arg_44_0, arg_44_1)
	if not arg_44_1 then
		return 
	end
	
	if SceneManager:getCurrentSceneName() == "collection" then
		CollectionController:release()
	end
	
	SceneManager:nextScene("collection", {
		mode = "story",
		parent_id = "story7",
		dlc_enter = true,
		select_item = {
			id = arg_44_1
		}
	})
end

function SubStoryChronicle.close(arg_45_0)
	arg_45_0.vars.wnd:removeFromParent()
	
	arg_45_0.vars = {}
	
	TopBarNew:pop()
	BackButtonManager:pop("story_dlc_chronicle")
end

SubStoryDLCStoryViewPopUp = {}

function HANDLER.story_dlc_view_popup(arg_46_0, arg_46_1)
	if arg_46_1 == "btn_week" then
		local var_46_0 = arg_46_0:getParent()
		
		if var_46_0 then
			SubStoryDLCStoryViewPopUp:onSelectChapter(tonumber(string.sub(var_46_0:getName(), "-1", "-1")))
		end
	elseif arg_46_1 == "btn_play_brown" and arg_46_0.item then
		SubStoryDLCStoryViewPopUp:play(arg_46_0.item)
	elseif arg_46_1 == "btn_view_all" then
		SubStoryDLCStoryViewPopUp:play_all()
	elseif arg_46_1 == "btn_close" then
		SubStoryDLCStoryViewPopUp:close()
	elseif arg_46_1 == "btn_battle" and arg_46_0.item then
		SubStoryDLCStoryViewPopUp:onBattle(arg_46_0.item)
	elseif arg_46_1 == "btn_illust" and arg_46_0.item and arg_46_0.item.illust then
		SubStoryDLCStoryViewPopUp:openIllust(arg_46_0.item)
	elseif arg_46_1 == "btn_movie" and arg_46_0.item and arg_46_0.item.movie then
		SubStoryDLCStoryViewPopUp:playMovie(arg_46_0.item)
	end
end

function SubStoryDLCStoryViewPopUp.open(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	if not arg_47_2 then
		return 
	end
	
	local var_47_0 = arg_47_3 or {}
	
	arg_47_0.vars = {}
	arg_47_0.vars.isClearStory = var_47_0.clearStory
	arg_47_0.vars.substory_id = arg_47_2
	
	arg_47_0:initData(arg_47_2)
	
	if table.empty(arg_47_0.vars.data) then
		return 
	end
	
	local var_47_1 = arg_47_1 or SceneManager:getRunningPopupScene()
	
	arg_47_0.vars.wnd = load_dlg("story_dlc_view_popup", true, "wnd", function()
		SubStoryDLCStoryViewPopUp:close()
	end)
	
	var_47_1:addChild(arg_47_0.vars.wnd)
	arg_47_0:initListView()
	arg_47_0:onSelectChapter(1)
end

function SubStoryDLCStoryViewPopUp.initListView(arg_49_0)
	arg_49_0.vars.listview = ItemListView:bindControl(arg_49_0.vars.wnd:getChildByName("list_view"))
	
	local var_49_0 = {
		onUpdate = function(arg_50_0, arg_50_1, arg_50_2)
			local var_50_0 = arg_50_1:getChildByName("btn_play_brown")
			local var_50_1 = arg_50_1:getChildByName("btn_battle")
			local var_50_2 = arg_50_1:getChildByName("btn_illust")
			local var_50_3 = arg_50_1:getChildByName("btn_movie")
			
			var_50_0.item = arg_50_2
			var_50_1.item = arg_50_2
			var_50_2.item = arg_50_2
			var_50_3.item = arg_50_2
			arg_50_1.item = arg_50_2
			
			if_set_visible(var_50_1, nil, arg_50_2.npc_team ~= nil)
			if_set_visible(var_50_2, nil, arg_50_2.illust ~= nil)
			if_set_visible(var_50_3, nil, arg_50_2.movie ~= nil)
			
			local var_50_4 = var_50_1:getContentSize().width * var_50_1:getScaleX()
			local var_50_5 = var_50_3:getContentSize().width * var_50_3:getScaleX()
			local var_50_6 = var_50_2:getContentSize().width * var_50_2:getScaleX()
			
			if var_50_1:isVisible() then
				var_50_3:setPositionX(var_50_3:getPositionX() - var_50_4 + 3)
				var_50_2:setPositionX(var_50_2:getPositionX() - var_50_4 + 3)
			end
			
			if not var_50_3:isVisible() then
				var_50_2:setPositionX(var_50_2:getPositionX() + var_50_5)
			end
			
			local var_50_7 = 340
			
			if var_50_1:isVisible() then
				var_50_7 = var_50_7 - var_50_4
			end
			
			if var_50_3:isVisible() then
				var_50_7 = var_50_7 - var_50_5
			end
			
			if var_50_2:isVisible() then
				var_50_7 = var_50_7 - var_50_6
			end
			
			if arg_50_2.is_lock then
				arg_50_1:setOpacity(76.5)
				if_set_visible(var_50_1, nil, false)
				if_set_visible(var_50_2, nil, false)
				if_set_visible(var_50_3, nil, false)
				if_set(arg_50_1, "txt_title", T("mission_name_unlock"))
				if_set(arg_50_1, "txt_desc", T("mission_name_desc"))
				if_set_sprite(arg_50_1, "face", "face/m0000_s.png")
			else
				local var_50_8 = arg_50_1:getChildByName("txt_title")
				
				if_set(var_50_8, nil, T(arg_50_2.name))
				
				if get_cocos_refid(var_50_8) then
					UIUserData:call(var_50_8, "SINGLE_WSCALE(" .. var_50_7 .. ")")
				end
				
				local var_50_9 = arg_50_1:getChildByName("txt_desc")
				
				if_set(var_50_9, nil, T(arg_50_2.desc))
				
				if get_cocos_refid(var_50_9) then
					UIUserData:call(var_50_9, "SINGLE_WSCALE(" .. var_50_7 .. ")")
				end
				
				if_set_sprite(arg_50_1, "face", "face/" .. arg_50_2.icon .. "_s.png")
			end
		end
	}
	
	arg_49_0.vars.listview:setRenderer(load_control("wnd/story_dlc_bar.csb"), var_49_0)
end

function SubStoryDLCStoryViewPopUp.initData(arg_51_0, arg_51_1)
	arg_51_0.vars.data = {}
	arg_51_0.vars.chapter_data = {}
	
	local var_51_0, var_51_1, var_51_2 = DB("substory_dlc_story_ui", arg_51_1, {
		"id",
		"parent_id",
		"step"
	})
	
	if not var_51_0 or var_51_1 then
		Log.e("empty substory data // substory_dlc_story_ui.db ", arg_51_1)
		
		return 
	end
	
	for iter_51_0 = 1, 99 do
		local var_51_3, var_51_4, var_51_5, var_51_6, var_51_7, var_51_8, var_51_9 = DBN("substory_dlc_story_ui", iter_51_0, {
			"id",
			"complete",
			"name",
			"parent_id",
			"step",
			"sort",
			"desc"
		})
		
		if not var_51_3 then
			break
		end
		
		if var_51_6 and var_51_6 == arg_51_1 and var_51_7 and tonumber(var_51_7) > 1 then
			table.insert(arg_51_0.vars.data, {
				id = var_51_3,
				complete = var_51_4,
				name = var_51_5,
				parent_id = var_51_6,
				step = var_51_7,
				sort = var_51_8,
				desc = var_51_9,
				story_data = {}
			})
		elseif var_51_3 == arg_51_1 and var_51_7 and tonumber(var_51_7) == 1 then
			arg_51_0.vars.chapter_data = {
				id = var_51_3,
				complete = var_51_4,
				name = var_51_5,
				parent_id = var_51_6,
				step = var_51_7,
				sort = var_51_8,
				desc = var_51_9,
				story_data = {}
			}
		end
	end
	
	local var_51_10 = {
		"id",
		"export_id",
		"complete",
		"parent_id",
		"sort",
		"quest_id",
		"face_id",
		"map_name",
		"title_name",
		"story_id",
		"level_enter",
		"npc_team",
		"movie",
		"illust",
		"default_bg",
		"default_bgm",
		"select_story",
		"select_skip",
		"show",
		"open_map"
	}
	
	for iter_51_1, iter_51_2 in pairs(arg_51_0.vars.data) do
		local var_51_11 = iter_51_2.id
		
		for iter_51_3 = 1, 99 do
			local var_51_12 = var_51_11 .. "_" .. iter_51_3
			local var_51_13 = DBT("substory_dlc_story", var_51_12, var_51_10)
			
			if not var_51_13 or table.empty(var_51_13) or var_51_13.parent_id and var_51_13.parent_id ~= var_51_11 then
				break
			end
			
			if var_51_13.quest_id then
				local var_51_14, var_51_15, var_51_16 = DB("substory_quest", var_51_13.quest_id, {
					"name",
					"desc",
					"icon"
				})
				
				var_51_13.icon = var_51_16
				var_51_13.name = var_51_14
				var_51_13.desc = var_51_15
			else
				var_51_13.icon = var_51_13.face_id or ""
				var_51_13.name = var_51_13.title_name or ""
				var_51_13.desc = var_51_13.map_name or ""
			end
			
			if not arg_51_0.vars.isClearStory then
				if var_51_13.quest_id then
					local var_51_17 = Account:getSubStoryQuest(var_51_13.quest_id) or {}
					
					if var_51_17.state ~= SUBSTORY_QUEST_STATE.CLEAR and var_51_17.state ~= SUBSTORY_QUEST_STATE.REWARDED then
						var_51_13.is_lock = true
					end
				end
				
				if not var_51_13.quest_id and var_51_13.open_map then
					local var_51_18 = string.split(var_51_13.open_map, ",")
					local var_51_19 = 0
					local var_51_20 = table.count(var_51_18)
					
					for iter_51_4, iter_51_5 in pairs(var_51_18) do
						if Account:isMapCleared(iter_51_5) then
							var_51_19 = var_51_19 + 1
						end
					end
					
					if var_51_20 <= var_51_19 then
						var_51_13.is_lock = false
					else
						var_51_13.is_lock = true
					end
				elseif not var_51_13.quest_id and not var_51_13.open_map then
					var_51_13.is_lock = false
					
					local var_51_21 = string.split(var_51_13.story_id, ",")
					local var_51_22 = ""
					
					for iter_51_6, iter_51_7 in pairs(var_51_21) do
						if not arg_51_0:isPlayedBefore(arg_51_1, iter_51_7) then
							var_51_13.is_lock = true
							
							break
						end
					end
				end
			end
			
			if DEBUG.DLC_STORY_OPEN then
				var_51_13.is_lock = false
			end
			
			table.insert(iter_51_2.story_data, var_51_13)
		end
	end
end

function SubStoryDLCStoryViewPopUp.onSelectChapter(arg_52_0, arg_52_1)
	arg_52_0.vars.select_chapter = arg_52_1
	
	arg_52_0:updateUI()
end

function SubStoryDLCStoryViewPopUp.updateUI(arg_53_0)
	local var_53_0 = table.count(arg_53_0.vars.data)
	
	for iter_53_0 = 1, 99 do
		local var_53_1 = arg_53_0.vars.wnd:getChildByName("n_week" .. iter_53_0)
		local var_53_2 = arg_53_0.vars.data[iter_53_0]
		
		if not var_53_1 then
			break
		end
		
		if_set_visible(var_53_1, "select", arg_53_0.vars.select_chapter == iter_53_0)
		var_53_1:setVisible(iter_53_0 <= var_53_0)
		
		if var_53_2 then
			if_set(var_53_1, "txt_week", T(var_53_2.name))
		end
	end
	
	local var_53_3 = arg_53_0.vars.data[arg_53_0.vars.select_chapter]
	
	if not var_53_3 or table.empty(var_53_3) then
		return 
	end
	
	if arg_53_0.vars.chapter_data then
		if_set(arg_53_0.vars.wnd, "title", T(arg_53_0.vars.chapter_data.name))
	end
	
	if_set(arg_53_0.vars.wnd, "sub_title", T(var_53_3.desc))
	arg_53_0.vars.listview:setItems(var_53_3.story_data)
	arg_53_0.vars.listview:jumpToTop()
end

function SubStoryDLCStoryViewPopUp.play_all(arg_54_0)
	if not arg_54_0.vars or not arg_54_0.vars.data or not arg_54_0.vars.select_chapter or not arg_54_0.vars.data[arg_54_0.vars.select_chapter] or not arg_54_0.vars.data[arg_54_0.vars.select_chapter].story_data then
		return 
	end
	
	local var_54_0 = table.shallow_clone(arg_54_0.vars.data[arg_54_0.vars.select_chapter].story_data)
	
	if not var_54_0 then
		return 
	end
	
	for iter_54_0 = #var_54_0, 1, -1 do
		if var_54_0[iter_54_0] and var_54_0[iter_54_0].is_lock then
			table.remove(var_54_0, iter_54_0)
		end
	end
	
	if table.empty(var_54_0) then
		balloon_message_with_sound("ui_dict_story_yet")
		
		return 
	end
	
	arg_54_0.vars.black_back_layer = cc.Layer:create()
	
	arg_54_0.vars.wnd:addChild(arg_54_0.vars.black_back_layer)
	
	local var_54_1 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_54_1:setPositionX(VIEW_BASE_LEFT)
	arg_54_0.vars.black_back_layer:addChild(var_54_1)
	CollectionStoryDetail:play_all(arg_54_0.vars.black_back_layer, var_54_0, function()
		arg_54_0.vars.black_back_layer:removeFromParent()
	end, {
		skip_chosen_opacity = true
	})
end

function SubStoryDLCStoryViewPopUp.play(arg_56_0, arg_56_1)
	if not arg_56_1 then
		return 
	end
	
	if arg_56_1.is_lock then
		balloon_message_with_sound("ui_dict_story_yet")
		
		return 
	end
	
	local var_56_0 = {
		isCanShow = true,
		type = "story",
		default_bgm = arg_56_1.default_bgm,
		id = arg_56_1.story_id
	}
	
	arg_56_0.vars.black_back_layer = cc.Layer:create()
	
	arg_56_0.vars.wnd:addChild(arg_56_0.vars.black_back_layer)
	
	local var_56_1 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_56_1:setPositionX(VIEW_BASE_LEFT)
	arg_56_0.vars.black_back_layer:addChild(var_56_1)
	CollectionStoryDetail:play(arg_56_0.vars.black_back_layer, var_56_0, function()
		arg_56_0.vars.black_back_layer:removeFromParent()
	end, {
		skip_chosen_opacity = true
	})
end

function SubStoryDLCStoryViewPopUp.openIllust(arg_58_0, arg_58_1)
	if not arg_58_1 then
		return 
	end
	
	if arg_58_1.is_lock then
		balloon_message_with_sound("ui_dict_story_yet")
		
		return 
	end
	
	if not arg_58_1.illust then
		return 
	end
	
	arg_58_0.vars.parent_layer = SceneManager:getRunningPopupScene()
	arg_58_0.vars.lobby_wnd = SubStoryDlcLobby:getWnd()
	arg_58_0.vars.wnd_detail = cc.Layer:create()
	
	arg_58_0.vars.parent_layer:addChild(arg_58_0.vars.wnd_detail)
	arg_58_0.vars.wnd_detail:setCascadeOpacityEnabled(true)
	CollectionImageViewer:open(arg_58_0.vars.wnd_detail, {
		isCanShow = true,
		type = "illust",
		illust = arg_58_1.illust
	}, {
		topbar_title = T("system_051_title"),
		close_callback = function()
			arg_58_0:close_illust()
		end
	})
	
	local var_58_0 = true
	local var_58_1 = var_58_0 and 0 or 250
	
	arg_58_0.vars.wnd_detail:setVisible(false)
	arg_58_0.vars.wnd_detail:setOpacity(0)
	UIAction:Add(SEQ(FADE_OUT(var_58_1), SHOW(false)), arg_58_0.vars.wnd, "block")
	
	if get_cocos_refid(arg_58_0.vars.lobby_wnd) then
		UIAction:Add(SEQ(FADE_OUT(var_58_1), SHOW(false)), arg_58_0.vars.lobby_wnd, "block")
	end
	
	UIAction:Add(SEQ(DELAY(var_58_1), SHOW(true), FADE_IN(var_58_1)), arg_58_0.vars.wnd_detail, "block")
	set_scene_fps(10)
end

function SubStoryDLCStoryViewPopUp.playMovie(arg_60_0, arg_60_1)
	if not arg_60_1 then
		return 
	end
	
	if arg_60_1.is_lock then
		balloon_message_with_sound("ui_dict_story_yet")
		
		return 
	end
	
	if not arg_60_1.movie then
		return 
	end
	
	if string.starts(arg_60_1.movie, "https") then
		Stove:openVideoPage(arg_60_1.movie)
	else
		CollectionStoryDetail:play_movie({
			isCanShow = true,
			movie = arg_60_1.movie
		})
	end
end

function SubStoryDLCStoryViewPopUp.close_illust(arg_61_0)
	if not arg_61_0.vars or not arg_61_0.vars.wnd then
		return 
	end
	
	TopBarNew:pop()
	BackButtonManager:pop("CollectionNewHero")
	UIAction:Add(SEQ(FADE_OUT(1), REMOVE()), arg_61_0.vars.wnd_detail, "block")
	UIAction:Add(SEQ(DELAY(2), SHOW(true), FADE_IN(1)), arg_61_0.vars.wnd, "block")
	
	if get_cocos_refid(arg_61_0.vars.lobby_wnd) then
		UIAction:Add(SEQ(DELAY(2), SHOW(true), FADE_IN(1)), arg_61_0.vars.lobby_wnd, "block")
	end
	
	UIAction:Add(SEQ(DELAY(250), CALL(function()
		SceneManager:getCurrentScene():showLetterBox(true)
	end)), "block")
	set_scene_fps(15)
end

function SubStoryDLCStoryViewPopUp.isPlayedBefore(arg_63_0, arg_63_1, arg_63_2)
	if not arg_63_1 or not arg_63_2 then
		return 
	end
	
	local var_63_0 = Account:getSubStoryStories(arg_63_1)
	
	if not var_63_0 or table.empty(var_63_0) or not var_63_0.clear_count then
		return 
	end
	
	for iter_63_0, iter_63_1 in pairs(var_63_0.clear_count) do
		if iter_63_0 == arg_63_2 then
			return true
		end
	end
end

function SubStoryDLCStoryViewPopUp.onBattle(arg_64_0, arg_64_1)
	if not arg_64_1 or not arg_64_1.npc_team or not arg_64_1.level_enter then
		Log.e("Wrong battle info")
		
		return 
	end
	
	if arg_64_1.is_lock then
		balloon_message_with_sound("Err: locked story")
		
		return 
	end
	
	BattleReady:show({
		enter_id = arg_64_1.level_enter,
		callback = SubStoryDLCStoryViewPopUp
	})
end

function SubStoryDLCStoryViewPopUp.onStartBattle(arg_65_0, arg_65_1)
	if not arg_65_1.npcteam_id then
		return 
	end
	
	Dialog:closeAll()
	print("입장:" .. arg_65_1.enter_id)
	startBattle(arg_65_1.enter_id, arg_65_1)
	BattleReady:hide()
end

function SubStoryDLCStoryViewPopUp.close(arg_66_0)
	if not arg_66_0.vars or not get_cocos_refid(arg_66_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("story_dlc_view_popup")
	arg_66_0.vars.wnd:removeFromParent()
	
	arg_66_0.vars = {}
end

SubStoryDLCManager = {}

function SubStoryDLCManager.setPlayedDLCEffect(arg_67_0, arg_67_1)
	arg_67_0.dlc_effect = arg_67_1
end

function SubStoryDLCManager.isPlayedDLCEffect(arg_68_0)
	return arg_68_0.dlc_effect
end
