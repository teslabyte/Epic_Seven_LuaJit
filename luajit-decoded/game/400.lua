SubStoryChristmasVillage = {}
ChristmasUtil = {}
ChristmasCraftManager = {}

local var_0_0 = {
	"tree",
	"hall",
	"restaurant",
	"concert",
	"hospital",
	"bridge"
}
local var_0_1 = 5

function HANDLER.dungeon_story_christmas_village(arg_1_0, arg_1_1)
	local var_1_0 = {
		"btn_bridge",
		"btn_hall",
		"btn_restaurant",
		"btn_concert",
		"btn_hospital"
	}
	
	if SubStoryChristmasVillage:isCloseSubstory() and table.find(var_1_0, arg_1_1) then
		local var_1_1 = string.split(arg_1_1, "_")[2]
		
		SubStoryChristmasVillage:afterOnCloseSubstory(var_1_1)
		
		return 
	end
	
	if arg_1_1 == "btn_tree" then
		ChristmasTreePopup:openPopup()
	elseif table.find(var_1_0, arg_1_1) then
		local var_1_2 = string.split(arg_1_1, "_")[2]
		
		SubStoryChristmasVillage:openBuildingPopup(var_1_2)
	end
end

function HANDLER.dungeon_christmas_reward_item(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_reward" then
		SubStoryChristmasVillage:req_get_craft_item()
	end
end

function SubStoryChristmasVillage.show(arg_3_0, arg_3_1)
	if arg_3_0.vars and get_cocos_refid(arg_3_0.vars.wnd) then
		return 
	end
	
	local var_3_0 = SubstoryManager:getInfo()
	
	if not var_3_0 or table.empty(var_3_0) then
		return 
	end
	
	if not var_3_0.contents_type_2 or var_3_0.contents_type_2 ~= "content_village" then
		return 
	end
	
	arg_3_0.vars = {}
	arg_3_0.vars.wnd = load_dlg("dungeon_story_christmas_village", true, "wnd")
	arg_3_0.vars.substory_id = var_3_0.id
	
	;(arg_3_1 or SceneManager:getRunningPopupScene()):addChild(arg_3_0.vars.wnd)
	
	local var_3_1 = SubStoryUtil:getTopbarCurrencies(var_3_0, {
		"crystal",
		"gold",
		"stamina"
	})
	
	TopBarNew:createFromPopup(T("village_back_btn"), arg_3_0.vars.wnd, function()
		arg_3_0:leave()
	end, var_3_1, var_3_0.help_id)
	arg_3_0:updateData()
	arg_3_0:updateUI()
	arg_3_0:updateCraft()
	
	if not arg_3_0.vars.time_scheduler then
		arg_3_0.vars.time_scheduler = Scheduler:addGlobalInterval(1000, arg_3_0.onUpdate_craft, arg_3_0)
		
		arg_3_0.vars.time_scheduler:setName("main.onUpdate_craft")
	end
	
	local var_3_2 = Account:getSubStoryContents(arg_3_0.vars.substory_id).content_village.buildings or {}
	
	ConditionContentsManager:dispatch("village.building.lv", {
		buildings = var_3_2
	})
	
	if ChristmasUtil:canRecieveTreeReward(arg_3_0.vars.substory_id) then
		arg_3_0:show_gift_bomb_eff()
	end
	
	TutorialGuide:procGuide("substory_vch1ba_1st")
	TutorialGuide:procGuide("substory_vch1ba_3rd")
end

function SubStoryChristmasVillage.show_gift_bomb_eff(arg_5_0)
	local var_5_0 = "christmas_e"
	local var_5_1 = Account:serverTimeDayLocalDetail()
	
	if var_5_1 ~= SubStoryUtil:getSubstoryConfigData(arg_5_0.vars.substory_id, var_5_0) then
		EffectManager:Play({
			z = 99999,
			fn = "ui_vch1aa2.cfx",
			layer = SceneManager:getRunningPopupScene(),
			x = DESIGN_WIDTH / 2,
			y = DESIGN_HEIGHT / 2
		})
		SubStoryUtil:setSubstoryConfigData(arg_5_0.vars.substory_id, var_5_0, var_5_1)
	end
end

function SubStoryChristmasVillage._getCraftMaterialData(arg_6_0, arg_6_1)
	if not arg_6_1 then
		return 
	end
	
	local var_6_0, var_6_1, var_6_2 = DB("substory_village_craft", arg_6_1, {
		"id",
		"craft_item_material",
		"craft_item_material_value"
	})
	
	return var_6_1, var_6_2
end

function SubStoryChristmasVillage.updateData(arg_7_0)
	arg_7_0.vars.data = {}
	arg_7_0.vars.cur_data = {}
	arg_7_0.vars.building_data = {}
	
	for iter_7_0 = 1, 9999 do
		local var_7_0, var_7_1, var_7_2, var_7_3, var_7_4, var_7_5, var_7_6, var_7_7, var_7_8, var_7_9, var_7_10, var_7_11 = DBN("substory_village", iter_7_0, {
			"id",
			"type",
			"unlock_enter",
			"story_btn_cnt",
			"story_1",
			"story_1_need_lv",
			"story_2",
			"story_2_need_lv",
			"craft_item_1_id",
			"craft_item_1_need_lv",
			"craft_item_2_id",
			"craft_item_2_need_lv"
		})
		
		if not var_7_0 then
			break
		end
		
		if string.starts(var_7_0, arg_7_0.vars.substory_id) then
			if not arg_7_0.vars.building_data[var_7_1] then
				arg_7_0.vars.building_data[var_7_1] = {}
			end
			
			if not arg_7_0.vars.data[var_7_1] then
				arg_7_0.vars.data[var_7_1] = {}
			end
			
			local var_7_12 = true
			
			if var_7_2 then
				var_7_12 = not Account:isMapCleared(var_7_2)
			end
			
			if DEBUG.MAP_DEBUG then
				var_7_12 = false
			end
			
			local var_7_13, var_7_14 = arg_7_0:_getCraftMaterialData(var_7_8)
			local var_7_15, var_7_16 = arg_7_0:_getCraftMaterialData(var_7_10)
			
			arg_7_0.vars.building_data[var_7_1] = {
				id = var_7_0,
				type = var_7_1,
				unlock_enter = var_7_2,
				story_btn_cnt = var_7_3,
				story_1 = var_7_4,
				story_1_need_lv = var_7_5,
				story_2 = var_7_6,
				story_2_need_lv = var_7_7,
				is_unlock = var_7_12,
				craft_item_1_id = var_7_8,
				craft_item_1_need_lv = var_7_9,
				craft_item_1_material = var_7_13,
				craft_item_1_material_value = var_7_14,
				craft_item_2_id = var_7_10,
				craft_item_2_need_lv = var_7_11,
				craft_item_2_material = var_7_15,
				craft_item_2_material_value = var_7_16
			}
			
			local var_7_17 = ChristmasUtil:getUserBuildingLevel(arg_7_0.vars.substory_id, var_7_0)
			
			if not arg_7_0.vars.cur_data[var_7_1] then
				arg_7_0.vars.cur_data[var_7_1] = {}
			end
			
			arg_7_0.vars.cur_data[var_7_1].cur_level = tonumber(var_7_17)
			arg_7_0.vars.cur_data[var_7_1].building_id = var_7_0
			arg_7_0.vars.cur_data[var_7_1].is_unlock = var_7_12
			arg_7_0.vars.cur_data[var_7_1].unlock_enter = var_7_2
			
			local var_7_18 = 1
			
			for iter_7_1 = 1, 9999 do
				local var_7_19 = string.format("%s_%02d", var_7_0, iter_7_1)
				local var_7_20 = DBT("substory_village_sub", var_7_19, {
					"id",
					"index",
					"type",
					"lv",
					"name",
					"icon",
					"lv_up_clear_stage",
					"lv_up_material_item_1",
					"lv_up_material_value_1",
					"lv_up_material_item_2",
					"lv_up_material_value_2",
					"lv_up_reward_item",
					"lv_up_reward_value",
					"lv_up_reward_grade_rate",
					"lv_up_reward_set_drop_rate_id"
				})
				
				if not var_7_20 or table.empty(var_7_20) then
					break
				end
				
				if var_7_18 < var_7_20.lv then
					var_7_18 = var_7_20.lv
				end
				
				arg_7_0.vars.data[var_7_20.type][var_7_20.lv] = var_7_20
				
				if var_7_20.lv == var_7_17 then
					table.merge(arg_7_0.vars.cur_data[var_7_1], var_7_20)
				end
			end
			
			arg_7_0.vars.cur_data[var_7_1].max_lv = var_7_18
		end
	end
end

function SubStoryChristmasVillage.updateCurData(arg_8_0)
	for iter_8_0 = 1, 9999 do
		local var_8_0, var_8_1, var_8_2, var_8_3, var_8_4, var_8_5, var_8_6, var_8_7, var_8_8, var_8_9, var_8_10, var_8_11, var_8_12, var_8_13, var_8_14, var_8_15 = DBN("substory_village", iter_8_0, {
			"id",
			"type",
			"unlock_enter",
			"story_btn_cnt",
			"story_1",
			"story_1_need_lv",
			"story_2",
			"story_2_need_lv",
			"craft_item_1_id",
			"craft_item_1_need_lv",
			"craft_item_1_material",
			"craft_item_1_material_value",
			"craft_item_2_id",
			"craft_item_2_need_lv",
			"craft_item_2_material",
			"craft_item_2_material_value"
		})
		
		if not var_8_0 then
			break
		end
		
		local var_8_16
		
		if string.find(var_8_0, arg_8_0.vars.substory_id) then
			if not arg_8_0.vars.cur_data[var_8_1] then
				arg_8_0.vars.cur_data[var_8_1] = {}
			end
			
			var_8_16 = ChristmasUtil:getUserBuildingLevel(arg_8_0.vars.substory_id, var_8_0)
			arg_8_0.vars.cur_data[var_8_1].cur_level = tonumber(var_8_16)
			arg_8_0.vars.cur_data[var_8_1].building_id = var_8_0
			
			for iter_8_1 = 1, 9999 do
				local var_8_17 = string.format("%s_%02d", var_8_0, iter_8_1)
				local var_8_18 = DBT("substory_village_sub", var_8_17, {
					"id",
					"index",
					"type",
					"lv",
					"name",
					"icon",
					"lv_up_clear_stage",
					"lv_up_material_item_1",
					"lv_up_material_value_1",
					"lv_up_material_item_2",
					"lv_up_material_value_2",
					"lv_up_reward_item",
					"lv_up_reward_value",
					"lv_up_reward_grade_rate",
					"lv_up_reward_set_drop_rate_id"
				})
				
				if not var_8_18 or table.empty(var_8_18) then
					break
				end
				
				if var_8_18.lv == var_8_16 then
					table.merge(arg_8_0.vars.cur_data[var_8_1], var_8_18)
				end
			end
		end
	end
end

function SubStoryChristmasVillage.updateCraft(arg_9_0)
	arg_9_0:updateCraftData()
	arg_9_0:updateCraftUI()
end

function SubStoryChristmasVillage.updateCraftData(arg_10_0)
	arg_10_0.vars.craft_items = ChristmasCraftManager:get_craft_item_data()
end

function SubStoryChristmasVillage.updateCraftUI(arg_11_0)
	local var_11_0 = {
		"hall",
		"restaurant",
		"concert",
		"hospital"
	}
	local var_11_1 = {}
	local var_11_2 = {}
	
	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		var_11_1[iter_11_1] = 0
		var_11_2[iter_11_1] = {}
	end
	
	for iter_11_2, iter_11_3 in pairs(var_0_0) do
		local var_11_3 = arg_11_0.vars.wnd:getChildByName("n_" .. iter_11_3)
		
		if get_cocos_refid(var_11_3) and table.find(var_11_0, iter_11_3) then
			local var_11_4 = var_11_3:getChildByName("n_christmas_reward_item")
			
			var_11_4:removeAllChildren()
			var_11_4:setVisible(true)
		end
	end
	
	for iter_11_4, iter_11_5 in pairs(arg_11_0.vars.craft_items) do
		local var_11_5 = arg_11_0.vars.wnd:getChildByName("n_" .. iter_11_5.type)
		
		if get_cocos_refid(var_11_5) and table.find(var_11_0, iter_11_5.type) and iter_11_5.can_receive then
			if var_11_1[iter_11_5.type] then
				var_11_1[iter_11_5.type] = var_11_1[iter_11_5.type] + 1
			end
			
			if var_11_2[iter_11_5.type] then
				local var_11_6 = DB("substory_village_craft", iter_11_5.id, {
					"craft_item"
				})
				
				if var_11_6 then
					table.insert(var_11_2[iter_11_5.type], var_11_6)
				end
			end
		end
	end
	
	for iter_11_6, iter_11_7 in pairs(var_11_1) do
		local var_11_7 = arg_11_0.vars.wnd:getChildByName("n_" .. iter_11_6)
		local var_11_8 = tonumber(iter_11_7)
		local var_11_9
		
		if get_cocos_refid(var_11_7) and var_11_8 > 0 then
			var_11_9 = load_control("wnd/dungeon_christmas_reward_item.csb")
			
			var_11_7:getChildByName("n_christmas_reward_item"):addChild(var_11_9)
			
			if get_cocos_refid(var_11_7.effect) then
				var_11_7.effect:removeFromParent()
			end
			
			var_11_7.effect = EffectManager:Play({
				z = 99999,
				fn = "ui_vch1aa3.cfx",
				y = 0,
				x = 0,
				layer = var_11_9
			})
			
			var_11_9:setPosition(0, 0)
			var_11_9:setAnchorPoint(0.5, 0.5)
			
			for iter_11_8 = 1, var_0_1 do
				if_set_visible(var_11_9, "n_" .. iter_11_8, iter_11_8 == var_11_8)
				
				local var_11_10
				
				if iter_11_8 == var_11_8 then
					var_11_10 = var_11_9:getChildByName("n_" .. iter_11_8)
					
					if get_cocos_refid(var_11_10) then
						for iter_11_9 = 1, var_11_8 do
							local var_11_11 = var_11_10:getChildByName("n_" .. iter_11_9 .. "_1")
							
							if get_cocos_refid(var_11_11) and var_11_2[iter_11_6] and var_11_2[iter_11_6][iter_11_9] then
								if_set_sprite(var_11_11, "img_product_1", "item/" .. var_11_2[iter_11_6][iter_11_9] .. ".png")
							end
						end
					end
				end
			end
		end
	end
end

function SubStoryChristmasVillage.onUpdate_craft(arg_12_0)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.wnd) or not arg_12_0.vars.craft_items then
		Scheduler:removeByName("main.onUpdate_craft")
		
		return 
	end
	
	arg_12_0.vars.craft_items = ChristmasCraftManager:get_craft_item_data() or {}
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0.vars.craft_items) do
		if iter_12_1.can_receive and iter_12_1.can_receive == false then
			iter_12_1.can_receive = true
			
			SubStoryChristmasVillage:updateCraftUI()
		end
		
		if false then
		end
	end
end

function SubStoryChristmasVillage.updateUI(arg_13_0, arg_13_1)
	if arg_13_1 then
		arg_13_0:updateBuildingIcon(arg_13_1)
	else
		arg_13_0:updateBuildingIconAll()
	end
	
	arg_13_0:update_building_noti()
end

function SubStoryChristmasVillage.updateBuildingIconAll(arg_14_0)
	for iter_14_0, iter_14_1 in pairs(var_0_0) do
		arg_14_0:updateBuildingIcon(iter_14_1)
	end
end

function SubStoryChristmasVillage.updateBuildingIcon(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.vars.wnd:getChildByName("n_" .. arg_15_1)
	
	if get_cocos_refid(var_15_0) then
		local var_15_1 = 1
		local var_15_2 = false
		
		if arg_15_0.vars.cur_data[arg_15_1] then
			var_15_1 = arg_15_0.vars.cur_data[arg_15_1].cur_level
			var_15_2 = arg_15_0.vars.cur_data[arg_15_1].is_unlock
		end
		
		local var_15_3
		local var_15_4
		
		if arg_15_1 == "tree" then
			var_15_3, var_15_4 = ChristmasUtil:getTreeImgPath(arg_15_0.vars.substory_id)
		else
			local var_15_5 = SubStoryChristmasVillage:getBuildingDataByLevel(arg_15_1, var_15_1)
			
			var_15_3 = "map/" .. var_15_5.icon
			
			if_set(var_15_0, "t_" .. arg_15_1, T(var_15_5.name))
		end
		
		local var_15_6 = cc.Sprite:create(var_15_3)
		local var_15_7 = var_15_0:getChildByName("n_building")
		
		if var_15_6 and get_cocos_refid(var_15_7) then
			var_15_7:removeAllChildren()
			var_15_7:addChild(var_15_6)
			
			local var_15_8 = var_15_2 and tocolor("#888888") or tocolor("#FFFFFF")
			
			if_set_color(var_15_7, nil, var_15_8)
		end
		
		if arg_15_1 == "tree" then
			if var_15_0.effect and get_cocos_refid(var_15_0.effect) then
				var_15_0.effect:removeFromParent()
			end
			
			if var_15_4 then
				var_15_0.effect = EffectManager:Play({
					z = 99999,
					fn = "ui_vch1aa4.cfx",
					y = 0,
					x = 0,
					layer = var_15_0
				})
			end
		end
	end
end

function SubStoryChristmasVillage.getBuilding_data(arg_16_0, arg_16_1)
	if not arg_16_1 then
		return 
	end
	
	return arg_16_0.vars.building_data[arg_16_1]
end

function SubStoryChristmasVillage.getDataByLevel(arg_17_0, arg_17_1, arg_17_2)
	if not arg_17_1 or not arg_17_2 then
		return 
	end
	
	if arg_17_0.vars.data[arg_17_1] then
		for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.data[arg_17_1]) do
			if iter_17_1.lv and tonumber(iter_17_1.lv) == tonumber(arg_17_2) then
				return iter_17_1
			end
		end
	end
end

function SubStoryChristmasVillage.req_get_craft_item(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.wnd) then
		return 
	end
	
	if not arg_18_0.vars.craft_items or table.empty(arg_18_0.vars.craft_items) then
		return 
	end
	
	local var_18_0 = false
	
	for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.craft_items) do
		if iter_18_1.can_receive then
			var_18_0 = true
			
			break
		end
	end
	
	if var_18_0 then
		query("substory_village_get_item", {
			substory_id = arg_18_0.vars.substory_id
		})
	end
end

function SubStoryChristmasVillage.getData(arg_19_0, arg_19_1)
	if not arg_19_1 then
		return 
	end
	
	return arg_19_0.vars.data[arg_19_1]
end

function SubStoryChristmasVillage.getCurData(arg_20_0, arg_20_1)
	if not arg_20_1 then
		return 
	end
	
	return arg_20_0.vars.cur_data[arg_20_1]
end

function SubStoryChristmasVillage.getBuildingDataByLevel(arg_21_0, arg_21_1, arg_21_2)
	if not arg_21_1 or not arg_21_2 then
		return 
	end
	
	for iter_21_0, iter_21_1 in pairs(arg_21_0.vars.data[arg_21_1]) do
		if iter_21_1.lv and iter_21_1.lv == arg_21_2 then
			return iter_21_1
		end
	end
end

function SubStoryChristmasVillage.isValid(arg_22_0)
	return arg_22_0.vars and get_cocos_refid(arg_22_0.vars.wnd)
end

function SubStoryChristmasVillage.openBuildingPopup(arg_23_0, arg_23_1)
	if not arg_23_1 or arg_23_1 == "tree" then
		return 
	end
	
	local var_23_0 = arg_23_0:getCurData(arg_23_1)
	
	if not var_23_0 then
		return 
	end
	
	if var_23_0.is_unlock then
		local var_23_1 = DB("level_enter", var_23_0.unlock_enter, {
			"name"
		})
		
		balloon_message_with_sound_raw_text(T("req_prev_map", {
			enter = T(var_23_1)
		}))
		
		return 
	end
	
	ChristmasBuildingPopup:openBuildingPopup(arg_23_1)
end

function SubStoryChristmasVillage.updateAfterUpgradeBuilding(arg_24_0, arg_24_1, arg_24_2)
	if not arg_24_1 or not arg_24_0.vars or not get_cocos_refid(arg_24_0.vars.wnd) then
		return 
	end
	
	if arg_24_1 == "substory_village_levelup_building" then
		arg_24_0:updateCurData()
		arg_24_0:updateUI(arg_24_2)
	elseif arg_24_1 == "substory_village_produce_item" then
		arg_24_0:updateCraftData()
		arg_24_0:update_building_noti()
	elseif arg_24_1 == "substory_village_get_item" then
		arg_24_0:updateCraft()
		arg_24_0:update_building_noti()
	elseif arg_24_1 == "substory_village_get_tree_reward" then
		arg_24_0:updateUI(arg_24_2)
	elseif arg_24_1 == "substory_village_cancel_item" then
		arg_24_0:updateCraft()
	end
end

function SubStoryChristmasVillage.update_building_noti(arg_25_0)
	if not arg_25_0.vars or not get_cocos_refid(arg_25_0.vars.wnd) then
		return 
	end
	
	local var_25_0 = {}
	
	for iter_25_0, iter_25_1 in pairs(arg_25_0.vars.cur_data) do
		if iter_25_1.lv ~= iter_25_1.max_lv then
			local var_25_1 = SubStoryChristmasVillage:getDataByLevel(iter_25_0, iter_25_1.lv + 1)
			
			if var_25_1 then
				local var_25_2 = true
				
				for iter_25_2 = 1, 2 do
					local var_25_3 = var_25_1["lv_up_material_item_" .. iter_25_2]
					local var_25_4 = var_25_1["lv_up_material_value_" .. iter_25_2]
					local var_25_5 = var_25_1.lv_up_clear_stage
					
					if var_25_3 and var_25_4 and (Account:getItemCount(var_25_3) < tonumber(var_25_4) or var_25_5 and not Account:isMapCleared(var_25_5)) then
						var_25_2 = false
						
						break
					end
				end
				
				if var_25_2 then
					table.insert(var_25_0, iter_25_0)
				end
			end
		end
	end
	
	for iter_25_3, iter_25_4 in pairs(var_0_0) do
		local var_25_6 = arg_25_0.vars.wnd:getChildByName("n_" .. iter_25_4)
		
		if get_cocos_refid(var_25_6) then
			if_set_visible(var_25_6, "icon_noti", table.find(var_25_0, iter_25_4))
		end
	end
end

function SubStoryChristmasVillage.isCloseSubstory(arg_26_0)
	return not SubstoryManager:isActiveSchedule(arg_26_0.vars.substory_id)
end

function SubStoryChristmasVillage.afterOnCloseSubstory(arg_27_0, arg_27_1)
	if arg_27_1 == "tree" then
		return 
	end
	
	if arg_27_0.vars.can_request_get_item then
		arg_27_0:req_get_craft_item()
	else
		balloon_message_with_sound("village_err_08")
	end
end

function SubStoryChristmasVillage.setWorldmapUpdate(arg_28_0, arg_28_1)
	if not arg_28_0.vars then
		return 
	end
	
	arg_28_0.vars.need_update_worldmap = arg_28_1
end

function SubStoryChristmasVillage.getWorldmapUpdate(arg_29_0)
	if not arg_29_0.vars then
		return 
	end
	
	return arg_29_0.vars.need_update_worldmap
end

function SubStoryChristmasVillage.leave(arg_30_0)
	if not arg_30_0.vars or not get_cocos_refid(arg_30_0.vars.wnd) then
		return 
	end
	
	local var_30_1
	
	if arg_30_0:getWorldmapUpdate() and SceneManager:getCurrentSceneName() == "world_custom" then
		local var_30_0 = WorldMapManager:getController()
		
		if var_30_0 then
			var_30_1 = var_30_0:getTown()
			
			if var_30_1 then
				local var_30_2, var_30_3 = var_30_1:procNewTownEffect()
				
				if var_30_3 and not table.empty(var_30_3) then
					for iter_30_0, iter_30_1 in pairs(var_30_3) do
						var_30_1:updateMapLine(iter_30_1)
					end
				end
			end
		end
	end
	
	TopBarNew:pop()
	BackButtonManager:pop("dungeon_story_christmas_village")
	Scheduler:removeByName("main.onUpdate_craft")
	UIAction:Add(SEQ(FADE_OUT(150), REMOVE(), CALL(function()
		arg_30_0.vars = nil
	end)), arg_30_0.vars.wnd, "block")
	SubstoryManager:updateNotifierContentsUI()
	SubStoryLobbyUIDefault:updateUI()
end

function ChristmasUtil.canReceiveTreeReward(arg_32_0, arg_32_1)
	local var_32_0 = false
	local var_32_1 = ChristmasUtil:getUserTreeDay(arg_32_1)
	local var_32_2 = ChristmasUtil:getCurTreeDay(arg_32_1)
	
	for iter_32_0 = 1, 999 do
		local var_32_3 = string.format("%s_%s_%02d", arg_32_1, "tree", iter_32_0)
		local var_32_4 = DBT("substory_village_tree_reward", var_32_3, {
			"id",
			"day",
			"present_item",
			"present_item_cnt"
		})
		
		if not var_32_4 or not var_32_4.id then
			break
		end
		
		var_32_4.can_receive = var_32_1 <= var_32_4.day and var_32_2 >= var_32_4.day
		var_32_4.is_received = var_32_1 >= var_32_4.day
		
		if not var_32_0 and var_32_4.can_receive and not var_32_4.is_received then
			var_32_0 = true
			
			break
		end
	end
	
	return var_32_0
end

function ChristmasUtil.canOpenTreePopup(arg_33_0, arg_33_1)
	if not arg_33_1 then
		return 
	end
	
	local var_33_0 = DBT("content_village", arg_33_1, {
		"id",
		"tree_default",
		"tree_decoration_1",
		"tree_decoration_2",
		"tree_reward_start_schedule",
		"change_terms_schedule",
		"change_terms_clear_stage"
	})
	
	if not var_33_0 or table.empty(var_33_0) then
		return 
	end
	
	local var_33_1 = SubstoryManager:isActiveSchedule(var_33_0.change_terms_schedule, SUBSTORY_CONSTANTS.ONE_WEEK)
	local var_33_2 = Account:isMapCleared(var_33_0.change_terms_clear_stage)
	
	if not var_33_1 or not var_33_2 then
		return false
	end
	
	return true
end

function ChristmasUtil.getTreeImgPath(arg_34_0, arg_34_1)
	if not arg_34_1 then
		return 
	end
	
	local var_34_0 = DBT("content_village", arg_34_1, {
		"id",
		"tree_default",
		"tree_decoration_1",
		"tree_decoration_2",
		"tree_reward_start_schedule",
		"change_terms_schedule",
		"change_terms_clear_stage"
	})
	
	if not var_34_0 or table.empty(var_34_0) then
		return 
	end
	
	local var_34_1 = SubstoryManager:isActiveSchedule(var_34_0.change_terms_schedule)
	local var_34_2 = Account:isMapCleared(var_34_0.change_terms_clear_stage)
	local var_34_3 = arg_34_0:canReceiveTreeReward(arg_34_1)
	local var_34_4 = var_34_3
	
	if not var_34_1 or not var_34_2 then
		if not var_34_2 then
			var_34_4 = false
		end
		
		return "map/" .. var_34_0.tree_default .. ".png", var_34_4
	end
	
	if not var_34_3 then
		return "map/" .. var_34_0.tree_decoration_1 .. ".png", var_34_4
	else
		local var_34_5 = true
		
		return "map/" .. var_34_0.tree_decoration_2 .. ".png", var_34_5
	end
end

function ChristmasUtil.find_craft_building_type(arg_35_0, arg_35_1)
	if not arg_35_1 then
		return 
	end
	
	for iter_35_0 = 1, 999 do
		local var_35_0, var_35_1, var_35_2, var_35_3 = DBN("substory_village", iter_35_0, {
			"id",
			"type",
			"craft_item_1_id",
			"craft_item_2_id"
		})
		
		if not var_35_0 then
			break
		end
		
		if var_35_2 and arg_35_1 == var_35_2 then
			return var_35_1
		end
		
		if var_35_3 and arg_35_1 == var_35_3 then
			return var_35_1
		end
	end
end

function ChristmasUtil.get_craft_item_data(arg_36_0, arg_36_1)
	local var_36_0 = Account:getSubStoryContents(arg_36_1).content_village.slot or {}
	local var_36_1 = {}
	
	for iter_36_0, iter_36_1 in pairs(var_36_0) do
		iter_36_1.type = ChristmasUtil:find_craft_building_type(iter_36_1.id)
		
		table.insert(var_36_1, iter_36_1)
	end
	
	table.sort(var_36_1, function(arg_37_0, arg_37_1)
		return arg_37_0.tm < arg_37_1.tm
	end)
	
	return var_36_1
end

function ChristmasUtil.getUserBuildingLevel(arg_38_0, arg_38_1, arg_38_2)
	return ((Account:getSubStoryContents(arg_38_1).content_village.buildings or {})[arg_38_2] or {}).lv or 1
end

function ChristmasUtil.getUserTreeDay(arg_39_0, arg_39_1)
	return Account:getSubStoryContents(arg_39_1).content_village.tree
end

function ChristmasUtil.getCurTreeDay(arg_40_0, arg_40_1)
	if not arg_40_1 then
		return 
	end
	
	local var_40_0 = DBT("content_village", arg_40_1, {
		"id",
		"tree_default",
		"tree_decoration_1",
		"tree_decoration_2",
		"tree_reward_start_schedule",
		"change_terms_schedule",
		"change_terms_clear_stage"
	})
	
	if not var_40_0 or not var_40_0.id then
		return 
	end
	
	local var_40_1 = Account:getSubStoryScheduleDB()[var_40_0.tree_reward_start_schedule]
	
	if not var_40_1 or table.empty(var_40_1) then
		return 
	end
	
	local var_40_2 = os.time()
	
	if var_40_2 >= var_40_1.start_time then
		local var_40_3 = var_40_2 / 86400
		local var_40_4 = var_40_1.start_time / 86400
		
		return math.floor(var_40_3 - var_40_4 + 1)
	else
		return -1
	end
end

function ChristmasUtil.canRecieveTreeReward(arg_41_0, arg_41_1)
	if not arg_41_1 or not arg_41_0:canOpenTreePopup(arg_41_1) then
		return 
	end
	
	local var_41_0 = ChristmasUtil:getUserTreeDay(arg_41_1)
	local var_41_1 = ChristmasUtil:getCurTreeDay(arg_41_1)
	local var_41_2 = false
	local var_41_3 = tonumber(var_41_0)
	local var_41_4 = tonumber(var_41_1)
	
	for iter_41_0 = 1, 999 do
		local var_41_5 = string.format("%s_%s_%02d", arg_41_1, "tree", iter_41_0)
		local var_41_6 = DBT("substory_village_tree_reward", var_41_5, {
			"id",
			"day"
		})
		
		if not var_41_6 or not var_41_6.id then
			break
		end
		
		local var_41_7 = tonumber(var_41_6.day)
		local var_41_8 = var_41_3 <= var_41_7 and var_41_7 <= var_41_4
		local var_41_9 = var_41_7 <= var_41_3
		
		if not var_41_2 and var_41_8 and not var_41_9 then
			return true
		end
	end
end

function ChristmasUtil.can_building_upgradable(arg_42_0, arg_42_1)
	if not arg_42_1 then
		return 
	end
	
	for iter_42_0 = 1, 9999 do
		local var_42_0 = DBN("substory_village", iter_42_0, {
			"id"
		})
		
		if not var_42_0 then
			break
		end
		
		if string.find(var_42_0, arg_42_1) then
			local var_42_1 = ChristmasUtil:getUserBuildingLevel(arg_42_1, var_42_0) or 1
			local var_42_2 = string.format("%s_%02d", var_42_0, var_42_1 + 1)
			local var_42_3 = DBT("substory_village_sub", var_42_2, {
				"id",
				"lv",
				"lv_up_clear_stage",
				"lv_up_material_item_1",
				"lv_up_material_value_1",
				"lv_up_material_item_2",
				"lv_up_material_value_2"
			})
			
			if var_42_3 and var_42_3.id then
				local var_42_4 = 0
				
				for iter_42_1 = 1, 2 do
					local var_42_5 = var_42_3["lv_up_material_item_" .. iter_42_1]
					local var_42_6 = var_42_3["lv_up_material_value_" .. iter_42_1]
					
					if var_42_5 and var_42_6 and Account:getItemCount(var_42_5) >= tonumber(var_42_6) then
						var_42_4 = var_42_4 + 1
					end
				end
				
				local var_42_7 = var_42_3.lv_up_clear_stage
				
				if var_42_7 and not Account:isMapCleared(var_42_7) then
					var_42_4 = 0
				end
				
				if var_42_4 >= 2 then
					return true
				end
			end
		end
	end
end

function ChristmasUtil.canRecieveCraftReward(arg_43_0, arg_43_1)
	if not arg_43_1 then
		return 
	end
	
	local var_43_0 = ChristmasUtil:get_craft_item_data(arg_43_1)
	
	if not var_43_0 or table.empty(var_43_0) then
		return 
	end
	
	for iter_43_0, iter_43_1 in pairs(var_43_0) do
		local var_43_1, var_43_2 = DB("substory_village_craft", iter_43_1.id, {
			"craft_item",
			"craft_time"
		})
		
		iter_43_1.craft_time, iter_43_1.craft_item = var_43_2 * 60, var_43_1
		
		local var_43_3 = tonumber(iter_43_1.craft_time) or 0
		
		if iter_43_1.tm + var_43_3 - os.time() <= 0 then
			return true
		end
	end
end

function ChristmasCraftManager.init(arg_44_0)
	arg_44_0.vars = {}
	arg_44_0.vars.craft_items = ChristmasUtil:get_craft_item_data(SubstoryManager:getInfo().id)
	arg_44_0.vars.time_scheduler = Scheduler:addGlobalInterval(1000, arg_44_0.onUpdate, arg_44_0)
	
	arg_44_0.vars.time_scheduler:setName("ChristmasCraftManager.onUpdate")
	arg_44_0:onUpdate()
end

function ChristmasCraftManager.refresh_craft_item_data(arg_45_0)
	if not arg_45_0.vars then
		return 
	end
	
	arg_45_0.vars.craft_items = ChristmasUtil:get_craft_item_data(SubstoryManager:getInfo().id)
	
	arg_45_0:onUpdate()
end

function ChristmasCraftManager.onUpdate(arg_46_0)
	if not arg_46_0.vars or not arg_46_0.vars.craft_items or not SubstoryManager:getInfo() then
		Scheduler:removeByName("ChristmasCraftManager.onUpdate")
		
		return 
	end
	
	for iter_46_0, iter_46_1 in pairs(arg_46_0.vars.craft_items) do
		if not iter_46_1.craft_item or not iter_46_1.craft_time then
			local var_46_0, var_46_1 = DB("substory_village_craft", iter_46_1.id, {
				"craft_item",
				"craft_time"
			})
			
			iter_46_1.craft_time, iter_46_1.craft_item = var_46_1 * 60, var_46_0
		end
		
		local var_46_2 = tonumber(iter_46_1.craft_time) or 0
		local var_46_3 = iter_46_1.tm + var_46_2 - os.time()
		local var_46_4 = var_46_3 <= 0
		
		if iter_46_1.can_receive ~= var_46_4 then
			local var_46_5 = SceneManager:getCurrentSceneName()
			
			if var_46_5 == "world_custom" or var_46_5 == "DungeonList" then
				SubstoryManager:updateNotifierContentsUI()
			end
		end
		
		iter_46_1.can_receive = var_46_4
		iter_46_1.left_time = var_46_3
	end
end

function ChristmasCraftManager.get_craft_item_data(arg_47_0)
	if not arg_47_0.vars or not arg_47_0.vars.craft_items then
		return 
	end
	
	return arg_47_0.vars.craft_items
end

function ChristmasCraftManager.remove(arg_48_0)
	Scheduler:removeByName("ChristmasCraftManager.onUpdate")
	
	arg_48_0.vars = nil
end
