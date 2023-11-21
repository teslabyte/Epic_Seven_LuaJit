ArtifactBonus = {}
ArtifactBonus.vars = {}
ArtifactBonus.tab = {
	currency = {
		node = "n_tab1",
		name = "currency"
	},
	growth = {
		node = "n_tab2",
		name = "growth"
	}
}

function HANDLER.artifact_bonus_base(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_tab1" then
		ArtifactBonus:selectSubStoryCurrencyTab()
	end
	
	if arg_1_1 == "btn_tab2" then
		ArtifactBonus:selectGrowthTab()
	end
	
	if arg_1_1 == "btn_close" then
		ArtifactBonus:close()
	end
end

function ArtifactBonus.close(arg_2_0)
	if_set_visible(arg_2_0.vars.wnd, "listview", false)
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_2_0.vars.wnd, "block")
	BackButtonManager:pop("Dialog.artifact_bonus_base")
end

function ArtifactBonus.show(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	opts = opts or {}
	arg_3_0.vars = {}
	arg_3_0.vars.sub_story_info = SubstoryManager:getInfo()
	arg_3_0.vars.sub_story_artifact_bonus_info = SubstoryManager:getArtifactBonusInfo()
	arg_3_0.vars.level_type = arg_3_2
	arg_3_0.vars.map_id = arg_3_3
	arg_3_0.vars.team = arg_3_1
	
	local var_3_0 = SceneManager:getRunningNativeScene()
	
	arg_3_0.vars.wnd = Dialog:open("wnd/artifact_bonus_base", arg_3_0, {
		back_func = function()
			ArtifactBonus:close()
		end
	})
	
	var_3_0:addChild(arg_3_0.vars.wnd)
	arg_3_0.vars.wnd:setOpacity(0)
	UIAction:Add(LOG(FADE_IN(200)), arg_3_0.vars.wnd, "block")
	arg_3_0:updateTabs()
end

function ArtifactBonus.selectSubStoryCurrencyTab(arg_5_0)
	local var_5_0 = arg_5_0.vars.wnd:getChildByName("n_tab_currency")
	
	if_set_visible(var_5_0, "tab_bg", true)
	
	local var_5_1 = arg_5_0.vars.wnd:getChildByName("n_tab_growth")
	
	if_set_visible(var_5_1, "tab_bg", false)
	if_set_visible(arg_5_0.vars.wnd, "n_currency", true)
	if_set_visible(arg_5_0.vars.wnd, "n_no_currency", Team:getSubStoryCurrencyBonusArtifactsCount(arg_5_0.vars.team, arg_5_0.vars.sub_story_artifact_bonus_info, arg_5_0.vars.map_id) == 0)
	if_set_visible(arg_5_0.vars.wnd, "n_growth", false)
	if_set_visible(arg_5_0.vars.wnd, "n_no_growth", false)
end

function ArtifactBonus.selectGrowthTab(arg_6_0)
	local var_6_0 = arg_6_0.vars.wnd:getChildByName("n_tab_currency")
	
	if_set_visible(var_6_0, "tab_bg", false)
	
	local var_6_1 = arg_6_0.vars.wnd:getChildByName("n_tab_growth")
	
	if_set_visible(var_6_1, "tab_bg", true)
	if_set_visible(arg_6_0.vars.wnd, "n_currency", false)
	if_set_visible(arg_6_0.vars.wnd, "n_no_currency", false)
	
	local var_6_2 = Team:getGrowthBonusArtifactsCount(arg_6_0.vars.team, arg_6_0.vars.level_type) ~= 0
	
	if_set_visible(arg_6_0.vars.wnd, "n_growth", var_6_2)
	if_set_visible(arg_6_0.vars.wnd, "n_no_growth", not var_6_2)
end

function ArtifactBonus.updateSubStoryCurrencyTab(arg_7_0)
	local var_7_0, var_7_1 = Team:getSubStoryCurrencyBonusArtifacts(arg_7_0.vars.team, arg_7_0.vars.sub_story_artifact_bonus_info, arg_7_0.vars.map_id)
	
	arg_7_0:updateSubStoryCurrencyBonusEffect(var_7_0)
	arg_7_0:createSubStoryCurrencyListView(var_7_0, var_7_1)
end

function ArtifactBonus.updateGrowthTab(arg_8_0)
	local var_8_0 = Team:getGrowthBonusArtifacts(arg_8_0.vars.team, arg_8_0.vars.level_type)
	
	table.sort(var_8_0, function(arg_9_0, arg_9_1)
		if arg_9_0.is_apply == arg_9_1.is_apply then
			return false
		end
		
		return arg_9_0.is_apply or not arg_9_1.is_apply
	end)
	arg_8_0:createGrowthListView(var_8_0)
end

function ArtifactBonus.updateTabs(arg_10_0)
	local var_10_0 = not arg_10_0.vars.sub_story_artifact_bonus_info or not table.empty(arg_10_0.vars.sub_story_artifact_bonus_info)
	local var_10_1 = true
	local var_10_2 = var_10_0 or var_10_1
	
	if_set_visible(arg_10_0.vars.wnd, "n_tab", var_10_2)
	if_set_visible(arg_10_0.vars.wnd, "n_tab_growth", var_10_1)
	if_set_visible(arg_10_0.vars.wnd, "n_tab_currency", var_10_0)
	
	local var_10_3, var_10_4 = Team:getSubStoryCurrencyBonusArtifacts(arg_10_0.vars.team, arg_10_0.vars.sub_story_artifact_bonus_info, arg_10_0.vars.map_id)
	
	if_set_visible(arg_10_0.vars.wnd, "n_top", not table.empty(var_10_3))
	if_set_visible(arg_10_0.vars.wnd, "n_no_item", table.empty(var_10_3))
	
	if var_10_0 then
		arg_10_0:updateSubStoryCurrencyTab()
	end
	
	if var_10_1 then
		arg_10_0:updateGrowthTab()
	end
	
	if var_10_0 then
		arg_10_0:selectSubStoryCurrencyTab()
	elseif var_10_1 then
		arg_10_0:selectGrowthTab()
	end
end

function ArtifactBonus.updateSubStoryCurrencyBonusEffect(arg_11_0, arg_11_1)
	local var_11_0 = {}
	local var_11_1 = SubstoryManager:getArtifactBonusInfo()
	
	for iter_11_0, iter_11_1 in pairs(arg_11_1) do
		local var_11_2 = arg_11_0:getBonusLevelWithColor(iter_11_1.equip)
		local var_11_3 = tonumber(var_11_1[iter_11_0]["arti" .. var_11_2])
		
		if type(iter_11_1.info.token) == "table" then
			for iter_11_2, iter_11_3 in pairs(iter_11_1.info.token) do
				var_11_0[iter_11_3] = var_11_0[iter_11_3] and var_11_0[iter_11_3] + var_11_3 or var_11_3
			end
		else
			var_11_0[iter_11_1.info.token] = var_11_0[iter_11_1.info.token] and var_11_0[iter_11_1.info.token] + var_11_3 or var_11_3
		end
	end
	
	local var_11_4 = arg_11_0.vars.wnd:findChildByName("n_reward")
	
	for iter_11_4 = 1, 3 do
		local var_11_5 = arg_11_0.vars.sub_story_info["token_id" .. iter_11_4]
		
		if var_11_5 then
			local var_11_6 = (var_11_0[var_11_5] or 0) * 100 + 1e-07
			
			if_set(var_11_4, "txt_item" .. iter_11_4, string.format("+%d%%", var_11_6))
			
			local var_11_7 = var_11_4:findChildByName("n_item" .. iter_11_4)
			
			if_set_visible(var_11_7, nil, true)
			UIUtil:getRewardIcon(nil, var_11_5, {
				no_count = true,
				no_bg = true,
				parent = var_11_7
			})
		else
			if_set_visible(var_11_4, "txt_item" .. iter_11_4, false)
			if_set_visible(var_11_4, "n_item" .. iter_11_4, false)
		end
	end
end

function ArtifactBonus.createGrowthListView(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.vars.wnd:getChildByName("n_growth"):getChildByName("listview")
	local var_12_1 = var_12_0:getContentSize()
	
	arg_12_0.vars.growth_list_view = {}
	
	copy_functions(ScrollView, arg_12_0.vars.growth_list_view)
	arg_12_0.vars.growth_list_view:initScrollView(var_12_0, var_12_1.width, var_12_1.height)
	
	function arg_12_0.vars.growth_list_view.getScrollViewItem(arg_13_0, arg_13_1)
		local var_13_0 = load_control("wnd/artifact_bonus_item_base.csb")
		local var_13_1 = var_13_0:getChildByName("n_artifact_bonus_item")
		
		if get_cocos_refid(var_13_1) then
			local var_13_2 = load_control("wnd/artifact_bonus_item.csb")
			
			var_13_1:addChild(var_13_2)
		end
		
		ArtifactBonus:updateGrowthListItem(var_13_0, arg_13_1)
		
		return var_13_0
	end
	
	arg_12_0.vars.growth_list_view:createScrollViewItems(arg_12_1)
end

function ArtifactBonus.createSubStoryCurrencyListView(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0.vars.wnd:getChildByName("n_currency"):getChildByName("listview")
	local var_14_1 = var_14_0:getContentSize()
	
	arg_14_0.vars.currency_list_view = {}
	
	copy_functions(ScrollView, arg_14_0.vars.currency_list_view)
	arg_14_0.vars.currency_list_view:initScrollView(var_14_0, var_14_1.width, var_14_1.height)
	
	function arg_14_0.vars.currency_list_view.getScrollViewItem(arg_15_0, arg_15_1)
		local var_15_0 = load_control("wnd/artifact_bonus_item_base.csb")
		local var_15_1 = var_15_0:getChildByName("n_artifact_bonus_item")
		
		if get_cocos_refid(var_15_1) then
			local var_15_2 = load_control("wnd/artifact_bonus_item.csb")
			
			var_15_1:addChild(var_15_2)
		end
		
		ArtifactBonus:updateSubStoryCurrencyListItem(var_15_0, arg_15_1)
		
		return var_15_0
	end
	
	arg_14_1 = arg_14_1 or {}
	
	local var_14_2 = {}
	
	for iter_14_0, iter_14_1 in pairs(arg_14_1) do
		table.insert(var_14_2, iter_14_1)
	end
	
	arg_14_2 = arg_14_2 or {}
	
	for iter_14_2, iter_14_3 in pairs(arg_14_2) do
		iter_14_3.info.order = iter_14_3.info.order * 10
		
		table.insert(var_14_2, iter_14_3)
	end
	
	table.sort(var_14_2, function(arg_16_0, arg_16_1)
		return arg_16_0.info.order < arg_16_1.info.order
	end)
	arg_14_0.vars.currency_list_view:createScrollViewItems(var_14_2)
end

function ArtifactBonus.getBonusLevelWithColor(arg_17_0, arg_17_1)
	local var_17_0 = (arg_17_1 or {}).dup_pt or 5
	local var_17_1 = 1
	local var_17_2 = cc.c3b(134, 81, 231)
	
	if var_17_0 > 4 then
		var_17_1 = 4
		var_17_2 = cc.c3b(107, 193, 27)
	elseif var_17_0 > 2 then
		var_17_1 = 3
		var_17_2 = cc.c3b(248, 194, 0)
	elseif var_17_0 > 0 then
		var_17_1 = 2
		var_17_2 = cc.c3b(20, 151, 211)
	end
	
	return var_17_1, var_17_2
end

function ArtifactBonus.updateGrowthListItem(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = getChildByPath(arg_18_1, "n_list_base/n_support")
	
	if_set_visible(var_18_0, nil, true)
	
	local var_18_1 = arg_18_1:getChildByName("n_artifact_bonus_item")
	
	if not get_cocos_refid(var_18_1) then
		return 
	end
	
	if_set_visible(var_18_1, "n_graph", false)
	if_set_visible(var_18_1, "n_support", true)
	
	local var_18_2 = var_18_1:getChildByName("n_support")
	
	if not get_cocos_refid(var_18_2) then
		return 
	end
	
	arg_18_0:updateUnitInfo(arg_18_1, arg_18_2.unit)
	var_18_1:getChildByName("n_arti"):addChild(UIUtil:updateEquipBar(nil, arg_18_2.equip, {
		no_equip = true
	}))
	if_set_visible(var_18_2, "n_wearer", arg_18_2.is_target_self)
	if_set_visible(var_18_2, "n_team", not arg_18_2.is_target_self)
	
	local var_18_3 = ({
		exp = "icon_menu_exp.png",
		intimacy = "icon_menu_familiarity.png"
	})[arg_18_2.type] or "icon_menu_familiarity.png"
	
	if_set_sprite(var_18_2, "n_icon", var_18_3)
	
	local var_18_4 = "+" .. arg_18_2.value * 100 .. "%"
	
	if_set(var_18_2, "txt_bonus", var_18_4)
	if_set_visible(arg_18_1, "n_no_support", not arg_18_2.is_apply)
	
	if not arg_18_2.is_apply then
		if_set_color(arg_18_1, "n_support", cc.c3b(91, 91, 91))
		if_set_color(arg_18_1, "mob_icon", cc.c3b(91, 91, 91))
		if_set_color(arg_18_1, "n_artifact_bonus_item", cc.c3b(91, 91, 91))
	end
end

function ArtifactBonus.updateSubStoryCurrencyListItem(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = getChildByPath(arg_19_1, "n_list_base/n_support")
	
	if_set_visible(var_19_0, nil, false)
	
	local var_19_1 = arg_19_1:getChildByName("n_artifact_bonus_item")
	
	if not get_cocos_refid(var_19_1) then
		return 
	end
	
	if_set_visible(var_19_1, "n_graph", true)
	if_set_visible(var_19_1, "n_support", false)
	
	local var_19_2 = arg_19_2.unit
	local var_19_3 = arg_19_2.equip
	local var_19_4 = arg_19_2.info
	local var_19_5, var_19_6 = arg_19_0:getBonusLevelWithColor(var_19_3)
	
	for iter_19_0 = 1, 4 do
		local var_19_7 = var_19_1:getChildByName("lv_" .. iter_19_0)
		
		if get_cocos_refid(var_19_7) then
			local var_19_8 = iter_19_0 <= var_19_5 and var_19_2 ~= nil
			
			if_set_visible(var_19_7, "bg_area", var_19_8)
			if_set(var_19_7, "t_value", string.format("+%d%%", (var_19_4["arti" .. iter_19_0] or 0) * 100))
			if_set_color(var_19_7, "bg_area", var_19_8 and var_19_6 or cc.c3b(136, 136, 136))
			if_set_color(var_19_7, "t_value", iter_19_0 == var_19_5 and var_19_2 and var_19_6 or cc.c3b(136, 136, 136))
		end
	end
	
	arg_19_0:updateSubStoryArtifactInfo(var_19_1, var_19_3)
	
	local var_19_10
	
	if type(var_19_4.token) == "string" then
		local var_19_9 = arg_19_1:getChildByName("reward_item1/1")
		
		UIUtil:getRewardIcon(nil, var_19_4.token, {
			no_count = true,
			parent = var_19_9
		})
	else
		var_19_10 = var_19_4.token
		
		for iter_19_1 = 1, 2 do
			if var_19_10[iter_19_1] then
				local var_19_11 = arg_19_1:getChildByName("reward_item" .. iter_19_1)
				
				UIUtil:getRewardIcon(nil, var_19_10[iter_19_1], {
					no_count = true,
					parent = var_19_11
				})
			end
		end
	end
	
	arg_19_0:updateUnitInfo(arg_19_1, var_19_2)
	
	if not arg_19_2.is_apply then
		if var_19_2 then
			if_set_visible(arg_19_1, "n_no_item", true)
		end
		
		local var_19_12 = cc.c3b(91, 91, 91)
		
		if_set_color(arg_19_1, "mob_icon", var_19_12)
		if_set_color(arg_19_1, "n_artifact_bonus_item", var_19_12)
		if_set_color(arg_19_1, "n_item", var_19_12)
	end
end

function ArtifactBonus.updateSubStoryArtifactInfo(arg_20_0, arg_20_1, arg_20_2)
	arg_20_2 = arg_20_2 or {}
	
	local var_20_0 = SubstoryManager:getInfo() or {}
	local var_20_1 = var_20_0.bonus_artifact_open_schedule or nil
	local var_20_2
	
	if not table.empty(arg_20_2) and (not var_20_1 or SubstoryManager:isArtiOpen(var_20_1, arg_20_2.code)) then
		var_20_2 = UIUtil:updateEquipBar(nil, arg_20_2, {
			no_equip = true
		})
	else
		local var_20_3 = {
			job_icon_offset_y = -22,
			disable_slv = true,
			arti_unkown_icon = var_20_0.bonus_artifact_unknown_icon or "icon_unknown_art1",
			arti_unkown_thumbnail = var_20_0.bonus_artifact_unknown_thunbnail or "unknown_art1_l"
		}
		
		var_20_2 = UIUtil:updateUnkownArtifactBar(arg_20_2, var_20_3)
	end
	
	arg_20_1:getChildByName("n_arti"):addChild(var_20_2)
end

function ArtifactBonus.updateUnitInfo(arg_21_0, arg_21_1, arg_21_2)
	if_set_visible(arg_21_1, "n_no_arti", not arg_21_2)
	
	if not arg_21_2 then
		return 
	end
	
	UIUtil:getUserIcon(arg_21_2, {
		no_popup = true,
		no_tooltip = true,
		no_lv = true,
		no_role = true,
		parent = arg_21_1:getChildByName("mob_icon")
	})
end
