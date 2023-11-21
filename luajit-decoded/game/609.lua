CharPreviewController = {}
CharPreviewController.StateMachine = {}

function HANDLER.intro_hero3(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_ok" then
		CharPreviewController:handler()
	elseif arg_1_1 == "btn_summon" then
		CharPreviewController:moveToGacha(arg_1_0.gacha_id)
	end
end

function HANDLER.intro_hero2(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_forward" then
		CharPreviewController:skipHandler()
	end
end

function CharPreviewController.StateMachine.init(arg_3_0)
	arg_3_0.state = "init"
	arg_3_0.STATES = {
		init = {
			common_scene = true
		},
		common_scene = {
			pre_skill_preview = true
		},
		pre_skill_preview = {
			skill_preview = true
		},
		skill_preview = {
			pre_ending_scene = true
		},
		pre_ending_scene = {
			ending_scene = true
		},
		ending_scene = {
			next_skill_preview = true,
			leave_scene = true
		},
		next_skill_preview = {
			skill_preview = true
		},
		leave_scene = {}
	}
	arg_3_0.STATES_CALLBACK = {
		common_scene = CharPreviewController.onState_CommonScene,
		pre_skill_preview = CharPreviewController.onState_PreSkillPreview,
		skill_preview = CharPreviewController.onState_SkillPreview,
		pre_ending_scene = CharPreviewController.onState_PreEndingScene,
		ending_scene = CharPreviewController.onState_EndingScene,
		leave_scene = CharPreviewController.onState_LeaveScene,
		next_skill_preview = CharPreviewController.onState_NextSkillPreview
	}
end

function CharPreviewController.StateMachine.moveState(arg_4_0, arg_4_1)
	if not arg_4_1 then
		return 
	end
	
	if not arg_4_0.STATES[arg_4_0.state][arg_4_1] then
		return 
	end
	
	arg_4_0.state = arg_4_1
	
	arg_4_0.STATES_CALLBACK[arg_4_1](CharPreviewController)
end

function CharPreviewController.StateMachine.getState(arg_5_0)
	return arg_5_0.state
end

function CharPreviewController._next_char(arg_6_0)
	arg_6_0.vars.preview_char = arg_6_0.vars.preview_char_list[1]
	
	table.remove(arg_6_0.vars.preview_char_list, 1)
	
	return arg_6_0.vars.preview_char
end

function CharPreviewController.actionMoveState(arg_7_0, arg_7_1, arg_7_2)
	if not arg_7_0.vars.states then
		arg_7_0.vars.states = {}
	end
	
	arg_7_0.vars.states[arg_7_2] = true
	
	Action:AddAsync(SEQ(DELAY(arg_7_1), CALL(function()
		arg_7_0.StateMachine:moveState(arg_7_2)
	end), CALL(function()
		arg_7_0.vars.states[arg_7_2] = nil
	end)), {}, arg_7_2)
end

function CharPreviewController.skipState(arg_10_0, arg_10_1)
	for iter_10_0, iter_10_1 in pairs(arg_10_0.vars.states) do
		Action:Remove(iter_10_0)
		
		iter_10_1 = nil
	end
	
	Action:Remove(arg_10_0.StateMachine:getState())
	arg_10_0.StateMachine:moveState(arg_10_1)
end

function CharPreviewController.setSilent(arg_11_0)
	SoundEngine:setVolumeBattle(0)
	SoundEngine:setVolumeVoice(0)
	
	local var_11_0 = SoundEngine:getCollectSound()
	local var_11_1 = SAVE:getOptionData("sound.vol_battle", 1)
	local var_11_2 = SAVE:getOptionData("sound.vol_voice", 1)
	
	for iter_11_0, iter_11_1 in pairs(var_11_0) do
		local var_11_3 = iter_11_1.mode == "battle" and var_11_1 or var_11_2
		
		Action:Add(LINEAR_CALL(250, iter_11_1.sound, function(arg_12_0, arg_12_1)
			if get_cocos_refid(arg_12_0) then
				arg_12_0:setVolume(arg_12_1)
			end
		end, var_11_3, 0), {}, "bgm.fade")
	end
end

function CharPreviewController.setVolume(arg_13_0)
	SoundEngine:setVolumeBattle(SAVE:getOptionData("sound.vol_battle", 1))
	SoundEngine:setVolumeVoice(SAVE:getOptionData("sound.vol_voice", 1))
end

function CharPreviewController.setVoiceVolume(arg_14_0)
	SoundEngine:setVolumeVoice(SAVE:getOptionData("sound.vol_voice", 1))
end

function CharPreviewController.setVoiceSilent(arg_15_0)
	SoundEngine:setVolumeVoice(0)
end

function CharPreviewController.onState_CommonScene(arg_16_0)
	arg_16_0:_next_char()
	
	if not arg_16_0.vars.native_scene_mode then
		CharPreviewCommonPart:show(arg_16_0.vars.preview_layer, arg_16_0.vars.ui_layer, arg_16_0.vars.preview_char)
	end
	
	SoundEngine:playBGM("event:/bgm/hero_appearance")
	
	if not arg_16_0.vars.native_scene_mode then
		SoundEngine:play("event:/ui/new_hero/hero_appearance_1")
		
		local var_16_0 = CharPreviewData:getStartTime(arg_16_0.vars.preview_char)
		
		arg_16_0:actionMoveState(CharPreviewUtil.COMMON_PART_TIME - var_16_0, "pre_skill_preview")
		Action:AddAsync(SEQ(DELAY(1667), CALL(function()
			SoundEngine:play("event:/ui/new_hero/hero_appearance_2")
		end)), {})
	else
		arg_16_0:actionMoveState(0, "pre_skill_preview")
	end
	
	arg_16_0:setSilent()
end

function CharPreviewController.onState_PreSkillPreview(arg_18_0)
	CharPreviewSkillPart:prepare(arg_18_0.vars.preview_layer, arg_18_0.vars.ui_layer, arg_18_0.vars.preview_char)
	
	if not arg_18_0.vars.native_scene_mode then
		local var_18_0 = CharPreviewData:getStartTime(arg_18_0.vars.preview_char)
		
		arg_18_0.vars.white_out_layer:setOpacity(255)
		Action:Add(SEQ(DELAY(var_18_0 - 40), RLOG(FADE_OUT(100))), arg_18_0.vars.white_out_layer)
		arg_18_0:actionMoveState(var_18_0, "skill_preview")
	else
		arg_18_0:actionMoveState(0, "skill_preview")
	end
end

function CharPreviewController.onState_SkillPreview(arg_19_0)
	arg_19_0:setVolume()
	SoundEngine:collectStart()
	CharPreviewEndingPart:release()
	CharPreviewCommonPart:release()
	CharPreviewViewer:Resume()
	CharPreviewSkillPart:show()
	
	local var_19_0 = CharPreviewData:getEndTime(arg_19_0.vars.preview_char)
	
	arg_19_0:actionMoveState(var_19_0, "pre_ending_scene")
end

function CharPreviewController.onState_PreEndingScene(arg_20_0)
	arg_20_0.vars.white_out_layer:setOpacity(0)
	Action:AddAsync(SEQ(LOG(FADE_IN(350)), DELAY(167), LOG(FADE_OUT(500))), arg_20_0.vars.white_out_layer)
	arg_20_0:actionMoveState(350, "ending_scene")
end

function CharPreviewController.onState_EndingScene(arg_21_0)
	arg_21_0:setSilent()
	CharPreviewData:saveSpecificUnit(arg_21_0.vars.preview_char)
	SoundEngine:collectEnd()
	CharPreviewSkillPart:release()
	SoundEngine:play("event:/ui/new_hero/hero_appearance_end")
	arg_21_0:setVoiceVolume()
	CharPreviewEndingPart:show(arg_21_0.vars.preview_layer, arg_21_0.vars.ui_layer, arg_21_0.vars.preview_char)
	arg_21_0:setVoiceSilent()
	
	if #arg_21_0.vars.preview_char_list > 0 then
		arg_21_0:_next_char()
		
		local var_21_0 = CharPreviewData:getStartTime(arg_21_0.vars.preview_char)
		
		UIAction:Add(DELAY(var_21_0), {}, "block")
		arg_21_0:actionMoveState(0, "next_skill_preview")
	end
end

function CharPreviewController.onState_NextSkillPreview(arg_22_0)
	CharPreviewSkillPart:prepare(arg_22_0.vars.preview_layer, arg_22_0.vars.ui_layer, arg_22_0.vars.preview_char)
	
	local var_22_0 = CharPreviewData:getStartTime(arg_22_0.vars.preview_char)
	
	CharPreviewViewer:Pause(var_22_0)
end

function CharPreviewController.onState_LeaveScene(arg_23_0)
	arg_23_0:setVolume()
	SoundEngine:collectEnd()
	
	if not arg_23_0.vars.native_scene_mode then
		SceneManager:popScene()
	else
		if arg_23_0.vars.callback_for_native_mode and type(arg_23_0.vars.callback_for_native_mode) == "function" then
			arg_23_0.vars.callback_for_native_mode(arg_23_0.vars.native_node)
		end
		
		SceneManager:getRunningScene():removeExtendHandler(arg_23_0.vars._extend_handler)
		
		arg_23_0.vars._extend_handler = nil
		
		BattleAction:Resume()
		CharPreviewController:onUnload()
		CharPreviewViewer:Destroy()
		CameraManager:resetDefault()
		
		CharPreviewUtil.vars = {}
	end
	
	SAVE:sendQueryServerConfig()
end

function CharPreviewController.handler(arg_24_0)
	if arg_24_0.StateMachine:getState() == "next_skill_preview" then
		arg_24_0.vars.white_out_layer:setOpacity(255)
		Action:AddAsync(LOG(FADE_OUT(500)), arg_24_0.vars.white_out_layer)
		arg_24_0:actionMoveState(0, "skill_preview")
	else
		arg_24_0:actionMoveState(0, "leave_scene")
	end
end

function CharPreviewController.skipHandler(arg_25_0)
	if arg_25_0.StateMachine:getState() == "skill_preview" then
		CharPreviewViewer:Pause(0, true)
		arg_25_0:skipState("pre_ending_scene")
	end
end

function CharPreviewController.moveToGacha(arg_26_0, arg_26_1)
	if not arg_26_1 then
		return 
	end
	
	SAVE:sendQueryServerConfig()
	arg_26_0:setVolume()
	SoundEngine:collectEnd()
	SceneManager:popScene()
	SceneManager:nextScene("gacha_unit", {
		gacha_mode = arg_26_1
	})
end

function CharPreviewController.onLoad(arg_27_0, arg_27_1)
	arg_27_0.vars.white_out_layer = cc.LayerColor:create(cc.c3b(255, 255, 255))
	
	arg_27_0.vars.white_out_layer:setPositionX(VIEW_BASE_LEFT)
	arg_27_0.vars.white_out_layer:setOpacity(0)
	arg_27_0.vars.white_out_layer:setLocalZOrder(3)
	
	arg_27_0.vars.ui_layer = cc.Layer:create()
	
	arg_27_0.vars.ui_layer:setLocalZOrder(2)
	
	arg_27_0.vars.preview_layer = cc.Layer:create()
	
	arg_27_0.vars.preview_layer:setLocalZOrder(1)
	
	arg_27_0.vars.layer = arg_27_1
	
	arg_27_0.vars.layer:addChild(arg_27_0.vars.preview_layer)
	arg_27_0.vars.layer:addChild(arg_27_0.vars.white_out_layer)
	arg_27_0.vars.layer:addChild(arg_27_0.vars.ui_layer)
	arg_27_0.StateMachine:moveState("common_scene")
end

function CharPreviewController.onUnload(arg_28_0)
	CharPreviewViewer:Unload()
end

function CharPreviewController.isBattlePrepare(arg_29_0)
	if not arg_29_0.vars then
		return nil
	end
	
	return arg_29_0.vars.battleReady
end

function CharPreviewController.init_data(arg_30_0)
	arg_30_0.vars.preview_char_list = {}
	
	local var_30_0 = CharPreviewData:getCharacterList()
	
	for iter_30_0, iter_30_1 in pairs(var_30_0) do
		arg_30_0.vars.preview_char_list[iter_30_0] = iter_30_1
	end
end

function CharPreviewController.safetyCode(arg_31_0)
	if SceneManager:getCurrentSceneName() ~= "lobby" then
		SceneManager:nextScene("lobby")
	end
end

function CharPreviewController.init(arg_32_0)
	arg_32_0.vars = {}
	
	if not CharPreviewData:isShow() then
		arg_32_0:safetyCode()
		
		return 
	end
	
	if not CharPreviewData:init() then
		arg_32_0:safetyCode()
		
		return 
	end
	
	arg_32_0:init_data()
	arg_32_0.StateMachine:init()
	SceneManager:nextScene("char_preview")
end

function CharPreviewController.showAttributeChangeCinematic(arg_33_0, arg_33_1, arg_33_2)
	arg_33_0.vars = {
		native_scene_mode = true
	}
	
	local var_33_0 = CharPreviewUtil:AddDataFromDB(arg_33_1)
	
	if not CharPreviewData:init(var_33_0) then
		arg_33_0:safetyCode()
		
		return 
	end
	
	arg_33_0:init_data()
	arg_33_0.StateMachine:init()
	
	local var_33_1 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	local var_33_2 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_33_2:setName("black")
	var_33_2:setPositionX(-1000)
	var_33_1:addChild(var_33_2)
	var_33_2:setContentSize(99999, 99999)
	
	local var_33_3 = ccui.Button:create()
	
	var_33_3:setTouchEnabled(true)
	var_33_3:ignoreContentAdaptWithSize(false)
	var_33_3:setContentSize(99999, 99999)
	var_33_3:setPosition(0, 0)
	var_33_3:setName("touch_block")
	var_33_1:addChild(var_33_3)
	SceneManager:getRunningNativeScene():addChild(var_33_1)
	
	arg_33_0.vars.native_node = var_33_1
	arg_33_0.vars.callback_for_native_mode = arg_33_2.callback
	arg_33_0.vars._extend_handler = {
		onAfterDraw = function()
			CharPreviewViewer:onAfterDraw()
		end
	}
	
	SceneManager:getRunningScene():addExtendHandler(arg_33_0.vars._extend_handler)
	CharPreviewController:onLoad(var_33_1)
end

if not PRODUCTION_MODE then
	function CharPreviewController.d_init(arg_35_0, arg_35_1)
		arg_35_0.vars = {}
		
		if not CharPreviewData:init(arg_35_1) then
			arg_35_0:safetyCode()
			
			return 
		end
		
		arg_35_0:init_data()
		arg_35_0.StateMachine:init()
		SceneManager:nextScene("char_preview")
	end
	
	function CharPreviewController.native_scene_init(arg_36_0, arg_36_1)
		arg_36_0.vars = {
			native_scene_mode = true
		}
		
		if not CharPreviewData:init(arg_36_1) then
			arg_36_0:safetyCode()
			
			return 
		end
		
		arg_36_0:init_data()
		arg_36_0.StateMachine:init()
		
		local var_36_0 = cc.LayerColor:create(cc.c3b(0, 0, 0))
		local var_36_1 = cc.LayerColor:create(cc.c3b(0, 0, 0))
		
		var_36_1:setName("black")
		var_36_1:setPositionX(-1000)
		var_36_0:addChild(var_36_1)
		var_36_1:setContentSize(99999, 99999)
		SceneManager:getRunningNativeScene():addChild(var_36_0)
		
		arg_36_0.vars.native_node = var_36_0
		
		SceneManager:getRunningScene():addExtendHandler({
			onAfterDraw = function()
				CharPreviewViewer:onAfterDraw()
			end
		})
		CharPreviewController:onLoad(var_36_0)
	end
	
	function t_t(arg_38_0)
		CharPreviewDebug:ClearData("c3143")
		CharPreviewDebug:AddDataFromDB("c3143")
		CharPreviewDebug:StartTestData()
	end
	
	function CharPreviewController.showAdin(arg_39_0, arg_39_1)
		CharPreviewDebug:ClearData()
		CharPreviewDebug:AddDataFromDB(arg_39_1)
		CharPreviewDebug:StartAttributeChangeCinematic()
	end
end

function CharPreviewController.isCanShowPreview(arg_40_0)
	return CharPreviewData:isShow()
end
