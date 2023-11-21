local function var_0_0(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_achieve" then
		if SubstoryManager:getInfo() then
			SubstoryAchievePopup:show()
			TutorialGuide:procGuide()
		end
		
		return 
	end
	
	if arg_1_1 == "btn_shop" then
		SubstoryManager:openStoryShop()
		
		return 
	end
	
	if arg_1_1 == "btn_substorypass" then
		SeasonPassBase:openSubstoryPass(function()
			WorldMapUIButtons:setEnableContentsUI()
		end)
		
		return 
	end
	
	if arg_1_1 == "btn_board" then
		SubstoryFestivalBoard:show()
		
		return 
	end
end

function HANDLER.battle_map_default(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	UIUtil:checkBtnTouchPos(arg_3_0, arg_3_3, arg_3_4)
	WorldMapUIButtons:onEventBtnHandler(arg_3_0, arg_3_1)
end

function HANDLER.battle_map_christmas_village(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	UIUtil:checkBtnTouchPos(arg_4_0, arg_4_3, arg_4_4)
	WorldMapUIButtons:onEventBtnHandler(arg_4_0, arg_4_1)
end

function HANDLER.battle_map_valentine(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	UIUtil:checkBtnTouchPos(arg_5_0, arg_5_3, arg_5_4)
	WorldMapUIButtons:onEventBtnHandler(arg_5_0, arg_5_1)
end

WorldMapUIButtons = WorldMapUIButtons or {}

function WorldMapUIButtons.getObj(arg_6_0)
	local var_6_0 = SubstoryManager:getInfo()
	
	if var_6_0 then
		local var_6_1 = var_6_0.world_ui_csb or "battle_map_default"
		
		return ({
			battle_map_default = SubStoryWorldMapUIButtons,
			battle_map_christmas_village = SubStoryVillageUIButtons,
			battle_map_valentine = SubStoryValentineUIButtons
		})[var_6_1]
	end
	
	if false then
	end
	
	return nil
end

function WorldMapUIButtons.updateSubstoryNotifier(arg_7_0)
	local var_7_0 = arg_7_0:getObj()
	
	if var_7_0 and var_7_0.updateSubstoryNotifier then
		var_7_0:updateSubstoryNotifier()
	end
end

function WorldMapUIButtons.onEventBtnHandler(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0:getObj()
	
	if var_8_0 and var_8_0.btnHandler then
		var_8_0:btnHandler(arg_8_1, arg_8_2)
	end
end

function WorldMapUIButtons.addButtons(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0:getObj()
	
	if var_9_0 and var_9_0.addButtons then
		var_9_0:addButtons(arg_9_1)
	end
end

function WorldMapUIButtons.setSubstoryEnableUI(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0:getObj()
	
	if var_10_0 and var_10_0.setSubstoryEnableUI then
		var_10_0:setSubstoryEnableUI(arg_10_1)
	end
end

WorldMapUIButtonsCommon = WorldMapUIButtonsCommon or {}

function WorldMapUIButtonsCommon.addButtons(arg_11_0, arg_11_1)
	arg_11_0.vars = {}
	
	arg_11_0:initUI()
end

function WorldMapUIButtonsCommon.btnHandler(arg_12_0, arg_12_1)
end

function WorldMapUIButtonsCommon.initUI(arg_13_0)
end

SubStoryWorldMapUIButtons = SubStoryWorldMapUIButtons or {}

function SubStoryWorldMapUIButtons.addButtons(arg_14_0, arg_14_1)
	local var_14_0 = SubstoryManager:getInfo().world_ui_csb or "battle_map_default"
	local var_14_1 = load_dlg(var_14_0, true, "wnd")
	
	var_14_1:setPosition(0, 0)
	var_14_1:setAnchorPoint(1, 0)
	arg_14_1:addChild(var_14_1)
	
	arg_14_0.vars = {}
	arg_14_0.vars.wnd = var_14_1
	
	arg_14_0:initUI()
end

function SubStoryWorldMapUIButtons.btnHandler(arg_15_0, arg_15_1, arg_15_2)
	var_0_0(arg_15_1, arg_15_2)
end

function SubStoryWorldMapUIButtons.initUI(arg_16_0)
end

function SubStoryWorldMapUIButtons.setSubstoryEnableUI(arg_17_0)
	if not arg_17_0.vars or not get_cocos_refid(arg_17_0.vars.wnd) then
		return 
	end
	
	local var_17_0 = SubstoryManager:getInfo()
	
	arg_17_0:setSubstoryPassUI(var_17_0)
	arg_17_0:setVisibleAchieveUI(var_17_0)
	arg_17_0:setVisibleShopUI(var_17_0)
	arg_17_0:setVisibleBoard()
	arg_17_0:varPosition(var_17_0)
end

function SubStoryWorldMapUIButtons.setSubstoryPassUI(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.vars.wnd:getChildByName("btn_substorypass")
	local var_18_1 = arg_18_1.pass_id ~= nil
	local var_18_2 = Account:getSubstoryPassData()
	
	if_set_visible(var_18_0, nil, var_18_1)
	
	if var_18_1 and var_18_2 then
		if_set(var_18_0, "label", T(var_18_2.main_db.scene_title))
		if_set_visible(var_18_0, "noti_icon", SeasonPass:isRemainReward(arg_18_1.pass_id))
	end
end

function SubStoryWorldMapUIButtons.setVisibleAchieveUI(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_1.achieve_flag == "y"
	local var_19_1 = arg_19_0.vars.wnd:getChildByName("btn_achieve")
	
	if get_cocos_refid(var_19_1) then
		var_19_1:setVisible(var_19_0)
	end
end

function SubStoryWorldMapUIButtons.setVisibleShopUI(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1.shop_schedule == nil or SubstoryManager:isOpenSubstoryShop(arg_20_1.shop_schedule, SUBSTORY_CONSTANTS.ONE_WEEK)
	local var_20_1 = arg_20_1.category ~= nil and var_20_0
	local var_20_2 = arg_20_0.vars.wnd:getChildByName("btn_shop")
	
	if get_cocos_refid(var_20_2) then
		var_20_2:setVisible(var_20_1)
	end
end

function SubStoryWorldMapUIButtons.setVisibleBoard(arg_21_0)
	if_set_visible(arg_21_0.vars.wnd, "btn_board", SubstoryManager:isContentsType(SUBSTORY_CONTENTS_TYPE.FESTIVAL_FM))
end

function SubStoryWorldMapUIButtons.varPosition(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.vars.wnd:getChildByName("btn_substorypass")
	local var_22_1 = arg_22_1.pass_id ~= nil
	local var_22_2 = arg_22_1.shop_schedule == nil or SubstoryManager:isOpenSubstoryShop(arg_22_1.shop_schedule, SUBSTORY_CONSTANTS.ONE_WEEK)
	local var_22_3 = arg_22_1.category ~= nil and var_22_2
	local var_22_4 = arg_22_1.achieve_flag == "y"
	local var_22_5 = arg_22_0.vars.wnd:getChildByName("btn_shop")
	local var_22_6 = arg_22_0.vars.wnd:getChildByName("btn_achieve")
	
	if var_22_1 then
		if not var_22_3 and not var_22_4 then
			var_22_0:setPositionX(var_22_5:getPositionX())
		elseif not var_22_3 or not var_22_4 then
			var_22_0:setPositionX(var_22_6:getPositionX())
		end
	end
	
	if var_22_4 and get_cocos_refid(var_22_6) and not var_22_3 then
		var_22_6:setPositionX(var_22_5:getPositionX())
	end
end

function SubStoryWorldMapUIButtons.updateSubstoryNotifier(arg_23_0)
	if not arg_23_0.vars or not get_cocos_refid(arg_23_0.vars.wnd) then
		return 
	end
	
	local var_23_0 = SubstoryManager:getInfo()
	
	arg_23_0:updateAchieveNotifier(var_23_0)
	
	if SubstoryManager:isContentsType(SUBSTORY_CONTENTS_TYPE.FESTIVAL_FM) then
		local var_23_1 = arg_23_0.vars.wnd:getChildByName("btn_board")
		
		if get_cocos_refid(var_23_1) then
			SubStoryFestivalUIUtil:updateBoardRedDot(var_23_1)
		end
	end
end

function SubStoryWorldMapUIButtons.updateAchieveNotifier(arg_24_0, arg_24_1)
	if arg_24_1.achieve_flag == "y" then
		local var_24_0 = arg_24_0.vars.wnd:getChildByName("btn_achieve")
		
		if get_cocos_refid(var_24_0) then
			local var_24_1 = var_24_0:getChildByName("noti_icon")
			local var_24_2 = SubstoryUIUtil:isAchieveNotifier()
			
			var_24_1:setVisible(var_24_2)
		end
	end
end

SubStoryVillageUIButtons = SubStoryVillageUIButtons or {}

copy_functions(SubStoryWorldMapUIButtons, SubStoryVillageUIButtons)

function SubStoryVillageUIButtons.initUI(arg_25_0)
end

function SubStoryVillageUIButtons.btnHandler(arg_26_0, arg_26_1, arg_26_2)
	var_0_0(arg_26_1, arg_26_2)
	
	if arg_26_2 == "btn_village" then
		SubStoryChristmasVillage:show()
	end
end

function SubStoryVillageUIButtons.updateSubstoryNotifier(arg_27_0)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.vars.wnd) then
		return 
	end
	
	local var_27_0 = SubstoryManager:getInfo()
	
	arg_27_0:updateAchieveNotifier(var_27_0)
	
	local var_27_1 = arg_27_0.vars.wnd:getChildByName("btn_village")
	
	if get_cocos_refid(var_27_1) then
		local var_27_2 = ChristmasUtil:canRecieveTreeReward(var_27_0.id) or ChristmasUtil:can_building_upgradable(var_27_0.id) or ChristmasUtil:canRecieveCraftReward(var_27_0.id)
		
		if_set_visible(var_27_1, "noti_icon", var_27_2)
	end
end

SubStoryValentineUIButtons = SubStoryValentineUIButtons or {}

copy_functions(SubStoryWorldMapUIButtons, SubStoryValentineUIButtons)

function SubStoryValentineUIButtons.initUI(arg_28_0)
	local var_28_0 = WorldMapManager:getController()
	local var_28_1 = true
	local var_28_2 = 255
	
	if var_28_0 then
		local var_28_3 = var_28_0:getMapKey()
		local var_28_4, var_28_5 = DB("substory_inference_1_note", var_28_3, {
			"id",
			"enter_btn_unlock_stage"
		})
		
		if var_28_4 and var_28_5 and Account:checkEnterMap(var_28_5) then
			var_28_1 = false
		end
	end
	
	if var_28_1 then
		var_28_2 = 76.5
	end
	
	if_set_opacity(arg_28_0.vars.wnd, "btn_case_note", var_28_2)
	if_set_visible(arg_28_0.vars.wnd, "img_lock", var_28_1)
	
	local var_28_6 = SubstoryManager:getInfo()
	local var_28_7 = arg_28_0.vars.wnd:getChildByName("n_case_note")
	
	if var_28_6 and var_28_6.id and string.starts(var_28_6.id, "vfm3") then
		local var_28_8 = arg_28_0.vars.wnd:getChildByName("btn_case_note")
		
		if get_cocos_refid(var_28_8) then
			if_set(var_28_8, "label", T("ui_battle_map_valentine_btn_note2"))
		end
	end
	
	local var_28_9 = var_28_6.shop_schedule == nil or SubstoryManager:isOpenSubstoryShop(var_28_6.shop_schedule, SUBSTORY_CONSTANTS.ONE_WEEK)
	
	if not (var_28_6.category ~= nil and var_28_9) and get_cocos_refid(var_28_7) then
		if not var_28_7.origin_x then
			var_28_7.origin_x = var_28_7:getPositionX()
		end
		
		var_28_7:setPositionX(var_28_7.origin_x + 184)
	end
end

function SubStoryValentineUIButtons.btnHandler(arg_29_0, arg_29_1, arg_29_2)
	var_0_0(arg_29_1, arg_29_2)
	
	if arg_29_2 == "btn_case_note" then
		local var_29_0 = WorldMapManager:getController()
		
		if var_29_0 then
			SubStoryInferenceNote:show(var_29_0:getMapKey())
		end
	end
end

function SubStoryValentineUIButtons.updateSubstoryNotifier(arg_30_0)
	if not arg_30_0.vars or not get_cocos_refid(arg_30_0.vars.wnd) then
		return 
	end
	
	local var_30_0 = SubstoryManager:getInfo()
	
	arg_30_0:updateAchieveNotifier(var_30_0)
	
	local var_30_1 = SubStoryCustom:checkNoti()
	local var_30_2 = arg_30_0.vars.wnd:getChildByName("btn_case_note")
	
	if get_cocos_refid(var_30_2) then
		if_set_visible(var_30_2, "noti_icon", var_30_1)
	end
end
