UnitInfosController = {}

function UnitInfosController.onCreate(arg_1_0, arg_1_1)
	arg_1_1 = arg_1_1 or {}
	arg_1_0.vars = {}
	arg_1_0.vars.base_wnd = UnitMain.vars.base_wnd
	
	if not UnitDetail:isValid() then
		UnitDetail:onCreate(arg_1_1)
	end
	
	arg_1_0.vars.modeList = {
		Detail = UnitInfosDetail,
		Story = UnitInfosStory,
		Emotion = UnitInfosEmotion,
		SubStory = UnitInfosSubStory
	}
	arg_1_0.vars.mode = arg_1_1.info_mode
	
	if not UnitMain:isExistBackground() then
		local var_1_0 = SAVE:getKeep("unit_detail_bg_id")
		
		if not var_1_0 then
			return 
		end
		
		local var_1_1 = make_bgpack_item(var_1_0)
		
		UnitMain:setBackground(var_1_1)
	end
end

function UnitInfosController.onEnter(arg_2_0, arg_2_1, arg_2_2)
	arg_2_2 = arg_2_2 or {}
	
	local var_2_0 = arg_2_2.unit
	local var_2_1 = arg_2_2.info_mode or "Detail"
	local var_2_2 = UnitMain:getHeroBelt()
	
	var_2_2:changeMode("Detail")
	
	var_2_0 = var_2_0 or var_2_2:getItems()[1]
	
	if var_2_0 then
		UnitDetail:onSelectUnitViaTouch(var_2_0)
		var_2_2:scrollToUnit(var_2_0, 0)
	end
	
	if not UnitMain:isPortraitUseMode(arg_2_1) then
		UnitMain:enterPortrait()
	end
	
	if UnitMain:isExistBackground() and arg_2_1 ~= "Detail" then
		UnitMain:fadeInBackground()
	end
	
	UnitDetail:updateSwapButtons()
	arg_2_0:setMode(var_2_1)
	
	if arg_2_1 ~= "Detail" and var_2_1 == "Detail" then
		UnitDetail:enterCommonUI(UnitMain:needToShowUnitList(arg_2_1))
		UnitInfosDetail:setEquipVisible(true)
	end
end

function UnitInfosController.getSceneState(arg_3_0)
	if not arg_3_0.vars then
		return {}
	end
	
	return {
		unit = UnitDetail:getUnit(),
		start_mode = UnitMain.vars.start_mode,
		info_mode = arg_3_0.vars.mode
	}
end

function UnitInfosController.getMode(arg_4_0)
	return arg_4_0.vars and arg_4_0.vars.mode
end

function UnitInfosController.getUnit(arg_5_0)
	return UnitDetail:getUnit()
end

function UnitInfosController.setMode(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.vars.mode
	
	if var_6_0 then
		arg_6_0.vars.modeList[var_6_0]:onLeave()
	end
	
	SoundEngine:play("event:/ui/ok")
	
	arg_6_0.vars.mode = arg_6_1
	
	arg_6_0.vars.modeList[arg_6_0.vars.mode]:onCreate(arg_6_0.vars.base_wnd)
	
	if var_6_0 == "Detail" and arg_6_1 ~= "Detail" then
		UnitDetail:leaveCommonUI()
		UnitMain:showUnitList(false)
		UnitInfosDetail:setEquipVisible(false)
	elseif var_6_0 ~= nil and arg_6_1 == "Detail" then
		UnitDetail:enterCommonUI()
		UnitMain:showUnitList(true)
		UnitInfosDetail:setEquipVisible(true)
	end
end

function UnitInfosController.onTouchDown(arg_7_0, arg_7_1, arg_7_2)
	if not arg_7_0.vars or not arg_7_0.vars.mode then
		return 
	end
	
	local var_7_0 = arg_7_0.vars.modeList[arg_7_0.vars.mode]
	
	if not var_7_0 or not var_7_0.onTouchDown then
		return 
	end
	
	return var_7_0:onTouchDown(arg_7_1, arg_7_2)
end

function UnitInfosController.onTouchUp(arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_0.vars or not arg_8_0.vars.mode then
		return 
	end
	
	local var_8_0 = arg_8_0.vars.modeList[arg_8_0.vars.mode]
	
	if not var_8_0 or not var_8_0.onTouchUp then
		return 
	end
	
	return var_8_0:onTouchUp(arg_8_1, arg_8_2)
end

function UnitInfosController.onTouchMove(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_0.vars or not arg_9_0.vars.mode then
		return 
	end
	
	local var_9_0 = arg_9_0.vars.modeList[arg_9_0.vars.mode]
	
	if not var_9_0 or not var_9_0.onTouchMove then
		return 
	end
	
	return var_9_0:onTouchMove(arg_9_1, arg_9_2)
end

function UnitInfosController.onAfterUpdate(arg_10_0)
	if not arg_10_0.vars or not arg_10_0.vars.mode then
		return 
	end
	
	local var_10_0 = arg_10_0.vars.modeList[arg_10_0.vars.mode]
	
	if not var_10_0 or not var_10_0.onAfterUpdate then
		return 
	end
	
	return var_10_0:onAfterUpdate()
end

function UnitInfosController.onSelectUnitViaTouch(arg_11_0, arg_11_1, arg_11_2)
	UnitDetail:onSelectUnitViaTouch(arg_11_1, arg_11_2)
end

function UnitInfosController.onSelectUnit(arg_12_0, arg_12_1, arg_12_2)
	UnitDetail:onSelectUnit(arg_12_1, arg_12_2)
end

function UnitInfosController.onPushBackButton(arg_13_0)
	if arg_13_0.vars.mode == "Detail" then
		if UnitMain:getStartMode() == "Detail" then
			UnitMain:onStartModePushBackButton()
			
			return TopBarNew.BACK_BUTTON_RESULT.BACK_BUTTON_MANAGER_NEED_POP
		end
		
		UnitDetail:onPushBackButton()
	else
		arg_13_0:setMode("Detail")
	end
end

function UnitInfosController.onLeave(arg_14_0, arg_14_1, arg_14_2)
	if arg_14_0.vars.mode then
		arg_14_0.vars.modeList[arg_14_0.vars.mode]:onLeave()
	end
	
	if arg_14_1 ~= "Detail" then
		local var_14_0 = UnitMain:needToShowUnitList(arg_14_1)
		
		UnitDetail:leaveCommonUI(var_14_0)
		UnitInfosDetail:setEquipVisible(false)
		
		if arg_14_1 ~= nil then
			UnitMain:fadeOutBackground()
		end
	end
	
	if not UnitMain:isPortraitUseMode(arg_14_1) then
		UnitMain:leavePortrait(nil, arg_14_1 ~= "Main")
	end
end
