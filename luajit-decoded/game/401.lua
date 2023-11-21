ChristmasBuildingPopup = {}
ChristmasTreePopup = {}

local var_0_0 = 5
local var_0_1 = 7

function HANDLER.battle_story_christmas_village_popup(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		ChristmasBuildingPopup:closeBuildingPopup()
	elseif arg_1_1 and string.starts(arg_1_1, "btn_story") then
		ChristmasBuildingPopup:show_story(arg_1_0.story_id, arg_1_0.story_can_see)
	elseif arg_1_1 and string.starts(arg_1_1, "btn_production_") then
		ChristmasBuildingPopup:press_item_icon(string.sub(arg_1_1, -1, -1))
	elseif arg_1_1 == "btn_extension" then
		ChristmasBuildingPopup:req_upgrade()
	elseif arg_1_1 == "btn_produce" then
		ChristmasBuildingPopup:req_craft_item(arg_1_0.can_craft, arg_1_0.craft_item_id, arg_1_0.craft_item_idx)
	end
end

function MsgHandler.substory_village_levelup_building(arg_2_0)
	if arg_2_0 then
		if arg_2_0.dec_result then
			Account:addReward(arg_2_0.dec_result)
		end
		
		if arg_2_0.rewards then
			local var_2_0 = false
			
			if arg_2_0.rewards.new_items and arg_2_0.rewards.new_items[1] then
				var_2_0 = true
			end
			
			if arg_2_0.rewards.currency_time then
				for iter_2_0, iter_2_1 in ipairs(arg_2_0.rewards.currency_time) do
					if Account:isCurrencyType(iter_2_0) then
						Account:setCurrencyTime(iter_2_0, iter_2_1)
					end
				end
				
				var_2_0 = true
			end
			
			local var_2_1 = Account:addReward(arg_2_0.rewards, {
				effect = true,
				single = var_2_0
			})
			
			if var_2_1.rewards and var_2_1.rewards[1] then
				local var_2_2 = var_2_1.rewards[1]
				
				if var_2_2.code and string.starts(var_2_2.code, "e") then
					Dialog:ShowRareDrop({
						count = 1,
						code = var_2_2.item.code,
						grade = var_2_2.item.grade
					})
				end
			end
		end
		
		if false then
		end
		
		if arg_2_0.substory_info then
			Account:setSubStory(arg_2_0.substory_info.substory_id, arg_2_0.substory_info)
		end
		
		SubStoryChristmasVillage:setWorldmapUpdate(true)
		ChristmasBuildingPopup:res_upgrade(arg_2_0)
		
		local var_2_3 = Account:getSubStoryContents(arg_2_0.substory_info.substory_id).content_village.buildings or {}
		
		ConditionContentsManager:dispatch("village.building.lv", {
			buildings = var_2_3
		})
	end
end

function MsgHandler.substory_village_produce_item(arg_3_0)
	if arg_3_0 then
		if arg_3_0.dec_result then
			Account:addReward(arg_3_0.dec_result)
		end
		
		if arg_3_0.substory_info then
			Account:setSubStory(arg_3_0.substory_info.substory_id, arg_3_0.substory_info)
		end
		
		ChristmasBuildingPopup:res_craft_item(arg_3_0)
	end
end

local function var_0_2(arg_4_0)
	if arg_4_0 and arg_4_0.rewards then
		local var_4_0 = {}
		
		for iter_4_0, iter_4_1 in pairs(arg_4_0.rewards) do
			if not iter_4_1.is_randombox then
				table.insert(var_4_0, iter_4_1)
			end
		end
		
		Dialog:msgScrollRewards(T("village_product_popup_desc"), {
			open_effect = true,
			title = T("village_product_popup_title"),
			rewards = var_4_0
		})
	end
end

function MsgHandler.substory_village_get_item(arg_5_0)
	if arg_5_0 then
		if arg_5_0.dec_result then
			Account:addReward(arg_5_0.dec_result)
		end
		
		if arg_5_0.rewards then
			local var_5_0 = Account:addReward(arg_5_0.rewards)
			
			var_0_2(var_5_0)
		end
		
		if arg_5_0.substory_info then
			Account:setSubStory(arg_5_0.substory_info.substory_id, arg_5_0.substory_info)
		end
		
		ChristmasBuildingPopup:res_get_craft_item(arg_5_0)
	end
end

function MsgHandler.substory_village_cancel_item(arg_6_0)
	if arg_6_0 then
		if arg_6_0.result then
			Account:addReward(arg_6_0.result)
		end
		
		if arg_6_0.substory_info then
			Account:setSubStory(arg_6_0.substory_info.substory_id, arg_6_0.substory_info)
		end
		
		ChristmasBuildingPopup:res_cancle_craft_item(arg_6_0)
	end
end

function ChristmasBuildingPopup.openBuildingPopup(arg_7_0, arg_7_1)
	arg_7_0.vars = {}
	arg_7_0.vars.wnd = load_dlg("battle_story_christmas_village_popup", true, "wnd", function()
		ChristmasBuildingPopup:closeBuildingPopup()
	end)
	
	SceneManager:getRunningPopupScene():addChild(arg_7_0.vars.wnd)
	
	local var_7_0 = SubstoryManager:getInfo() or {}
	
	arg_7_0.vars.substory_id = var_7_0.id or "vch1aa"
	
	if arg_7_1 == "bridge" then
		arg_7_0.vars.main_wnd = arg_7_0.vars.wnd:getChildByName("n_window")
		
		if_set_visible(arg_7_0.vars.wnd, "n_window", true)
		if_set_visible(arg_7_0.vars.wnd, "n_window_2", false)
	elseif arg_7_1 == "hall" or arg_7_1 == "restaurant" or arg_7_1 == "concert" or arg_7_1 == "hospital" then
		arg_7_0.vars.main_wnd = arg_7_0.vars.wnd:getChildByName("n_window_2")
		
		if_set_visible(arg_7_0.vars.wnd, "n_window", false)
		if_set_visible(arg_7_0.vars.wnd, "n_window_2", true)
	end
	
	arg_7_0.vars.mode = arg_7_1
	arg_7_0.vars.is_bridge = arg_7_1 == "bridge"
	
	arg_7_0:update_data()
	
	if not arg_7_0.vars.cur_data then
		return 
	end
	
	arg_7_0:update_ui()
	
	if not arg_7_0.vars.is_bridge then
		arg_7_0:refresh_craft()
	end
	
	if not arg_7_0.vars.is_bridge and arg_7_0.vars.request_owner then
		arg_7_0:req_get_craft_item()
	end
	
	TutorialGuide:procGuide()
	arg_7_0:check_tutorial()
end

function ChristmasBuildingPopup.check_tutorial(arg_9_0)
	if TutorialGuide:isPlayingTutorial() then
		return 
	end
	
	if arg_9_0.vars.mode == "restaurant" then
		local var_9_0 = arg_9_0.vars.cur_data.restaurant
		
		if arg_9_0.vars.cur_data.cur_level >= 2 and TutorialGuide:startGuide("substory_vch1ba_2nd") then
			return 
		end
	end
end

function ChristmasBuildingPopup.update_data(arg_10_0)
	arg_10_0.vars.cur_data = SubStoryChristmasVillage:getCurData(arg_10_0.vars.mode)
	arg_10_0.vars.building_data = SubStoryChristmasVillage:getBuilding_data(arg_10_0.vars.mode)
end

function ChristmasBuildingPopup.update_ui(arg_11_0)
	local var_11_0 = tonumber(arg_11_0.vars.cur_data.cur_level)
	local var_11_1 = tonumber(arg_11_0.vars.cur_data.max_lv)
	local var_11_2 = "map/" .. arg_11_0.vars.cur_data.icon
	local var_11_3 = cc.Sprite:create(var_11_2)
	local var_11_4 = arg_11_0.vars.main_wnd:getChildByName("n_building")
	local var_11_5 = arg_11_0.vars.main_wnd:getChildByName("n_extension")
	
	if get_cocos_refid(var_11_4) and var_11_3 then
		var_11_4:removeAllChildren()
		var_11_4:addChild(var_11_3)
	end
	
	local var_11_6 = var_11_1 <= var_11_0
	
	arg_11_0.vars.can_upgrade = true
	arg_11_0.vars.upgrade_err_msg = nil
	
	if_set_visible(arg_11_0.vars.main_wnd, "n_extension", not var_11_6)
	if_set_visible(arg_11_0.vars.main_wnd, "n_no_extension", var_11_6)
	if_set_opacity(arg_11_0.vars.main_wnd:getChildByName("n_reward_extension_info"), "n_item", not var_11_6 and 255 or 76.5)
	if_set(arg_11_0.vars.main_wnd, "t_building", T(arg_11_0.vars.cur_data.name))
	
	if not var_11_6 then
		local var_11_7 = SubStoryChristmasVillage:getDataByLevel(arg_11_0.vars.mode, var_11_0 + 1)
		
		for iter_11_0 = 1, 2 do
			local var_11_8 = var_11_7["lv_up_material_item_" .. iter_11_0]
			local var_11_9 = var_11_7["lv_up_material_value_" .. iter_11_0]
			local var_11_10 = "n_item" .. iter_11_0
			local var_11_11 = var_11_5:getChildByName(var_11_10)
			
			if var_11_8 and var_11_9 and var_11_11 then
				var_11_11:removeAllChildren()
				
				local var_11_12 = UIUtil:getRewardIcon(var_11_9, var_11_8, {
					parent = var_11_11
				})
				
				if Account:getItemCount(var_11_8) < tonumber(var_11_9) then
					arg_11_0.vars.can_upgrade = false
					arg_11_0.vars.upgrade_err_msg = T("village_err_03")
					
					var_11_12:setOpacity(76.5)
				end
			end
		end
		
		local var_11_13 = arg_11_0.vars.main_wnd:getChildByName("txt_mission")
		
		if get_cocos_refid(var_11_13) and var_11_7.lv_up_clear_stage then
			local var_11_14 = DB("level_enter", var_11_7.lv_up_clear_stage, {
				"name"
			})
			
			if_set(var_11_13, nil, T("village_ui_01", {
				stage = T(var_11_14)
			}))
			
			if not Account:isMapCleared(var_11_7.lv_up_clear_stage) then
				arg_11_0.vars.can_upgrade = false
				arg_11_0.vars.upgrade_err_msg = T("village_err_02", {
					stage = T(var_11_14)
				})
			end
		end
		
		if_set_opacity(arg_11_0.vars.main_wnd, "btn_extension", arg_11_0.vars.can_upgrade and 255 or 76.5)
	else
		arg_11_0.vars.can_upgrade = false
		arg_11_0.vars.upgrade_err_msg = T("village_err_01")
	end
	
	local function var_11_15(arg_12_0)
		if not arg_12_0 then
			return 
		end
		
		if arg_12_0.lv_up_reward_item and arg_12_0.lv_up_reward_value then
			local var_12_0 = arg_11_0.vars.main_wnd:getChildByName("n_reward_extension_info")
			
			if get_cocos_refid(var_12_0) then
				local var_12_1 = var_12_0:getChildByName("n_item")
				
				var_12_1:removeAllChildren()
				
				local var_12_2 = {}
				local var_12_3
				local var_12_4
				
				if string.starts(arg_12_0.lv_up_reward_item, "e") then
					var_12_2 = {
						parent = var_12_1,
						grade_rate = arg_12_0.lv_up_reward_grade_rate,
						set_fx = arg_12_0.lv_up_reward_set_drop_rate_id
					}
					var_12_4 = "equip"
				else
					var_12_2 = {
						parent = var_12_1
					}
					var_12_4 = arg_12_0.lv_up_reward_value
				end
				
				UIUtil:getRewardIcon(var_12_4, arg_12_0.lv_up_reward_item, var_12_2)
			end
		end
	end
	
	local var_11_16
	
	if not var_11_6 then
		var_11_16 = SubStoryChristmasVillage:getDataByLevel(arg_11_0.vars.mode, var_11_0 + 1)
	else
		var_11_16 = arg_11_0.vars.cur_data
	end
	
	var_11_15(var_11_16)
	
	if not arg_11_0.vars.is_bridge then
		arg_11_0:update_productUI()
	end
	
	arg_11_0:update_storyUI()
end

function ChristmasBuildingPopup.update_productUI(arg_13_0)
	if arg_13_0.vars.is_bridge then
		return 
	end
	
	local var_13_0 = arg_13_0.vars.main_wnd:getChildByName("n_prodiction")
	local var_13_1 = tonumber(arg_13_0.vars.cur_data.cur_level)
	
	if get_cocos_refid(var_13_0) then
		for iter_13_0 = 1, 2 do
			local var_13_2 = var_13_0:getChildByName("n_produce_" .. iter_13_0)
			
			if get_cocos_refid(var_13_2) then
				local var_13_3 = tonumber(arg_13_0.vars.building_data["craft_item_" .. iter_13_0 .. "_need_lv"])
				local var_13_4 = arg_13_0.vars.building_data["craft_item_" .. iter_13_0 .. "_id"]
				local var_13_5 = arg_13_0.vars.building_data["craft_item_" .. iter_13_0 .. "_material"]
				local var_13_6 = arg_13_0.vars.building_data["craft_item_" .. iter_13_0 .. "_material_value"]
				
				if var_13_3 and var_13_4 and var_13_5 and var_13_6 then
					var_13_2:setVisible(true)
					
					local var_13_7 = var_13_2:getChildByName("btn_produce")
					local var_13_8 = var_13_2:getChildByName("n_lock")
					local var_13_9 = var_13_2:getChildByName("n_time")
					local var_13_10 = var_13_3 <= var_13_1
					
					if_set_visible(var_13_7, nil, var_13_10)
					if_set_visible(var_13_9, nil, var_13_10)
					if_set_visible(var_13_8, nil, not var_13_10)
					
					if not var_13_10 then
						local var_13_11 = SubStoryChristmasVillage:getDataByLevel(arg_13_0.vars.mode, var_13_3)
						
						if var_13_11 then
							if_set(var_13_8, "t_lock", T("village_ui_02", {
								name = T(var_13_11.name)
							}))
						end
					end
					
					var_13_7.can_craft = var_13_10
					var_13_7.craft_item_id = var_13_4
					var_13_7.craft_item_idx = iter_13_0
					
					local var_13_12, var_13_13 = DB("substory_village_craft", var_13_4, {
						"craft_item",
						"craft_time"
					})
					
					UIUtil:getRewardIcon(nil, var_13_12, {
						parent = var_13_2:getChildByName("n_item_" .. iter_13_0)
					})
					if_set(var_13_2, "t_produce_" .. iter_13_0, T(var_13_4))
					
					if var_13_10 then
						if_set(var_13_7, "t", var_13_6)
						
						if var_13_13 then
							if_set(var_13_2, "t_time", T("village_info_desc_4", {
								time = sec_to_full_string(var_13_13 * 60)
							}))
						end
						
						UIUtil:getRewardIcon(nil, var_13_5, {
							no_bg = true,
							parent = var_13_7:getChildByName("n_token")
						})
					end
				else
					var_13_2:setVisible(false)
				end
			end
		end
	end
end

function ChristmasBuildingPopup.update_storyUI(arg_14_0)
	local var_14_0 = tonumber(arg_14_0.vars.building_data.story_btn_cnt)
	local var_14_1 = arg_14_0.vars.main_wnd:getChildByName("n_story")
	local var_14_2 = arg_14_0.vars.cur_data.cur_level
	local var_14_3 = arg_14_0.vars.is_bridge and 1 or 2
	
	if get_cocos_refid(var_14_1) then
		for iter_14_0 = 1, var_14_3 do
			local var_14_4 = var_14_1:getChildByName("btn_story" .. iter_14_0)
			local var_14_5 = var_14_1:getChildByName("icon_check" .. iter_14_0)
			
			if get_cocos_refid(var_14_4) and get_cocos_refid(var_14_5) and iter_14_0 <= var_14_0 then
				local var_14_6 = arg_14_0.vars.building_data["story_" .. iter_14_0 .. "_need_lv"]
				local var_14_7 = arg_14_0.vars.building_data["story_" .. iter_14_0]
				local var_14_8 = var_14_6 <= var_14_2
				
				var_14_5:setVisible(var_14_8)
				if_set_opacity(var_14_4, nil, var_14_8 and 255 or 76.5)
				
				var_14_4.story_can_see = var_14_8
				var_14_4.story_id = var_14_7
			end
		end
	end
end

function ChristmasBuildingPopup.show_story(arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_1 then
		return 
	end
	
	if not arg_15_2 then
		balloon_message_with_sound("village_err_04")
		
		return 
	end
	
	local var_15_0 = {}
	
	play_story(arg_15_1, {
		force = true,
		on_finish = function()
			ChristmasBuildingPopup:update_storyUI()
			ChristmasBuildingPopup:check_tutorial()
		end,
		choice_id = var_15_0
	})
end

function ChristmasBuildingPopup.refresh_craft(arg_17_0)
	local var_17_0 = arg_17_0.vars.main_wnd:getChildByName("n_production")
	
	arg_17_0.vars.craft_items = ChristmasCraftManager:get_craft_item_data()
	arg_17_0.vars.can_request_get_item = false
	arg_17_0.vars.request_owner = false
	
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.craft_items) do
		local var_17_1 = string.format("%s_%02d", "n_production", iter_17_0)
		local var_17_2 = var_17_0:getChildByName(var_17_1)
		
		if get_cocos_refid(var_17_2) then
			local var_17_3 = var_17_2:getChildByName("reward_item")
			
			var_17_3:removeAllChildren()
			var_17_3:setVisible(true)
			
			if not iter_17_1.parent_node then
				iter_17_1.parent_node = var_17_2
			end
			
			local var_17_4 = UIUtil:getRewardIcon(nil, iter_17_1.craft_item, {
				parent = var_17_3
			})
			local var_17_5 = iter_17_1.can_receive
			
			if_set_visible(var_17_2, "n_time", not var_17_5)
			if_set_visible(var_17_2, "img_check", var_17_5)
			
			if var_17_5 then
				arg_17_0.vars.can_request_get_item = true
				
				if arg_17_0.vars.request_owner == false then
					arg_17_0.vars.request_owner = arg_17_0.vars.mode == iter_17_1.type
				end
			else
				local var_17_6 = sec_to_full_string(iter_17_1.left_time)
				
				if_set(var_17_2, "t_time", var_17_6)
			end
		end
	end
	
	for iter_17_2 = table.count(arg_17_0.vars.craft_items) + 1, var_0_0 do
		local var_17_7 = string.format("%s_%02d", "n_production", iter_17_2)
		local var_17_8 = var_17_0:getChildByName(var_17_7)
		
		if get_cocos_refid(var_17_8) then
			var_17_8:getChildByName("reward_item"):removeAllChildren()
			if_set_visible(var_17_8, "n_time", false)
			if_set_visible(var_17_8, "img_check", false)
		end
	end
	
	if not arg_17_0.vars.time_scheduler then
		arg_17_0.vars.time_scheduler = Scheduler:addGlobalInterval(1000, arg_17_0.onUpdate_craft, arg_17_0)
		
		arg_17_0.vars.time_scheduler:setName("popup.onUpdate_craft")
	end
end

function ChristmasBuildingPopup.onUpdate_craft(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.wnd) or not arg_18_0.vars.craft_items then
		Scheduler:removeByName("popup.onUpdate_craft")
		
		return 
	end
	
	arg_18_0.vars.craft_items = ChristmasCraftManager:get_craft_item_data() or {}
	
	for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.craft_items) do
		local var_18_0 = iter_18_1.parent_node
		
		if get_cocos_refid(var_18_0) then
			local var_18_1 = iter_18_1.can_receive
			
			if_set_visible(var_18_0, "n_time", not var_18_1)
			if_set_visible(var_18_0, "img_check", var_18_1)
			
			if var_18_1 then
				if arg_18_0.vars.can_request_get_item == false then
					arg_18_0.vars.can_request_get_item = true
					
					if arg_18_0.vars.request_owner == false then
						arg_18_0.vars.request_owner = arg_18_0.vars.mode == iter_18_1.type
					end
				end
			else
				local var_18_2 = sec_to_full_string(iter_18_1.left_time)
				
				if_set(var_18_0, "t_time", var_18_2)
			end
		end
	end
end

function ChristmasBuildingPopup.press_item_icon(arg_19_0, arg_19_1)
	if not arg_19_1 then
		return 
	end
	
	local var_19_0 = tonumber(arg_19_1) or 1
	local var_19_1 = arg_19_0.vars.craft_items[var_19_0]
	
	if not var_19_1 then
		return 
	end
	
	if var_19_1.can_receive then
		arg_19_0:req_get_craft_item()
	else
		arg_19_0:req_cancle_craft_item(var_19_1)
	end
end

function ChristmasBuildingPopup.req_upgrade(arg_20_0)
	local var_20_0 = arg_20_0.vars.upgrade_err_msg or ""
	
	if not arg_20_0.vars.can_upgrade then
		balloon_message_with_sound_raw_text(var_20_0)
		
		return 
	end
	
	local var_20_1 = arg_20_0.vars.cur_data.cur_level
	
	if var_20_1 >= arg_20_0.vars.cur_data.max_lv then
		return 
	end
	
	if SubStoryChristmasVillage:isCloseSubstory() then
		return 
	end
	
	Dialog:msgBox(T("village_info_popup_desc"), {
		yesno = true,
		title = T("village_info_btn"),
		handler = function()
			query("substory_village_levelup_building", {
				building_id = arg_20_0.vars.cur_data.building_id,
				substory_id = arg_20_0.vars.substory_id,
				cur_lv = var_20_1
			})
		end
	})
end

function ChristmasBuildingPopup.res_upgrade(arg_22_0, arg_22_1)
	if not arg_22_1 or not arg_22_0.vars or not get_cocos_refid(arg_22_0.vars.wnd) then
		return 
	end
	
	local var_22_0 = arg_22_0.vars.cur_data.type
	
	SubStoryChristmasVillage:updateAfterUpgradeBuilding("substory_village_levelup_building", var_22_0)
	arg_22_0:update_data()
	arg_22_0:update_ui()
	
	if not arg_22_0.vars.is_bridge then
		arg_22_0:refresh_craft()
	end
	
	local var_22_1 = tonumber(arg_22_0.vars.cur_data.cur_level)
	local var_22_2
	local var_22_3 = tonumber(arg_22_0.vars.building_data.story_1_need_lv) or -1
	local var_22_4 = tonumber(arg_22_0.vars.building_data.story_2_need_lv) or -1
	
	if var_22_1 == var_22_3 then
		var_22_2 = arg_22_0.vars.building_data.story_1
	elseif var_22_1 == var_22_4 then
		var_22_2 = arg_22_0.vars.building_data.story_2
	end
	
	local var_22_5 = SceneManager:getRunningPopupScene()
	local var_22_6 = cc.c3b(0, 0, 0)
	local var_22_7 = cc.LayerColor:create(var_22_6)
	
	var_22_7:setContentSize(VIEW_WIDTH, VIEW_WIDTH)
	var_22_7:setPosition(VIEW_BASE_LEFT, 0)
	var_22_7:setLocalZOrder(99999)
	var_22_7:setOpacity(153)
	var_22_5:addChild(var_22_7)
	
	local var_22_8 = arg_22_0.vars.wnd:getChildByName("n_effect")
	local var_22_9 = EffectManager:Play({
		z = 99999,
		fn = "ui_vch1aa1.cfx",
		layer = var_22_5,
		x = var_22_8:getPositionX(),
		y = var_22_8:getPositionY()
	})
	
	UIAction:Add(SEQ(DELAY(3200), CALL(function()
		if var_22_2 then
			arg_22_0:show_story(var_22_2, true)
		end
	end), TARGET(var_22_9, REMOVE()), TARGET(var_22_7, REMOVE()), REMOVE()), var_22_7, "block")
end

function ChristmasBuildingPopup.req_craft_item(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	if not arg_24_1 then
		balloon_message_with_sound("village_err_06")
		
		return 
	end
	
	if not arg_24_2 or not arg_24_3 then
		return 
	end
	
	if table.count(arg_24_0.vars.craft_items) >= var_0_0 then
		balloon_message_with_sound("village_err_07")
		
		return 
	end
	
	if SubStoryChristmasVillage:isCloseSubstory() then
		return 
	end
	
	local var_24_0 = arg_24_0.vars.building_data
	local var_24_1 = var_24_0.id
	local var_24_2 = arg_24_3
	local var_24_3 = var_24_0["craft_item_" .. var_24_2 .. "_material"]
	local var_24_4 = var_24_0["craft_item_" .. var_24_2 .. "_material_value"]
	
	if var_24_3 and var_24_4 then
		if Account:getItemCount(var_24_3) >= tonumber(var_24_4) then
			query("substory_village_produce_item", {
				building_id = var_24_1,
				item_num = var_24_2,
				substory_id = arg_24_0.vars.substory_id
			})
		else
			balloon_message_with_sound("need_token")
		end
	end
	
	TutorialGuide:procGuide()
end

function ChristmasBuildingPopup.res_craft_item(arg_25_0, arg_25_1)
	if not arg_25_1 then
		return 
	end
	
	ChristmasCraftManager:refresh_craft_item_data()
	
	local var_25_0 = arg_25_0.vars.cur_data.type
	
	SubStoryChristmasVillage:updateAfterUpgradeBuilding("substory_village_produce_item", var_25_0)
	arg_25_0:refresh_craft()
end

function ChristmasBuildingPopup.req_get_craft_item(arg_26_0)
	if not arg_26_0.vars or not get_cocos_refid(arg_26_0.vars.wnd) then
		return 
	end
	
	if not arg_26_0.vars.craft_items or table.empty(arg_26_0.vars.craft_items) then
		return 
	end
	
	if not arg_26_0.vars.can_request_get_item then
		return 
	end
	
	query("substory_village_get_item", {
		substory_id = arg_26_0.vars.substory_id
	})
end

function ChristmasBuildingPopup.res_get_craft_item(arg_27_0, arg_27_1)
	if not arg_27_1 then
		return 
	end
	
	ChristmasCraftManager:refresh_craft_item_data()
	SubStoryChristmasVillage:updateAfterUpgradeBuilding("substory_village_get_item")
	
	if arg_27_0.vars and get_cocos_refid(arg_27_0.vars.wnd) then
		arg_27_0:refresh_craft()
	end
end

function ChristmasBuildingPopup.req_cancle_craft_item(arg_28_0, arg_28_1)
	if not arg_28_1 or arg_28_1.can_receive then
		return 
	end
	
	if SubStoryChristmasVillage:isCloseSubstory() then
		return 
	end
	
	Dialog:msgBox(T("village_cancle_popup_desc"), {
		yesno = true,
		title = T("village_cancle_popup_title"),
		handler = function()
			query("substory_village_cancel_item", {
				substory_id = arg_28_0.vars.substory_id,
				craft_id = arg_28_1.id,
				item_tm = arg_28_1.tm
			})
		end
	})
end

function ChristmasBuildingPopup.res_cancle_craft_item(arg_30_0, arg_30_1)
	if not arg_30_1 then
		return 
	end
	
	ChristmasCraftManager:refresh_craft_item_data()
	SubStoryChristmasVillage:updateAfterUpgradeBuilding("substory_village_cancel_item")
	
	if arg_30_0.vars and get_cocos_refid(arg_30_0.vars.wnd) then
		arg_30_0:refresh_craft()
	end
end

function ChristmasBuildingPopup.closeBuildingPopup(arg_31_0)
	if not arg_31_0.vars or not get_cocos_refid(arg_31_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("battle_story_christmas_village_popup")
	UIAction:Add(SEQ(FADE_OUT(150), REMOVE(), CALL(function()
		if arg_31_0.vars.time_scheduler then
			Scheduler:removeByName("popup.onUpdate_craft")
		end
		
		arg_31_0.vars = nil
	end)), arg_31_0.vars.wnd, "block")
	TutorialGuide:procGuide()
end

function HANDLER.battle_story_christmas_calendar(arg_33_0, arg_33_1)
	if arg_33_1 == "btn_get" then
		ChristmasTreePopup:req_reward()
	elseif arg_33_1 == "btn_close" then
		ChristmasTreePopup:closePopup()
	end
end

function MsgHandler.substory_village_get_tree_reward(arg_34_0)
	if arg_34_0 then
		if arg_34_0.rewards then
			local var_34_0 = Account:addReward(arg_34_0.rewards)
			
			Dialog:msgScrollRewards(T("village_present_popup_desc"), {
				open_effect = true,
				title = T("village_present_popup_title"),
				rewards = var_34_0.rewards
			})
		end
		
		if arg_34_0.dec_result then
			Account:addReward(arg_34_0.dec_result)
		end
		
		if arg_34_0.substory_info then
			Account:setSubStory(arg_34_0.substory_info.substory_id, arg_34_0.substory_info)
		end
		
		ChristmasTreePopup:res_reward(arg_34_0)
	end
end

function ChristmasTreePopup.openPopup(arg_35_0, arg_35_1)
	local var_35_0 = SubstoryManager:getInfo() or {}
	
	if not ChristmasUtil:canOpenTreePopup(var_35_0.id) then
		return 
	end
	
	arg_35_0.vars = {}
	arg_35_0.vars.wnd = load_dlg("battle_story_christmas_calendar", true, "wnd", function()
		ChristmasTreePopup:closePopup()
	end)
	arg_35_0.vars.substory_id = var_35_0.id or "vch1aa"
	
	;(arg_35_1 or SceneManager:getRunningPopupScene()):addChild(arg_35_0.vars.wnd)
	arg_35_0:update()
end

function ChristmasTreePopup.update(arg_37_0)
	arg_37_0:updateData()
	arg_37_0:updateUI()
end

function ChristmasTreePopup.updateData(arg_38_0)
	arg_38_0.vars.data = {}
	arg_38_0.vars.can_receive_reward = false
	arg_38_0.vars.user_day = ChristmasUtil:getUserTreeDay(arg_38_0.vars.substory_id)
	arg_38_0.vars.cur_day = ChristmasUtil:getCurTreeDay(arg_38_0.vars.substory_id)
	arg_38_0.vars.user_day = tonumber(arg_38_0.vars.user_day)
	arg_38_0.vars.cur_day = tonumber(arg_38_0.vars.cur_day)
	
	for iter_38_0 = 1, 999 do
		local var_38_0 = string.format("%s_%s_%02d", arg_38_0.vars.substory_id, "tree", iter_38_0)
		local var_38_1 = DBT("substory_village_tree_reward", var_38_0, {
			"id",
			"day",
			"present_item",
			"present_item_cnt"
		})
		
		if not var_38_1 or not var_38_1.id then
			break
		end
		
		local var_38_2 = tonumber(var_38_1.day)
		
		var_38_1.can_receive = var_38_2 >= arg_38_0.vars.user_day and var_38_2 <= arg_38_0.vars.cur_day
		var_38_1.is_received = var_38_2 <= arg_38_0.vars.user_day
		
		if not arg_38_0.vars.can_receive_reward and var_38_1.can_receive and not var_38_1.is_received then
			arg_38_0.vars.can_receive_reward = true
		end
		
		table.insert(arg_38_0.vars.data, var_38_1)
	end
	
	table.sort(arg_38_0.vars.data, function(arg_39_0, arg_39_1)
		return arg_39_0.day < arg_39_1.day
	end)
end

function ChristmasTreePopup.updateUI(arg_40_0)
	for iter_40_0 = 1, var_0_1 do
		local var_40_0 = "n_week" .. iter_40_0
		local var_40_1 = arg_40_0.vars.wnd:getChildByName(var_40_0)
		local var_40_2 = arg_40_0.vars.data[iter_40_0].present_item
		local var_40_3 = arg_40_0.vars.data[iter_40_0].present_item_cnt
		local var_40_4 = tonumber(arg_40_0.vars.data[iter_40_0].day)
		local var_40_5 = arg_40_0.vars.data[iter_40_0].is_received
		local var_40_6 = arg_40_0.vars.data[iter_40_0].can_receive
		local var_40_7 = arg_40_0.vars.data[iter_40_0].day
		
		if get_cocos_refid(var_40_1) and var_40_2 and var_40_3 then
			local var_40_8 = var_40_1:getChildByName("n_d1")
			
			var_40_8:removeAllChildren()
			
			local var_40_9 = UIUtil:getRewardIcon(var_40_3, var_40_2, {
				parent = var_40_8
			})
			
			if_set_visible(var_40_1, "icon_check1", var_40_5)
			
			if var_40_5 then
				var_40_9:setOpacity(76.5)
			end
			
			if_set(var_40_1, "t_day", T("remain_day_single", {
				day = var_40_7
			}))
		end
	end
	
	if_set_opacity(arg_40_0.vars.wnd, "btn_get", arg_40_0.vars.can_receive_reward and 255 or 76.5)
end

function ChristmasTreePopup.req_reward(arg_41_0)
	if not arg_41_0.vars.can_receive_reward then
		balloon_message_with_sound("village_present_popup_err")
		
		return 
	end
	
	query("substory_village_get_tree_reward", {
		substory_id = arg_41_0.vars.substory_id
	})
end

function ChristmasTreePopup.res_reward(arg_42_0, arg_42_1)
	arg_42_0:update()
	SubStoryChristmasVillage:updateAfterUpgradeBuilding("substory_village_get_tree_reward", "tree")
end

function ChristmasTreePopup.closePopup(arg_43_0)
	if not arg_43_0.vars or not get_cocos_refid(arg_43_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("battle_story_christmas_calendar")
	UIAction:Add(SEQ(FADE_OUT(150), REMOVE(), CALL(function()
		arg_43_0.vars = nil
	end)), arg_43_0.vars.wnd, "block")
end
