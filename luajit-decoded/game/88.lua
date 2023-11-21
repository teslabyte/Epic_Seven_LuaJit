GrowthGuideNavigator = {}
GrowthGuideNavigator.navigators = {}
GrowthGuideNavigator.navigator_infos = {}

function GrowthGuideNavigator.getBranchRoot(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_1:getParent()
	
	while tolua.type(var_1_0) ~= "ccui.ScrollView" and tolua.type(var_1_0) ~= "cc.Layer" do
		if not get_cocos_refid(var_1_0) then
			return nil
		end
		
		var_1_0 = var_1_0:getParent()
	end
	
	return var_1_0
end

local function var_0_0(arg_2_0, arg_2_1)
	if not get_cocos_refid(arg_2_0) then
		return false
	end
	
	if not arg_2_0.guide_tag then
		return false
	end
	
	if arg_2_0.guide_tag == arg_2_1 then
		return true
	end
	
	if string.starts(arg_2_1, "\\r") then
		local var_2_0 = string.sub(arg_2_1, 3, -1)
		
		if string.match(arg_2_0.guide_tag, var_2_0) then
			return true
		end
	end
	
	return false
end

function GrowthGuideNavigator.getChildTagNode(arg_3_0, arg_3_1, arg_3_2)
	for iter_3_0, iter_3_1 in pairs(arg_3_1:getChildren()) do
		if var_0_0(iter_3_1, arg_3_2) then
			return iter_3_1
		end
	end
	
	return nil
end

function GrowthGuideNavigator.getScrollViewItem(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_0:getBranchRoot(arg_4_1)
	
	if not get_cocos_refid(var_4_0) then
		return nil
	end
	
	for iter_4_0, iter_4_1 in pairs(var_4_0:getChildren()) do
		if iter_4_1:getName() == arg_4_2 and var_0_0(iter_4_1, arg_4_3) then
			return iter_4_1
		end
		
		local var_4_1 = iter_4_1:getChildByName(arg_4_2)
		
		if var_0_0(var_4_1, arg_4_3) then
			return var_4_1
		end
	end
	
	return nil
end

function GrowthGuideNavigator.getTagNode(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_2 == "" then
		return arg_5_0:getChildTagNode(arg_5_1, arg_5_3)
	end
	
	if arg_5_1:getName() == arg_5_2 and var_0_0(arg_5_1, arg_5_3) then
		return arg_5_1
	end
	
	local var_5_0 = arg_5_1:getChildByName(arg_5_2)
	
	if not get_cocos_refid(var_5_0) then
		return nil
	end
	
	if not var_5_0.guide_tag then
		return nil
	end
	
	if var_0_0(var_5_0, arg_5_3) then
		return var_5_0
	end
	
	local var_5_1 = var_5_0:getParent()
	
	for iter_5_0, iter_5_1 in pairs(var_5_1:getChildren()) do
		if iter_5_1:getName() == arg_5_2 and var_0_0(iter_5_1, arg_5_3) then
			return iter_5_1
		end
	end
	
	return arg_5_0:getScrollViewItem(var_5_0, arg_5_2, arg_5_3)
end

function GrowthGuideNavigator.clearNavigators(arg_6_0)
	for iter_6_0, iter_6_1 in pairs(arg_6_0.navigators) do
		arg_6_0:removeNavigator(iter_6_1)
	end
	
	arg_6_0.navigators = {}
end

function GrowthGuideNavigator.updateNavigators(arg_7_0)
	local function var_7_0(arg_8_0, arg_8_1)
		if not get_cocos_refid(arg_8_1) then
			return true
		end
		
		local var_8_0 = arg_8_1:getParent()
		
		if not get_cocos_refid(var_8_0) then
			arg_7_0:removeNavigator(arg_8_1)
			
			return true
		end
		
		local var_8_1 = arg_7_0:getNavigatorTargetNode(arg_8_1.navigator_info.node_path)
		
		if not get_cocos_refid(var_8_1) then
			arg_7_0:removeNavigator(arg_8_1)
			
			return true
		end
		
		if arg_8_1.guide_tag ~= var_8_0.guide_tag then
			arg_8_1:removeFromParent()
			var_8_1:addChild(arg_8_1)
		end
		
		return false
	end
	
	table.delete_i(arg_7_0.navigators, var_7_0)
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0.navigator_infos) do
		arg_7_0:markNavigator(iter_7_1)
	end
end

function GrowthGuideNavigator.getNavigatorTargetNode(arg_9_0, arg_9_1)
	local var_9_0 = SceneManager:getRunningRootScene()
	
	for iter_9_0, iter_9_1 in pairs(string.split(arg_9_1, "/")) do
		local var_9_1, var_9_2 = iter_9_1:find("%b[]")
		
		if var_9_1 then
			local var_9_3 = iter_9_1:sub(1, var_9_1 - 1)
			local var_9_4 = iter_9_1:sub(var_9_1 + 1, var_9_2 - 1)
			
			var_9_0 = arg_9_0:getTagNode(var_9_0, var_9_3, var_9_4)
		else
			var_9_0 = var_9_0:getChildByName(iter_9_1)
		end
		
		if not get_cocos_refid(var_9_0) then
			return nil
		end
	end
	
	return var_9_0
end

function GrowthGuideNavigator.removeNavigator(arg_10_0, arg_10_1)
	if not get_cocos_refid(arg_10_1) then
		return 
	end
	
	arg_10_1:removeFromParent()
	arg_10_1:release()
	
	arg_10_1 = nil
end

function GrowthGuideNavigator.markNavigator(arg_11_0, arg_11_1)
	if arg_11_1.scene_name ~= "none" and SceneManager:getCurrentSceneName() ~= arg_11_1.scene_name then
		return 
	end
	
	local var_11_0 = arg_11_0:getNavigatorTargetNode(arg_11_1.node_path)
	
	if not get_cocos_refid(var_11_0) then
		return 
	end
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0.navigators) do
		if iter_11_1:getParent() == var_11_0 then
			return 
		end
	end
	
	local var_11_1 = var_11_0:getContentSize().width * arg_11_1.anchor.x + arg_11_1.rel_pos.x
	local var_11_2 = var_11_0:getContentSize().height * arg_11_1.anchor.y + arg_11_1.rel_pos.y
	local var_11_3 = GrowthGuide:getTrackingNavigatorIcon()
	local var_11_4 = EffectManager:Play({
		fn = var_11_3,
		layer = var_11_0,
		pivot_x = var_11_1,
		pivot_y = var_11_2
	})
	
	if not get_cocos_refid(var_11_4) then
		return 
	end
	
	var_11_4:setCascadeOpacityEnabled(false)
	var_11_4:setScaleX(1 / calcWorldScaleX(var_11_4))
	var_11_4:setScaleY(1 / calcWorldScaleY(var_11_4))
	var_11_4:setRotation(-calcWorldRotation(var_11_4))
	var_11_4:retain()
	
	var_11_4.navigator_info = arg_11_1
	var_11_4.guide_tag = var_11_0.guide_tag
	
	var_11_4:bringToFront()
	table.insert(arg_11_0.navigators, var_11_4)
end

function GrowthGuideNavigator.proc(arg_12_0)
	if ContentDisable:byAlias("growthguide_navigator") then
		return 
	end
	
	if not GrowthGuide:isEnable() then
		return 
	end
	
	if not GrowthGuide:isTracking() then
		return 
	end
	
	arg_12_0:updateGrowthGuideNavigatorInfos()
	arg_12_0:updateNavigators()
end

function GrowthGuideNavigator.isChangeTrackingQuest(arg_13_0)
	if GrowthGuide:getDBTrackingQuest() == arg_13_0.tracking_quest then
		return false
	end
	
	return true
end

function GrowthGuideNavigator.updateTrackingQuest(arg_14_0)
	arg_14_0.tracking_quest = GrowthGuide:getDBTrackingQuest()
end

function GrowthGuideNavigator.updateGrowthGuideNavigatorInfos(arg_15_0)
	if not arg_15_0:isChangeTrackingQuest() then
		return 
	end
	
	arg_15_0:updateTrackingQuest()
	
	if not arg_15_0.tracking_quest then
		return 
	end
	
	if not GrowthGuide:isOpenQuest(arg_15_0.tracking_quest) then
		return 
	end
	
	arg_15_0:clearNavigators()
	
	arg_15_0.navigator_infos = {}
	arg_15_0.tracking_quest.quest_navigator = arg_15_0.tracking_quest.quest_navigator:gsub("%s+", "")
	
	local var_15_0 = arg_15_0.tracking_quest.quest_navigator:split(";")
	
	for iter_15_0, iter_15_1 in pairs(var_15_0) do
		local var_15_1 = iter_15_1:split(",")
		
		if #var_15_1 > 1 then
			table.insert(arg_15_0.navigator_infos, {
				scene_name = var_15_1[1],
				node_path = var_15_1[2],
				anchor = {
					x = var_15_1[3] or 0.5,
					y = var_15_1[4] or 0.5
				},
				rel_pos = {
					x = var_15_1[5] or 0,
					y = var_15_1[6] or 0
				}
			})
		end
	end
end

function GrowthGuideNavigator.isNeedToResetQuestNavigator(arg_16_0)
	if not arg_16_0:isChangeTrackingQuest() then
		return 
	end
	
	if not arg_16_0.tracking_quest then
		return 
	end
	
	if not GrowthGuide:isOpenQuest(arg_16_0.tracking_quest) then
		return 
	end
	
	if not arg_16_0.navigator_infos or table.empty(arg_16_0.navigator_infos) then
		return 
	end
	
	arg_16_0.tracking_quest.quest_navigator = arg_16_0.tracking_quest.quest_navigator:gsub("%s+", "")
	
	local var_16_0 = arg_16_0.tracking_quest.quest_navigator:split(";")
	
	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		local var_16_1 = iter_16_1:split(",")
		
		if not arg_16_0.navigator_infos[iter_16_0] then
			return 
		end
		
		local var_16_2 = arg_16_0.navigator_infos[iter_16_0]
		
		if #var_16_1 > 1 and (var_16_2.scene_name ~= var_16_1[1] or var_16_2.node_path ~= var_16_1[2]) then
			return 
		end
	end
	
	return true
end

function GrowthGuideNavigator.updateVisibleByContentDisable(arg_17_0)
	if ContentDisable:byAlias("growthguide_navigator") then
		arg_17_0:clearNavigators()
	end
end

function GrowthGuideNavigator.__mark(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4, arg_18_5)
	if PRODUCTION_MODE then
		return 
	end
	
	print("!주의! 치트가 아닐 때는 성장가이드 튜토리얼을 끝내야 네비게이터가 동작합니다.")
	arg_18_0:markNavigator({
		scene_name = SceneManager:getCurrentSceneName(),
		node_path = arg_18_1,
		anchor = {
			x = arg_18_2 or 0.5,
			y = arg_18_3 or 0.5
		},
		rel_pos = {
			x = arg_18_4 or 0,
			y = arg_18_5 or 0
		}
	})
end

function GrowthGuideNavigator.__navigatorInfos(arg_19_0)
	if PRODUCTION_MODE then
		return 
	end
	
	print("---------- navigator infos -----------")
	
	for iter_19_0, iter_19_1 in pairs(arg_19_0.navigator_infos) do
		print(iter_19_1.scene_name, iter_19_1.node_path, iter_19_1.anchor.x, iter_19_1.anchor.y, iter_19_1.rel_pos.x, iter_19_1.rel_pos.y)
	end
end

function GrowthGuideNavigator.__navigators(arg_20_0)
	if PRODUCTION_MODE then
		return 
	end
	
	print("---------- navigators -----------")
	
	for iter_20_0, iter_20_1 in pairs(arg_20_0.navigators) do
		local var_20_0 = iter_20_1.navigator_info
		
		print(iter_20_1, var_20_0.scene_name, var_20_0.node_path, var_20_0.anchor.x, var_20_0.anchor.y, var_20_0.rel_pos.x, var_20_0.rel_pos.y)
	end
end
