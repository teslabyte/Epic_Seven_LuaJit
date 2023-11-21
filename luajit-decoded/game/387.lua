SubStoryViewerUtil = {}

function SubStoryViewerUtil.checkIsActive(arg_1_0, arg_1_1)
	if DEBUG.SHOW_STORY_COLLECTION then
		return true
	end
	
	if SubstorySystemStory:isSubstoryCleared(arg_1_1.id) then
		return true
	end
	
	return false
end

function SubStoryViewerUtil.isMain(arg_2_0, arg_2_1, arg_2_2)
	return arg_2_1.cast_main == arg_2_2
end

function SubStoryViewerUtil.getCastingCount(arg_3_0, arg_3_1)
	return table.count(arg_3_1.casting)
end

function SubStoryViewerUtil.getHaveCastingCount(arg_4_0, arg_4_1)
	local var_4_0 = 0
	
	for iter_4_0, iter_4_1 in pairs(arg_4_1.casting) do
		if Account:getCollectionUnit(iter_4_1) then
			var_4_0 = var_4_0 + 1
		end
	end
	
	return var_4_0
end

local function var_0_0(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = arg_5_1:findChildByName("n_hero" .. arg_5_3)
	local var_5_1 = arg_5_1:findChildByName("icon_check" .. arg_5_3)
	
	if not var_5_0 or not var_5_1 then
		return 
	end
	
	if not var_5_0.origin_pos then
		var_5_0.origin_pos = var_5_0:getPositionX()
		var_5_1.origin_pos = var_5_1:getPositionX()
	end
	
	if arg_5_0 < arg_5_3 then
		if_set_visible(var_5_0, nil, false)
		if_set_visible(var_5_1, nil, false)
		
		return 
	end
	
	if_set_visible(var_5_0, nil, true)
	
	local var_5_2 = arg_5_2.casting[arg_5_3]
	local var_5_3 = UIUtil:getRewardIcon("c", var_5_2, {
		no_popup = false,
		name = false,
		zodiac = 6,
		use_basic_star = true,
		scale = 1,
		no_grade = true
	})
	
	var_5_0:removeAllChildren()
	var_5_0:addChild(var_5_3)
	
	local var_5_4 = Account:getCollectionUnit(var_5_2)
	
	if_set_visible(var_5_1, nil, var_5_4)
	
	if not var_5_4 then
		if_set_color(var_5_0, nil, cc.c3b(80, 80, 80))
	else
		if_set_color(var_5_0, nil, cc.c3b(255, 255, 255))
	end
	
	if arg_5_4 then
		var_5_0:setPositionX(var_5_0.origin_pos)
		var_5_1:setPositionX(var_5_1.origin_pos)
	end
end

function SubStoryViewerUtil.setHeroes(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = SubStoryViewerUtil:getCastingCount(arg_6_2)
	
	for iter_6_0 = 1, 8 do
		var_0_0(var_6_0, arg_6_1, arg_6_2, iter_6_0, arg_6_3)
	end
end

function SubStoryViewerUtil.sortDB(arg_7_0, arg_7_1, arg_7_2)
	table.sort(arg_7_1, function(arg_8_0, arg_8_1)
		local var_8_0 = SubStoryViewerUtil:checkIsActive(arg_8_0)
		
		if var_8_0 ~= SubStoryViewerUtil:checkIsActive(arg_8_1) then
			return var_8_0
		end
		
		if arg_7_2 ~= nil then
			local var_8_1 = SubStoryViewerUtil:isMain(arg_8_0, arg_7_2)
			
			if var_8_1 ~= SubStoryViewerUtil:isMain(arg_8_1, arg_7_2) then
				return var_8_1
			end
		end
		
		return arg_8_0.sort < arg_8_1.sort
	end)
end

function SubStoryViewerUtil.onSubStoryItemUpdate(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = CollectionUtil:makeQuestData(arg_9_2)
	
	CollectionUtil:setStoryRendererBasic(arg_9_1, var_9_0)
	
	local var_9_1 = 255
	
	if not arg_9_3 then
		var_9_1 = var_9_1 * 0.3
	end
	
	if_set_opacity(arg_9_1, nil, var_9_1)
	if_set_visible(arg_9_1, "btn_battle", false and arg_9_2.npc_team ~= nil)
	
	arg_9_1:findChildByName("btn_play_brown").data = {
		type = "story",
		unlock_msg = "hero_detail_story_cast_desc",
		id = arg_9_2.story_id,
		default_bg = arg_9_2.default_bg,
		default_bgm = arg_9_2.default_bgm,
		level_enter = arg_9_2.level_enter,
		isCanShow = arg_9_3
	}
end
