EpisodeAdinUI = {}
ADIN_CHAPTER_STATE = {}
ADIN_CHAPTER_STATE.INACTIVE = -1
ADIN_CHAPTER_STATE.ACTIVE = 0
ADIN_CHAPTER_STATE.COMPLETE = 1

local var_0_0 = 560
local var_0_1 = 58

EpisodeAdin = EpisodeAdin or {}

function EpisodeAdin.isAdinCode(arg_1_0, arg_1_1)
	EpisodeAdin.adin_codes = EpisodeAdin.adin_codes or string.split(GAME_CONTENT_VARIABLE.adin_character_id, ";")
	
	for iter_1_0, iter_1_1 in pairs(EpisodeAdin.adin_codes or {}) do
		if iter_1_1 == arg_1_1 then
			return true
		end
	end
	
	return false
end

function HANDLER.adin_base(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		EpisodeAdinUI:closeMissionScroll()
	elseif arg_2_1 == "btn_open" then
		EpisodeAdinUI:openMissionScroll()
	elseif arg_2_1 == "btn_scroll_pass" then
		EpisodeAdinUI:scrollToLeft()
	elseif arg_2_1 == "btn_quest_fold" then
		EpisodeAdinUI:closeMissionScroll()
	end
end

function HANDLER.adin_quest_list_item(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_cshop_go" then
		if arg_3_0.state == EPISODE_MISSION_STATE.ACTIVE then
			if arg_3_0.give_code and arg_3_0.contents_id and arg_3_0.give_count then
				UIUtil:showPresentWnd(arg_3_0.contents_id, CONTENTS_TYPE.EPISODE_MISSION, arg_3_0.give_code, arg_3_0.give_count)
			elseif arg_3_0.btn_move then
				EpisodeAdinUI:close()
				movetoPath(arg_3_0.path)
			end
		elseif arg_3_0.state == EPISODE_MISSION_STATE.CLEAR then
			EpisodeAdinUI:queryCompleteMission(arg_3_0.contents_id)
		end
	end
end

function HANDLER.adin_screen_s_card(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_reward" then
		if arg_4_0.already_receive then
			balloon_message_with_sound("substory_travel_reward_complete")
			
			return 
		else
			EpisodeAdinUI:queryCompleteChapter(arg_4_0.chapter_num)
		end
	elseif arg_4_1 == "btn_quest" then
		EpisodeAdinUI:openMissionScroll()
	elseif arg_4_1 == "btn_quest_open" then
		EpisodeAdinUI:queryActiveChapter(arg_4_0.chapter_id)
		EpisodeAdinUI:stopEffectSound()
	elseif arg_4_1 == "btn_progress_info" then
		local var_4_0 = EpisodeAdinUI:getChapterIndex(arg_4_0.chapter_id)
		
		EpisodeAdinUI:toastProgressInfo(var_4_0)
		EpisodeAdinUI:scrollToChapter(var_4_0)
	end
end

function HANDLER.adin_screen_l_card(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_adin" then
		EpisodeAdinUI:scrollToChapter(arg_5_0.chapter_index)
	end
end

function MsgHandler.adin_mission_complete(arg_6_0)
	if arg_6_0.mission_info and arg_6_0.rewards then
		Account:updateEpisodeMission(arg_6_0.mission_info)
		
		local var_6_0 = {
			title = T("quest_chapter_reward_title"),
			desc = T("awaken_adin_reward_desc")
		}
		
		Account:addReward(arg_6_0.rewards, {
			play_reward_data = var_6_0
		})
		EpisodeAdinUI:onUpdateUI()
	end
end

function MsgHandler.adin_chapter_complete(arg_7_0)
	local var_7_0 = {}
	local var_7_1, var_7_2 = DB("episode_adin", arg_7_0.chapter_info.chapter_id, {
		"reward_type",
		"reward_value"
	})
	
	if var_7_1 == "adin_skill_unlock" then
		Dialog:msgRewards(T("awaken_adin_skill_unlock_complete"), {
			rewards = {
				{
					item = {
						count = 1,
						code = "ma_sample_adin_skill"
					}
				}
			}
		})
	elseif var_7_1 == "adin_change_class" and arg_7_0.unit then
		UnitExtensionUI:openAwakenResult(var_7_2)
		Account:unitAttributeChange(arg_7_0.unit)
		
		if arg_7_0.unit_extension_doc then
			Account:updateUnitExtension(arg_7_0.unit_extension_doc)
		end
	elseif string.starts(var_7_1, "adin_change_") then
		local var_7_3 = string.find(var_7_1, "fire")
		
		UnitExtensionUI:openUnlockResult(var_7_2, {
			tutorial_start = var_7_3
		})
	elseif var_7_1 == "item" and arg_7_0.rewards and table.count(arg_7_0.rewards or {}) > 0 then
		local var_7_4 = {
			title = T("quest_chapter_reward_title"),
			desc = T("awaken_adin_core_reward_desc")
		}
		
		var_7_4.open_effect = true
		
		Account:addReward(arg_7_0.rewards, {
			play_reward_data = var_7_4
		})
	end
	
	if arg_7_0.chapter_info then
		Account:updateAdinChapter(arg_7_0.chapter_info)
		EpisodeAdinUI:onUpdateUI()
	end
end

function MsgHandler.adin_missions_active(arg_8_0)
	if arg_8_0.chapter_info then
		Account:updateAdinChapter(arg_8_0.chapter_info)
		EpisodeAdinUI:onUpdateUI()
		EpisodeAdinUI:openMissionScroll()
		
		local var_8_0 = ConditionContentsManager:getContents(CONTENTS_TYPE.EPISODE_MISSION)
		
		if var_8_0 then
			var_8_0:initConditionListner()
		end
		
		if TutorialGuide:isPlayingTutorial() then
			TutorialGuide:procGuide()
		end
	end
end

function MsgHandler.adin_get(arg_9_0)
	local var_9_0 = Account:addUnit(arg_9_0.adin_unit)
	
	if arg_9_0.updated_collections then
		Account:updateCollectionData(arg_9_0.updated_collections)
	end
	
	CharPreviewController:showAttributeChangeCinematic(var_9_0.db.code, {
		callback = function(arg_10_0)
			if not get_cocos_refid(arg_10_0) then
				if not PRODUCTION_MODE then
					balloon_message_with_sound("nil preview_layer!")
				end
				
				return 
			end
			
			UIAction:Add(SEQ(CALL(function()
				if not EpisodeAdinUI:isShow() then
					WorldMapManager:getController():playBGM()
					EpisodeAdinUI:show()
				end
			end), DELAY(1000), REMOVE()), arg_10_0, "block")
		end
	})
end

copy_functions(ScrollView, EpisodeAdinUI)

function EpisodeAdinUI.show(arg_12_0)
	if not Account:getAdin() and not Account:isAdinOnCollection() then
		arg_12_0:queryGetAdin()
		
		return 
	end
	
	local var_12_0 = load_dlg("adin_base", true, "wnd")
	local var_12_1 = SceneManager:getRunningPopupScene()
	
	arg_12_0.vars = {}
	arg_12_0.vars.wnd = var_12_0
	arg_12_0.vars.chapter_db = arg_12_0:getChapterDB()
	arg_12_0.vars.scrollview = arg_12_0.vars.wnd:getChildByName("scrollview_screen")
	
	arg_12_0.vars.scrollview:addEventListener(function(arg_13_0, arg_13_1)
		arg_12_0:onScrollViewEvent(arg_13_0, arg_13_1)
	end)
	if_set_opacity(var_12_0, "btn_scroll_pass", 0)
	if_set_visible(var_12_0, "btn_scroll_pass", false)
	
	arg_12_0.vars.fade_out = true
	
	arg_12_0:initMissionScrollView()
	arg_12_0:updateChapterScroll()
	
	if not arg_12_0:openMissionScroll() then
		arg_12_0:scrollToChapter(arg_12_0:getLastChapterIndex())
	end
	
	if_set_visible(var_12_0, nil, false)
	UIAction:Add(SEQ(CALL(function()
		SoundEngine:play("event:/effect/awaken_adin_enter_close")
	end), DELAY(250), CALL(function()
		EffectManager:Play({
			fn = "awaken_adin_enter_all.cfx",
			pivot_z = 99998,
			layer = SceneManager:getRunningNativeScene(),
			x = DESIGN_WIDTH / 2,
			y = VIEW_HEIGHT / 2
		})
	end), DELAY(500), FADE_IN(150), CALL(function()
		SoundEngine:play("event:/effect/awaken_adin_enter_open")
	end), DELAY(400), CALL(function()
		if not TutorialGuide:isPlayingTutorial() then
			TutorialGuide:startGuide("tuto_adin_awake_2")
		end
	end)), var_12_0, "block")
	TopBarNew:createFromPopup(T("awaken_adin_title"), arg_12_0.vars.wnd, function()
		arg_12_0:close()
	end, nil, "infoadve1_11", {
		force_unit_top_layer = true
	})
	UIUserData:call(var_12_0:getChildByName("btn_scroll_pass"), "SHAKE(0 , 8 , 600 , true)")
	var_12_1:addChild(var_12_0)
	ConditionContentsManager:adinForceUpdateConditions()
end

function EpisodeAdinUI.getScrollViewItem(arg_19_0, arg_19_1)
	local var_19_0 = load_control("wnd/adin_quest_list_item.csb")
	
	if_set(var_19_0, "txt_title", T(arg_19_1.name))
	if_set(var_19_0, "txt_sub_title", T(arg_19_1.desc))
	
	local var_19_1 = arg_19_1.info or {
		score1 = 0,
		state = EPISODE_MISSION_STATE.ACTIVE
	}
	local var_19_2 = to_n(arg_19_1.value.count)
	local var_19_3 = math.min(var_19_1.score1, var_19_2)
	local var_19_4 = var_19_1.state
	
	if_set(var_19_0, "txt_progress", var_19_3 .. "/" .. var_19_2)
	if_set_percent(var_19_0, "progress", var_19_3 / var_19_2)
	
	local var_19_5 = var_19_0:getChildByName("btn_cshop_go")
	
	if get_cocos_refid(var_19_5) then
		var_19_5.path = arg_19_1.btn_move
		var_19_5.contents_id = arg_19_1.id
		var_19_5.state = var_19_4
		var_19_5.give_code = arg_19_1.give_code
		var_19_5.give_count = arg_19_1.give_count
		var_19_5.btn_move = arg_19_1.btn_move and true or nil
		
		UIUtil:setColorRewardButtonState(var_19_4, var_19_0, var_19_5, {
			add_x_active = 9,
			add_x_clear = 9,
			give = arg_19_1.give_code
		})
		UIUserData:call(var_19_5:getChildByName("btn_label"), "SINGLE_WSCALE(85)", {
			origin_scale_x = 0.38
		})
	end
	
	UIUserData:call(var_19_0:getChildByName("txt_title"), "MULTI_SCALE(2, 30)")
	UIUserData:call(var_19_0:getChildByName("txt_sub_title"), "MULTI_SCALE(2, 30)")
	UIUtil:getRewardIcon(arg_19_1.reward_count1, arg_19_1.reward_id1, {
		parent = var_19_0:getChildByName("n_reward")
	})
	if_set_opacity(var_19_0, nil, var_19_4 == EPISODE_MISSION_STATE.COMPLETE and 102 or 255)
	
	return var_19_0
end

function EpisodeAdinUI.getMissionScrollItems(arg_20_0)
	local var_20_0 = arg_20_0:getActiveChapter()
	local var_20_1 = arg_20_0:getMissionDB(var_20_0.chapter_id)
	
	table.sort(var_20_1, function(arg_21_0, arg_21_1)
		local var_21_0 = arg_21_0.info and (to_n(arg_21_0.info.state) + 1) % 3 or 1
		local var_21_1 = arg_21_1.info and (to_n(arg_21_1.info.state) + 1) % 3 or 1
		
		if var_21_0 == var_21_1 then
			return arg_21_0.sort < arg_21_1.sort
		else
			return var_21_1 < var_21_0
		end
	end)
	
	return var_20_1
end

function EpisodeAdinUI.refreshMissionScrollItems(arg_22_0)
	local var_22_0 = arg_22_0.vars.wnd:getChildByName("RIGHT"):getChildByName("n_quest")
	
	if not arg_22_0:getActiveChapter() then
		var_22_0:setVisible(false)
		
		return 
	end
	
	var_22_0:setVisible(true)
	arg_22_0.vars.mission_scrollview:removeAllChildren()
	arg_22_0:createScrollViewItems(arg_22_0:getMissionScrollItems())
end

function EpisodeAdinUI.initMissionScrollView(arg_23_0)
	arg_23_0.vars.mission_scrollview = arg_23_0.vars.wnd:getChildByName("n_quest_scroll")
	
	arg_23_0:initScrollView(arg_23_0.vars.mission_scrollview, 500, 110)
	
	local var_23_0 = arg_23_0.vars.wnd:getChildByName("RIGHT"):getChildByName("n_quest")
	
	if not arg_23_0:getActiveChapter() then
		var_23_0:setVisible(false)
		
		return 
	end
	
	local var_23_1 = arg_23_0:getMissionScrollItems() or {}
	
	ConditionContentsManager:checkState(CONTENTS_TYPE.EPISODE_MISSION, {
		db_data = var_23_1
	})
	arg_23_0:createScrollViewItems(var_23_1)
end

function EpisodeAdinUI.onScrollViewEvent(arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_0.vars and not get_cocos_refid(arg_24_0.vars.wnd) then
		return 
	end
	
	local var_24_0 = -arg_24_0:getScrollView():getInnerContainerPosition().x
	local var_24_1 = arg_24_0.vars.wnd:getChildByName("btn_scroll_pass")
	
	if math.abs(var_24_0) < 0.01 then
		return 
	end
	
	if get_cocos_refid(var_24_1) then
		if not arg_24_0.vars.fade_out and var_24_0 < var_0_1 then
			arg_24_0.vars.fade_out = true
			
			UIAction:Add(SEQ(FADE_OUT(150), SHOW(false)), var_24_1)
		elseif arg_24_0.vars.fade_out and var_24_0 > var_0_1 and not var_24_1:isVisible() then
			arg_24_0.vars.fade_out = nil
			
			UIAction:Add(SEQ(SHOW(true), FADE_IN(150)), var_24_1)
		end
	end
end

function EpisodeAdinUI.getScrollView(arg_25_0)
	if not arg_25_0.vars and not get_cocos_refid(arg_25_0.vars.wnd) then
		return 
	end
	
	return arg_25_0.vars.scrollview or arg_25_0.vars.wnd:getChildByName("scrollview_screen")
end

function EpisodeAdinUI.getChapterNode(arg_26_0, arg_26_1)
	if not arg_26_0.vars and not get_cocos_refid(arg_26_0.vars.wnd) then
		return 
	end
	
	local var_26_0 = arg_26_0:getScrollView()
	
	if not get_cocos_refid(var_26_0) then
		return 
	end
	
	local var_26_1 = var_26_0:getChildren()
	
	if not var_26_1 then
		return 
	end
	
	local var_26_2 = var_26_1[1]:getChildren()
	
	if arg_26_1 > table.count(var_26_2 or {}) then
		balloon_message_with_sound("최대 병풍 숫자보다 큰 index 입니다.")
		
		return 
	end
	
	return var_26_2[arg_26_1]
end

function EpisodeAdinUI.isShow(arg_27_0)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.vars.wnd) then
		return false
	end
	
	return true
end

function EpisodeAdinUI.getMissionCenterNode(arg_28_0)
	if not arg_28_0.vars and not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	if not arg_28_0.vars.is_open_mission_scroll then
		return 
	end
	
	if arg_28_0.ScrollViewItems then
		local var_28_0 = math.ceil(table.count(arg_28_0.ScrollViewItems) / 2)
		
		if arg_28_0.ScrollViewItems[var_28_0] and get_cocos_refid(arg_28_0.ScrollViewItems[var_28_0].control) then
			return arg_28_0.ScrollViewItems[var_28_0].control
		end
	end
end

function EpisodeAdinUI.getMissionDB(arg_29_0, arg_29_1)
	local var_29_0 = {}
	
	for iter_29_0 = 1, 6 do
		local var_29_1 = DBT("episode_mission", arg_29_0:getMissionID(arg_29_0:getChapterIndex(arg_29_1), iter_29_0), {
			"id",
			"value",
			"name",
			"desc",
			"reward_id1",
			"reward_count1",
			"btn_move",
			"sort",
			"give_code",
			"give_count"
		})
		
		if not var_29_1 or not var_29_1.id then
			break
		end
		
		var_29_1.value = totable(var_29_1.value)
		var_29_1.info = Account:getEpisodeMissionByID(var_29_1.id)
		
		table.push(var_29_0, var_29_1)
	end
	
	return var_29_0
end

function EpisodeAdinUI.getChapterDB(arg_30_0)
	local var_30_0 = {}
	
	for iter_30_0 = 1, 12 do
		local var_30_1 = DBT("episode_adin", arg_30_0:getChapterID(iter_30_0), {
			"id",
			"sort",
			"background",
			"reward_name",
			"reward_type",
			"reward_value",
			"reward_count",
			"open",
			"unlock",
			"chapter_id",
			"mission_unlock",
			"mission_progress"
		})
		
		if not var_30_1 then
			break
		end
		
		local var_30_2 = to_n(var_30_1.sort)
		
		if var_30_1.mission_progress then
			var_30_1.mission_progress = string.split(var_30_1.mission_progress, ",")
		end
		
		if var_30_1.chapter_id then
			var_30_1.name = DB("level_world_2_continent", var_30_1.chapter_id, {
				"name"
			})
		end
		
		var_30_0[var_30_2] = var_30_1
	end
	
	return var_30_0
end

function EpisodeAdinUI.onUpdateUI(arg_31_0, arg_31_1)
	if not arg_31_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_31_0.vars.wnd) then
		return 
	end
	
	arg_31_0:updateChapterScroll(arg_31_1)
	arg_31_0:refreshMissionScrollItems()
end

function EpisodeAdinUI.stopEffectSound(arg_32_0)
	if not arg_32_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_32_0.vars.effect_line) and arg_32_0.vars.effect_line.sd then
		arg_32_0.vars.effect_line.sd:stop()
	end
	
	if get_cocos_refid(arg_32_0.vars.effect_particle) and arg_32_0.vars.effect_particle.sd then
		arg_32_0.vars.effect_particle.sd:stop()
	end
	
	if get_cocos_refid(arg_32_0.vars.effect_adin_attribute) and arg_32_0.vars.effect_adin_attribute.sd then
		arg_32_0.vars.effect_adin_attribute.sd:stop()
	end
	
	if get_cocos_refid(arg_32_0.vars.effect_core_particle) and arg_32_0.vars.effect_core_particle.sd then
		arg_32_0.vars.effect_core_particle.sd:stop()
	end
end

function EpisodeAdinUI.initLongBackBoard(arg_33_0, arg_33_1, arg_33_2)
	arg_33_2 = arg_33_2 or {}
	
	local var_33_0 = {}
	
	for iter_33_0, iter_33_1 in pairs(string.split(GAME_CONTENT_VARIABLE.adin_character_id, ";")) do
		local var_33_1, var_33_2, var_33_3 = DB("character_attribute_change", iter_33_1, {
			"skill_tree",
			"attr_change_unlock_value",
			"sort"
		})
		
		if var_33_3 then
			var_33_0[var_33_3] = {
				id = iter_33_1,
				attribute = var_33_1,
				chapter = arg_33_0:getChapterIndex(var_33_2),
				face_id = DB("character", iter_33_1, {
					"face_id"
				})
			}
		end
	end
	
	if type(arg_33_1) == "string" then
		for iter_33_2, iter_33_3 in pairs(var_33_0) do
			if iter_33_3.id == arg_33_1 then
				arg_33_1 = iter_33_3
				
				break
			end
		end
	end
	
	local var_33_4 = {
		wind = cc.c3b(6, 89, 0),
		fire = cc.c3b(113, 0, 0),
		ice = cc.c3b(0, 80, 162),
		light = cc.c3b(159, 94, 0)
	}
	local var_33_5 = load_control("wnd/adin_screen_l_card.csb")
	local var_33_6 = DB("character_attribute_change", arg_33_1.id, "background")
	
	if_set_sprite(var_33_5, "bg", "img/" .. var_33_6)
	
	local var_33_7 = var_33_5:getChildByName("n_" .. arg_33_1.attribute)
	local var_33_8, var_33_9 = UIUtil:getPortraitAni(arg_33_1.id, {
		parent_pos_y = var_33_7:getPositionY(),
		parent_pos_x = var_33_7:getPositionX()
	})
	
	if var_33_8 then
		var_33_7:removeAllChildren()
		var_33_7:addChild(var_33_8)
		
		if not var_33_9 then
			var_33_8:setAnchorPoint(0.5, 0.15)
		end
		
		var_33_8:setScale(0.8)
	end
	
	local var_33_10 = var_33_5:getChildByName("n_bottom")
	
	if_set_color(var_33_10, "n_port_grow", var_33_4[arg_33_1.attribute])
	if_set_color(var_33_5, "n_port_grow", var_33_4[arg_33_1.attribute])
	if_set_sprite(var_33_10, "n_face_l", "face/" .. arg_33_1.face_id .. "_l.png")
	if_set_sprite(var_33_5, "n_properties", "img/cm_icon_pro" .. arg_33_1.attribute .. ".png")
	if_set(var_33_5, "txt_info", T("hero_ele_" .. arg_33_1.attribute))
	if_set_cascade_opacity(var_33_5, nil, true)
	
	for iter_33_4, iter_33_5 in pairs(var_33_5:getChildren() or {}) do
		if_set_cascade_opacity(iter_33_5, nil, true)
	end
	
	if arg_33_2.invisible_info then
		if_set_visible(var_33_5, "n_bottom", false)
		if_set_visible(var_33_5, "n_info", false)
	end
	
	return var_33_5
end

function EpisodeAdinUI.updateChapterScroll(arg_34_0, arg_34_1)
	if not arg_34_0.vars or not get_cocos_refid(arg_34_0.vars.wnd) then
		return 
	end
	
	local var_34_0 = arg_34_0:getScrollView()
	
	if not get_cocos_refid(var_34_0) then
		return 
	end
	
	arg_34_1 = arg_34_1 or {}
	
	var_34_0:removeAllChildren()
	
	local var_34_1 = {}
	
	for iter_34_0, iter_34_1 in pairs(string.split(GAME_CONTENT_VARIABLE.adin_character_id, ";")) do
		local var_34_2, var_34_3, var_34_4 = DB("character_attribute_change", iter_34_1, {
			"skill_tree",
			"attr_change_unlock_value",
			"sort"
		})
		
		if var_34_4 then
			var_34_1[var_34_4] = {
				id = iter_34_1,
				attribute = var_34_2,
				chapter = arg_34_0:getChapterIndex(var_34_3),
				face_id = DB("character", iter_34_1, {
					"face_id"
				})
			}
		end
	end
	
	local var_34_5 = {
		wind = cc.c3b(6, 89, 0),
		fire = cc.c3b(113, 0, 0),
		ice = cc.c3b(0, 80, 162),
		light = cc.c3b(159, 94, 0)
	}
	local var_34_6 = ccui.Layout:create()
	
	var_34_6:setContentSize(0, var_34_0:getContentSize().height)
	var_34_6:setLayoutType(ccui.LayoutType.HORIZONTAL)
	var_34_6:setAutoSizeEnabled(true)
	var_34_6:setCascadeOpacityEnabled(true)
	var_34_6:setName("@layout")
	
	local function var_34_7(arg_35_0)
		local var_35_0 = Account:getAdin() or {
			inst = {}
		}
		
		EpisodeAdinUI.vars.character_popup = UIUtil:getCharacterPopup({
			show_adin_ui = true,
			code = arg_35_0,
			lv = var_35_0.inst.lv,
			grade = var_35_0.inst.grade,
			z = var_35_0.inst.zodiac,
			devote = var_35_0.inst.devote
		})
		
		return EpisodeAdinUI.vars.character_popup
	end
	
	local var_34_8 = 1
	local var_34_9 = 1
	local var_34_10 = {}
	
	for iter_34_2 = 1, #var_34_1 do
		if UnitExtension:isAttributeUnlocked(var_34_1[iter_34_2].id) then
			local var_34_11 = arg_34_0:initLongBackBoard(var_34_1[iter_34_2])
			local var_34_12 = var_34_11:getChildByName("btn_adin")
			
			if get_cocos_refid(var_34_12) then
				WidgetUtils:setupPopup({
					force_enable = true,
					control = var_34_12,
					creator = function()
						local var_36_0
						
						if TutorialGuide:isPlayingTutorial() then
							if get_cocos_refid(EpisodeAdinUI:getChapterNode(2):getChildByName("btn_adin")) == get_cocos_refid(var_34_11:getChildByName("btn_adin")) then
								var_36_0 = var_34_7(var_34_1[iter_34_2].id)
							end
						else
							var_36_0 = var_34_7(var_34_1[iter_34_2].id)
						end
						
						if var_36_0 then
							local var_36_1 = TutorialGuide:isPlayingTutorial() and TutorialGuide.vars.started_guide_id == "tuto_adin_awake_3"
							
							UIAction:Add(SEQ(DELAY(var_36_1 and TutorialGuide.vars.cur_guide.delay or 0), CALL(function()
								if TutorialGuide:isPlayingTutorial() then
									TutorialGuide:procGuide()
								end
							end)), var_36_0, "block")
						end
						
						return var_36_0
					end
				})
				
				var_34_12.chapter_index = var_34_1[iter_34_2].chapter
			end
			
			if arg_34_1.first_get_adin_type and var_34_1[iter_34_2].id == arg_34_1.first_get_adin_type and not arg_34_0.vars.effect_adin_attribute then
				arg_34_0.vars.effect_adin_attribute = EffectManager:Play({
					scale = 0.8,
					fn = "adin_effect_attribute_particle.cfx",
					y = 360,
					x = 160,
					layer = var_34_11
				})
			end
			
			var_34_6:addChild(var_34_11)
			
			for iter_34_3 = var_34_8, var_34_1[iter_34_2].chapter do
				table.insert(var_34_10, iter_34_3, var_34_11)
			end
			
			var_34_8 = var_34_1[iter_34_2].chapter + 1
		else
			var_34_9 = iter_34_2
			
			break
		end
	end
	
	local var_34_13 = arg_34_0.vars.chapter_db
	
	for iter_34_4 = var_34_8, #var_34_13 do
		local var_34_14 = Account:getAdinChapterByID(var_34_13[iter_34_4].id) or {
			state = ADIN_CHAPTER_STATE.INACTIVE
		}
		local var_34_15 = load_control("wnd/adin_screen_s_card.csb")
		
		if_set_visible(var_34_15, "n_quest", var_34_14.state == ADIN_CHAPTER_STATE.ACTIVE)
		if_set_visible(var_34_15, "icon_check", var_34_14.state == ADIN_CHAPTER_STATE.COMPLETE)
		if_set_visible(var_34_15, "n_stage_lock", var_34_14.state == ADIN_CHAPTER_STATE.INACTIVE)
		if_set_visible(var_34_15, "n_forward", var_34_14.state == ADIN_CHAPTER_STATE.INACTIVE)
		if_set_visible(var_34_15, "n_unlock", false)
		if_set_visible(var_34_15, "btn_reward", false)
		if_set_sprite(var_34_15, "bg", "img/" .. var_34_13[iter_34_4].background .. ".png")
		
		local var_34_16 = var_34_15:getChildByName("n_info")
		
		if get_cocos_refid(var_34_16) then
			local var_34_17 = string.split(T(var_34_13[iter_34_4].name), ".")
			
			if_set(var_34_16, "txt_chapter", T("awaken_adin_corereward_name", {
				chapter = var_34_17[1]
			}))
			if_set(var_34_16, "txt_zone", T(var_34_13[iter_34_4].reward_name))
			var_34_16:setColor(var_34_14.state == ADIN_CHAPTER_STATE.ACTIVE and cc.c3b(255, 255, 255) or cc.c3b(98, 98, 98))
			UIUtil:getRewardIcon(var_34_13[iter_34_4].reward_count, var_34_13[iter_34_4].reward_value, {
				parent = var_34_16:getChildByName("n_mob")
			})
		end
		
		if var_34_14.state == ADIN_CHAPTER_STATE.INACTIVE then
			if arg_34_0:isChapterUnlocked(var_34_13[iter_34_4].id) then
				if_set_visible(var_34_15, "n_unlock", true)
				if_set_visible(var_34_15, "btn_progress_info", false)
				
				local var_34_18 = var_34_15:getChildByName("btn_quest_open")
				
				if not arg_34_0.vars.effect_line and not arg_34_0.vars.effect_particle then
					arg_34_0.vars.effect_line = EffectManager:Play({
						check_loop_sound = true,
						z = 1,
						fn = "adin_effect_mission_line.cfx",
						y = 0,
						x = 0,
						layer = var_34_15:getChildByName("n_eff_1")
					})
					arg_34_0.vars.effect_particle = EffectManager:Play({
						check_loop_sound = true,
						z = 1,
						fn = "adin_effect_mission_particle.cfx",
						y = 0,
						x = 0,
						layer = var_34_15:getChildByName("n_eff_0")
					})
				end
				
				if get_cocos_refid(var_34_18) then
					var_34_18.chapter_id = var_34_13[iter_34_4].id
				end
			end
			
			if_set_percent(var_34_15, "n_progress", 1 - arg_34_0:getChapterClearRate(iter_34_4))
			
			local var_34_19 = var_34_15:getChildByName("btn_progress_info")
			
			if get_cocos_refid(var_34_19) then
				var_34_19.chapter_id = var_34_13[iter_34_4].id
			end
		elseif var_34_14.state == ADIN_CHAPTER_STATE.ACTIVE then
			if arg_34_0:isChapterCleared() then
				if_set_visible(var_34_15, "n_eff_a", true)
				
				if not arg_34_0.vars.effect_core_particle then
					arg_34_0.vars.effect_core_particle = EffectManager:Play({
						z = 1,
						fn = "adin_effect_core_particle.cfx",
						y = 0,
						x = 0,
						layer = var_34_15:getChildByName("n_eff_a")
					})
				end
				
				local var_34_20 = var_34_15:getChildByName("btn_reward")
				
				if get_cocos_refid(var_34_20) then
					var_34_20:setVisible(true)
					
					var_34_20.chapter_num = iter_34_4
				end
			end
		elseif var_34_14.state == ADIN_CHAPTER_STATE.COMPLETE and arg_34_0:isChapterCleared(iter_34_4) then
			local var_34_21 = var_34_15:getChildByName("btn_reward")
			
			if get_cocos_refid(var_34_21) then
				var_34_21:setVisible(true)
				
				var_34_21.chapter_num = iter_34_4
				var_34_21.already_receive = true
			end
		end
		
		local var_34_22 = var_34_1[var_34_9]
		
		if var_34_22 and var_34_22.chapter == iter_34_4 then
			local var_34_23 = var_34_15:getChildByName("btn_adin")
			
			if get_cocos_refid(var_34_23) then
				var_34_23:setVisible(true)
				
				arg_34_0.vars.character_popup = WidgetUtils:setupPopup({
					control = var_34_23,
					creator = function()
						return var_34_7(var_34_22.id)
					end
				})
			end
			
			var_34_9 = var_34_9 + 1
		end
		
		table.insert(var_34_10, iter_34_4, var_34_15)
		var_34_6:addChild(var_34_15)
	end
	
	var_34_6:forceDoLayout()
	var_34_0:addChild(var_34_6)
	var_34_0:setScrollBarEnabled(false)
	
	if var_34_8 > #var_34_13 then
		local var_34_24 = var_34_0:getContentSize().width - var_34_6:getContentSize().width
		
		var_34_0:setPositionX((DESIGN_WIDTH + var_34_24) / 2)
		var_34_0:setBounceEnabled(false)
		if_set_visible(arg_34_0.vars.wnd, "btn_scroll_pass", false)
	end
	
	arg_34_0.vars.ui = var_34_10
	arg_34_0.vars.scrollview = var_34_0
	arg_34_0.vars.layout = var_34_6
	
	arg_34_0:updateScrollMargin()
end

function EpisodeAdinUI.updateScrollMargin(arg_39_0)
	if not arg_39_0.vars or not get_cocos_refid(arg_39_0.vars.wnd) then
		return 
	end
	
	local var_39_0 = arg_39_0:getScrollView()
	
	if not get_cocos_refid(var_39_0) then
		return 
	end
	
	local var_39_1 = arg_39_0.vars.layout or var_39_0:getChildByName("@layout")
	
	if not get_cocos_refid(var_39_1) then
		return 
	end
	
	local var_39_2 = -var_39_0:getInnerContainerPosition().x
	local var_39_3 = arg_39_0:getActiveChapter() and arg_39_0:getMissionScrollWidth() or 0
	
	var_39_0:setInnerContainerSize({
		height = 0,
		width = var_39_1:getContentSize().width + var_39_3
	})
	
	local var_39_4 = var_39_0:getInnerContainerSize().width - var_39_0:getContentSize().width
	
	if var_39_4 > 0 then
		local var_39_5 = var_39_2 / var_39_4
		
		var_39_0:jumpToPercentHorizontal(var_39_5 * 100)
	end
end

function EpisodeAdinUI.scrollToLeft(arg_40_0)
	if not arg_40_0.vars or not get_cocos_refid(arg_40_0.vars.wnd) then
		return 
	end
	
	local var_40_0 = arg_40_0:getScrollView()
	
	if not get_cocos_refid(var_40_0) then
		return 
	end
	
	var_40_0:scrollToLeft(1, true)
	var_40_0:setTouchEnabled(false)
	UIAction:Add(SEQ(DELAY(500), CALL(function()
		var_40_0:setTouchEnabled(true)
	end)), var_40_0, "block")
end

function EpisodeAdinUI.scrollToChapter(arg_42_0, arg_42_1)
	if not arg_42_0.vars or not get_cocos_refid(arg_42_0.vars.wnd) then
		return 
	end
	
	if not arg_42_1 then
		return 
	end
	
	local var_42_0 = arg_42_0:getScrollView()
	
	if not get_cocos_refid(var_42_0) or not arg_42_0.vars.ui then
		return 
	end
	
	local var_42_1 = arg_42_0.vars.ui[arg_42_1] or arg_42_0.vars.ui[1]
	local var_42_2 = var_42_1:getPositionX() + var_42_1:getContentSize().width
	
	if var_42_2 < DESIGN_WIDTH - var_0_0 then
		var_42_0:scrollToPercentHorizontal(0, 1, true)
	else
		local var_42_3 = var_42_0:getInnerContainerSize().width - var_42_0:getContentSize().width
		
		if var_42_3 > 0 then
			local var_42_4 = math.min((var_42_2 - DESIGN_WIDTH + var_0_0) / var_42_3, 1)
			
			var_42_0:scrollToPercentHorizontal(var_42_4 * 100, 1, true)
		end
	end
	
	var_42_0:setTouchEnabled(false)
	UIAction:Add(SEQ(DELAY(200), CALL(function()
		var_42_0:setTouchEnabled(true)
	end)), var_42_0, "block")
end

function EpisodeAdinUI.openMissionScroll(arg_44_0)
	if not arg_44_0.vars or not get_cocos_refid(arg_44_0.vars.wnd) then
		return 
	end
	
	if not arg_44_0:getActiveChapter() then
		return 
	end
	
	local var_44_0 = arg_44_0.vars.wnd:getChildByName("n_land")
	
	if get_cocos_refid(var_44_0) then
		local var_44_1 = arg_44_0:getActiveChapter()
		
		if var_44_1 then
			local var_44_2 = string.split(T(arg_44_0.vars.chapter_db[arg_44_0:getChapterIndex(var_44_1.chapter_id)].name), ".")
			
			if_set(var_44_0, "txt_number", var_44_2[1])
		end
	end
	
	local var_44_3 = arg_44_0.vars.wnd:getChildByName("n_quest_open")
	local var_44_4 = arg_44_0.vars.wnd:getChildByName("RIGHT")
	local var_44_5 = var_44_4:getChildByName("n_quest")
	
	SoundEngine:play("event:/effect/adin_se_mission_open")
	UIAction:Add(SEQ(RLOG(MOVE_TO(150, var_44_3:getPositionX()))), var_44_5, "block")
	if_set_visible(var_44_4, "btn_close", true)
	if_set_visible(var_44_4, "btn_open", false)
	if_set_visible(arg_44_0.vars.wnd, "btn_quest_fold", true)
	
	arg_44_0.vars.is_open_mission_scroll = true
	
	arg_44_0:updateScrollMargin()
	arg_44_0:scrollToChapter(arg_44_0:getLastChapterIndex())
	
	return true
end

function EpisodeAdinUI.closeMissionScroll(arg_45_0)
	if not arg_45_0.vars or not get_cocos_refid(arg_45_0.vars.wnd) then
		return 
	end
	
	local var_45_0 = arg_45_0.vars.wnd:getChildByName("n_quest_fold")
	local var_45_1 = arg_45_0.vars.wnd:getChildByName("RIGHT")
	local var_45_2 = var_45_1:getChildByName("n_quest")
	
	SoundEngine:play("event:/effect/adin_se_mission_close")
	UIAction:Add(SEQ(RLOG(MOVE_TO(150, var_45_0:getPositionX()))), var_45_2, "block")
	if_set_visible(var_45_1, "btn_close", false)
	if_set_visible(var_45_1, "btn_open", true)
	if_set_visible(arg_45_0.vars.wnd, "btn_quest_fold", false)
	
	arg_45_0.vars.is_open_mission_scroll = false
	
	arg_45_0:updateScrollMargin()
end

function EpisodeAdinUI.getMissionScrollWidth(arg_46_0)
	return arg_46_0.vars.is_open_mission_scroll and var_0_0 or var_0_1
end

function EpisodeAdinUI.toastProgressInfo(arg_47_0, arg_47_1)
	if not arg_47_0.vars or not get_cocos_refid(arg_47_0.vars.wnd) then
		return 
	end
	
	local var_47_0 = arg_47_0.vars.chapter_db[arg_47_1]
	
	if not var_47_0 then
		return 
	end
	
	if var_47_0.open == "y" then
		local var_47_1 = var_47_0.name
		
		if var_47_1 then
			local var_47_2 = arg_47_1 - 1 > 0 and arg_47_1 - 1 or 1
			local var_47_3 = arg_47_0:getChapterClearRate(arg_47_1) == 1
			local var_47_4 = arg_47_0:getChapterClearRate(var_47_2) == 1
			local var_47_5 = arg_47_0.vars.chapter_db[var_47_2]
			local var_47_6 = Account:getAdinChapterByID(var_47_5.id) and .state == ADIN_CHAPTER_STATE.COMPLETE
			
			if var_47_4 and var_47_3 and not var_47_6 then
				balloon_message_with_sound("awaken_adin_screen_unlock_ready")
			else
				balloon_message_with_sound("awaken_adin_screen_unlock_condition", {
					chapter = T(var_47_1)
				})
			end
		else
			balloon_message_with_sound("awaken_adin_update_soon")
		end
	else
		balloon_message_with_sound("awaken_adin_update_soon")
	end
end

function EpisodeAdinUI.getActiveChapter(arg_48_0)
	local var_48_0 = Account:getAdinChapters() or {}
	
	for iter_48_0, iter_48_1 in pairs(var_48_0) do
		if iter_48_1.state == ADIN_CHAPTER_STATE.ACTIVE then
			return iter_48_1
		end
	end
	
	return nil
end

function EpisodeAdinUI.getLastChapterIndex(arg_49_0)
	local var_49_0 = 0
	local var_49_1 = arg_49_0.vars.chapter_db
	local var_49_2 = Account:getAdinChapters() or {}
	
	for iter_49_0, iter_49_1 in pairs(var_49_2) do
		if iter_49_1.state == ADIN_CHAPTER_STATE.ACTIVE then
			return arg_49_0:getChapterIndex(iter_49_1.chapter_id)
		elseif iter_49_1.state == ADIN_CHAPTER_STATE.COMPLETE then
			local var_49_3 = arg_49_0:getChapterIndex(iter_49_1.chapter_id) + 1
			
			if var_49_1[var_49_3] and var_49_1[var_49_3].open then
				var_49_0 = math.max(var_49_0, var_49_3)
			else
				var_49_0 = math.max(var_49_0, var_49_3 - 1)
			end
		end
	end
	
	return var_49_0
end

function EpisodeAdinUI.isChapterCleared(arg_50_0, arg_50_1)
	arg_50_1 = arg_50_1 or arg_50_0:getActiveChapter()
	
	if not arg_50_1 then
		return 
	end
	
	if type(arg_50_1) == "table" then
		if arg_50_1.state ~= ADIN_CHAPTER_STATE.ACTIVE then
			return 
		end
		
		arg_50_1 = arg_50_1.chapter_id
	end
	
	local var_50_0 = arg_50_0:getMissionDB(arg_50_1)
	
	for iter_50_0, iter_50_1 in pairs(var_50_0) do
		local var_50_1 = Account:getEpisodeMissionByID(iter_50_1.id)
		
		if not var_50_1 then
			return false
		end
		
		if var_50_1.state < EPISODE_MISSION_STATE.COMPLETE then
			return false
		end
	end
	
	return true
end

function EpisodeAdinUI.getReceivableRewards(arg_51_0)
	local var_51_0 = arg_51_0:getActiveChapter()
	
	if not var_51_0 then
		return 
	end
	
	local var_51_1 = arg_51_0:getMissionDB(var_51_0.chapter_id)
	local var_51_2
	
	for iter_51_0, iter_51_1 in pairs(var_51_1) do
		local var_51_3 = Account:getEpisodeMissionByID(iter_51_1.id)
		
		if var_51_3 and var_51_3.state == EPISODE_MISSION_STATE.CLEAR then
			var_51_2 = var_51_2 or {}
			
			table.push(var_51_2, iter_51_1.reward_id1)
		end
	end
	
	return var_51_2
end

function EpisodeAdinUI.isChapterAvailable(arg_52_0)
	local var_52_0 = Account:getAdinChapters() or {}
	local var_52_1 = 1
	
	for iter_52_0, iter_52_1 in pairs(var_52_0) do
		if iter_52_1.state == ADIN_CHAPTER_STATE.COMPLETE then
			var_52_1 = var_52_1 + 1
		elseif iter_52_1.state == ADIN_CHAPTER_STATE.ACTIVE then
			return false
		end
	end
	
	return arg_52_0:isChapterUnlocked(arg_52_0:getChapterID(var_52_1))
end

function EpisodeAdinUI.isChapterUnlocked(arg_53_0, arg_53_1)
	local var_53_0, var_53_1, var_53_2 = DB("episode_adin", arg_53_1, {
		"open",
		"unlock",
		"mission_unlock"
	})
	
	return var_53_0 == "y" and arg_53_0:isMapCleared(var_53_2) and arg_53_0:isChapterCompleted(var_53_1)
end

function EpisodeAdinUI.isMapCleared(arg_54_0, arg_54_1)
	if not arg_54_1 then
		return true
	end
	
	return Account:isMapCleared(arg_54_1)
end

function EpisodeAdinUI.isChapterCompleted(arg_55_0, arg_55_1)
	if not arg_55_1 then
		return true
	end
	
	local var_55_0 = Account:getAdinChapterByID(arg_55_1)
	
	return var_55_0 and var_55_0.state == ADIN_CHAPTER_STATE.COMPLETE
end

function EpisodeAdinUI.getChapterClearRate(arg_56_0, arg_56_1)
	local var_56_0 = arg_56_0.vars.chapter_db[arg_56_1] or {}
	
	if var_56_0.mission_progress and #var_56_0.mission_progress > 0 then
		local var_56_1 = 0
		
		for iter_56_0, iter_56_1 in pairs(var_56_0.mission_progress) do
			if Account:isMapCleared(iter_56_1) then
				var_56_1 = var_56_1 + 1
			end
		end
		
		return var_56_1 / #var_56_0.mission_progress
	else
		return 1
	end
end

function EpisodeAdinUI.getChapterID(arg_57_0, arg_57_1)
	return "adin_main_" .. arg_57_1
end

function EpisodeAdinUI.getChapterIndex(arg_58_0, arg_58_1)
	return to_n(string.sub(arg_58_1, 11, -1))
end

function EpisodeAdinUI.getMissionID(arg_59_0, arg_59_1, arg_59_2)
	return "adin_mission_" .. arg_59_1 .. "_" .. arg_59_2
end

function EpisodeAdinUI.queryGetAdin(arg_60_0)
	query("adin_get")
end

function EpisodeAdinUI.queryCompleteMission(arg_61_0, arg_61_1)
	query("adin_mission_complete", {
		mission_id = arg_61_1
	})
end

function EpisodeAdinUI.queryCompleteChapter(arg_62_0, arg_62_1)
	if not arg_62_0.vars then
		return 
	end
	
	local var_62_0 = arg_62_0.vars.chapter_db[arg_62_1]
	
	if not var_62_0 then
		return 
	end
	
	if var_62_0.reward_type == "adin_change_class" then
		local var_62_1 = Account:getAdin()
		
		if not var_62_1 then
			return 
		end
		
		if BackPlayManager:isRunning() and BackPlayManager:isInBackPlayTeam(var_62_1:getUID()) then
			balloon_message_with_sound("msg_bgbattle_cant_classchange")
			
			return 
		end
		
		query("adin_chapter_complete", {
			chapter_id = var_62_0.id,
			unit_id = var_62_1.inst.uid
		})
	else
		query("adin_chapter_complete", {
			chapter_id = var_62_0.id
		})
	end
	
	EpisodeAdinUI:stopEffectSound()
end

function EpisodeAdinUI.queryActiveChapter(arg_63_0, arg_63_1)
	query("adin_missions_active", {
		chapter_id = arg_63_1
	})
end

function EpisodeAdinUI.closeCharacterPopUp(arg_64_0)
	if not arg_64_0:isShowCharacterPopUp() then
		return 
	end
	
	arg_64_0.vars.character_popup:removeFromParent()
	
	arg_64_0.vars.character_popup = nil
	
	BackButtonManager:pop()
	
	return true
end

function EpisodeAdinUI.isShowCharacterPopUp(arg_65_0)
	if not arg_65_0.vars then
		return 
	end
	
	return get_cocos_refid(arg_65_0.vars.character_popup)
end

function EpisodeAdinUI.updateDevoteStat(arg_66_0, arg_66_1)
	if not arg_66_0.vars then
		return 
	end
	
	if arg_66_0.vars and not get_cocos_refid(arg_66_0.vars.character_popup) or not arg_66_1 then
		return 
	end
	
	local var_66_0 = arg_66_0.vars.character_popup
	
	UIUtil:setDevoteDetail_new(var_66_0, arg_66_1, {
		target = "n_dedi"
	})
	UIUtil:setUnitAllInfo(arg_66_0.vars.wnd, arg_66_1)
end

function EpisodeAdinUI.close(arg_67_0)
	if not arg_67_0.vars or not get_cocos_refid(arg_67_0.vars.wnd) then
		return 
	end
	
	Dialog:close("destiny_present")
	UIAction:Add(SEQ(FADE_OUT(300), CALL(function()
		if not arg_67_0.vars then
			return 
		end
		
		arg_67_0:stopEffectSound()
		
		if arg_67_0.vars and get_cocos_refid(arg_67_0.vars.wnd) then
			arg_67_0.vars.wnd:removeFromParent()
		end
		
		arg_67_0.vars.wnd = nil
		arg_67_0.vars = nil
		
		BackButtonManager:pop("TopBarNew." .. T("awaken_adin_title"))
		TopBarNew:pop()
		
		if SceneManager:getCurrentSceneName() == "worldmap_scene" then
			local var_68_0 = WorldMapManager:getWorldMapUI()
			
			if var_68_0 then
				var_68_0:updateCustomUI()
				
				local var_68_1 = var_68_0.controller:getContinentID()
				
				TopBarNew:setTitleName(T(DB("level_world_2_continent", var_68_1, "name")), "infoadve1")
			end
		end
	end)), arg_67_0.vars.wnd, "block")
end
