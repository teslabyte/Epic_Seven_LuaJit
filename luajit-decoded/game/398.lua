SubStoryInferenceNote = {}
SubStoryCluePage = {}

function HANDLER.battle_story_valentine_case_notebook_popup(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_arrow_r" then
		SubStoryInferenceNote:MoveMission(true)
	elseif arg_1_1 == "btn_arrow_l" then
		SubStoryInferenceNote:MoveMission(false)
	elseif string.starts(arg_1_1, "btn_on_book") or string.starts(arg_1_1, "btn_off_book") then
		SubStoryInferenceNote:selectInference(tonumber(string.sub(arg_1_1, -1, -1)))
	elseif arg_1_1 == "btn_obtained_clues" then
		SubStoryInferenceNote:openCluePage()
	elseif arg_1_1 == "btn_move" and arg_1_0.path then
		SubStoryInferenceNote:moveTo(arg_1_0.path)
	elseif arg_1_1 == "btn_give" then
		UIUtil:showPresentWnd(arg_1_0.contents_id, CONTENTS_TYPE.SUBSTORY_CUSTOM_MISSION, arg_1_0.give_code, arg_1_0.give_count)
	elseif arg_1_1 == "btn_get" then
		SubStoryInferenceNote:req_clearMission()
	elseif string.starts(arg_1_1, "btn_off_chapter") and arg_1_0.chapter_id then
		SubStoryInferenceNote:onSelectChapter(arg_1_0.chapter_id)
	elseif arg_1_1 == "btn_close" then
		SubStoryInferenceNote:close()
	end
end

function HANDLER.battle_story_valentine_event_clue_popup(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" then
		SubStoryCluePage:close()
	end
end

local var_0_0 = false

function _isUserClueEmpty(arg_3_0)
	if not arg_3_0 then
		return 
	end
	
	if var_0_0 then
		return false
	end
	
	local var_3_0 = "incl_" .. arg_3_0 .. "_1"
	local var_3_1, var_3_2 = DB("substory_inference_3_clue", var_3_0, {
		"id",
		"unlock_custom_mission_id"
	})
	
	if not var_3_1 or not var_3_2 then
		return true
	end
	
	if var_3_1 and var_3_2 and not SubStoryCustomMission:isRewarded(var_3_2) then
		return true
	end
	
	return false
end

function SubStoryInferenceNote.show(arg_4_0, arg_4_1, arg_4_2)
	if not arg_4_1 then
		return 
	end
	
	local var_4_0 = SubstoryManager:getInfo()
	
	if not var_4_0 then
		return 
	end
	
	if not DB("substory_inference_1_note", arg_4_1, {
		"id"
	}) then
		Log.e("Err: Wrong Note id: ", arg_4_1)
		
		return 
	end
	
	local var_4_1 = DB("substory_inference_1_note", arg_4_1, {
		"enter_btn_unlock_stage",
		"name"
	})
	
	if var_4_1 and not Account:checkEnterMap(var_4_1) then
		local var_4_2 = DB("level_enter", var_4_1, {
			"name"
		}) or ""
		
		balloon_message_with_sound_raw_text(T_KR("msg_locked_inference_note", {
			stage_name = T(var_4_2)
		}))
		
		return 
	end
	
	if arg_4_0.vars and get_cocos_refid(arg_4_0.vars.wnd) then
		return 
	end
	
	local var_4_3 = arg_4_2 or {}
	
	arg_4_0.vars = {}
	arg_4_0.vars.wnd = load_dlg("battle_story_valentine_case_notebook_popup", false, "wnd", function()
		SubStoryInferenceNote:close()
	end)
	
	;(var_4_3.parent_layer or SceneManager:getRunningPopupScene()):addChild(arg_4_0.vars.wnd)
	
	arg_4_0.vars.substory_id = var_4_0.id
	arg_4_0.vars.note_id = arg_4_1
	
	arg_4_0:updateData()
	arg_4_0:initUI()
	arg_4_0:updateUI()
	TutorialGuide:procGuide()
	SubstoryManager:updateNotifierContentsUI()
end

function SubStoryInferenceNote.updateData(arg_6_0)
	arg_6_0.vars.data = {}
	
	local var_6_0 = true
	local var_6_1 = true
	local var_6_2 = 1
	local var_6_3 = 1
	local var_6_4 = 1
	
	for iter_6_0 = 1, 9999999 do
		local var_6_5, var_6_6, var_6_7, var_6_8, var_6_9, var_6_10, var_6_11 = DBN("substory_inference_2_case", iter_6_0, {
			"id",
			"note_id",
			"btn_txt",
			"case_title",
			"custom_mission_id",
			"clue_id",
			"unlock_stage"
		})
		
		if not var_6_5 or not var_6_6 then
			break
		end
		
		if var_6_6 == arg_6_0.vars.note_id then
			local var_6_12 = 1
			local var_6_13 = {}
			local var_6_14 = {}
			local var_6_15 = string.split(var_6_9, ",")
			local var_6_16 = table.count(var_6_15)
			local var_6_17 = table.count(var_6_15) == 1
			
			for iter_6_1, iter_6_2 in pairs(var_6_15) do
				local var_6_18 = DBT("substory_custom_mission", iter_6_2, {
					"id",
					"mission_linear_progress",
					"name",
					"note",
					"desc",
					"res",
					"content_type",
					"condition",
					"value",
					"give_code",
					"give_count",
					"btn_move",
					"reward_value1",
					"reward_count1",
					"grade_rate1",
					"set_drop_rate_id1",
					"reward_value2",
					"reward_count2",
					"grade_rate2",
					"set_drop_rate_id2"
				})
				
				if var_6_18 and var_6_18.id then
					if not var_6_17 then
						if iter_6_1 == 1 then
							var_6_18.is_first = true
						elseif iter_6_1 == var_6_16 then
							var_6_18.is_last = true
						end
					else
						var_6_18.is_only_one = true
					end
					
					local var_6_19 = SubStoryCustom:getMissionInfo(var_6_18.id)
					
					if var_6_19 and not table.empty(var_6_19) then
						var_6_18.is_cleared = SubStoryCustomMission:isRewarded(var_6_18.id)
						var_6_18.can_receive = SubStoryCustom:isClearedMission(var_6_18.id)
					else
						var_6_18.is_cleared = false
						var_6_18.can_receive = false
					end
					
					if iter_6_0 == 1 and tonumber(iter_6_1) == 1 then
						var_6_0 = true
					end
					
					if var_6_11 and not Account:isMapCleared(var_6_11) then
						var_6_0 = false
					end
					
					var_6_18.can_show = var_6_0
					var_6_0 = var_6_18.is_cleared
					
					if var_6_18.can_show then
						var_6_12 = iter_6_1
					end
					
					if tonumber(iter_6_1) == 1 then
						var_6_1 = var_6_18.can_show
					end
					
					var_6_18.value = totable(var_6_18.value)
					var_6_18.score = SubStoryCustomMission:getScore(var_6_18.id)
					
					if var_0_0 then
						var_6_18.can_show = true
					end
					
					table.insert(var_6_14, var_6_18)
				end
			end
			
			local var_6_20
			
			if var_6_10 then
				var_6_20 = DBT("substory_inference_3_clue", var_6_10, {
					"id",
					"note_id",
					"clue_res",
					"clue_txt",
					"clue_deco",
					"unlock_custom_mission_id"
				})
			end
			
			if var_6_2 == 1 then
				var_6_1 = true
			end
			
			local var_6_21 = var_6_1
			
			if var_6_1 then
				var_6_3 = var_6_2
				var_6_4 = var_6_12
			end
			
			if var_6_11 and not Account:isMapCleared(var_6_11) then
				var_6_21 = false
			end
			
			if var_0_0 then
				var_6_21 = true
			end
			
			table.insert(arg_6_0.vars.data, {
				id = var_6_5,
				note_id = var_6_6,
				btn_txt = var_6_7,
				case_title = var_6_8,
				custom_mission_id = var_6_9,
				clue_id = var_6_10,
				clue_data = var_6_20,
				custom_mission_data = var_6_14,
				max_custom_mission_idx = var_6_16,
				can_show = var_6_21
			})
			
			var_6_2 = var_6_2 + 1
		end
	end
	
	if not arg_6_0.vars.cur_inference_idx then
		arg_6_0.vars.cur_inference_idx = var_6_3
		arg_6_0.vars.cur_mission_idx = var_6_4
	end
	
	arg_6_0.vars.cur_inference = arg_6_0.vars.data[arg_6_0.vars.cur_inference_idx]
	arg_6_0.vars.cur_mission = arg_6_0.vars.cur_inference.custom_mission_data[arg_6_0.vars.cur_mission_idx]
	arg_6_0.vars.chapter_data = {}
	
	local var_6_22 = SubstoryManager:getChapterIDList()
	
	if var_6_22 then
		for iter_6_3, iter_6_4 in pairs(var_6_22) do
			local var_6_23 = DB("substory_inference_1_note", iter_6_4, {
				"enter_btn_unlock_stage"
			})
			
			if var_6_23 and Account:checkEnterMap(var_6_23) then
				table.insert(arg_6_0.vars.chapter_data, iter_6_4)
			end
		end
	end
end

function SubStoryInferenceNote._updateMissionData(arg_7_0)
	arg_7_0:updateData()
	
	arg_7_0.vars.cur_inference = arg_7_0.vars.data[arg_7_0.vars.cur_inference_idx]
	arg_7_0.vars.cur_mission = arg_7_0.vars.cur_inference.custom_mission_data[arg_7_0.vars.cur_mission_idx]
end

function SubStoryInferenceNote.initUI(arg_8_0)
	local var_8_0 = table.count(arg_8_0.vars.data)
	local var_8_1 = 6
	local var_8_2 = arg_8_0.vars.wnd:getChildByName("off_bookmark")
	local var_8_3 = arg_8_0.vars.wnd:getChildByName("on_bookmark")
	
	var_8_2:setVisible(true)
	var_8_3:setVisible(true)
	
	for iter_8_0 = 1, var_8_1 do
		local var_8_4 = var_8_2:getChildByName("off_" .. iter_8_0)
		local var_8_5 = var_8_3:getChildByName("on_" .. iter_8_0)
		
		if_set_visible(var_8_5, nil, false)
		if_set_visible(var_8_4, nil, false)
		if_set_visible(var_8_5, "n_noti", false)
		if_set_visible(var_8_4, "n_noti", false)
		
		local var_8_6 = arg_8_0.vars.data[iter_8_0]
		
		if var_8_6 and var_8_6.btn_txt then
			if_set(var_8_5, "t_disc", T(var_8_6.btn_txt))
			if_set(var_8_4, "t_disc", T(var_8_6.btn_txt))
		end
	end
	
	for iter_8_1 = 1, var_8_0 do
		if_set_visible(var_8_3, "on_" .. iter_8_1, iter_8_1 <= var_8_0)
	end
	
	if arg_8_0.vars.substory_id and string.starts(arg_8_0.vars.substory_id, "vfm3") then
		local var_8_7 = arg_8_0.vars.wnd:getChildByName("btn_obtained_clues")
		local var_8_8 = arg_8_0.vars.wnd:getChildByName("n_mission")
		
		if get_cocos_refid(var_8_8) and get_cocos_refid(var_8_7) then
			if_set(var_8_7, "t_obtain", T("ui_battle_story_valentine_case_notebook_popup_btn_clue2"))
			if_set(var_8_8, "t_mission", T("ui_battle_story_valentine_case_notebook_popup_invastigate2"))
		end
	end
end

function SubStoryInferenceNote.selectMission(arg_9_0, arg_9_1)
	if not arg_9_1 or not arg_9_0.vars.cur_inference then
		return 
	end
	
	local var_9_0 = tonumber(arg_9_1)
	
	if var_9_0 > tonumber(arg_9_0.vars.cur_inference.max_custom_mission_idx) or var_9_0 < 1 then
		return 
	end
	
	arg_9_0.vars.cur_mission_idx = var_9_0
	arg_9_0.vars.cur_mission = arg_9_0.vars.cur_inference.custom_mission_data[arg_9_0.vars.cur_mission_idx]
end

function SubStoryInferenceNote.MoveMission(arg_10_0, arg_10_1)
	if not arg_10_0.vars.cur_inference then
		return 
	end
	
	local var_10_0
	
	if arg_10_1 then
		var_10_0 = arg_10_0.vars.cur_mission_idx + 1
	else
		var_10_0 = arg_10_0.vars.cur_mission_idx - 1
	end
	
	if var_10_0 > tonumber(arg_10_0.vars.cur_inference.max_custom_mission_idx) or var_10_0 < 1 then
		return 
	end
	
	if not arg_10_0.vars.cur_inference.custom_mission_data[arg_10_0.vars.cur_mission_idx].can_show then
		return 
	end
	
	arg_10_0.vars.cur_mission_idx = var_10_0
	arg_10_0.vars.cur_mission = arg_10_0.vars.cur_inference.custom_mission_data[arg_10_0.vars.cur_mission_idx]
	
	arg_10_0:updatePageUI()
	
	local var_10_1, var_10_2 = arg_10_0:getNotiValue()
	
	if var_10_1 and var_10_2 and var_10_2 == arg_10_0.vars.cur_mission_idx then
		local var_10_3 = arg_10_0.vars.wnd:getChildByName("n_arrow_r")
		
		if_set_visible(var_10_3, "noti", false)
		arg_10_0:setNotiValue(nil, nil)
	end
end

function SubStoryInferenceNote.selectInference(arg_11_0, arg_11_1)
	if not arg_11_1 or not arg_11_0.vars.cur_inference then
		return 
	end
	
	local var_11_0 = tonumber(arg_11_1)
	
	if var_11_0 > table.count(arg_11_0.vars.data) or var_11_0 < 1 then
		return 
	end
	
	if not arg_11_0.vars.data[arg_11_0.vars.cur_inference_idx].can_show then
		return 
	end
	
	arg_11_0.vars.cur_inference_idx = var_11_0
	arg_11_0.vars.cur_inference = arg_11_0.vars.data[arg_11_0.vars.cur_inference_idx]
	
	arg_11_0:selectMission(1)
	arg_11_0:updateUI()
	
	local var_11_1, var_11_2 = arg_11_0:getNotiValue()
	
	if var_11_1 and not var_11_2 and var_11_1 == arg_11_0.vars.cur_inference_idx then
		local var_11_3 = arg_11_0.vars.wnd:getChildByName("on_bookmark")
		local var_11_4 = arg_11_0.vars.wnd:getChildByName("off_bookmark")
		local var_11_5 = var_11_3:getChildByName("on_" .. var_11_1)
		local var_11_6 = var_11_4:getChildByName("off_" .. var_11_1)
		
		if get_cocos_refid(var_11_5) and get_cocos_refid(var_11_6) then
			if_set_visible(var_11_5, "n_noti", true)
			if_set_visible(var_11_6, "n_noti", true)
		end
		
		arg_11_0:setNotiValue(nil, nil)
	end
end

function SubStoryInferenceNote.updateUI(arg_12_0)
	arg_12_0:updateSideUI()
	arg_12_0:updatePageUI()
	arg_12_0:updateChapterUI()
end

function SubStoryInferenceNote.updateSideUI(arg_13_0)
	local var_13_0 = table.count(arg_13_0.vars.data)
	local var_13_1 = 6
	local var_13_2 = arg_13_0.vars.wnd:getChildByName("off_bookmark")
	local var_13_3 = arg_13_0.vars.wnd:getChildByName("on_bookmark")
	
	for iter_13_0 = 1, var_13_1 do
		local var_13_4 = var_13_2:getChildByName("off_" .. iter_13_0)
		local var_13_5 = var_13_3:getChildByName("on_" .. iter_13_0)
		
		if_set_visible(var_13_5, nil, false)
		if_set_visible(var_13_4, nil, false)
		if_set_visible(var_13_5, "n_noti", false)
		if_set_visible(var_13_4, "n_noti", false)
	end
	
	for iter_13_1 = 1, var_13_0 do
		if_set_visible(var_13_2, "off_" .. iter_13_1, iter_13_1 ~= arg_13_0.vars.cur_inference_idx)
		if_set_visible(var_13_3, "on_" .. iter_13_1, iter_13_1 == arg_13_0.vars.cur_inference_idx)
	end
	
	for iter_13_2, iter_13_3 in pairs(arg_13_0.vars.data) do
		if tonumber(iter_13_2) ~= 1 and not iter_13_3.can_show then
			if_set_visible(var_13_2, "off_" .. iter_13_2, false)
			if_set_visible(var_13_3, "on_" .. iter_13_2, false)
		end
	end
end

function SubStoryInferenceNote.updatePageUI(arg_14_0)
	if not arg_14_0.vars.cur_inference or not arg_14_0.vars.cur_mission then
		Log.e("Err: no inference or custom mission", arg_14_0.vars.cur_inference_idx, arg_14_0.vars.cur_mission_idx)
		
		return 
	end
	
	local var_14_0 = arg_14_0.vars.cur_inference
	local var_14_1 = arg_14_0.vars.cur_mission
	local var_14_2 = arg_14_0.vars.wnd:getChildByName("n_note")
	local var_14_3 = var_14_2:getChildByName("n_mission")
	local var_14_4 = tonumber(arg_14_0.vars.cur_inference.max_custom_mission_idx)
	
	if_set(var_14_2:getChildByName("n_title"), "t_disc", arg_14_0.vars.cur_mission_idx .. "/" .. var_14_4)
	
	if var_14_1.is_only_one then
		if_set_visible(arg_14_0.vars.wnd, "n_arrow_l", false)
		if_set_visible(arg_14_0.vars.wnd, "n_arrow_r", false)
	else
		if_set_visible(arg_14_0.vars.wnd, "n_arrow_l", not var_14_1.is_first)
		if_set_visible(arg_14_0.vars.wnd, "n_arrow_r", not var_14_1.is_last)
	end
	
	if_set(var_14_2, "t_title", T(var_14_0.case_title))
	if_set(var_14_2, "t_investigation", T(var_14_1.name))
	if_set(var_14_2, "t_disc_0", T(var_14_1.note))
	if_set(var_14_2, "t_disc_1", T(var_14_1.desc))
	if_set_sprite(var_14_2, "img_event_clue", "img/" .. var_14_1.res)
	
	local var_14_5 = {
		"mob_icon",
		"reward_item"
	}
	
	for iter_14_0 = 1, 2 do
		local var_14_6 = var_14_3:getChildByName(var_14_5[iter_14_0])
		local var_14_7 = var_14_1["reward_value" .. iter_14_0]
		local var_14_8 = var_14_1["reward_count" .. iter_14_0]
		local var_14_9 = var_14_1["grade_rate" .. iter_14_0]
		local var_14_10 = var_14_1["set_drop_rate_id" .. iter_14_0]
		
		if get_cocos_refid(var_14_6) then
			var_14_6:removeAllChildren()
			
			if var_14_7 then
				var_14_6:setVisible(true)
				
				local var_14_11 = {}
				local var_14_12
				local var_14_13
				
				if var_14_9 and var_14_10 then
					var_14_11 = {
						parent = var_14_6,
						grade_rate = var_14_9,
						set_fx = var_14_10
					}
					var_14_13 = "equip"
				else
					var_14_11 = {
						parent = var_14_6
					}
					var_14_13 = var_14_8
				end
				
				UIUtil:getRewardIcon(var_14_13, var_14_7, var_14_11)
			else
				var_14_6:setVisible(false)
			end
		end
	end
	
	if_set_visible(arg_14_0.vars.wnd, "btn_obtained_clues", true)
	
	local var_14_14 = 255
	
	if _isUserClueEmpty(arg_14_0.vars.note_id) then
		var_14_14 = 76.5
	end
	
	if_set_opacity(arg_14_0.vars.wnd, "btn_obtained_clues", var_14_14)
	
	local var_14_15 = arg_14_0.vars.cur_inference.custom_mission_data[arg_14_0.vars.cur_mission_idx + 1]
	
	if var_14_15 and not var_14_15.can_show then
		if_set_visible(arg_14_0.vars.wnd, "n_arrow_r", false)
	end
	
	arg_14_0:update_progress()
	arg_14_0:updatePageButtonUI()
	arg_14_0:updateNotiUI()
	arg_14_0:updateClueBtnEffect()
end

function SubStoryInferenceNote.updateClueBtnEffect(arg_15_0)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.wnd) then
		return 
	end
	
	local var_15_0 = arg_15_0.vars.wnd:getChildByName("btn_obtained_clues")
	local var_15_1 = false
	
	if get_cocos_refid(var_15_0) then
		if SubStoryInferenceNote.eff_list then
			if get_cocos_refid(var_15_0.n_btn_eff) then
				var_15_0.n_btn_eff:removeFromParent()
				
				var_15_0.n_btn_eff = nil
			end
			
			if SubStoryInferenceNote.eff_list[arg_15_0.vars.note_id] then
				var_15_0.n_btn_eff = EffectManager:Play({
					x = 108.5,
					y = 33,
					fn = "ui_super_battle_proviso.cfx",
					layer = var_15_0
				})
			elseif get_cocos_refid(var_15_0.n_btn_eff) then
				var_15_1 = true
			end
		elseif get_cocos_refid(var_15_0.n_btn_eff) then
			var_15_1 = true
		end
		
		if var_15_1 then
			var_15_0.n_btn_eff:removeFromParent()
			
			var_15_0.n_btn_eff = nil
		end
	end
end

function SubStoryInferenceNote.updateChapterUI(arg_16_0)
	local var_16_0 = arg_16_0.vars.wnd:getChildByName("on_bookmark_chapter")
	local var_16_1 = arg_16_0.vars.wnd:getChildByName("off_bookmark_chapter")
	
	var_16_0:setVisible(true)
	var_16_1:setVisible(true)
	
	for iter_16_0 = 1, 3 do
		local var_16_2 = arg_16_0.vars.chapter_data[iter_16_0]
		local var_16_3 = var_16_0:getChildByName("on_" .. iter_16_0)
		local var_16_4 = var_16_1:getChildByName("off_" .. iter_16_0)
		local var_16_5 = var_16_4:getChildByName("btn_off_chapter_" .. iter_16_0)
		
		if get_cocos_refid(var_16_3) and get_cocos_refid(var_16_4) and get_cocos_refid(var_16_5) then
			if var_16_2 then
				local var_16_6 = DB("level_world_3_chapter", var_16_2, {
					"name"
				})
				
				var_16_3:setVisible(var_16_2 == arg_16_0.vars.note_id)
				var_16_4:setVisible(true)
				
				var_16_5.chapter_id = var_16_2
				
				if var_16_6 then
					if_set(var_16_3, "t_disc", T(var_16_6))
					if_set(var_16_4, "t_disc", T(var_16_6))
				end
			else
				var_16_3:setVisible(false)
				var_16_4:setVisible(false)
			end
		end
	end
end

function SubStoryInferenceNote.onSelectChapter(arg_17_0, arg_17_1)
	if not arg_17_0.vars or not get_cocos_refid(arg_17_0.vars.wnd) or not arg_17_1 then
		return 
	end
	
	arg_17_0.vars.note_id = arg_17_1
	arg_17_0.vars.cur_inference_idx = nil
	
	arg_17_0:updateData()
	arg_17_0:initUI()
	arg_17_0:updateUI()
end

function SubStoryInferenceNote.updateChapterNotiUI(arg_18_0)
	local var_18_0 = arg_18_0.vars.wnd:getChildByName("on_bookmark_chapter")
	local var_18_1 = arg_18_0.vars.wnd:getChildByName("off_bookmark_chapter")
	
	for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.chapter_data) do
		local var_18_2 = false
		
		for iter_18_2 = 1, 99999999 do
			local var_18_3, var_18_4, var_18_5 = DBN("substory_inference_2_case", iter_18_2, {
				"id",
				"note_id",
				"custom_mission_id"
			})
			
			if not var_18_3 or not var_18_4 then
				break
			end
			
			if iter_18_1 == var_18_4 then
				local var_18_6 = string.split(var_18_5, ",")
				
				for iter_18_3, iter_18_4 in pairs(var_18_6) do
					if SubStoryCustom:isClearedMission(iter_18_4) and not SubStoryCustom:isReceivedReward(iter_18_4) then
						var_18_2 = true
						
						break
					end
				end
			end
		end
		
		local var_18_7 = var_18_0:getChildByName("on_" .. iter_18_0)
		local var_18_8 = var_18_1:getChildByName("off_" .. iter_18_0)
		
		if get_cocos_refid(var_18_7) and get_cocos_refid(var_18_8) then
			if_set_visible(var_18_7, "n_noti", var_18_2)
			if_set_visible(var_18_8, "n_noti", var_18_2)
		end
	end
end

function SubStoryInferenceNote.updateNotiUI(arg_19_0)
	local var_19_0 = arg_19_0.vars.cur_mission
	
	if not var_19_0.is_last then
		local var_19_1 = var_19_0.is_only_one
	end
	
	local var_19_2 = arg_19_0.vars.wnd:getChildByName("on_bookmark")
	local var_19_3 = arg_19_0.vars.wnd:getChildByName("off_bookmark")
	
	for iter_19_0 = 1, 6 do
		local var_19_4 = var_19_2:getChildByName("on_" .. iter_19_0)
		local var_19_5 = var_19_3:getChildByName("off_" .. iter_19_0)
		
		if get_cocos_refid(var_19_4) and get_cocos_refid(var_19_5) then
			if_set_visible(var_19_4, "n_noti", false)
			if_set_visible(var_19_5, "n_noti", false)
		end
	end
	
	local var_19_6 = arg_19_0.vars.wnd:getChildByName("n_arrow_r")
	
	if_set_visible(var_19_6, "noti", false)
	
	local var_19_7, var_19_8 = arg_19_0:getNotiValue()
	
	if var_19_7 and not var_19_8 then
		local var_19_9 = var_19_2:getChildByName("on_" .. var_19_7)
		local var_19_10 = var_19_3:getChildByName("off_" .. var_19_7)
		
		if get_cocos_refid(var_19_9) and get_cocos_refid(var_19_10) then
			if_set_visible(var_19_9, "n_noti", true)
			if_set_visible(var_19_10, "n_noti", true)
		end
	elseif var_19_7 and var_19_8 and arg_19_0.vars.cur_inference_idx == var_19_7 and arg_19_0.vars.cur_mission_idx + 1 == var_19_8 then
		if_set_visible(var_19_6, "noti", true)
	end
	
	arg_19_0:updateChapterNotiUI()
end

function SubStoryInferenceNote.update_progress(arg_20_0)
	local var_20_0 = arg_20_0.vars.wnd:getChildByName("progress_ing")
	
	if_set_visible(var_20_0, nil, true)
	if_set_visible(arg_20_0.vars.wnd, "progress_clear", false)
	
	local var_20_1 = tonumber(arg_20_0.vars.cur_mission.value.count) or 0
	local var_20_2 = tonumber(arg_20_0.vars.cur_mission.score) or 0
	local var_20_3 = math.min(var_20_2, var_20_1)
	
	if_set_percent(var_20_0, "progress_bar", var_20_3 / var_20_1)
	if_set(var_20_0, "t_percent", var_20_3 .. "/" .. var_20_1)
	
	if var_20_1 <= var_20_3 or arg_20_0.vars.cur_mission.is_cleared then
		if_set_color(var_20_0, "progress_bar", cc.c3b(107, 193, 27))
	else
		if_set_color(var_20_0, "progress_bar", cc.c3b(146, 109, 62))
	end
end

function SubStoryInferenceNote.updatePageButtonUI(arg_21_0)
	local var_21_0 = arg_21_0.vars.cur_mission
	local var_21_1 = arg_21_0.vars.wnd:getChildByName("n_btn")
	local var_21_2 = var_21_1:getChildByName("btn_move")
	local var_21_3 = arg_21_0.vars.wnd:getChildByName("btn_give")
	
	var_21_3.contents_id = var_21_0.id
	var_21_3.give_code = var_21_0.give_code
	var_21_3.give_count = var_21_0.give_count
	
	if var_21_0.btn_move then
		var_21_2.path = var_21_0.btn_move
	end
	
	var_21_2:setTouchEnabled(true)
	
	local var_21_4 = 255
	
	if var_21_0.is_cleared then
		var_21_2:setTouchEnabled(false)
		if_set_visible(var_21_1, "btn_move", true)
		if_set_visible(var_21_3, nil, false)
		if_set_visible(var_21_1, "t_complete", true)
		if_set_visible(var_21_1, "n_move", false)
		if_set_visible(var_21_1, "btn_get", false)
		
		var_21_4 = 76.5
	elseif var_21_0.can_receive then
		if_set_visible(var_21_1, "btn_move", false)
		if_set_visible(var_21_3, nil, false)
		if_set_visible(var_21_1, "t_complete", false)
		if_set_visible(var_21_1, "btn_get", true)
	else
		local var_21_5 = var_21_0.give_code and var_21_0.give_count
		
		if_set_visible(var_21_3, nil, var_21_5)
		if_set_visible(var_21_1, "btn_move", not var_21_5)
		if_set_visible(var_21_1, "t_complete", false)
		if_set_visible(var_21_1, "n_move", true)
		if_set_visible(var_21_1, "btn_get", false)
	end
	
	var_21_2:setOpacity(var_21_4)
end

function SubStoryInferenceNote.moveTo(arg_22_0, arg_22_1)
	if not arg_22_1 then
		return 
	end
	
	movetoPath(arg_22_1)
	arg_22_0:close()
end

function SubStoryInferenceNote.onUpdateUI(arg_23_0)
	if not arg_23_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_23_0.vars.wnd) then
		return 
	end
	
	arg_23_0:_updateMissionData()
	arg_23_0:updateNotiValue()
	arg_23_0:updateUI()
end

function SubStoryInferenceNote.res_query(arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_1 then
		return 
	end
	
	if arg_24_1 == "substory_custom_mission_complete" then
		arg_24_0:res_clearMission(arg_24_2)
		TutorialGuide:procGuide()
	end
end

function SubStoryInferenceNote.req_clearMission(arg_25_0)
	if not arg_25_0.vars or not arg_25_0.vars.cur_mission then
		return 
	end
	
	local var_25_0 = arg_25_0.vars.cur_mission
	
	if not var_25_0.can_receive or var_25_0.is_cleared then
		return 
	end
	
	query("substory_custom_mission_complete", {
		substory_id = arg_25_0.vars.substory_id,
		mission_id = var_25_0.id
	})
end

function SubStoryInferenceNote.res_clearMission(arg_26_0, arg_26_1)
	if not arg_26_1 or not arg_26_1.info then
		return 
	end
	
	arg_26_0:onUpdateUI()
	
	if SceneManager:getCurrentSceneName() == "world_custom" then
		local var_26_0 = WorldMapManager:getController()
		
		if var_26_0 then
			local var_26_1 = var_26_0:getTown()
			
			if var_26_1 then
				var_26_1:procNewTownEffect()
				var_26_1:updateEventNavigator()
			end
		end
	end
	
	SubstoryManager:updateNotifierContentsUI()
end

function SubStoryInferenceNote.updateNotiValue(arg_27_0)
	if not arg_27_0.vars or not arg_27_0.vars.data or not arg_27_0.vars.cur_inference_idx then
		return 
	end
	
	local var_27_0 = arg_27_0.vars.cur_inference_idx + 1
	local var_27_1 = arg_27_0.vars.data[var_27_0]
	local var_27_2 = arg_27_0.vars.cur_mission_idx + 1
	local var_27_3 = arg_27_0.vars.cur_inference.custom_mission_data[var_27_2]
	
	if not var_27_3 and var_27_0 then
		arg_27_0:setNotiValue(var_27_0, nil)
	elseif var_27_3 then
		arg_27_0:setNotiValue(arg_27_0.vars.cur_inference_idx, var_27_2)
	else
		arg_27_0:setNotiValue(nil, nil)
	end
end

local function var_0_1()
	local var_28_0 = 0
	local var_28_1 = SubstoryManager:getChapterIDList()
	
	if var_28_1 then
		for iter_28_0, iter_28_1 in pairs(var_28_1) do
			local var_28_2 = DB("substory_inference_1_note", iter_28_1, {
				"enter_btn_unlock_stage"
			})
			
			if var_28_2 and Account:checkEnterMap(var_28_2) then
				var_28_0 = var_28_0 + 1
			end
		end
	end
	
	return var_28_0
end

function SubStoryInferenceNote.initNewNoteNoti(arg_29_0)
	if not SubStoryInferenceNote.enterable_note_idx then
		local var_29_0 = var_0_1()
		
		SubStoryInferenceNote.enterable_note_idx = var_29_0
	end
end

function SubStoryInferenceNote.checkNewNoteNoti(arg_30_0)
	if not SubStoryInferenceNote.enterable_note_idx then
		return 
	end
	
	local var_30_0 = var_0_1()
	
	if var_30_0 ~= SubStoryInferenceNote.enterable_note_idx then
		SubStoryInferenceNote.enterable_note_idx = var_30_0
		
		return true
	end
end

function SubStoryInferenceNote.setNotiValue(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_0.vars.substory_id .. arg_31_0.vars.note_id .. "infe_noti"
	local var_31_1 = arg_31_0.vars.substory_id .. arg_31_0.vars.note_id .. "mis_noti"
	
	SAVE:set(var_31_0, arg_31_1)
	SAVE:set(var_31_1, arg_31_2)
end

function SubStoryInferenceNote.getNotiValue(arg_32_0)
	local var_32_0 = arg_32_0.vars.substory_id .. arg_32_0.vars.note_id .. "infe_noti"
	local var_32_1 = arg_32_0.vars.substory_id .. arg_32_0.vars.note_id .. "mis_noti"
	local var_32_2 = SAVE:get(var_32_0, nil)
	local var_32_3 = SAVE:get(var_32_1, nil)
	
	return tonumber(var_32_2), tonumber(var_32_3)
end

function SubStoryInferenceNote.show_effect_clue(arg_33_0, arg_33_1)
	if not arg_33_0.vars or not get_cocos_refid(arg_33_0.vars.wnd) or not arg_33_1 then
		return 
	end
	
	if not SubStoryInferenceNote.eff_list then
		SubStoryInferenceNote.eff_list = {}
	end
	
	local var_33_0
	local var_33_1
	
	for iter_33_0, iter_33_1 in pairs(arg_33_0.vars.data) do
		if iter_33_1.custom_mission_data then
			for iter_33_2, iter_33_3 in pairs(iter_33_1.custom_mission_data) do
				if iter_33_3.id == arg_33_1 then
					var_33_0 = iter_33_3.is_last
					var_33_1 = iter_33_1.clue_id
					
					break
				end
			end
		end
		
		if var_33_0 ~= nil then
			break
		end
	end
	
	if var_33_1 then
		SubStoryInferenceNote.eff_list[arg_33_0.vars.note_id] = true
		
		arg_33_0:updateClueBtnEffect()
	end
	
	if not var_33_0 or not var_33_1 then
		return 
	end
	
	SubStoryCluePage:open(arg_33_0.vars.note_id, {
		show_effect_clue = var_33_1
	})
end

function SubStoryInferenceNote.openCluePage(arg_34_0)
	if not arg_34_0.vars or not get_cocos_refid(arg_34_0.vars.wnd) or not arg_34_0.vars.note_id then
		return 
	end
	
	SubStoryCluePage:open(arg_34_0.vars.note_id)
	
	if SubStoryInferenceNote.eff_list and SubStoryInferenceNote.eff_list[arg_34_0.vars.note_id] then
		SubStoryInferenceNote.eff_list[arg_34_0.vars.note_id] = nil
	end
	
	arg_34_0:updateClueBtnEffect()
end

function SubStoryInferenceNote.close(arg_35_0)
	if not arg_35_0.vars or not get_cocos_refid(arg_35_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("battle_story_valentine_case_notebook_popup")
	UIAction:Add(SEQ(FADE_OUT(300), REMOVE(), CALL(function()
		arg_35_0.vars = nil
	end)), arg_35_0.vars.wnd, "block")
end

function SubStoryCluePage.open(arg_37_0, arg_37_1, arg_37_2)
	if not arg_37_1 then
		return 
	end
	
	local var_37_0 = DB("substory_inference_1_note", arg_37_1, {
		"id"
	})
	
	if not var_37_0 then
		Log.e("Err: Wrong Note id: ", arg_37_1)
		
		return 
	end
	
	if _isUserClueEmpty(var_37_0) then
		balloon_message_with_sound("msg_substory_inference_no_clue")
		
		return 
	end
	
	if arg_37_0.vars and get_cocos_refid(arg_37_0.vars.wnd) then
		return 
	end
	
	arg_37_0.vars = {}
	arg_37_0.vars.wnd = load_dlg("battle_story_valentine_event_clue_popup", false, "wnd", function()
		SubStoryCluePage:close()
	end)
	arg_37_0.vars.opts = arg_37_2 or {}
	
	;(arg_37_0.vars.opts.parent_layer or SceneManager:getRunningPopupScene()):addChild(arg_37_0.vars.wnd)
	arg_37_0.vars.wnd:bringToFront()
	
	arg_37_0.vars.show_effect_clue = arg_37_0.vars.opts.show_effect_clue
	
	local var_37_1 = arg_37_1
	
	arg_37_0.vars.clue_popup_title = DB("substory_inference_1_note", var_37_1, {
		"clue_popup_title"
	})
	arg_37_0.vars.id = "incl_" .. var_37_1
	
	arg_37_0:updateData()
	arg_37_0:updateUI()
	TutorialGuide:procGuide()
end

function SubStoryCluePage.updateData(arg_39_0)
	arg_39_0.vars.data = {}
	
	local var_39_0 = 4
	
	for iter_39_0 = 1, var_39_0 do
		local var_39_1 = arg_39_0.vars.id .. "_" .. iter_39_0
		local var_39_2 = DBT("substory_inference_3_clue", var_39_1, {
			"id",
			"note_id",
			"clue_res",
			"clue_txt",
			"clue_deco",
			"unlock_custom_mission_id"
		})
		
		if var_39_2 and var_39_2.id then
			if var_39_2.unlock_custom_mission_id then
				var_39_2.is_cleared = SubStoryCustomMission:isRewarded(var_39_2.unlock_custom_mission_id)
			else
				Log.e("Err: empty data", var_39_1, var_39_2.unlock_custom_mission_id)
			end
			
			if var_0_0 then
				var_39_2.is_cleared = true
			end
			
			table.insert(arg_39_0.vars.data, var_39_2)
		end
	end
end

function SubStoryCluePage.updateUI(arg_40_0)
	local var_40_0 = 4
	local var_40_1 = table.count(arg_40_0.vars.data)
	
	for iter_40_0 = 1, 4 do
		local var_40_2 = arg_40_0.vars.wnd:getChildByName("n_event_clue" .. iter_40_0)
		
		if get_cocos_refid(var_40_2) and arg_40_0.vars.data[iter_40_0] then
			local var_40_3 = var_40_2:getChildByName("event_clue" .. iter_40_0)
			
			if get_cocos_refid(var_40_2) then
				local var_40_4 = arg_40_0.vars.data[iter_40_0]
				
				var_40_2:setVisible(true)
				var_40_3:setVisible(true)
				
				local var_40_5 = var_40_2:getChildByName("img_event_clue" .. iter_40_0)
				
				if_set_sprite(var_40_5, nil, "img/" .. var_40_4.clue_res)
				if_set_sprite(var_40_2, "img_check" .. iter_40_0, var_40_4.clue_deco)
				
				if arg_40_0.vars.show_effect_clue and arg_40_0.vars.show_effect_clue == var_40_4.id then
					if_set_visible(var_40_2, "img_check" .. iter_40_0, false)
					
					local var_40_6 = var_40_2:getChildByName("n_eff_check" .. iter_40_0)
					
					var_40_6:setVisible(true)
					var_40_5:setOpacity(0)
					
					var_40_5.origin_y = var_40_5:getPositionY()
					
					var_40_5:setPositionY(var_40_5:getPositionY() + 50)
					if_set(var_40_2, "t_disc", "")
					
					local var_40_7 = 30
					local var_40_8 = 3000
					
					UIAction:Add(SEQ(CALL(function()
						EffectManager:Play({
							x = 0,
							y = 0,
							fn = "vva2aa_eff_1.cfx",
							layer = var_40_6
						})
					end), DELAY(var_40_8), CALL(function()
						SoundEngine:play("event:/effect/vva2aa_eff_3")
					end), TEXT(T(var_40_4.clue_txt), false, var_40_7), CALL(function()
						EffectManager:Play({
							x = 0,
							y = 0,
							fn = "vva2aa_eff_2.cfx",
							layer = var_40_6
						})
					end), DELAY(1000), CALL(function()
						var_40_6:setVisible(false)
						if_set_visible(var_40_2, "img_check" .. iter_40_0, true)
					end)), var_40_2:getChildByName("t_disc"))
					UIAction:Add(SEQ(DELAY(1000), FADE_IN(500), MOVE_TO(200, var_40_5:getPositionX(), var_40_5.origin_y)), var_40_5)
				elseif var_40_4.is_cleared then
					if_set(var_40_2, "t_disc", T(var_40_4.clue_txt))
					if_set_visible(var_40_2, "img_check" .. iter_40_0, true)
				else
					var_40_2:setVisible(false)
				end
			end
		end
	end
	
	for iter_40_1 = var_40_1 + 1, 4 do
		if_set_visible(arg_40_0.vars.wnd, "n_event_clue" .. iter_40_1, false)
	end
	
	if_set(arg_40_0.vars.wnd, "t_title", T(arg_40_0.vars.clue_popup_title))
end

function SubStoryCluePage.close(arg_45_0)
	if not arg_45_0.vars or not get_cocos_refid(arg_45_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("battle_story_valentine_event_clue_popup")
	UIAction:Add(SEQ(FADE_OUT(300), REMOVE(), CALL(function()
		arg_45_0.vars = nil
	end)), arg_45_0.vars.wnd, "block")
end
