OriginTree = OriginTree or {}

copy_functions(ScrollView, OriginTree)

local var_0_0 = 4
local var_0_1 = 3

TREE_ELF = "s_elf"
TREE_VAM = "vam"

function MsgHandler.origin_tree_star_reward(arg_1_0)
	local var_1_0
	
	if arg_1_0.rewards then
		local var_1_1 = false
		
		if arg_1_0.rewards.new_items and arg_1_0.rewards.new_items[1] then
			local var_1_2 = true
		end
		
		if arg_1_0.rewards.currency_time then
			for iter_1_0, iter_1_1 in ipairs(arg_1_0.rewards.currency_time) do
				if Account:isCurrencyType(iter_1_0) then
					Account:setCurrencyTime(iter_1_0, iter_1_1)
				end
			end
			
			local var_1_3 = true
		end
		
		local var_1_4 = Account:addReward(arg_1_0.rewards, {
			single = true
		})
	end
	
	Account:setWorldmapRwards(arg_1_0.info.chapter_id, tonumber(arg_1_0.info.count))
	OriginTree:resStarReward(arg_1_0)
end

function MsgHandler.init_origin_tree_star_reward(arg_2_0)
	if arg_2_0 then
		Account:setWorldmapRwards(arg_2_0.info.chapter_id, tonumber(arg_2_0.info.count))
		OriginTree:showUnlockPopup()
	end
end

function HANDLER.tree_unlock_popup(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_ok" then
		OriginTree:closeUnlockPopup()
	end
end

function HANDLER.map_depth_tree_origin(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_elf_arrow" or arg_4_1 == "btn_vampire_arrow" or arg_4_1 == "btn_title" then
		OriginTree:visibleSelectResearchUI(true)
	elseif arg_4_1 == "btn_star_reward" then
		OriginTree:reqStarReward()
	end
end

function HANDLER.map_depth_tree_origin_sorting(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_toggle" then
		OriginTree:toggleSelectResearchUI()
	elseif arg_5_1 == "btn_bg" then
		OriginTree:visibleSelectResearchUI(false)
	elseif string.starts(arg_5_1, "btn_sort") then
		OriginTree:visibleSelectResearchUI(false)
		OriginTree:selectResearch(string.sub(arg_5_1, -1, -1))
	end
end

function HANDLER.map_depth_tree_origin_item(arg_6_0, arg_6_1)
	if arg_6_1 == "btn_story" then
		if arg_6_0.story_id and arg_6_0.can_show then
			play_story(arg_6_0.story_id)
		else
			balloon_message_with_sound("ep5_tree_err_03")
		end
	elseif arg_6_1 == "btn_touch" then
		OriginTree:openBattleReady(arg_6_0.battle_id, arg_6_0.is_prev_cleared)
	end
end

function OriginTree.open(arg_7_0, arg_7_1, arg_7_2)
	if not arg_7_1 or arg_7_0.vars and get_cocos_refid(arg_7_0.vars.wnd) then
		return 
	end
	
	if arg_7_1 == TREE_ELF and not UnlockSystem:isUnlockSystem(UNLOCK_ID.ORIGIN_TREE_ELF) or arg_7_1 == TREE_VAM and not UnlockSystem:isUnlockSystem(UNLOCK_ID.ORIGIN_TREE_VAM) then
		return 
	end
	
	if ContentDisable:byAlias("ep5_tree_enter") then
		return 
	end
	
	if arg_7_0:initStarReward(arg_7_1) then
		return 
	end
	
	arg_7_0.vars = {}
	arg_7_0.vars.wnd = load_dlg("map_depth_tree_bg", true, "wnd", function()
		OriginTree:close()
	end)
	arg_7_0.vars.n_control = load_dlg("map_depth_tree_origin", true, "wnd")
	
	local var_7_0 = SceneManager:getDefaultLayer()
	
	arg_7_0.vars.wnd:addChild(arg_7_0.vars.n_control)
	var_7_0:addChild(arg_7_0.vars.wnd)
	
	arg_7_0.vars.camp_type = arg_7_1
	
	local var_7_1 = {}
	
	TopBarNew:createFromPopup(T("ep5_tree_title_s_elf_s1"), arg_7_0.vars.wnd, function()
		arg_7_0:close()
	end, var_7_1, "infoadve1_12")
	if_set_visible(arg_7_0.vars.wnd, "n_vampire", arg_7_0.vars.camp_type == TREE_VAM)
	if_set_visible(arg_7_0.vars.wnd, "n_elf", arg_7_0.vars.camp_type == TREE_ELF)
	
	local var_7_2 = arg_7_0.vars.wnd:getChildByName("bottom")
	
	if arg_7_0.vars.camp_type == TREE_VAM then
		if_set_sprite(var_7_2, "img_race", "img/cm_icon_vampires_bg.png")
		if_set_color(var_7_2, "-", tocolor("#C56110"))
	elseif arg_7_0.vars.camp_type == TREE_ELF then
		if_set_sprite(var_7_2, "img_race", "img/cm_icon_elf_bg.png")
		if_set_color(var_7_2, "-", tocolor("#1DB7FF"))
	end
	
	arg_7_0:updateAll()
	arg_7_0:updateSelectResearchUI()
	arg_7_0:removeSceneState()
	TutorialGuide:procGuide()
end

function OriginTree.needStarReward(arg_10_0, arg_10_1)
	if not arg_10_1 then
		return 
	end
	
	local var_10_0
	
	if arg_10_1 == TREE_VAM then
		var_10_0 = "vampire_s1"
	elseif arg_10_1 == TREE_ELF then
		var_10_0 = "shadowelf_s1"
	end
	
	return Account:getWorldmapReward(var_10_0) == nil, var_10_0
end

function OriginTree.initStarReward(arg_11_0, arg_11_1)
	local var_11_0, var_11_1 = arg_11_0:needStarReward(arg_11_1)
	
	if var_11_0 then
		OriginTree.camp_type = arg_11_1
		
		query("init_origin_tree_star_reward", {
			research_id = var_11_1
		})
		
		return true
	end
end

function OriginTree.showUnlockPopup(arg_12_0)
	local var_12_0 = load_dlg("mapshop_unlock_popup", true, "wnd", function()
		OriginTree:closeUnlockPopup()
	end)
	
	var_12_0:setName("tree_unlock_popup")
	if_set(var_12_0, "label", T("close_text"))
	SceneManager:getDefaultLayer():addChild(var_12_0)
	
	local var_12_1 = OriginTree.camp_type
	
	OriginTree.camp_type = nil
	var_12_0.camp_type = var_12_1
	
	local var_12_2 = var_12_1 == TREE_VAM and UNLOCK_ID.ORIGIN_TREE_VAM or UNLOCK_ID.ORIGIN_TREE_ELF
	local var_12_3, var_12_4, var_12_5, var_12_6 = DB("system_achievement_effect", var_12_2, {
		"id",
		"effect_title",
		"effect_desc",
		"effect_icon"
	})
	
	if var_12_3 then
		if_set(var_12_0, "txt_title", T(var_12_4))
		if_set(var_12_0, "txt_disc", T(var_12_5))
		if_set_sprite(var_12_0, "icon_treasure_map", "img/" .. var_12_6 .. ".png")
	end
	
	UIAction:Add(DELAY(500), var_12_0, "block")
end

function OriginTree.closeUnlockPopup(arg_14_0)
	BackButtonManager:pop("mapshop_unlock_popup")
	SceneManager:getDefaultLayer():getChildByName("tree_unlock_popup"):removeFromParent()
	
	if TutorialGuide:startGuide("ep5_tree") then
		return 
	end
end

function OriginTree.updateSelectResearchUI(arg_15_0)
	local var_15_0 = arg_15_0.vars.all_data
	local var_15_1 = arg_15_0:getCurData()
	
	if not get_cocos_refid(arg_15_0.vars.n_select_research) then
		arg_15_0.vars.n_select_research = load_dlg("map_depth_tree_origin_sorting", true, "wnd")
		
		arg_15_0.vars.n_select_research:setVisible(false)
		arg_15_0.vars.wnd:getChildByName("n_sort"):addChild(arg_15_0.vars.n_select_research)
		arg_15_0.vars.n_select_research:setPosition(0, 0)
	end
	
	local var_15_2 = arg_15_0.vars.wnd:getChildByName("n_sort_cursor")
	
	for iter_15_0 = 1, 99999 do
		local var_15_3 = arg_15_0.vars.n_select_research:getChildByName("btn_sort" .. iter_15_0)
		local var_15_4 = var_15_0[iter_15_0]
		
		if not get_cocos_refid(var_15_3) or not var_15_4 then
			break
		end
		
		var_15_3:setVisible(true)
		if_set(var_15_3, "txt_sort" .. iter_15_0, T(var_15_4.category_name))
		
		if var_15_4.id == var_15_1.id then
			var_15_2:setPositionY(var_15_3:getPositionY())
		end
	end
	
	if table.count(var_15_0) >= 3 then
		local var_15_5 = arg_15_0.vars.n_select_research:getChildByName("bg")
		local var_15_6 = var_15_5:getContentSize()
		
		var_15_6.height = var_15_6.height + 49
		
		var_15_5:setContentSize(var_15_6)
	elseif table.count(var_15_0) == 1 then
		local var_15_7 = arg_15_0.vars.n_select_research:getChildByName("bg")
		local var_15_8 = var_15_7:getContentSize()
		
		var_15_8.height = var_15_8.height - 49
		
		var_15_7:setContentSize(var_15_8)
	end
end

function OriginTree.visibleSelectResearchUI(arg_16_0, arg_16_1)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.wnd) or not get_cocos_refid(arg_16_0.vars.n_select_research) then
		return 
	end
	
	arg_16_0.vars.n_select_research:setVisible(arg_16_1)
end

function OriginTree.toggleSelectResearchUI(arg_17_0)
	if not arg_17_0.vars or not get_cocos_refid(arg_17_0.vars.wnd) or not get_cocos_refid(arg_17_0.vars.n_select_research) then
		return 
	end
	
	arg_17_0.vars.n_select_research:setVisible(not arg_17_0.vars.n_select_research:isVisible())
end

function OriginTree.selectResearch(arg_18_0, arg_18_1)
	if not arg_18_1 then
		return 
	end
	
	local var_18_0 = tonumber(arg_18_1)
	local var_18_1 = arg_18_0.vars.all_data[var_18_0]
	
	if not var_18_1 then
		return 
	end
	
	local var_18_2 = arg_18_0.vars.all_data[var_18_0 - 1]
	
	if var_18_2 and not var_18_2.ending_level and not var_18_2.is_cleared_all and var_18_2.research_datas then
		local var_18_3 = var_18_2.research_datas[table.count(var_18_2.research_datas)]
		
		if var_18_3 then
			balloon_message_with_sound("ep5_tree_err_01", {
				stage_name = T(var_18_3.name)
			})
		end
		
		return 
	end
	
	local var_18_4 = arg_18_0.vars.all_data
	local var_18_5 = arg_18_0:getCurData()
	local var_18_6 = arg_18_0.vars.wnd:getChildByName("n_sort_cursor")
	
	for iter_18_0 = 1, 99999 do
		local var_18_7 = arg_18_0.vars.n_select_research:getChildByName("btn_sort" .. iter_18_0)
		local var_18_8 = arg_18_0.vars.all_data[iter_18_0]
		
		if not get_cocos_refid(var_18_7) or not var_18_8 then
			break
		end
		
		if var_18_8.id == var_18_1.id then
			var_18_6:setPositionY(var_18_7:getPositionY())
		end
	end
	
	arg_18_0:selectData(var_18_0)
	arg_18_0:updateAll(true)
end

function OriginTree.getStarRewardData(arg_19_0, arg_19_1)
	local var_19_0 = DBT("level_world_3_chapter", arg_19_1, {
		"id",
		"name",
		"desc",
		"reward_vars"
	})
	local var_19_1 = string.split(var_19_0.reward_vars, ";")
	
	return tonumber(var_19_1[1]), var_19_1[2], tonumber(var_19_1[3])
end

function OriginTree.updateData(arg_20_0)
	arg_20_0.vars.all_data = {}
	
	local var_20_0 = true
	local var_20_1 = false
	local var_20_2
	
	for iter_20_0 = 1, 999999 do
		local var_20_3, var_20_4 = DBN("ep5_tree", iter_20_0, {
			"id",
			"camp_type"
		})
		
		if var_20_3 and var_20_4 and var_20_4 == arg_20_0.vars.camp_type then
			local var_20_5 = DBT("ep5_tree", var_20_3, {
				"id",
				"scene_title",
				"category_name",
				"research_bg_img",
				"camp_type",
				"research_level",
				"ending_level",
				"battle_btn_1",
				"battle_1_add_bg_img",
				"battle_1_story_id",
				"battle_btn_2",
				"battle_2_add_bg_img",
				"battle_2_story_id",
				"battle_btn_3",
				"battle_3_add_bg_img",
				"battle_3_story_id",
				"battle_btn_4",
				"battle_4_add_bg_img",
				"battle_4_story_id"
			})
			
			if not var_20_5 or not var_20_5.id then
				return 
			end
			
			local var_20_6 = Account:checkReceivedTreeRewardById(var_20_5.id)
			
			var_20_5.research_level = tonumber(var_20_5.research_level)
			var_20_5.star_reward_need_cnt, var_20_5.star_reward_type, var_20_5.star_reward_val = arg_20_0:getStarRewardData(var_20_5.id)
			var_20_5.is_received_star_reward = tonumber(var_20_6) >= tonumber(var_20_5.star_reward_need_cnt)
			var_20_5.total_star_count = 0
			
			if not var_20_5.ending_level then
				var_20_2 = var_20_5.id
			end
			
			local var_20_7 = 0
			local var_20_8 = {}
			local var_20_9 = false
			
			for iter_20_1 = 1, var_0_0 do
				if not var_20_5["battle_btn_" .. iter_20_1] then
					break
				end
				
				local var_20_10 = var_20_5["battle_btn_" .. iter_20_1]
				local var_20_11 = false
				local var_20_12, var_20_13 = arg_20_0:getStarCount(var_20_10)
				
				if DEBUG.TREE_SHOW_ALL then
					var_20_12 = 3
					var_20_13 = true
					var_20_7 = var_20_7 + 1
					var_20_11 = true
				elseif Account:isMapCleared(var_20_10) then
					var_20_7 = var_20_7 + 1
					var_20_11 = true
				end
				
				if var_20_12 < 3 then
					var_20_9 = true
				end
				
				var_20_5.total_star_count = var_20_5.total_star_count + var_20_12
				
				local var_20_14 = var_20_8[iter_20_1 - 1] and var_20_8[iter_20_1 - 1].is_cleared
				
				if iter_20_1 == 1 then
					var_20_14 = true
				end
				
				local var_20_15 = DB("level_enter", var_20_10, {
					"name"
				})
				
				var_20_8[iter_20_1] = {
					battle_id = var_20_10,
					story_id = var_20_5["battle_" .. iter_20_1 .. "_story_id"],
					bg_img = var_20_5["battle_" .. iter_20_1 .. "_add_bg_img"],
					star_count = var_20_12,
					is_full_star = var_20_13,
					is_cleared = var_20_11,
					is_prev_cleared = var_20_14,
					name = var_20_15
				}
			end
			
			if not var_20_5.ending_level and var_20_0 and (not var_20_5.is_received_star_reward or var_20_9) then
				var_20_0 = false
			end
			
			var_20_1 = var_20_5.ending_level
			
			if table.count(var_20_8) == var_20_7 then
				var_20_5.is_cleared_all = true
			end
			
			var_20_5.research_datas = var_20_8
			
			table.insert(arg_20_0.vars.all_data, var_20_5)
		end
	end
	
	table.sort(arg_20_0.vars.all_data, function(arg_21_0, arg_21_1)
		return arg_21_0.research_level < arg_21_1.research_level
	end)
	
	if not var_20_1 then
		var_20_0 = var_20_0 and false
	end
	
	arg_20_0.vars.is_end_all = var_20_0
	
	if DEBUG.TREE_SHOW_ALL then
		arg_20_0.vars.is_end_all = true
	end
	
	arg_20_0:checkEnding()
	
	if not arg_20_0.vars.cur_data then
		if arg_20_0.select_idx then
			arg_20_0:selectData(arg_20_0.select_idx)
			arg_20_0:checkNeedUnlockAction(arg_20_0.research_idx)
		elseif arg_20_0.vars.is_end_all then
			local var_20_16 = 1
			
			for iter_20_2, iter_20_3 in pairs(arg_20_0.vars.all_data) do
				if iter_20_3.ending_level then
					var_20_16 = iter_20_2
					
					break
				end
			end
			
			arg_20_0:selectData(var_20_16)
		else
			arg_20_0:selectData(1)
		end
	end
	
	if table.count(arg_20_0.vars.all_data) == 1 then
		if_set_visible(arg_20_0.vars.wnd, "btn_vampire_arrow", false)
		if_set_visible(arg_20_0.vars.wnd, "btn_elf_arrow", false)
		if_set_visible(arg_20_0.vars.wnd, "btn_title", false)
	end
	
	arg_20_0:updateNewTreeDataNoti(arg_20_0.vars.camp_type, var_20_2)
end

function OriginTree.checkEnding(arg_22_0)
	if arg_22_0.vars.is_end_all then
		local var_22_0 = {}
		
		for iter_22_0, iter_22_1 in pairs(arg_22_0.vars.all_data) do
			if not iter_22_1.ending_level then
				local var_22_1 = iter_22_1.research_datas
				
				for iter_22_2, iter_22_3 in pairs(var_22_1) do
					table.insert(var_22_0, iter_22_3)
				end
			else
				iter_22_1.research_datas = var_22_0
				
				break
			end
		end
	else
		local var_22_2
		
		for iter_22_4, iter_22_5 in pairs(arg_22_0.vars.all_data) do
			if iter_22_5.ending_level and iter_22_5.ending_level == "y" then
				var_22_2 = iter_22_4
			end
		end
		
		if var_22_2 then
			table.remove(arg_22_0.vars.all_data, var_22_2)
		end
	end
end

function OriginTree.getStarCount(arg_23_0, arg_23_1)
	if not arg_23_1 then
		return 
	end
	
	local var_23_0 = Account:getStageScore(arg_23_1) or 0
	local var_23_1 = var_23_0 >= var_0_1
	
	return var_23_0, var_23_1
end

function OriginTree.getCurData(arg_24_0)
	return arg_24_0.vars.cur_data
end

function OriginTree.getCurResearch(arg_25_0)
	return arg_25_0:getCurData().research_datas
end

function OriginTree.selectData(arg_26_0, arg_26_1)
	arg_26_0.vars.select_idx = arg_26_1
	arg_26_0.vars.cur_data = arg_26_0.vars.all_data[arg_26_1]
end

function OriginTree.updateAll(arg_27_0, arg_27_1)
	arg_27_0:updateData()
	arg_27_0:updateUI(arg_27_1)
end

function OriginTree._update_all(arg_28_0)
	arg_28_0:updateScrollView()
	
	if arg_28_0.vars.is_end_all and arg_28_0:getCurData().ending_level then
		arg_28_0:updateEndAllBG()
		if_set_visible(arg_28_0.vars.wnd, "bottom", false)
		arg_28_0:updateScrollviewSize(true)
	else
		arg_28_0:updateBG()
		if_set_visible(arg_28_0.vars.wnd, "bottom", true)
		arg_28_0:updateStar()
		arg_28_0:updateNotiUI()
		arg_28_0:updateScrollviewSize(false)
	end
end

function OriginTree.updateScrollviewSize(arg_29_0, arg_29_1)
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.vars.wnd) then
		return 
	end
	
	local var_29_0 = arg_29_0.vars.wnd:getChildByName("scroll_view")
	
	if get_cocos_refid(var_29_0) then
		if not var_29_0.origin_size then
			var_29_0.origin_size = var_29_0:getContentSize()
		end
		
		local var_29_1 = var_29_0.origin_size
		
		if arg_29_1 then
			var_29_1.height = var_29_1.height + 98
		end
		
		arg_29_0:setSize(var_29_1.width, var_29_1.height, true, false)
	end
end

function OriginTree.updateNewTreeDataNoti(arg_30_0, arg_30_1, arg_30_2)
	if not arg_30_1 or not arg_30_2 then
		return 
	end
	
	SAVE:setKeep("origin_tree_last_" .. arg_30_1, arg_30_2)
end

function OriginTree.getNewTreeDataNoti(arg_31_0, arg_31_1, arg_31_2)
	if not arg_31_1 or not arg_31_2 then
		return 
	end
	
	local var_31_0 = SAVE:getKeep("origin_tree_last_" .. arg_31_1)
	
	if not var_31_0 or var_31_0 ~= arg_31_2 then
		return true
	end
end

function OriginTree.updateNotiOnMissionBaseUI(arg_32_0, arg_32_1)
	if not arg_32_1 then
		return 
	end
	
	if arg_32_1 == TREE_ELF and not UnlockSystem:isUnlockSystem(UNLOCK_ID.ORIGIN_TREE_ELF) or arg_32_1 == TREE_VAM and not UnlockSystem:isUnlockSystem(UNLOCK_ID.ORIGIN_TREE_VAM) then
		return 
	end
	
	local var_32_0, var_32_1 = arg_32_0:needStarReward(arg_32_1)
	
	if var_32_0 then
		return true
	end
	
	local var_32_2
	
	for iter_32_0 = 1, 999999 do
		local var_32_3, var_32_4 = DBN("ep5_tree", iter_32_0, {
			"id",
			"camp_type"
		})
		
		if not var_32_3 then
			break
		end
		
		if arg_32_1 and arg_32_1 == var_32_4 then
			local var_32_5 = DBT("ep5_tree", var_32_3, {
				"id",
				"scene_title",
				"category_name",
				"research_bg_img",
				"camp_type",
				"research_level",
				"ending_level",
				"battle_btn_1",
				"battle_1_add_bg_img",
				"battle_1_story_id",
				"battle_btn_2",
				"battle_2_add_bg_img",
				"battle_2_story_id",
				"battle_btn_3",
				"battle_3_add_bg_img",
				"battle_3_story_id",
				"battle_btn_4",
				"battle_4_add_bg_img",
				"battle_4_story_id"
			})
			local var_32_6 = OriginTree:getStarRewardData(var_32_3)
			local var_32_7 = Account:checkReceivedTreeRewardById(var_32_5.id)
			
			if not var_32_5.ending_level then
				var_32_2 = var_32_5.id
			end
			
			if var_32_7 < var_32_6 then
				local var_32_8 = 0
				
				for iter_32_1 = 1, var_0_0 do
					if not var_32_5["battle_btn_" .. iter_32_1] then
						break
					end
					
					local var_32_9 = var_32_5["battle_btn_" .. iter_32_1]
					local var_32_10, var_32_11 = arg_32_0:getStarCount(var_32_9)
					
					var_32_8 = var_32_8 + var_32_10
				end
				
				if var_32_6 <= var_32_8 then
					return true
				end
			end
		end
	end
	
	if arg_32_0:getNewTreeDataNoti(arg_32_1, var_32_2) then
		return true
	end
end

function OriginTree.updateNotiUI(arg_33_0)
end

function OriginTree.updateUI(arg_34_0, arg_34_1)
	if not arg_34_0.vars or not get_cocos_refid(arg_34_0.vars.wnd) then
		return 
	end
	
	if arg_34_1 then
		arg_34_0:updateOnSelect()
	else
		arg_34_0:_update_all()
	end
	
	TopBarNew:setTitleName(T(arg_34_0:getCurData().scene_title), "infoadve1_12")
	
	local var_34_0
	
	if arg_34_0.vars.camp_type == TREE_VAM then
		var_34_0 = arg_34_0.vars.wnd:getChildByName("n_vampire")
	elseif arg_34_0.vars.camp_type == TREE_ELF then
		var_34_0 = arg_34_0.vars.wnd:getChildByName("n_elf")
	end
	
	if get_cocos_refid(var_34_0) then
		if_set(var_34_0, "title", T(arg_34_0:getCurData().category_name))
	end
end

function OriginTree.updateStar(arg_35_0)
	if not arg_35_0.vars or not get_cocos_refid(arg_35_0.vars.wnd) then
		return 
	end
	
	local var_35_0 = arg_35_0:getCurData()
	local var_35_1 = arg_35_0:getCurResearch()
	
	if not var_35_0 or not var_35_1 then
		return 
	end
	
	local var_35_2 = arg_35_0.vars.wnd:getChildByName("bottom")
	local var_35_3 = arg_35_0.vars.wnd:getChildByName("progress_bg")
	local var_35_4 = var_35_0.is_received_star_reward
	local var_35_5 = 0
	local var_35_6 = tonumber(var_35_0.star_reward_need_cnt)
	
	for iter_35_0, iter_35_1 in pairs(var_35_1) do
		var_35_5 = iter_35_1.star_count + var_35_5
	end
	
	if_set(var_35_3, "t_percent", var_35_5 .. "/" .. var_35_6)
	if_set_percent(var_35_3, "progress_bar", var_35_5 / var_35_6)
	if_set_color(var_35_3, nil, var_35_6 <= var_35_5 and tocolor("#6bc11b") or tocolor("#926d3e"))
	if_set_visible(var_35_2, "icon_noti", var_35_6 <= var_35_5 and not var_35_4)
	
	local var_35_7 = UIUtil:getRewardIcon(tonumber(var_35_0.star_reward_val), var_35_0.star_reward_type, {
		show_small_count = true,
		parent = var_35_2:getChildByName("reward_item"),
		count = var_35_0.star_reward_val
	})
	
	if_set_opacity(var_35_7, nil, var_35_4 and 76.5 or 255)
	if_set_visible(var_35_2, "icon_check", var_35_4)
end

function OriginTree.reqStarReward(arg_36_0)
	if not arg_36_0.vars or not get_cocos_refid(arg_36_0.vars.wnd) then
		return 
	end
	
	local var_36_0 = arg_36_0:getCurData()
	
	if not var_36_0 or var_36_0.is_received_star_reward then
		balloon_message_with_sound("taked_all")
		
		return 
	end
	
	if var_36_0.total_star_count < var_36_0.star_reward_need_cnt then
		balloon_message_with_sound("not_yet_take_star_reward")
		
		return 
	end
	
	query("origin_tree_star_reward", {
		research_id = var_36_0.id
	})
end

function OriginTree.resStarReward(arg_37_0, arg_37_1)
	if not arg_37_0.vars or not get_cocos_refid(arg_37_0.vars.wnd) or not arg_37_1 then
		return 
	end
	
	arg_37_0:updateAll()
	arg_37_0:updateSelectResearchUI()
	arg_37_0:selectData(arg_37_0.vars.select_idx)
	arg_37_0:updateStar()
	
	if arg_37_0.vars.is_end_all then
		arg_37_0:selectResearch(3)
	end
end

function OriginTree.updateScrollView(arg_38_0)
	if not arg_38_0.vars or not get_cocos_refid(arg_38_0.vars.wnd) then
		return 
	end
	
	if not arg_38_0.vars.scroll_view then
		arg_38_0.vars.scroll_view = arg_38_0.vars.wnd:getChildByName("scroll_view")
		
		arg_38_0:initScrollView(arg_38_0.vars.scroll_view, 314, 67)
	end
	
	local var_38_0 = arg_38_0:getCurResearch()
	
	arg_38_0:createScrollViewItems(var_38_0)
end

function OriginTree.getFirstScrollViewItemForTuto(arg_39_0)
	if not arg_39_0.vars or not get_cocos_refid(arg_39_0.vars.wnd) then
		return 
	end
	
	local var_39_0 = ((arg_39_0.ScrollViewItems or {})[1] or {}).control
	
	if not var_39_0 then
		return 
	end
	
	return var_39_0:getChildByName("btn_touch")
end

function OriginTree.getScrollViewItem(arg_40_0, arg_40_1)
	local var_40_0 = load_control("wnd/map_depth_tree_origin_item.csb")
	local var_40_1 = arg_40_1.star_count
	local var_40_2 = arg_40_1.story_id
	local var_40_3 = arg_40_1.battle_id
	local var_40_4 = Account:isMapCleared(var_40_3)
	local var_40_5 = Account:checkEnterMap(var_40_3)
	local var_40_6 = arg_40_1.is_prev_cleared
	local var_40_7 = arg_40_1.is_full_star
	local var_40_8 = var_40_0:getChildByName("btn_story")
	local var_40_9 = var_40_0:getChildByName("btn_touch")
	local var_40_10 = var_40_0:getChildByName("n_star")
	local var_40_11 = var_40_10:getChildByName("n_3")
	local var_40_12 = var_40_10:getChildByName("n_2")
	
	var_40_8.story_id = arg_40_1.story_id
	var_40_8.can_show = arg_40_1.is_full_star
	var_40_8.is_prev_cleared = var_40_6
	var_40_9.battle_id = var_40_3
	var_40_9.is_prev_cleared = var_40_6
	
	if var_40_1 == 0 then
		if_set_visible(var_40_10, "n_3", false)
		if_set_visible(var_40_10, "n_2", false)
	elseif var_40_1 == 1 then
		if_set_visible(var_40_10, "n_3", true)
		if_set_visible(var_40_10, "n_2", false)
		if_set_visible(var_40_11, "img_star1", true)
		if_set_visible(var_40_11, "img_star2", false)
		if_set_visible(var_40_11, "img_star3", false)
	elseif var_40_1 == 2 then
		if_set_visible(var_40_10, "n_3", false)
		if_set_visible(var_40_10, "n_2", true)
	elseif var_40_1 == 3 then
		if_set_visible(var_40_10, "n_3", true)
		if_set_visible(var_40_10, "n_2", false)
		if_set_visible(var_40_11, "img_star1", true)
		if_set_visible(var_40_11, "img_star2", true)
		if_set_visible(var_40_11, "img_star3", true)
	end
	
	if_set_visible(var_40_0, "icon_checked", var_40_4)
	if_set_visible(var_40_0, "icon_lock", not var_40_6 or not var_40_5)
	if_set(var_40_0, "title", T(arg_40_1.name))
	if_set_color(var_40_0, "title", var_40_4 and tocolor("#6bc11b") or tocolor("#ffffff"))
	if_set_opacity(var_40_0, "n_race_info", var_40_6 and var_40_5 and 255 or 76.5)
	
	if var_40_6 and var_40_5 then
		if_set_opacity(var_40_0, "btn_story", var_40_4 and var_40_7 and 255 or 76.5)
	end
	
	UIUserData:call(var_40_0:getChildByName("title"), "MULTI_SCALE(3,65)")
	
	if arg_40_0.vars.camp_type == TREE_VAM then
		if_set_color(var_40_0, "img_story", tocolor("#ffd45f"))
		if_set_sprite(var_40_0, "img_race", "img/cm_icon_vampires.png")
	elseif arg_40_0.vars.camp_type == TREE_ELF then
		if_set_color(var_40_0, "img_story", tocolor("#5fdbff"))
		if_set_sprite(var_40_0, "img_race", "img/cm_icon_elf.png")
	end
	
	return var_40_0
end

function OriginTree.updateOnSelect(arg_41_0)
	if not get_cocos_refid(arg_41_0.vars.curtain) then
		arg_41_0.vars.curtain = cc.LayerColor:create(cc.c3b(0, 0, 0))
		
		local var_41_0 = SceneManager:getDefaultLayer()
		
		arg_41_0.vars.curtain:setOpacity(0)
		arg_41_0.vars.curtain:setPosition(VIEW_BASE_LEFT, 0)
		arg_41_0.vars.curtain:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
		arg_41_0.vars.wnd:addChild(arg_41_0.vars.curtain)
		arg_41_0.vars.curtain:bringToFront()
		arg_41_0.vars.curtain:setVisible(false)
	end
	
	arg_41_0.vars.curtain:setVisible(true)
	UIAction:Add(SEQ(FADE_IN(400), DELAY(200), CALL(function()
		arg_41_0:_update_all()
	end), DELAY(200), FADE_OUT(800)), arg_41_0.vars.curtain, "block")
end

function OriginTree.updateEndAllBG(arg_43_0)
	if not arg_43_0.vars or not get_cocos_refid(arg_43_0.vars.wnd) then
		return 
	end
	
	local var_43_0 = arg_43_0:getCurData()
	
	for iter_43_0 = 1, 4 do
		local var_43_1 = string.format("%s_%02d", "n_painting", iter_43_0)
		local var_43_2 = arg_43_0.vars.wnd:getChildByName(var_43_1)
		
		if get_cocos_refid(var_43_2) then
			var_43_2:setVisible(false)
		end
	end
	
	local var_43_3 = var_43_0.research_bg_img
	local var_43_4 = getChildByPath(arg_43_0.vars.wnd, "bg")
	
	if get_cocos_refid(var_43_4) then
		if_set_sprite(var_43_4, nil, "map/" .. var_43_3)
	end
end

function OriginTree.updateBG(arg_44_0)
	if not arg_44_0.vars or not get_cocos_refid(arg_44_0.vars.wnd) then
		return 
	end
	
	local var_44_0 = arg_44_0:getCurData()
	local var_44_1 = arg_44_0:getCurResearch()
	
	for iter_44_0, iter_44_1 in pairs(var_44_1) do
		local var_44_2 = string.format("%s_%02d", "n_painting", iter_44_0)
		local var_44_3 = arg_44_0.vars.wnd:getChildByName(var_44_2)
		
		if get_cocos_refid(var_44_3) then
			local var_44_4 = iter_44_1.is_full_star
			
			var_44_3:setVisible(var_44_4)
			
			if not var_44_3.init_img then
				if_set_sprite(var_44_3, "img_painting", "map/" .. iter_44_1.bg_img .. ".png")
				
				var_44_3.init_img = true
			end
		end
	end
	
	local var_44_5 = var_44_0.research_bg_img
	local var_44_6 = getChildByPath(arg_44_0.vars.wnd, "bg")
	
	if get_cocos_refid(var_44_6) then
		if_set_sprite(var_44_6, nil, "map/" .. var_44_5)
	end
end

function OriginTree.checkNeedUnlockAction(arg_45_0, arg_45_1)
	if not arg_45_0.vars or not get_cocos_refid(arg_45_0.vars.wnd) or not arg_45_1 then
		return 
	end
	
	local var_45_0 = arg_45_0.prev_star_count or 0
	local var_45_1 = 0
	local var_45_2 = arg_45_0:getCurResearch()
	
	if var_45_2 and var_45_2[arg_45_1] then
		var_45_1 = var_45_2[arg_45_1].star_count
	end
	
	if tonumber(var_45_1) > tonumber(var_45_0) and var_45_1 >= 3 then
		arg_45_0:startUnlockAction(arg_45_1)
	end
end

function OriginTree.startUnlockAction(arg_46_0, arg_46_1)
	if not arg_46_0.vars or not get_cocos_refid(arg_46_0.vars.wnd) or not arg_46_1 then
		return 
	end
	
	local var_46_0 = arg_46_0:getCurData()
	local var_46_1 = arg_46_0:getCurResearch()
	
	if not var_46_1[arg_46_1] then
		return 
	end
	
	local var_46_2
	
	for iter_46_0, iter_46_1 in pairs(var_46_1) do
		local var_46_3 = string.format("%s_%02d", "n_painting", iter_46_0)
		local var_46_4 = arg_46_0.vars.wnd:getChildByName(var_46_3)
		
		if get_cocos_refid(var_46_4) then
			local var_46_5 = iter_46_1.is_full_star
			
			var_46_4:setVisible(var_46_5)
			
			if iter_46_0 == arg_46_1 then
				var_46_4:setOpacity(0)
				SoundEngine:play("event:/effect/ep5_tree_doodle")
				
				var_46_2 = iter_46_1.story_id
				
				UIAction:Add(SEQ(DELAY(300), FADE_IN(800), DELAY(900), CALL(function()
					if var_46_2 then
						play_story(var_46_2)
					end
				end)), var_46_4, "block")
			end
		end
	end
end

function OriginTree.playStory(arg_48_0, arg_48_1)
	if not arg_48_0.vars.cur_research_data.story_id then
		return 
	end
end

function OriginTree.openBattleReady(arg_49_0, arg_49_1, arg_49_2)
	if not arg_49_1 then
		return 
	end
	
	local var_49_0 = {}
	
	if not Account:checkEnterMap(arg_49_1, var_49_0) then
		local var_49_1 = UIUtil:setMsgCheckEnterMapErr(arg_49_1, var_49_0)
		
		if var_49_0 and var_49_0.map_ids and var_49_0.map_ids[1] then
			local var_49_2 = var_49_0.map_ids[1]
			local var_49_3 = DB("level_enter", var_49_2, {
				"episode"
			})
			
			if var_49_3 and var_49_3 == "adventure_ep5" and not Account:checkEnterMap(var_49_2) then
				balloon_message_with_sound("hidden_stage_unlock_msg_ep5")
			else
				balloon_message_with_sound_raw_text(var_49_1)
			end
		else
			balloon_message_with_sound_raw_text(var_49_1)
		end
		
		return 
	end
	
	if not arg_49_2 then
		balloon_message_with_sound("ep5_tree_err_02")
		
		return 
	end
	
	BattleReady:show({
		hide_open_difficulty = true,
		is_tree = true,
		enter_id = arg_49_1,
		callback = arg_49_0
	})
	TutorialGuide:procGuide()
end

function OriginTree.onStartBattle(arg_50_0, arg_50_1)
	startBattle(arg_50_1.enter_id, arg_50_1)
	
	local var_50_0 = arg_50_0:getCurResearch()
	
	if var_50_0 then
		for iter_50_0, iter_50_1 in pairs(var_50_0) do
			if iter_50_1.battle_id and iter_50_1.battle_id == arg_50_1.enter_id then
				arg_50_0.prev_star_count = iter_50_1.star_count
				arg_50_0.research_idx = iter_50_0
				
				break
			end
		end
		
		arg_50_0.select_idx = arg_50_0.vars.select_idx
		arg_50_0.camp_type = arg_50_0.vars.camp_type
	end
	
	local var_50_1 = WorldMapManager:getController()
	local var_50_2 = var_50_1:getTown()
	
	if var_50_2 then
		local var_50_3 = var_50_2:getCurTown()
		
		if var_50_3 then
			local var_50_4 = DB("level_enter", var_50_3, {
				"type"
			})
			
			if WORLDMAP_MODE_LIST[var_50_4] then
				var_50_1:saveLastTown(var_50_3)
			end
		end
	end
end

function OriginTree.getSceneState(arg_51_0)
	return arg_51_0.select_idx, arg_51_0.prev_star_count, arg_51_0.camp_type
end

function OriginTree.removeSceneState(arg_52_0)
	arg_52_0.select_idx = nil
	arg_52_0.prev_star_count = nil
	arg_52_0.camp_type = nil
	arg_52_0.research_idx = nil
end

function OriginTree.close(arg_53_0)
	if not arg_53_0.vars or not get_cocos_refid(arg_53_0.vars.wnd) then
		return 
	end
	
	TopBarNew:pop()
	BackButtonManager:pop("map_depth_tree_bg")
	arg_53_0:removeSceneState()
	arg_53_0.vars.wnd:removeFromParent()
	
	arg_53_0.vars = nil
	
	local var_53_0 = WorldMapManager:getController()
	
	if var_53_0 then
		local var_53_1 = var_53_0:getWorldMapUI()
		
		if var_53_1 then
			var_53_1:UpdateAfterShowTown()
		end
	end
end
