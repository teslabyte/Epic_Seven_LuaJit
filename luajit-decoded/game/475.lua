function HANDLER.game_camp(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_back" then
		CampingSiteNew:showMainUI(false)
		
		if Battle.logic:getCampingTopicCount() > 0 then
			Dialog:msgBox(T("camp_exit_desc", {
				count = LIMIT_CAMPING_TOPIC - Battle.logic:getCampingTopicCount()
			}), {
				yesno = true,
				title = T("camp_exit_title"),
				handler = function()
					CampingSiteNew:exit()
				end,
				cancel_handler = function()
					CampingSiteNew:showMainUI(true)
				end
			})
		else
			CampingSiteNew:exit()
		end
		
		return 
	end
	
	local var_1_0 = tonumber(string.sub(arg_1_1, -1))
	
	if var_1_0 then
		CampingSiteNew:talkToIndex(var_1_0)
	end
end

function HANDLER.game_camp_detail(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_top_back" then
		CampingSiteNew:hideTopicUI()
		CampingSiteNew:showMainUI(true)
		
		return 
	end
	
	if string.starts(arg_4_1, "btn_topic") then
		if not arg_4_0.logged_topic then
			CampingSiteNew:selectTopic(string.sub(arg_4_1, -1))
		end
		
		return 
	end
end

function HANDLER.game_camp_result(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_close" then
		CampingSiteNew:hideResultPopup()
	end
end

CampingSiteNew = {}

function CampingSiteNew.enter(arg_6_0, arg_6_1)
	SoundEngine:playBGM("event:/bgm/battle_camp")
	
	arg_6_0._callback = arg_6_1
	arg_6_0._active = true
	arg_6_0.main_ui = nil
	arg_6_0.prev_time_scale = getenv("time_scale")
	
	setenv("time_scale", 1.2)
	
	local var_6_0 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	local var_6_1 = SceneManager:getDefaultLayer()
	
	var_6_0:setOpacity(0)
	var_6_0:setPosition(VIEW_BASE_LEFT, 0)
	var_6_0:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	var_6_1:addChild(var_6_0)
	BattleAction:Add(SEQ(FADE_IN(400), DELAY(400), FADE_OUT(800)), var_6_0, "battle.camping_curtain")
	BattleAction:Add(SEQ(DELAY(400), CALL(CampingSiteNew.doEnterStage, arg_6_0)), var_6_1, "block")
end

function CampingSiteNew.exit(arg_7_0)
	arg_7_0:viewEffect("leave")
	BattleAction:Add(SEQ(DELAY(6000), CALL(play_curtain, SceneManager:getDefaultLayer(), 0, 200, 200, 400, "battle.camping", false, 999, 1, cc.c3b(0, 0, 0)), DELAY(200), CALL(CampingSiteNew.doLeaveStage, arg_7_0)), arg_7_0.layer, "battle.camping")
end

function CampingSiteNew.isActive(arg_8_0)
	return arg_8_0._active
end

function CampingSiteNew.doLeaveStage(arg_9_0)
	local var_9_0 = Battle.logic:getCurrentRoadInfo()
	local var_9_1 = DB("level_stage_1_info", var_9_0.road_id, "bgm")
	
	SoundEngine:playBGM("event:/bgm/" .. (var_9_1 or "map01"))
	
	arg_9_0._active = false
	arg_9_0.field = nil
	arg_9_0.logic = nil
	
	arg_9_0:showAlreadyStage(true)
	
	if get_cocos_refid(arg_9_0.ui_layer) then
		arg_9_0.ui_layer:removeFromParent()
	end
	
	if get_cocos_refid(arg_9_0.layer) then
		arg_9_0.layer:removeFromParent()
	end
	
	if get_cocos_refid(arg_9_0.main_ui) then
		arg_9_0.main_ui:removeFromParent()
	end
	
	arg_9_0.ui_layer = nil
	arg_9_0.layer = nil
	arg_9_0.main_ui = nil
	arg_9_0.camping_data = nil
	
	setenv("time_scale", arg_9_0.prev_time_scale)
	BattleTopBar:updateCampingButton()
	saveBattleInfo()
	
	if Battle.logic:getCampingTopicCount() > 0 then
		local var_9_2 = Battle.logic:getBattleUID()
		
		ConditionContentsManager:dispatch("battle.camping", {
			unique_id = var_9_2
		})
	end
	
	if type(arg_9_0._callback) == "function" then
		arg_9_0._callback()
	end
	
	arg_9_0._callback = nil
end

function CampingSiteNew.doEnterStage(arg_10_0)
	arg_10_0:showAlreadyStage(false)
	
	local var_10_0, var_10_1 = FIELD_NEW:create("camping", VIEW_WIDTH * 2, false, {
		viewport_height = 3800
	})
	
	arg_10_0.layer = var_10_0
	arg_10_0.field = var_10_1
	
	var_10_1:setViewPortPosition(DESIGN_WIDTH * 0.5)
	var_10_1:updateViewport()
	
	local var_10_2 = SceneManager:getDefaultLayer()
	
	var_10_2:addChild(var_10_0)
	arg_10_0:initUILayer()
	
	arg_10_0.logic = Battle.logic
	
	local var_10_3 = 0
	
	for iter_10_0 = 1, 4 do
		local var_10_4 = arg_10_0:getUnitByPos(iter_10_0)
		
		if var_10_4 then
			local var_10_5 = CACHE:getModelWithCheckAnim(var_10_4.db.model_id, var_10_4.db.skin, "camping", "idle", var_10_4.db.atlas, var_10_4.db.model_opt)
			
			if get_cocos_refid(var_10_5) then
				var_10_5:setName("model_" .. iter_10_0)
				var_10_1.main.layer:addChild(var_10_5)
				
				var_10_3 = var_10_3 + 1
				
				arg_10_0:layoutModel(var_10_5, var_10_4.inst.pos)
			end
		end
	end
	
	arg_10_0:viewEffect("enter")
	BattleAction:Add(SEQ(DELAY(3000), CALL(CampingSiteNew.showMainUI, arg_10_0, true)), var_10_2, "battle.camping")
end

function CampingSiteNew.showAlreadyStage(arg_11_0, arg_11_1)
	local var_11_0 = SceneManager:getDefaultLayer()
	
	for iter_11_0, iter_11_1 in pairs(var_11_0:getChildren()) do
		iter_11_1:setVisible(arg_11_1)
	end
end

function CampingSiteNew.getLayoutData(arg_12_0, arg_12_1)
	return ({
		{
			x = 450,
			y = 190
		},
		{
			flip = true,
			x = 790,
			y = 167
		},
		{
			x = 390,
			y = 80
		},
		{
			flip = true,
			x = 830,
			y = 80
		},
		{
			x = 680,
			y = 300
		},
		{
			flip = true,
			x = 780,
			y = 300
		}
	})[arg_12_1]
end

function CampingSiteNew.layoutModel(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0:getLayoutData(arg_13_2)
	
	arg_13_1:setPosition(var_13_0.x, var_13_0.y)
	
	if var_13_0.flip then
		arg_13_1:setScaleX(-arg_13_1:getScaleX())
		
		arg_13_1.camp_flip = true
	end
	
	arg_13_1.camp_z = arg_13_1:getLocalZOrder()
	
	arg_13_1:setLocalZOrder(arg_13_2)
end

function CampingSiteNew.initUILayer(arg_14_0)
	local var_14_0 = ccui.Button:create()
	
	var_14_0:setTouchEnabled(true)
	var_14_0:ignoreContentAdaptWithSize(false)
	var_14_0:setContentSize(DESIGN_WIDTH, 3000)
	var_14_0:setPosition(0, 0)
	var_14_0:setAnchorPoint(0, 0)
	var_14_0:addTouchEventListener(function(arg_15_0, arg_15_1)
	end)
	var_14_0:setName("@camp_ui_layer")
	
	local var_14_1 = ccui.Button:create()
	
	var_14_1:setTouchEnabled(true)
	var_14_1:ignoreContentAdaptWithSize(false)
	var_14_1:setContentSize(VIEW_WIDTH, 3000)
	var_14_1:setPosition(VIEW_BASE_LEFT, 0)
	var_14_1:setAnchorPoint(0, 0)
	var_14_1:addTouchEventListener(function(arg_16_0, arg_16_1)
	end)
	var_14_1:setName("@blank")
	var_14_1:setLocalZOrder(-1)
	var_14_0:addChild(var_14_1)
	arg_14_0.layer:addChild(var_14_0)
	
	arg_14_0.ui_layer = var_14_0
end

function CampingSiteNew.showMainUI(arg_17_0, arg_17_1)
	if arg_17_0.logic:getCampingTopicCount() >= LIMIT_CAMPING_TOPIC then
		arg_17_0:exit()
		
		return 
	end
	
	local var_17_0
	
	if not get_cocos_refid(arg_17_0.main_ui) then
		var_17_0 = load_dlg("game_camp", true, "wnd")
		
		arg_17_0.ui_layer:addChild(var_17_0)
		
		arg_17_0.main_ui = var_17_0
		
		local var_17_1 = var_17_0:getChildByName("btn_back")
		
		if get_cocos_refid(var_17_1) then
			var_17_1:setPositionX(var_17_1:getPositionX() + VIEW_BASE_LEFT)
		end
		
		for iter_17_0 = 1, 4 do
			local var_17_2 = var_17_0:getChildByName("cm_icon_hero" .. iter_17_0)
			
			if arg_17_0:getUnitByPos(iter_17_0) then
				local var_17_3 = arg_17_0:getLayoutData(iter_17_0)
				
				var_17_2:setPosition(var_17_3.x, var_17_3.y)
				var_17_2:setVisible(true)
			else
				var_17_2:setVisible(false)
			end
		end
	end
	
	arg_17_0.main_ui:setVisible(arg_17_1)
	
	local var_17_4 = math.max(0, LIMIT_CAMPING_TOPIC - arg_17_0.logic:getCampingTopicCount())
	
	if_set(arg_17_0.main_ui, "txt", T("ui_camping_conversation_num", {
		count = var_17_4
	}))
end

function CampingSiteNew.viewEffect(arg_18_0, arg_18_1)
	local var_18_0 = DESIGN_WIDTH / 2
	local var_18_1 = {
		TO_Y = 0,
		FROM_Y = 900,
		TOTAL_TIME = 3000,
		field = arg_18_0.field,
		Start = function(arg_19_0)
			arg_19_0.START_Y = 0
		end,
		Update = function(arg_20_0, arg_20_1, arg_20_2)
			local var_20_0 = (arg_20_1.elapsed_time + (arg_20_2 or 0)) / arg_20_1.TOTAL_TIME
			
			arg_20_0.field:setViewPortPosition(var_18_0, arg_20_0.FROM_Y + var_20_0 * (arg_20_0.TO_Y - arg_20_0.FROM_Y))
			arg_20_0.field:updateViewport()
		end,
		Finish = function(arg_21_0)
			arg_21_0.field:setViewPortPosition(var_18_0, arg_21_0.TO_Y)
			arg_21_0.field:updateViewport()
		end
	}
	local var_18_2 = {
		TO_Y = 1320,
		FROM_Y = 0,
		TOTAL_TIME = 6000,
		TO_X = var_18_0,
		field = arg_18_0.field,
		Start = function(arg_22_0)
			arg_22_0.START_Y = 0
		end,
		Update = function(arg_23_0, arg_23_1, arg_23_2)
			local var_23_0 = (arg_23_1.elapsed_time + (arg_23_2 or 0)) / arg_23_1.TOTAL_TIME
			
			arg_23_0.field:setViewPortPosition(var_18_0, arg_23_0.FROM_Y + var_23_0 * (arg_23_0.TO_Y - arg_23_0.FROM_Y))
			arg_23_0.field:updateViewport()
		end,
		Finish = function(arg_24_0)
			arg_24_0.field:setViewPortPosition(var_18_0, arg_24_0.TO_Y)
			arg_24_0.field:updateViewport()
		end
	}
	
	if arg_18_1 == "leave" then
		BattleAction:Add(USER_ACT(var_18_2), arg_18_0.field, "battle.camping_cam")
	else
		arg_18_0.field:setViewPortPosition(var_18_0, 900)
		arg_18_0.field:updateViewport()
		BattleAction:Add(USER_ACT(var_18_1), arg_18_0.field, "battle.camping_cam")
	end
end

function CampingSiteNew.getFriendUnits(arg_25_0, arg_25_1)
	local var_25_0 = {}
	
	for iter_25_0, iter_25_1 in pairs(arg_25_0.logic.starting_friends) do
		if iter_25_1 and iter_25_1.db.code ~= arg_25_1.db.code and not iter_25_1:isDead() then
			table.insert(var_25_0, iter_25_1)
		end
	end
	
	return var_25_0
end

function CampingSiteNew.getUnitByPos(arg_26_0, arg_26_1)
	local var_26_0
	
	for iter_26_0, iter_26_1 in pairs(arg_26_0.logic.starting_friends) do
		if iter_26_1 and iter_26_1.inst.pos == arg_26_1 and not iter_26_1:isDead() then
			var_26_0 = iter_26_1
			
			break
		end
	end
	
	return var_26_0
end

function CampingSiteNew.talkToIndex(arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0:getUnitByPos(arg_27_1)
	
	if var_27_0 then
		arg_27_0._select_unit_idx = arg_27_1
		
		arg_27_0:showTopicUI(var_27_0)
		arg_27_0:showMainUI(false)
	end
end

function CampingSiteNew.isLoggedTopic(arg_28_0, arg_28_1, arg_28_2)
	if not arg_28_1 then
		return false
	end
	
	local var_28_0 = arg_28_1.db["topic_" .. arg_28_2]
	
	if not var_28_0 then
		return false
	end
	
	local var_28_1 = arg_28_0.logic:getCampingData() or {}
	
	for iter_28_0, iter_28_1 in pairs(var_28_1) do
		if iter_28_1.topic == var_28_0 then
			return true
		end
	end
	
	return false
end

function CampingSiteNew.showTopicUI(arg_29_0, arg_29_1)
	if get_cocos_refid(arg_29_0.topic_ui) then
		arg_29_0:hideTopicUI()
	end
	
	local var_29_0 = load_dlg("game_camp_detail", true, "wnd", function()
		CampingSiteNew:hideTopicUI()
		CampingSiteNew:showMainUI(true)
	end)
	
	arg_29_0.ui_layer:addChild(var_29_0)
	
	local var_29_1 = arg_29_0.ui_layer:getChildByName("@talk_btn")
	
	if get_cocos_refid(var_29_1) then
		var_29_1:removeFromParent()
	end
	
	arg_29_0.topic_ui = var_29_0
	
	if_set(arg_29_0.topic_ui, "txt_name", T(arg_29_1.db.name))
	
	if not arg_29_0.logic:getCampingData() then
		local var_29_2 = {}
	end
	
	local var_29_3 = arg_29_0:getFriendUnits(arg_29_1)
	
	for iter_29_0 = 1, 2 do
		local var_29_4 = arg_29_0.topic_ui:getChildByName("n_sel" .. iter_29_0 .. "_intimacy")
		local var_29_5 = arg_29_0.topic_ui:getChildByName("n_btn" .. iter_29_0)
		local var_29_6 = arg_29_1.db["topic_" .. iter_29_0]
		local var_29_7 = var_29_6 ~= nil
		
		var_29_5:setVisible(var_29_7)
		var_29_4:setVisible(var_29_7)
		
		local var_29_10
		
		if var_29_6 then
			if_set(var_29_5, "txt", T(var_29_6))
			
			local var_29_8 = var_29_5:getChildByName("btn_topic_" .. iter_29_0)
			
			if get_cocos_refid(var_29_8) then
				var_29_8.logged_topic = arg_29_0:isLoggedTopic(arg_29_1, iter_29_0)
				
				local var_29_9 = var_29_8.logged_topic and 76 or 255
				
				var_29_5:setOpacity(var_29_9)
				var_29_4:setOpacity(var_29_9)
				
				var_29_10 = CampingSiteNew:setUnitsNode(var_29_4, #var_29_3)
				
				if get_cocos_refid(var_29_10) then
					for iter_29_1, iter_29_2 in pairs(var_29_3) do
						local var_29_11 = {
							unit_code = iter_29_2.db.code
						}
						
						if iter_29_2:isMoonlightDestinyUnit() then
							var_29_11.unit_code = MoonlightDestiny:getRelationCharacterCode(var_29_11.unit_code)
						end
						
						var_29_11.skin_code = iter_29_2.inst.skin_code
						var_29_11.point = 0
						
						for iter_29_3 = 1, 2 do
							local var_29_12 = iter_29_2.db["personality_" .. iter_29_3]
							
							if var_29_12 then
								local var_29_13 = DB("camp_utterance", var_29_6, var_29_12) or 0
								
								if var_29_13 < 0 then
									var_29_13 = 0
								end
								
								var_29_11.point = var_29_11.point + var_29_13
							end
						end
						
						CampingSiteNew:setFriendCtrl(var_29_10:getChildByName(tostring(iter_29_1)), var_29_11)
					end
				end
			end
		end
	end
	
	if_set_visible(arg_29_0.topic_ui, "n_talk", false)
	if_set_visible(arg_29_0.topic_ui, "n_select_topic", true)
	
	local var_29_14 = arg_29_1:getFaceIDForCamp()
	local var_29_15, var_29_16 = UIUtil:getPortraitAni(var_29_14, {
		pin_sprite_position_y = true
	})
	
	if var_29_15 then
		var_29_15:setAnchorPoint(0.5, 0)
		
		if var_29_16 then
		else
			var_29_15:setPositionY(-100)
		end
		
		arg_29_0.topic_ui:getChildByName("portrait"):addChild(var_29_15)
		var_29_15:setOpacity(0)
		UIAction:Add(SPAWN(FADE_IN(200)), var_29_15, "battle.portrait")
	end
	
	local var_29_17 = arg_29_0.topic_ui:getChildByName("RIGHT")
	
	var_29_17:setPositionX(VIEW_WIDTH / 2)
	var_29_17:setOpacity(0)
	UIAction:Add(SPAWN(FADE_IN(120), MOVE_TO(120, 0, 0)), var_29_17, "battle.topic_ui")
end

function CampingSiteNew.hideTopicUI(arg_31_0)
	local function var_31_0(arg_32_0)
		if get_cocos_refid(arg_32_0.topic_ui) then
			arg_32_0.topic_ui:removeFromParent()
			
			arg_32_0.topic_ui = nil
		end
	end
	
	local var_31_1 = arg_31_0.topic_ui:getChildByName("RIGHT")
	
	UIAction:Add(SPAWN(FADE_OUT(120)), var_31_1, "block")
	
	local var_31_2 = arg_31_0.topic_ui:getChildByName("portrait")
	
	UIAction:Add(SEQ(FADE_OUT(120), CALL(var_31_0, arg_31_0)), var_31_2, "block")
	BackButtonManager:pop("game_camp_detail")
end

function CampingSiteNew.selectTopic(arg_33_0, arg_33_1)
	if_set_visible(arg_33_0.topic_ui, "n_talk", true)
	
	local var_33_0 = arg_33_0:getUnitByPos(arg_33_0._select_unit_idx)
	local var_33_1 = var_33_0.db.code
	
	if var_33_0:isMoonlightDestinyUnit() then
		var_33_1 = MoonlightDestiny:getRelationCharacterCode(var_33_1)
	end
	
	local var_33_2 = ccui.Button:create()
	
	var_33_2:setTouchEnabled(true)
	var_33_2:ignoreContentAdaptWithSize(false)
	var_33_2:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	var_33_2:setPosition(0, 0)
	var_33_2:setAnchorPoint(0, 0)
	
	local function var_33_3()
		if UIAction:Find("block") then
			return 
		end
		
		if arg_33_0.voc_player and arg_33_0.voc_player:tryStop() == false then
			return 
		end
		
		arg_33_0.voc_player = nil
		
		CampingSiteNew:topicRequest(arg_33_1)
		var_33_2:setTouchEnabled(false)
		BackButtonManager:pop("talk")
	end
	
	BackButtonManager:push({
		check_id = "talk",
		back_func = var_33_3
	})
	var_33_2:addTouchEventListener(function(arg_35_0, arg_35_1)
		if arg_35_1 ~= 2 then
			return 
		end
		
		var_33_3()
	end)
	var_33_2:setName("@talk_btn")
	arg_33_0.ui_layer:addChild(var_33_2)
	
	local var_33_4 = var_33_0:getSkinCode()
	local var_33_5 = var_33_1
	
	if var_33_4 then
		local var_33_6 = string.format("%s_camping_%02d", var_33_4, arg_33_1)
		
		if DB("character_intimacy_voice", var_33_6, "id") then
			var_33_5 = var_33_4
		end
	end
	
	if_set(arg_33_0.topic_ui, "txt_info", " ")
	
	local var_33_7 = T("utterance_" .. var_33_1 .. "_" .. arg_33_1)
	
	if var_33_4 then
		local var_33_8 = T("utterance_" .. var_33_4 .. "_" .. arg_33_1)
		
		if DEBUG_TEXT_ID or not string.starts(var_33_8, "@utterance_") and not string.starts(var_33_8, "utterance_") then
			var_33_7 = var_33_8
		end
	end
	
	UIAction:Add(TEXT(var_33_7), arg_33_0.topic_ui:getChildByName("txt_info"))
	if_set_visible(arg_33_0.topic_ui, "n_select_topic", false)
	
	local var_33_9 = arg_33_0.topic_ui:getChildByName("n_cursor")
	
	if get_cocos_refid(var_33_9) then
		local var_33_10 = DB("character_intimacy_voice", string.format("%s_camping_%02d", var_33_5, arg_33_1), "sound_id")
		local var_33_11 = "event:/" .. var_33_10
		
		arg_33_0.voc_player = UIHelper:playTalkVoice(var_33_11, var_33_9, var_33_9:getChildByName("move_updown"), "battle.camping_cursor")
	end
end

function CampingSiteNew.topicRequest(arg_36_0, arg_36_1)
	local var_36_0 = assert(arg_36_0:getUnitByPos(arg_36_0._select_unit_idx))
	
	arg_36_0.logic:command({
		cmd = "CampingTopic",
		topic_idx = arg_36_1,
		unit_uid = var_36_0.inst.uid
	})
	
	arg_36_0._select_unit_idx = nil
end

function CampingSiteNew.topicResult(arg_37_0, arg_37_1)
	if not arg_37_1 then
		return 
	end
	
	saveBattleInfo()
	
	for iter_37_0, iter_37_1 in pairs(arg_37_1.unit_list) do
		if iter_37_1.point ~= 0 then
			local var_37_0 = arg_37_0.field.main.layer:getChildByName("model_" .. iter_37_1.unit_pos)
			
			if get_cocos_refid(var_37_0) then
				local var_37_1, var_37_2 = var_37_0:getBonePosition("top")
				local var_37_3 = arg_37_0:getLayoutData(iter_37_1.unit_pos).flip
				
				if iter_37_1.point > 0 then
					local function var_37_4()
						local var_38_0 = "ui_camping_note" .. math.random(1, 3) + (var_37_3 and 3 or 0) .. ".cfx"
						
						EffectManager:Play({
							fn = var_38_0,
							layer = arg_37_0.ui_layer,
							x = var_37_1,
							y = var_37_2
						})
						SoundEngine:play("event:/effect/ui_camping_happy")
					end
					
					UIAction:Add(REPEAT(iter_37_1.point, SEQ(CALL(var_37_4), DELAY(200))), arg_37_0.ui_layer, "battle.camping_result")
				else
					local var_37_5 = var_37_3 and 30 or -30
					
					UIAction:Add(SEQ(DELAY(1000), CALL(EffectManager.Play, EffectManager, {
						fn = "ui_camping_boring.cfx",
						layer = arg_37_0.ui_layer,
						x = var_37_1 + var_37_5,
						y = var_37_2,
						flip_x = not var_37_3
					})), arg_37_0.ui_layer, "battle.camping_result")
				end
			end
		end
	end
	
	local var_37_6 = 0
	local var_37_7 = 1600
	
	if arg_37_1.min_point == 0 and arg_37_1.max_point == 0 then
		var_37_6 = 0
	elseif var_37_7 < arg_37_1.max_point * 200 then
		var_37_6 = arg_37_1.max_point * 200
	else
		var_37_6 = var_37_7
	end
	
	UIAction:Add(SEQ(CALL(CampingSiteNew.hideTopicUI, arg_37_0), DELAY(400 + var_37_6), CALL(CampingSiteNew.showResultPopup, arg_37_0, arg_37_1.unit_list, arg_37_1.morale_info)), arg_37_0.ui_layer, "battle.camping_result")
end

function CampingSiteNew.setUnitsNode(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = arg_39_1:getChildByName("n_hero_1-3")
	local var_39_1 = arg_39_1:getChildByName("n_hero_2")
	
	if_set_visible(var_39_0, nil, arg_39_2 == 1 or arg_39_2 == 3)
	if_set_visible(var_39_1, nil, arg_39_2 == 2)
	
	if arg_39_2 == 1 then
		var_39_0:findChildByName("1"):removeFromParent()
		var_39_0:findChildByName("2"):setName("1")
		var_39_0:findChildByName("3"):removeFromParent()
		
		return var_39_0
	end
	
	if arg_39_2 == 2 then
		return var_39_1
	end
	
	if arg_39_2 == 3 then
		return var_39_0
	end
	
	return nil
end

function CampingSiteNew.setFriendCtrl(arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	if not get_cocos_refid(arg_40_1) then
		return 
	end
	
	arg_40_3 = arg_40_3 or {}
	
	arg_40_1:setVisible(true)
	
	local var_40_0 = DB("character", arg_40_2.skin_code or arg_40_2.unit_code, "face_id")
	
	if_set_sprite(arg_40_1, "face", "face/" .. var_40_0 .. "_s.png")
	
	local var_40_1 = "t_count_" .. (arg_40_2.point > 0 and "up" or "down")
	local var_40_2 = arg_40_1:findChildByName("n_intimacy")
	
	if_set_visible(var_40_2, "cm_icon_etccompu_up", arg_40_2.point > 0)
	if_set_visible(var_40_2, "cm_icon_etccompu_keep", arg_40_2.point == 0)
	if_set_visible(var_40_2, "cm_icon_etccompu_down", arg_40_2.point < 0)
	if_set(var_40_2, var_40_1, math.abs(arg_40_2.point))
	
	local var_40_3 = arg_40_1:findChildByName("n_morale")
	
	if_set_visible(var_40_3, "cm_icon_etccompu_up", arg_40_2.point > 0)
	if_set_visible(var_40_3, "cm_icon_etccompu_keep", arg_40_2.point <= 0)
	if_set(var_40_3, var_40_1, math.max(0, arg_40_2.point))
	
	if arg_40_3.show_effect then
		EffectManager:Play({
			fn = arg_40_2.point < 0 and "ui_result_hate.cfx" or "ui_result_love.cfx",
			layer = arg_40_1
		})
	end
end

function CampingSiteNew.showResultPopup(arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = #arg_41_1
	
	if table.empty(arg_41_1) then
		arg_41_0:showMainUI(true)
		
		return 
	end
	
	local var_41_1 = load_dlg("game_camp_result", true, "wnd", function()
		CampingSiteNew:hideResultPopup()
	end)
	local var_41_2 = CampingSiteNew:setUnitsNode(var_41_1, var_41_0)
	local var_41_3 = 0
	
	if get_cocos_refid(var_41_2) then
		for iter_41_0, iter_41_1 in pairs(arg_41_1) do
			CampingSiteNew:setFriendCtrl(var_41_2:getChildByName(tostring(iter_41_0)), iter_41_1, {
				show_effect = true
			})
			
			var_41_3 = var_41_3 + iter_41_1.point
		end
	end
	
	if_set_visible(var_41_1, "morale_up", false)
	if_set_visible(var_41_1, "morale_down", false)
	arg_41_0:updateMorale(var_41_1:getChildByName("n_smile_before"), arg_41_2.before_morale)
	arg_41_0:updateMorale(var_41_1:getChildByName("n_smile_after"), arg_41_2.after_morale)
	
	if arg_41_2.changed_morale ~= 0 then
		local var_41_4 = arg_41_2.changed_morale > 0 and "up" or "down"
		local var_41_5 = var_41_1:getChildByName("morale_" .. var_41_4)
		
		if get_cocos_refid(var_41_5) then
			var_41_5:setVisible(true)
			if_set(var_41_5, "t_count", math.abs(arg_41_2.changed_morale))
		end
	end
	
	if_set_arrow(var_41_1)
	arg_41_0.ui_layer:addChild(var_41_1)
end

function CampingSiteNew.hideResultPopup(arg_43_0)
	local var_43_0 = arg_43_0.ui_layer:getChildByName("game_camp_result")
	
	if get_cocos_refid(var_43_0) then
		var_43_0:removeFromParent()
	end
	
	arg_43_0:showMainUI(true)
	BackButtonManager:pop("game_camp_result")
end

function CampingSiteNew.updateMorale(arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = Battle.logic:getMoraleLevel(arg_44_2)
	
	if get_cocos_refid(arg_44_1) then
		for iter_44_0 = 1, UI_MORALE_LEVEL_COUNT do
			local var_44_1 = arg_44_1:getChildByName("i" .. iter_44_0)
			
			var_44_1:setVisible(iter_44_0 == var_44_0)
			if_set(var_44_1, "t_count", arg_44_2)
		end
	end
end
