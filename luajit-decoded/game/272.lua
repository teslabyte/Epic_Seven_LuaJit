ClassChange = {}
ClassChange.vars = {}
ClassChangeMainList = {}
ClassChangeMainList.vars = {}

function MsgHandler.classchange_add(arg_1_0)
	ClassChange:setClassChangeInfo(arg_1_0)
	
	local var_1_0 = ClassChange:getUnitInfo(arg_1_0.target_code)
	
	ClassChange:closeBatchPopup()
	
	if arg_1_0.first_batched and var_1_0.db.start_story then
		start_new_story(nil, var_1_0.db.start_story, {
			force_on_finish = true,
			force = true,
			on_finish = function()
				ClassChange:showUnitDetail(var_1_0)
			end
		})
	else
		ClassChange:showUnitDetail(var_1_0)
	end
	
	BackPlayManager:forceStopPlay("classchange_add")
	ConditionContentsManager:getClassChangeQuest():initConditionListner()
	BackButtonManager:pop()
	BackButtonManager:pop()
end

function MsgHandler.classchange_finish(arg_3_0)
	Account:replaceUnit(arg_3_0.new_unit)
	
	local var_3_0 = SceneManager:getCurrentSceneName()
	local var_3_1 = Account:getUnit(arg_3_0.target_uid)
	
	if var_3_0 == "class_change" then
		ClassChange:setClassChangeInfo(arg_3_0)
		ClassChange:onPushBackButton()
	elseif UnitMain:isValid() and (var_3_0 == "unit_ui" or UnitMain:isPopupMode()) then
		UnitMain:removePortrait()
		HeroBelt:getInst("UnitMain"):updateUnit(nil, var_3_1)
		UnitDetail:updateUnitInfo(var_3_1)
		UnitMain:setMode("Detail", {
			unit = var_3_1
		})
	else
		SceneManager:nextScene("unit_ui", {
			mode = "Detail",
			unit = var_3_1
		})
	end
	
	local var_3_2 = ClassChange:makeDBInfo()[arg_3_0.target_code]
	
	if arg_3_0.first_cleared and var_3_2.db.clear_story then
		start_new_story(nil, var_3_2.db.clear_story, {
			force_on_finish = true,
			force = true,
			on_finish = function()
				ClassChange:playUnitEffect(arg_3_0.target_code, arg_3_0.new_code, function()
					if var_3_0 == "class_change" then
						SceneManager:nextScene("unit_ui", {
							mode = "Zodiac",
							unit = var_3_1
						})
					end
				end)
			end
		})
	else
		ClassChange:playUnitEffect(arg_3_0.target_code, arg_3_0.new_code, function()
		end)
	end
	
	ConditionContentsManager:dispatch("sync.classchange")
end

function MsgHandler.classchange_stop(arg_7_0)
	ClassChange:setClassChangeInfo(arg_7_0)
	ClassChange:onPushBackButton()
	BackPlayManager:forceStopPlay("classchange_stop")
	ConditionContentsManager:getClassChangeQuest():initConditionListner()
end

function MsgHandler.get_reward_classchange_quest(arg_8_0)
	local var_8_0 = {
		title = T("clear_cc_quest_title"),
		desc = T("clear_cc_quest_reward_msg")
	}
	
	Account:addReward(arg_8_0.rewards, {
		play_reward_data = var_8_0
	})
	Account:setClassChangeQuest(arg_8_0.contents_id, arg_8_0.quest_doc)
	ClassChangeQuestList:ItemListRefresh()
	ClassChange:updateQuestProgress()
	ClassChange:setDetailData()
	ClassChange:updateCCButtonState()
	ClassChangeMainList:refresh()
end

function MsgHandler.give_classchange_quest(arg_9_0)
	Account:addReward(arg_9_0.result)
	Account:setClassChangeQuest(arg_9_0.contents_id, arg_9_0.quest_doc)
	
	if arg_9_0.conditions and arg_9_0.conditions.clear_conditions then
		for iter_9_0, iter_9_1 in pairs(arg_9_0.conditions.clear_conditions) do
			ConditionContentsManager:setConditionGroupData(iter_9_1)
		end
		
		for iter_9_2, iter_9_3 in pairs(arg_9_0.conditions.update_conditions or {}) do
			ConditionContentsManager:setConditionGroupData(iter_9_3)
		end
	end
	
	ClassChangeQuestList:ItemListRefresh()
	balloon_message_with_sound("success_give_classchange_quest")
end

function HANDLER.classchange_popup_item(arg_10_0, arg_10_1)
	if arg_10_1 == "btn_select" then
		ClassChange:selectBatchList(getParentWindow(arg_10_0))
	end
end

function HANDLER.classchange_add(arg_11_0, arg_11_1)
	if arg_11_1 == "btn_cancel" then
		ClassChange:closeBatchPopup()
	elseif arg_11_1 == "btn_ok" then
		local var_11_0 = ClassChange:getSelectedItem()
		
		if not get_cocos_refid(var_11_0) then
			balloon_message_with_sound("msg_cc_no_select")
			
			return 
		end
		
		local var_11_1 = getParentWindow(arg_11_0).code
		local var_11_2 = var_11_0.uid
		
		query("classchange_add", {
			code = var_11_1,
			reg_uid = var_11_0.uid
		})
	end
end

function HANDLER.classchange_item(arg_12_0, arg_12_1)
	if arg_12_1 == "btn_detail" or arg_12_1 == "btn_preview" or arg_12_1 == "btn_start" or arg_12_1 == "btn_continue" then
		ClassChange:buildTmpData(arg_12_0.info.db.char_id)
		
		local var_12_0 = ClassChange:getUnitInfo(arg_12_0.info.db.char_id)
		
		ClassChange:showUnitDetail(var_12_0)
	elseif arg_12_1 == "btn_contents" then
		ClassChange:showUnitRecommendTipPopup(arg_12_0.info)
	elseif arg_12_1 == "btn_levelup" then
		if ContentDisable:byAlias("hero") then
			balloon_message(T("content_disable"))
			
			return 
		end
		
		if BackPlayManager:isRunning() and BackPlayManager:isInBackPlayTeam(arg_12_0.info.db.uid) then
			balloon_message_with_sound("msg_bgbattle_cant_levelup")
			
			return 
		end
		
		UnitMain:show({
			mode = "LevelUp",
			popup_mode = true,
			unit = Account:getUnit(arg_12_0.info.db.uid)
		})
	elseif arg_12_1 == "btn_destiny" then
		Destiny:show(arg_12_0.info.db.char_id, {
			wnd = ClassChange.vars.wnd,
			class_change_turn_back_id = arg_12_0.info.db.char_id
		})
	elseif arg_12_1 == "btn_go" and arg_12_0.info and arg_12_0.info.db and arg_12_0.info.db.btn_move then
		movetoPath(arg_12_0.info.db.btn_move)
	end
end

function HANDLER.classchange(arg_13_0, arg_13_1)
	HANDLER.classchange_item(arg_13_0:getParent():getParent():getParent(), arg_13_1)
end

function HANDLER.classchange_detail(arg_14_0, arg_14_1)
	if arg_14_1 == "btn_unload" then
		if not ClassChange:getDetailInfo().reg_uid then
			return 
		end
		
		Dialog:msgBox(T("ui_cc_unload_desc"), {
			yesno = true,
			title = T("ui_cc_unload_title"),
			handler = function()
				query("classchange_stop", {
					code = ClassChange:getDetailInfo().code
				})
			end
		})
	elseif arg_14_1 == "btn_finish" then
		if arg_14_0:getOpacity() < 255 then
			if not ClassChange:getDetailInfo().reg_uid then
				return 
			end
			
			balloon_message_with_sound("ui_class_change_finish_fail")
			
			return 
		end
		
		if BackPlayManager:isInBackPlayTeam(ClassChange:getDetailInfo().reg_uid) then
			balloon_message_with_sound("msg_bgbattle_cant_classchange")
			
			return 
		end
		
		Dialog:msgBox(T("ui_cc_finish_desc"), {
			yesno = true,
			title = T("ui_cc_finish_title"),
			handler = function()
				query("classchange_finish", {
					code = ClassChange:getDetailInfo().code,
					category_id = ClassChange:getDetailInfo().db.id
				})
			end
		})
	elseif arg_14_1 == "btn_go" then
		if arg_14_0.class_change_state ~= 1 then
			balloon_message_with_sound("ui_classchange_start_now")
			
			return 
		end
		
		if arg_14_0.state >= 2 then
		elseif arg_14_0.state == 1 then
			query("get_reward_classchange_quest", {
				contents_id = arg_14_0.contents_id
			})
		elseif arg_14_0.state == 0 then
			if arg_14_0.give_code then
				ClassChangeQuestList:showPresentWnd(nil, arg_14_0.contents_id, arg_14_0.give_code, arg_14_0.give_count)
			elseif arg_14_0.enter_stage then
				ClassChangeQuestList:enterBattle(arg_14_0)
			else
				movetoPath(arg_14_0.btn_move)
			end
		end
	elseif arg_14_1 == "btn_go_skilltree" then
		ClassChange:showSkillTree()
	elseif arg_14_1 == "btn_mission_list" then
		ClassChange:openInfoPopup(ClassChangeQuestList, SceneManager:getRunningPopupScene(), "ui_classchange_list_mission")
	elseif arg_14_1 == "btn_skill_preview" then
		CollectionNewHero:showSkillPreview(ClassChange.vars.base_unit.db.code)
	elseif arg_14_1 == "btn_start" or arg_14_1 == "btn_continue" then
		local var_14_0 = ClassChange:getDetailInfo()
		
		if var_14_0.blocked then
			balloon_message_with_sound("msg_cc_register_others", {
				value = GAME_STATIC_VARIABLE.class_change_regist_max or 2
			})
			
			return 
		end
		
		ClassChange:openBatchPopup(ClassChange:getUnitInfo(var_14_0.code or var_14_0.db.char_id))
	end
end

function HANDLER.classchange_info_popup(arg_17_0, arg_17_1)
	if ClassChange.open_popup and arg_17_1 == "btn_close" then
		ClassChange.open_popup:removeFromParent()
		BackButtonManager:pop("classchange.popup")
	elseif arg_17_1 == "btn_go" then
		balloon_message_with_sound("ui_classchange_start_now")
	end
end

function ClassChange.openInfoPopup(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	if not get_cocos_refid(ClassChange.open_popup) then
		ClassChange.open_popup = load_dlg("classchange_info_popup", true, "wnd")
		
		if_set(ClassChange.open_popup, "title", T(arg_18_3))
		arg_18_2:addChild(ClassChange.open_popup)
		
		if arg_18_1 and arg_18_1.init then
			if arg_18_4 then
				ClassChange:buildTmpData(arg_18_4)
			end
			
			arg_18_1:init(ClassChange.open_popup, true)
		end
		
		BackButtonManager:push({
			check_id = "classchange.popup",
			back_func = function()
				if get_cocos_refid(ClassChange.open_popup) then
					ClassChange.open_popup:removeFromParent()
					
					ClassChange.open_popup = nil
					
					BackButtonManager:pop("classchange.popup")
				end
			end
		})
		
		return ClassChange.open_popup
	else
		ClassChange.open_popup:removeFromParent()
		
		ClassChange.open_popup = nil
	end
end

local function var_0_0(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0:getChildByName("n_effs")
	
	if get_cocos_refid(var_20_0) then
		local var_20_1 = var_20_0:getChildren()
		local var_20_2 = 0
		
		if table.count(var_20_1) > 0 then
			local var_20_3 = false
			
			for iter_20_0, iter_20_1 in pairs(var_20_1) do
				local var_20_4 = SceneManager:convertToSceneSpace(iter_20_1, {
					y = 0,
					x = iter_20_1:getContentSize().width
				})
				
				var_20_2 = iter_20_1:getContentSize().width
				
				if VIEW_WIDTH * 0.95 < var_20_4.x then
					var_20_3 = true
					
					break
				end
			end
			
			if var_20_3 then
				arg_20_0:setPositionX(arg_20_0:getPositionX() - var_20_2)
			end
		end
	end
	
	local var_20_5 = arg_20_0:getChildByName("diff_skill")
	
	if get_cocos_refid(var_20_5) then
		var_20_5:setAnchorPoint(0, 0)
		var_20_5:setPositionY(arg_20_0:getContentSize().height - var_20_5:getContentSize().height)
		
		local var_20_6 = SceneManager:convertToSceneSpace(var_20_5, {
			x = 0,
			y = 0
		})
		local var_20_7 = false
		
		if var_20_6.x < 0 then
			var_20_7 = true
		end
		
		if var_20_7 then
			arg_20_0:setPositionX(arg_20_0:getPositionX() + math.abs(var_20_6.x) + NotchStatus:getNotchBaseLeft())
		end
	end
	
	if get_cocos_refid(arg_20_0) and arg_20_2 and arg_20_2.opts and arg_20_2.opts.limit_height then
		local var_20_8 = arg_20_2.opts.limit_height
		
		if var_20_8 and var_20_8 < arg_20_0:getContentSize().height - 20 then
			arg_20_0:setPositionY(0 + arg_20_0:getContentSize().height / 2)
		end
	end
end

function ClassChange.playUnitEffect(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	set_high_fps_tick(3000)
	
	local var_21_0 = SceneManager:getRunningNativeScene()
	local var_21_1 = 999998
	local var_21_2 = arg_21_1
	local var_21_3 = UNIT:create({
		code = var_21_2
	})
	local var_21_4 = CACHE:getModel(var_21_3.db.model_id, var_21_3.db.skin, nil, var_21_3.db.atlas, var_21_3.db.model_opt)
	
	var_21_4:setVisible(false)
	
	local var_21_5 = arg_21_2
	local var_21_6 = UNIT:create({
		code = var_21_5
	})
	local var_21_7 = CACHE:getModel(var_21_6.db.model_id, var_21_6.db.skin, nil, var_21_6.db.atlas, var_21_6.db.model_opt)
	
	var_21_7:setVisible(false)
	
	local var_21_8 = EffectManager:Play({
		node_name = "@UI_CLASS_CHANGE_BG",
		fn = "ui_class_change_bg.cfx",
		layer = var_21_0,
		z = var_21_1
	})
	
	var_21_8:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	
	local var_21_9 = var_21_8:getPrimitiveNode("ui_class_change_bg/char_node")
	
	var_21_9:setInheritScale(true)
	var_21_9:setInheritRotation(true)
	var_21_9:addChild(var_21_4)
	var_21_9:addChild(var_21_7)
	var_21_4:setLocalZOrder(5)
	var_21_7:setLocalZOrder(5)
	
	local var_21_10 = ccui.Button:create()
	
	var_21_10:setOpacity(0)
	var_21_10:setName("btn_blocks")
	var_21_10:setTouchEnabled(true)
	var_21_10:setPosition(-4000, -4000)
	var_21_10:ignoreContentAdaptWithSize(false)
	var_21_10:setContentSize(99999, 99999)
	var_21_8:addChild(var_21_10)
	var_21_10:bringToFront()
	UIAction:Add(SEQ(CALL(function()
		var_21_8:start()
	end), TARGET(var_21_4, MOTION("idle", true)), TARGET(var_21_4, SHOW(true)), DELAY(1600), TARGET(var_21_4, SHOW(false)), TARGET(var_21_7, SHOW(true)), TARGET(var_21_7, DMOTION("b_idle_ready")), TARGET(var_21_7, MOTION("b_idle", true)), DELAY(1400), CALL(function()
		UnitSummonResult:ShowCharGet(var_21_5, var_21_0, function()
			var_21_8:removeFromParent()
			
			if arg_21_3 then
				arg_21_3()
			end
		end, {
			none_bg = true,
			is_classchange = true,
			x_offset = 300 - VIEW_BASE_LEFT,
			z = var_21_1
		})
	end), DELAY(600), CALL(function()
		local var_25_0 = load_dlg("dlg_zodiac_reward_skill", true, "wnd")
		local var_25_1 = var_25_0:getChildByName("skill_01")
		local var_25_2 = var_25_0:getChildByName("skill_02")
		local var_25_3 = tonumber(DB("classchange_category", "cc_" .. arg_21_1, {
			"change_skill"
		}))
		local var_25_4 = var_21_3:getSkillByIndex(var_25_3)
		
		UIUtil:getSkillDetail(var_21_3, var_25_4, {
			ignore_check = true,
			wnd = var_25_1,
			skill_id = var_25_4
		})
		
		local var_25_5 = var_21_6:getSkillByIndex(var_25_3)
		
		UIUtil:getSkillDetail(var_21_6, var_25_5, {
			ignore_check = true,
			wnd = var_25_2,
			skill_id = var_25_5
		})
		if_set(var_25_0, "txt_title", T("ui_cc_skill_popup_title"))
		if_set(var_25_0, "txt_top", T("ui_cc_skill_popup_desc"))
		Dialog:msgBox({
			fade_in = 500,
			dlg = var_25_0,
			handler = function()
			end
		})
	end)), var_21_8, "block")
end

function ClassChangeMainList.refresh(arg_27_0, arg_27_1)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.vars.listView) then
		return 
	end
	
	arg_27_0.vars.listView:removeAllChildren()
	arg_27_0:createList(ClassChange:makeClassChangeInfo())
	
	if arg_27_1 then
		arg_27_0:ratioJumper(arg_27_1)
	end
end

function ClassChange.buildTmpData(arg_28_0, arg_28_1)
	arg_28_0.vars = arg_28_0.vars or {}
	arg_28_0.vars.list = arg_28_0:makeClassChangeInfo()
	
	local var_28_0 = 0
	local var_28_1 = GAME_STATIC_VARIABLE.class_change_regist_max or 2
	local var_28_2 = false
	local var_28_3 = {}
	
	for iter_28_0, iter_28_1 in pairs(arg_28_0.vars.list) do
		if iter_28_1.state ~= 2 then
			if iter_28_1.reg_uid then
				var_28_0 = var_28_0 + 1
				
				if var_28_1 <= var_28_0 then
					var_28_2 = true
				end
			end
			
			table.insert(var_28_3, iter_28_1)
		end
	end
	
	for iter_28_2, iter_28_3 in pairs(var_28_3) do
		if not iter_28_3.reg_uid then
			iter_28_3.blocked = var_28_2
		end
	end
	
	arg_28_0:setDetailInfo(arg_28_0.vars.list[arg_28_1])
end

function ClassChange.show(arg_29_0)
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.CLASS_CHANGE) then
		local var_29_0, var_29_1, var_29_2 = UnlockSystem:getSystemEnterData(UNLOCK_ID.CLASS_CHANGE)
		
		balloon_message_with_sound(var_29_0)
		
		return 
	end
	
	if SceneManager:getCurrentSceneName() == "class_change" then
		return 
	end
	
	local var_29_3, var_29_4 = ClassChange:CheckNotification()
	
	if not var_29_3 and var_29_4 == 0 then
		balloon_message_with_sound("notyet_dev")
		
		return 
	end
	
	SceneManager:nextScene("class_change")
end

function ClassChange.open(arg_30_0, arg_30_1)
	arg_30_1 = arg_30_1 or {}
	arg_30_0.vars = {}
	arg_30_0.vars.opts = arg_30_1
	
	local var_30_0 = arg_30_1.parent or SceneManager:getRunningNativeScene()
	local var_30_1 = cc.Sprite:create("img/base_unit.png")
	
	var_30_1:setPosition(VIEW_WIDTH / 2 + VIEW_BASE_LEFT, VIEW_HEIGHT / 2)
	
	img_sz = var_30_1:getContentSize()
	
	local var_30_2 = VIEW_WIDTH / img_sz.width
	local var_30_3 = VIEW_HEIGHT / img_sz.height
	
	var_30_2 = math.is_nan_or_inf(var_30_2) and 1 or var_30_2
	var_30_3 = math.is_nan_or_inf(var_30_3) and 1 or var_30_3
	
	var_30_1:setScale(var_30_2, var_30_3)
	var_30_0:addChild(var_30_1)
	arg_30_0:createMainUI(arg_30_1)
	TopBarNew:create(T("ui_class_change_title"), var_30_0, function()
		ClassChange:onPushBackButton()
	end, nil, nil, "growth_5_1")
	
	arg_30_0.vars.list = arg_30_0:makeClassChangeInfo()
	
	ClassChangeMainList:createList(arg_30_0.vars.list)
	if_set_visible(arg_30_0.vars.scrollview, nil, false)
	BackButtonManager:push({
		check_id = "ClassChange",
		back_func = function()
			arg_30_0:close()
			BackButtonManager:pop("ClassChange")
		end
	})
	
	if arg_30_1.info then
		arg_30_0:showUnitDetail(arg_30_0.vars.list[arg_30_1.info.code])
	end
	
	arg_30_0:checkNew()
	Analytics:setMode("ClassChange")
	ConditionContentsManager:classChangeForceUpdateConditions()
	TutorialGuide:ifStartGuide("classchange_start")
end

function ClassChange.getUnitInfo(arg_33_0, arg_33_1)
	return arg_33_0.vars.list[arg_33_1]
end

function ClassChange.getClassChangeInfo(arg_34_0)
	return arg_34_0.vars.list
end

function ClassChange.setClassChangeInfo(arg_35_0, arg_35_1)
	if arg_35_1.cc_list then
		Account:setClassChangeInfo(arg_35_1.cc_list)
		
		local var_35_0 = arg_35_0:makeClassChangeInfo()
		
		arg_35_0.vars.list = var_35_0
		
		ClassChangeMainList:updateList(var_35_0)
	end
	
	if arg_35_1.cc_doc then
		Account:mergeClassChangeInfo(arg_35_1.cc_doc.code, arg_35_1.cc_doc)
		
		local var_35_1 = arg_35_0:makeClassChangeInfo()
		
		arg_35_0.vars.list = var_35_1
		
		ClassChangeMainList:updateList(var_35_1)
	end
end

function ClassChange.makeClassChangeInfo(arg_36_0)
	if not arg_36_0.vars.db_info then
		arg_36_0.vars.db_info = arg_36_0:makeDBInfo()
	end
	
	local var_36_0 = Account:getClassChangeInfo()
	local var_36_1 = table.clone(arg_36_0.vars.db_info)
	
	for iter_36_0, iter_36_1 in pairs(var_36_1) do
		for iter_36_2, iter_36_3 in pairs(var_36_0[iter_36_0] or {}) do
			iter_36_1[iter_36_2] = iter_36_3
		end
		
		local var_36_2 = Account:getUnitsByCode(iter_36_0)
		local var_36_3 = not table.empty(var_36_2)
		local var_36_4 = true
		
		for iter_36_4, iter_36_5 in pairs(var_36_2) do
			if iter_36_5:getLv() >= (GAME_STATIC_VARIABLE.class_change_level or 30) then
				var_36_4 = false
				
				break
			else
				iter_36_1.db.uid = iter_36_5:getUID()
			end
		end
		
		if table.count(Account:getUnitsByCode(iter_36_1.char_id_cc)) > 0 then
			var_36_3 = true
		end
		
		iter_36_1.own = var_36_3
		iter_36_1.under_level = var_36_4
		iter_36_1.clear_enter = iter_36_1.db.clear_enter
		iter_36_1.get_material = iter_36_1.db.get_material
		iter_36_1.is_have_material = Account:getItemCount(iter_36_1.db.get_material) > 0
		iter_36_1.state = iter_36_1.state or 0
		iter_36_1.is_lock_enter_condition = iter_36_1.db.clear_enter and not Account:isMapCleared(iter_36_1.db.clear_enter) and iter_36_1.state ~= 1
		
		local var_36_5 = 0
		
		iter_36_1.progress = arg_36_0:getQuestProgress(iter_36_1.db.id)
		iter_36_1.db.recommend = DB("classchange_category", iter_36_1.db.id, {
			"recommend"
		})
		
		local var_36_6 = Destiny:loadCategoryDB()
		
		for iter_36_6, iter_36_7 in pairs(var_36_6 or {}) do
			if iter_36_7.char_id == iter_36_1.db.char_id then
				iter_36_1.db.destiny = iter_36_7
				
				break
			end
		end
	end
	
	return var_36_1
end

function ClassChange.updateQuestProgress(arg_37_0)
	if not arg_37_0.vars or not arg_37_0.vars.list then
		return 
	end
	
	for iter_37_0, iter_37_1 in pairs(arg_37_0.vars.list) do
		iter_37_1.progress = arg_37_0:getQuestProgress(iter_37_1.db.id)
	end
end

local function var_0_1(arg_38_0)
	if arg_38_0 then
		local var_38_0 = arg_38_0.reg_uid
		
		if var_38_0 then
			local var_38_1 = Account:getUnit(var_38_0)
			
			if var_38_1 and var_38_1:getLv() >= GAME_STATIC_VARIABLE.class_change_level then
				return true
			end
		end
	end
end

function ClassChange.checkQuestNotificationByCode(arg_39_0, arg_39_1)
	local var_39_0 = Account:getClassChangeQuests() or {}
	local var_39_1 = Account:getClassChangeInfo()
	
	for iter_39_0, iter_39_1 in pairs(var_39_0) do
		if iter_39_1.state == CLASS_CHANGE_QUEST_STATE.CLEAR and arg_39_1 == iter_39_1.code and var_0_1(var_39_1[iter_39_1.code]) and var_39_1[iter_39_1.code].state == 1 then
			return true
		end
	end
	
	return false
end

function ClassChange.checkNew(arg_40_0)
	NewNotice:checkNew(NewNotice.ID.CLASS_CHANGE)
end

function ClassChange.isNew(arg_41_0)
	return UnlockSystem:isUnlockSystem(UNLOCK_ID.CLASS_CHANGE) and NewNotice:isNew(NewNotice.ID.CLASS_CHANGE)
end

function ClassChange.CheckNotification(arg_42_0)
	local var_42_0 = Account:getClassChangeQuests() or {}
	local var_42_1 = Account:getClassChangeInfo()
	
	for iter_42_0, iter_42_1 in pairs(var_42_0) do
		if iter_42_1.state == CLASS_CHANGE_QUEST_STATE.CLEAR and var_0_1(var_42_1[iter_42_1.code]) and var_42_1[iter_42_1.code].state == 1 then
			return true
		end
	end
	
	local var_42_2 = 0
	local var_42_3 = 0
	local var_42_4 = 0
	local var_42_5 = 0
	
	for iter_42_2 = 1, 99 do
		local var_42_6, var_42_7, var_42_8, var_42_9 = DBN("classchange_category", iter_42_2, {
			"id",
			"char_id",
			"clear_enter",
			"get_material"
		})
		
		if not var_42_6 then
			break
		end
		
		local var_42_10 = 0
		local var_42_11
		
		if var_42_1[var_42_7] then
			var_42_10 = var_42_1[var_42_7].state
			var_42_11 = var_42_1[var_42_7].reg_uid
		end
		
		if var_42_10 == 1 then
			if arg_42_0:getQuestProgress(var_42_6) >= 1 then
				return true
			end
			
			if var_42_11 and Account:getUnit(var_42_11) then
				var_42_2 = var_42_2 + 1
			end
		elseif var_42_10 > 1 then
			var_42_3 = var_42_3 + 1
		else
			local var_42_12 = var_42_8 and not Account:isMapCleared(var_42_8)
			local var_42_13 = var_42_9 and Account:getItemCount(var_42_9) <= 0
			local var_42_14 = Account:getUnitsByCode(var_42_7)
			local var_42_15 = false
			
			for iter_42_3, iter_42_4 in pairs(var_42_14) do
				if not var_42_12 and not var_42_13 and (GAME_STATIC_VARIABLE.class_change_level or 50) <= iter_42_4:getLv() then
					var_42_15 = true
				end
			end
			
			if var_42_15 then
				var_42_5 = var_42_5 + 1
			end
		end
		
		var_42_4 = var_42_4 + 1
	end
	
	local var_42_16 = var_42_4 - var_42_3
	
	if var_42_2 < math.min(var_42_16, GAME_STATIC_VARIABLE.class_change_regist_max or 2) and var_42_5 > 0 then
		return true
	end
	
	return false, var_42_4
end

function ClassChange.getQuestProgress(arg_43_0, arg_43_1)
	local var_43_0 = 0
	local var_43_1 = 0
	
	for iter_43_0 = 1, 99 do
		local var_43_2 = string.format("%s_quest_%02d", arg_43_1, iter_43_0)
		local var_43_3, var_43_4 = DB("classchange_quest", var_43_2, {
			"id",
			"char_id"
		})
		
		if not var_43_3 then
			break
		end
		
		var_43_1 = var_43_1 + 1
		
		local var_43_5 = Account:getClassChangeQuest(var_43_3)
		
		if tonumber(var_43_5.state) >= tonumber(CLASS_CHANGE_QUEST_STATE.REWARDED) then
			var_43_0 = var_43_0 + 1
		end
	end
	
	return var_43_0 / var_43_1
end

function ClassChange.makeDBInfo(arg_44_0)
	local var_44_0 = {}
	
	for iter_44_0 = 1, 99 do
		local var_44_1 = {
			"id",
			"char_id",
			"char_id_cc",
			"change_skill",
			"image",
			"sort",
			"hide",
			"start_story",
			"clear_story",
			"clear_enter",
			"clear_enter_desc",
			"lock_text",
			"get_material",
			"btn_move",
			"lock_text_lv"
		}
		local var_44_2, var_44_3, var_44_4, var_44_5, var_44_6, var_44_7, var_44_8, var_44_9, var_44_10, var_44_11, var_44_12, var_44_13, var_44_14, var_44_15, var_44_16 = DBN("classchange_category", iter_44_0, var_44_1)
		
		if not var_44_2 then
			break
		end
		
		if var_44_8 ~= "y" then
			var_44_0[var_44_3] = {
				db = {
					id = var_44_2,
					char_id = var_44_3,
					char_id_cc = var_44_4,
					change_skill = var_44_5,
					image = var_44_6,
					sort = var_44_7,
					start_story = var_44_9,
					clear_story = var_44_10,
					clear_enter = var_44_11,
					clear_enter_desc = var_44_12,
					lock_text = var_44_13,
					get_material = var_44_14,
					btn_move = var_44_15,
					lock_text_lv = var_44_16
				}
			}
		end
	end
	
	return var_44_0
end

function ClassChange.createMainUI(arg_45_0, arg_45_1)
	arg_45_1 = arg_45_1 or arg_45_0.vars.opts
	arg_45_0.vars.wnd = load_dlg("classchange", true, "wnd")
	
	;(arg_45_1.parent or SceneManager:getRunningNativeScene()):addChild(arg_45_0.vars.wnd)
end

function ClassChange.getWnd(arg_46_0)
	if not arg_46_0.vars then
		return 
	end
	
	return arg_46_0.vars.wnd
end

function ClassChange.createDetailUI(arg_47_0, arg_47_1)
	arg_47_1 = arg_47_1 or arg_47_0.vars.opts
	arg_47_0.vars.detail = load_dlg("classchange_detail", true, "wnd")
	
	local var_47_0 = arg_47_0:getDetailInfo()
	
	arg_47_0.vars.detail.info = var_47_0
	
	local var_47_1 = var_47_0.state == 0 and ClassChangeSkillList or ClassChangeQuestList
	
	var_47_1:init(arg_47_0.vars.detail)
	ConditionContentsManager:classChangeForceUpdateConditions()
	;(arg_47_1.parent or SceneManager:getRunningNativeScene()):addChild(arg_47_0.vars.detail)
	arg_47_0:setDetailData()
	arg_47_0:updateCCButtonState()
	
	local var_47_2 = arg_47_0.vars.detail:getChildByName("n_informa")
	
	var_47_2:setPositionX(-300)
	UIAction:Add(LOG(MOVE_TO(250, 0)), var_47_2, "block")
	
	local var_47_3 = arg_47_0.vars.detail:getChildByName("n_portrait")
	
	var_47_3:setOpacity(0)
	UIAction:Add(SPAWN(LOG(OPACITY(250, 0, 1))), var_47_3, "block")
	
	local var_47_4 = var_47_1.vars.listView or var_47_1.vars.itemView
	
	if var_47_4 then
		var_47_4:setOpacity(0)
		var_47_4:setPositionY(-300)
		UIAction:Add(SPAWN(LOG(MOVE_TO(250, var_47_4:getPositionX(), 0)), LOG(OPACITY(250, 0, 1))), var_47_4, "block")
	end
	
	local var_47_5 = arg_47_0.vars.detail:getChildByName("n_list_title")
	
	if_set(var_47_5, "t_title", var_47_0.state == 0 and T("ui_classchange_list_skill") or T("ui_classchange_list_mission"))
	var_47_5:setPositionY(-300)
	UIAction:Add(SPAWN(LOG(MOVE_TO(250, var_47_5:getPositionX(), 0)), LOG(OPACITY(250, 0, 1))), var_47_5, "block")
end

function ClassChange.showSkillTree(arg_48_0)
	arg_48_0.vars.detail:setVisible(false)
	
	local var_48_0 = arg_48_0.vars.base_unit
	
	var_48_0.inst.stree = {
		3,
		3,
		3,
		3,
		3,
		3,
		3,
		3,
		3,
		3,
		3,
		3,
		3,
		3,
		3
	}
	
	UnitZodiac:beginDictMode(arg_48_0.vars.detail:getParent(), var_48_0, true)
	BackButtonManager:push({
		check_id = "ClassChange.Skilltree",
		back_func = function()
			ClassChange:hideSkillTree()
		end
	})
end

function ClassChange.hideSkillTree(arg_50_0)
	arg_50_0.vars.detail:setVisible(true)
	UnitZodiac:endDictMode()
	BackButtonManager:pop("ClassChange.Skilltree")
end

function ClassChange.isShow(arg_51_0)
	if not arg_51_0.vars then
		return 
	end
	
	return get_cocos_refid(arg_51_0.vars.wnd)
end

function ClassChange.setDetailData(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0:getDetailInfo()
	local var_52_1 = arg_52_0.vars.detail
	local var_52_2, var_52_3, var_52_4, var_52_5 = DB("character", var_52_0.db.char_id_cc, {
		"name",
		"role",
		"grade",
		"face_id"
	})
	local var_52_6 = UNIT:create({
		code = var_52_0.db.char_id_cc,
		g = var_52_4
	})
	local var_52_7 = UNIT:create({
		code = var_52_0.db.char_id,
		g = var_52_4
	})
	
	var_52_6.inst.zodiac = 6
	
	var_52_6:updateZodiacSkills()
	var_52_6:calc()
	
	arg_52_0.vars.base_unit = var_52_6
	
	UIUtil:setUnitAllInfo(var_52_1, var_52_6)
	TopBarNew:setTitleName(T(var_52_2), "growth_5_1")
	
	local var_52_8 = var_52_1:getChildByName("txt_char_name")
	
	if get_cocos_refid(var_52_8) then
		var_52_8:setString(T(var_52_2))
		UIUserData:proc(var_52_8)
		if_call(var_52_1:getChildByName("n_char_info"), "star1", "setPositionX", 10 + var_52_8:getContentSize().width * var_52_8:getScaleX() + var_52_8:getPositionX())
	end
	
	for iter_52_0 = 1, 3 do
		local var_52_9 = {
			tooltip_opts = {
				show_effs = "right",
				limit_height = 563,
				call_by_show = var_0_0
			}
		}
		
		if iter_52_0 == 3 then
			var_52_9.diff_skill = {
				skill_id = 3,
				unit = var_52_7
			}
		end
		
		local var_52_10 = UIUtil:getSkillIcon(var_52_6, iter_52_0, var_52_9)
		local var_52_11 = var_52_1:getChildByName("skill" .. iter_52_0)
		
		var_52_11:removeAllChildren()
		
		if get_cocos_refid(var_52_11) then
			var_52_11:addChild(var_52_10)
		end
	end
	
	local var_52_12 = false
	local var_52_13 = var_52_1:getChildByName("n_skill_upgrade")
	
	if get_cocos_refid(var_52_13) then
		local var_52_14 = var_52_0.db.change_skill
		local var_52_15 = var_52_1:getChildByName("skill" .. var_52_14)
		
		if get_cocos_refid(var_52_15) then
			var_52_13:setPosition(var_52_15:getPosition())
			
			var_52_12 = true
		end
	end
	
	if not var_52_12 then
		if_set_visible(var_52_1, "n_skill_upgrade", false)
	end
	
	local var_52_16 = Account:getUnit(var_52_0.reg_uid)
	
	UIUtil:getUserIcon(var_52_16, {
		scale = 1.4,
		parent = var_52_1:getChildByName("n_face_ally")
	})
	
	if var_52_0.state ~= 0 then
		if_set_visible(var_52_1, "n_progress", true)
		if_set(var_52_1, "t_percent", var_52_0.progress * 100 .. "%")
		if_set_percent(var_52_1, "progress", var_52_0.progress)
		if_set_visible(var_52_1, "btn_finish", var_52_0.progress >= 1)
		if_set_visible(var_52_1, "btn_unload", var_52_0.state ~= -1 and var_52_0.progress < 1)
	else
		if_set(var_52_1, "t_percent", "0%")
		if_set_percent(var_52_1, "progress", 0)
		if_set_visible(var_52_1, "n_ing", false)
		if_set_visible(var_52_1, "btn_go_skilltree", false)
		if_set_visible(var_52_1, "btn_mission_list", true)
	end
	
	if_set_visible(var_52_1, "n_strat", var_52_0.state == 0 and var_52_0.progress == 0 and var_52_0.own == true and var_52_0.under_level == false and var_52_0.reg_uid == nil and not var_52_0.is_lock_enter_condition)
	
	if var_52_1:getChildByName("n_strat"):isVisible() then
		local var_52_17 = true
		
		if var_52_0.clear_enter and var_52_0.is_lock_enter_condition then
			var_52_17 = false
		elseif var_52_0.get_material and not var_52_0.is_have_material then
			var_52_17 = false
		end
		
		if_set_visible(var_52_1, "n_strat", var_52_17)
	end
	
	if_set_visible(var_52_1, "btn_continue", var_52_1:getChildByName("n_strat"):isVisible() == false and var_52_0.state == -1 and var_52_0.own == true and var_52_0.under_level == false and not var_52_0.is_lock_enter_condition)
	if_set_visible(var_52_1, "n_ing", var_52_1:getChildByName("btn_continue"):isVisible() or var_52_1:getChildByName("btn_unload"):isVisible() or var_52_0.state == -1 and var_52_0.own == true or var_52_0.progress == 1 and var_52_0.reg_uid ~= nil and var_52_0.state == 1)
	if_set_opacity(var_52_1, "btn_start", var_52_1:getChildByName("n_strat"):isVisible() and var_52_0.blocked == true and 102 or 255)
	if_set_opacity(var_52_1, "btn_continue", var_52_1:getChildByName("btn_continue"):isVisible() and var_52_0.blocked == true and 102 or 255)
	
	if not arg_52_0.vars.portrait or not get_cocos_refid(arg_52_0.vars.portrait) then
		local var_52_18, var_52_19 = UIUtil:getPortraitAni(var_52_5, {
			pin_sprite_position_y = false
		})
		
		if var_52_18 then
			var_52_18:setPositionY(-150)
			var_52_18:setScaleX(1)
			var_52_1:getChildByName("n_portrait"):addChild(var_52_18)
			
			arg_52_0.vars.portrait = var_52_18
		end
	end
end

function ClassChange.createUI(arg_53_0, arg_53_1)
	arg_53_1 = arg_53_1 or {}
end

function ClassChange.close(arg_54_0)
	arg_54_0.vars.wnd:removeFromParent()
	
	arg_54_0.vars = {}
	
	Analytics:saveCurTabTime()
	SceneManager:nextScene("lobby")
end

function ClassChange.openBatchPopup(arg_55_0, arg_55_1)
	local var_55_0 = arg_55_0.vars.opts
	local var_55_1 = Account:getUnitsByCode(arg_55_1.db.char_id)
	local var_55_2 = false
	local var_55_3 = 0
	
	for iter_55_0, iter_55_1 in pairs(var_55_1) do
		if (GAME_STATIC_VARIABLE.class_change_level or 50) <= iter_55_1:getLv() then
			var_55_2 = true
			var_55_3 = var_55_3 + 1
		end
	end
	
	if clear_enter and not Account:isMapCleared(clear_enter) then
		balloon_message_with_sound("msg_cc_no_enter_condition")
		
		return 
	end
	
	if table.empty(var_55_1) or not var_55_2 then
		balloon_message_with_sound("msg_cc_no_unit")
		
		return 
	end
	
	if arg_55_1.blocked then
		balloon_message_with_sound("msg_cc_register_others", {
			value = GAME_STATIC_VARIABLE.class_change_regist_max or 2
		})
		
		return 
	end
	
	local var_55_4 = math.min(var_55_3, 5)
	local var_55_5 = load_dlg("classchange_add", true, "wnd", function()
		ClassChange:closeBatchPopup()
	end)
	
	arg_55_0.vars.popup = var_55_5
	var_55_5.code = arg_55_1.db.char_id
	
	SceneManager:getRunningNativeScene():addChild(var_55_5)
	
	local var_55_6 = var_55_5:getChildByName("n_target" .. var_55_4)
	
	table.sort(var_55_1, function(arg_57_0, arg_57_1)
		if arg_57_0:getLv() == arg_57_1:getLv() then
			return arg_57_0:getZodiacGrade() > arg_57_1:getZodiacGrade()
		end
		
		return arg_57_0:getLv() > arg_57_1:getLv()
	end)
	
	arg_55_0.vars.popup_childs = {}
	
	for iter_55_2 = 1, var_55_4 do
		local var_55_7 = var_55_1[iter_55_2]
		local var_55_8 = load_control("wnd/classchange_popup_item.csb")
		
		var_55_6:getChildByName("t" .. iter_55_2):addChild(var_55_8)
		
		var_55_8.uid = var_55_7:getUID()
		
		local var_55_9 = var_55_8:getChildByName("n_lv")
		
		UIUtil:setLevel(var_55_9, var_55_7:getLv(), var_55_7:getMaxLevel(), 2)
		
		if var_55_7:isMaxLevel() then
			var_55_9:setPositionX(var_55_9:getPositionX() - 10)
		end
		
		local var_55_10 = UIUtil:getUserIcon(var_55_7, {
			lv = false,
			scale = 1.4,
			parent = var_55_8:getChildByName("n_face_ally")
		})
		
		if_set_visible(var_55_10, "n_lv", false)
		if_set_visible(var_55_10, "color", false)
		if_set_visible(var_55_10, "bg_color", false)
		table.insert(arg_55_0.vars.popup_childs, var_55_8)
	end
	
	arg_55_0:selectBatchList(arg_55_0.vars.popup_childs[1])
	GrowthGuideNavigator:proc()
end

function ClassChange.closeBatchPopup(arg_58_0)
	if not get_cocos_refid(arg_58_0.vars.popup) then
		arg_58_0.vars.popup = nil
		
		return 
	end
	
	for iter_58_0, iter_58_1 in pairs(arg_58_0.vars.popup_childs) do
		if get_cocos_refid(iter_58_1) then
			iter_58_1:removeFromParent()
		end
	end
	
	arg_58_0.vars.popup_childs = nil
	
	BackButtonManager:pop(arg_58_0.vars.popup)
	arg_58_0.vars.popup:removeFromParent()
	
	arg_58_0.vars.popup = nil
end

function ClassChange.selectBatchList(arg_59_0, arg_59_1)
	for iter_59_0, iter_59_1 in pairs(arg_59_0.vars.popup_childs) do
		if_set_visible(iter_59_1, "select", iter_59_1 == arg_59_1)
	end
end

function ClassChange.getSelectedItem(arg_60_0)
	for iter_60_0, iter_60_1 in pairs(arg_60_0.vars.popup_childs) do
		local var_60_0 = iter_60_1:getChildByName("select")
		
		if get_cocos_refid(var_60_0) and var_60_0:isVisible() then
			return iter_60_1
		end
	end
end

function ClassChange.onPushBackButton(arg_61_0)
	if not get_cocos_refid(arg_61_0.vars.detail) then
		BackButtonManager:pop("ClassChange")
		arg_61_0:close()
	elseif arg_61_0.vars.detail:isVisible() then
		BackButtonManager:pop("ClassChange_detail")
		arg_61_0:toggleDetailView()
	else
		arg_61_0:hideSkillTree()
	end
end

function ClassChange.getSceneState(arg_62_0)
	local var_62_0 = {}
	
	if arg_62_0.vars and arg_62_0.vars.detail then
		var_62_0.info = arg_62_0.vars.info
	end
	
	return var_62_0
end

function ClassChange.toggleDetailView(arg_63_0)
	if not get_cocos_refid(arg_63_0.vars.detail) then
		arg_63_0.vars.wnd:setVisible(false)
		arg_63_0:createDetailUI()
	else
		local var_63_0 = ""
		
		if arg_63_0.vars.detail.info and arg_63_0.vars.detail.info.db then
			var_63_0 = arg_63_0.vars.detail.info.db.char_id
		end
		
		arg_63_0.vars.detail:removeFromParent()
		
		arg_63_0.vars.detail = nil
		
		local var_63_1 = arg_63_0:makeClassChangeInfo()
		
		ClassChangeMainList:updateList(var_63_1)
		arg_63_0.vars.wnd:setVisible(true)
		TopBarNew:setTitleName(T("ui_class_change_title"), "growth_5_1")
		ClassChangeMainList:ratioJumper(var_63_0)
	end
	
	GrowthGuideNavigator:proc()
end

function ClassChange.showUnitDetail(arg_64_0, arg_64_1)
	arg_64_0:setDetailInfo(arg_64_1)
	ClassChange:toggleDetailView()
	BackButtonManager:push({
		check_id = "ClassChange_detail",
		back_func = function()
			ClassChange:toggleDetailView()
			BackButtonManager:pop("ClassChange_detail")
		end
	})
end

function ClassChange.setDetailInfo(arg_66_0, arg_66_1)
	arg_66_0.vars.info = arg_66_1
end

function ClassChange.getDetailInfo(arg_67_0)
	local var_67_0 = arg_67_0.vars.info or arg_67_0.vars.opts and arg_67_0.vars.opts.info
	
	if var_67_0 then
		return var_67_0
	else
		balloon_message_with_sound("해당 유닛의 전직 스킬 데이터가 누락됐습니다. 전직 영웅이 맞나요?")
		
		return 
	end
end

function ClassChange.getRandomOwnCharacterCode(arg_68_0)
	local var_68_0 = {}
	local var_68_1 = arg_68_0:makeClassChangeInfo()
	
	for iter_68_0, iter_68_1 in pairs(var_68_1) do
		if iter_68_1.state == 1 then
			table.insert(var_68_0, iter_68_1.db.char_id_cc)
		end
	end
	
	local var_68_2 = #var_68_0
	
	if var_68_2 == 0 then
		return 
	end
	
	return var_68_0[math.random(1, var_68_2)]
end

function ClassChange.getCompletedCount(arg_69_0)
	local var_69_0 = arg_69_0:makeClassChangeInfo()
	local var_69_1 = 0
	
	for iter_69_0, iter_69_1 in pairs(var_69_0) do
		if iter_69_1.state == 2 then
			var_69_1 = var_69_1 + 1
		end
	end
	
	return var_69_1, table.count(var_69_0)
end

function ClassChange.updateCCButtonState(arg_70_0)
	if not get_cocos_refid(arg_70_0.vars.detail) then
		return 
	end
	
	if arg_70_0.vars and arg_70_0.vars.info then
		local var_70_0 = arg_70_0.vars.info
		
		if_set_visible(arg_70_0.vars.detail, "icon_clan_0", false)
		
		if var_70_0.state == 1 then
			local var_70_1 = ClassChange:getDetailInfo()
			
			if tonumber(var_70_1.progress) >= 1 then
				if_set_opacity(arg_70_0.vars.detail, "btn_finish", 255)
				if_set_visible(arg_70_0.vars.detail, "icon_clan_0", true)
				if_set_color(arg_70_0.vars.detail, "progress", cc.c3b(107, 193, 27))
				if_set_color(arg_70_0.vars.detail, "t_title", cc.c3b(107, 193, 27))
			else
				if_set_opacity(arg_70_0.vars.detail, "btn_finish", 76.5)
				if_set_color(arg_70_0.vars.detail, "progress", cc.c3b(146, 109, 62))
				if_set_color(arg_70_0.vars.detail, "t_title", cc.c3b(146, 109, 62))
			end
		elseif var_70_0.state == 2 then
			if_set_opacity(arg_70_0.vars.detail, "btn_finish", 76.5)
			if_set_color(arg_70_0.vars.detail, "progress", cc.c3b(107, 193, 27))
			if_set_color(arg_70_0.vars.detail, "t_title", cc.c3b(107, 193, 27))
		elseif var_70_0.state == 0 then
			if_set_opacity(arg_70_0.vars.detail, "btn_finish", 76.5)
			if_set_color(arg_70_0.vars.detail, "progress", cc.c3b(146, 109, 62))
			if_set_color(arg_70_0.vars.detail, "t_title", cc.c3b(146, 109, 62))
		else
			if_set_opacity(arg_70_0.vars.detail, "btn_finish", 76.5)
			if_set_color(arg_70_0.vars.detail, "progress", cc.c3b(76, 76, 76))
			if_set_color(arg_70_0.vars.detail, "t_title", cc.c3b(76, 76, 76))
		end
	end
end

function ClassChangeMainList.createList(arg_71_0, arg_71_1)
	arg_71_0.vars = {}
	arg_71_0.vars.listView = GroupListView:bindControl(ClassChange.vars.wnd:getChildByName("listview"))
	
	arg_71_0.vars.listView:setListViewCascadeOpacityEnabled(true)
	arg_71_0.vars.listView:setEnableMargin(true)
	
	local var_71_0 = load_control("wnd/classchange_item_title.csb")
	local var_71_1 = {
		onUpdate = function(arg_72_0, arg_72_1, arg_72_2)
			local var_72_0 = arg_72_1:getChildByName("n_title_recommend")
			
			if arg_72_2.is_top then
				var_72_0:findChildByName("bar"):setName("this_is_not_bar")
				arg_72_1:getChildByName("bar"):setVisible(false)
			end
			
			if_set_visible(arg_72_1, "n_title_recommend", arg_72_2.recommend)
			if_set_visible(arg_72_1, "n_title_normal", not arg_72_2.recommend)
			
			if arg_72_2.recommend then
				var_72_0:getChildByName("t_title"):setPositionX(var_72_0:getChildByName("recommend_bg"):getContentSize().width + 20)
			end
			
			if arg_72_2.recommend then
			else
				if_set(arg_72_1:getChildByName("n_title_normal"), "t_title", T(arg_72_2.title, {
					max_count = arg_72_2.max_count,
					count = arg_72_2.count
				}))
			end
			
			arg_72_1.data = {
				data = arg_72_2,
				title = T(arg_72_2.title)
			}
		end
	}
	local var_71_2 = load_control("wnd/classchange_item.csb")
	local var_71_3 = {
		onUpdate = function(arg_73_0, arg_73_1, arg_73_2)
			arg_73_1.info = arg_73_2
			
			local var_73_0, var_73_1 = DB("character", arg_73_2.db.char_id, {
				"grade",
				"face_id"
			})
			local var_73_2, var_73_3 = DB("character", arg_73_2.db.char_id_cc, {
				"grade",
				"face_id"
			})
			local var_73_4 = UNIT:create({
				code = var_73_1,
				g = var_73_0
			})
			local var_73_5 = UNIT:create({
				code = var_73_3,
				g = var_73_2
			})
			
			UIUtil:setUnitAllInfo(arg_73_1, var_73_4)
			
			local var_73_6 = arg_73_1:getChildByName("txt_char_name")
			
			if get_cocos_refid(var_73_6) then
				var_73_6:setString(T(var_73_4.db.name))
				UIUserData:proc(var_73_6)
				if_call(arg_73_1:getChildByName("n_char_info"), "star1", "setPositionX", 10 + var_73_6:getContentSize().width * var_73_6:getScaleX() + var_73_6:getPositionX())
			end
			
			local var_73_7 = cc.Sprite:create("classchange/" .. arg_73_2.db.image)
			
			if not get_cocos_refid(var_73_7) then
				Log.e("Class change", "classchange/" .. arg_73_2.db.image .. " file not found")
				
				return 
			end
			
			var_73_7:setAnchorPoint(0, 0)
			arg_73_1:getChildByName("n_bg"):addChild(var_73_7)
			if_set_visible(arg_73_1, "btn_start", false)
			if_set_visible(arg_73_1, "btn_continue", false)
			if_set_visible(arg_73_1, "btn_detail", false)
			if_set_visible(arg_73_1, "btn_go", false)
			if_set_visible(arg_73_1, "n_black", false)
			
			local var_73_8 = ClassChange:checkQuestNotificationByCode(arg_73_2.db.char_id) or arg_73_2.state == 1 and arg_73_2.progress >= 1
			
			if_set_visible(arg_73_1, "img_noti", var_73_8)
			arg_71_0:updateItem(arg_73_1, arg_73_2)
			arg_73_1:getChildByName("progress"):setContentSize(498, 11)
			;(function(arg_74_0)
				if table.count(arg_74_0 or {}) == 0 then
					return 
				end
				
				local var_74_0 = arg_73_1:getChildByName("btn_contents")
				
				if arg_74_0.recommend_content_icon2 then
					local var_74_1 = SpriteCache:getSprite("img/" .. arg_74_0.recommend_content_icon1)
					
					var_74_0:getChildByName("n_icon_menu1"):addChild(var_74_1)
					
					local var_74_2 = SpriteCache:getSprite("img/" .. arg_74_0.recommend_content_icon2)
					
					var_74_0:getChildByName("n_icon_menu2"):addChild(var_74_2)
				else
					local var_74_3 = SpriteCache:getSprite("img/" .. arg_74_0.recommend_content_icon1)
					
					var_74_0:getChildByName("n_icon_menu1/1"):addChild(var_74_3)
				end
			end)(ClassChange:getRecommandData(arg_73_2.db.id))
			
			local var_73_9 = arg_73_2.own
			local var_73_10 = arg_73_2.under_level
			local var_73_11 = arg_73_2.is_lock_enter_condition
			
			var_73_5.inst.zodiac = 6
			
			var_73_5:updateZodiacSkills()
			var_73_5:calc()
			
			local var_73_12 = UIUtil:getSkillIcon(var_73_5, 3, {
				tooltip_opts = {
					show_effs = "right",
					limit_height = 563,
					call_by_show = var_0_0
				},
				diff_skill = {
					skill_id = 3,
					unit = var_73_4
				}
			})
			
			arg_73_1:getChildByName("n_skill"):getChildByName("skill"):addChild(var_73_12)
			
			local var_73_13 = arg_73_1:getChildByName("n_skill_upgrade")
			
			if get_cocos_refid(var_73_13) then
				local var_73_14 = arg_73_1:getChildByName("skill")
				
				if get_cocos_refid(var_73_14) then
					var_73_13:setPosition(var_73_14:getPosition())
				end
			end
		end
	}
	
	arg_71_0.vars.listView:setRenderer(var_71_0, var_71_2, var_71_1, var_71_3)
	arg_71_0:updateList(arg_71_1)
end

ClassChangeMainList.already_progressed = "ui_classchange_item_title_progress"
ClassChangeMainList.possible = "ui_classchange_item_title_possible"
ClassChangeMainList.impossible = "ui_classchange_item_title_impossible"

function ClassChangeMainList.updateList(arg_75_0, arg_75_1)
	if not arg_75_1 then
		return 
	end
	
	if arg_75_0.vars.list ~= arg_75_1 then
		arg_75_0.vars.listView:removeAllChildren()
		
		arg_75_0.vars.list = arg_75_1
		
		local var_75_0 = 0
		local var_75_1 = GAME_STATIC_VARIABLE.class_change_regist_max or 2
		local var_75_2 = false
		local var_75_3 = {}
		
		for iter_75_0, iter_75_1 in pairs(arg_75_1) do
			if iter_75_1.state ~= 2 then
				if iter_75_1.reg_uid then
					var_75_0 = var_75_0 + 1
					
					if var_75_1 <= var_75_0 then
						var_75_2 = true
					end
				end
				
				table.insert(var_75_3, iter_75_1)
			end
		end
		
		for iter_75_2, iter_75_3 in pairs(var_75_3) do
			if not iter_75_3.reg_uid then
				iter_75_3.blocked = var_75_2
			end
		end
		
		local function var_75_4(arg_76_0)
			local var_76_0 = 0
			
			if arg_76_0.reg_uid then
				var_76_0 = var_76_0 + 100
			end
			
			if arg_76_0.state > 0 then
				var_76_0 = var_76_0 + 100
			end
			
			if arg_76_0.own then
				var_76_0 = var_76_0 + 50
			end
			
			return var_76_0 - arg_76_0.db.sort
		end
		
		table.sort(var_75_3, function(arg_77_0, arg_77_1)
			return var_75_4(arg_77_0) > var_75_4(arg_77_1)
		end)
		
		local var_75_5 = table.clone(var_75_3)
		local var_75_6 = 0
		local var_75_7 = false
		local var_75_8 = {}
		
		for iter_75_4, iter_75_5 in pairs(var_75_3 or {}) do
			if iter_75_5.state == 1 and not iter_75_5.is_lock_enter_condition then
				var_75_7 = true
				var_75_6 = var_75_6 + 1
				
				table.insert(var_75_8, iter_75_5)
				
				var_75_5[iter_75_4] = nil
			end
		end
		
		local var_75_9 = false
		local var_75_10 = {}
		
		for iter_75_6, iter_75_7 in pairs(var_75_5 or {}) do
			if (iter_75_7.db.recommend or "") == "y" and (iter_75_7.state == -1 or iter_75_7.state == 0) then
				var_75_9 = true
				
				table.insert(var_75_10, iter_75_7)
				
				var_75_5[iter_75_6] = nil
			end
		end
		
		local var_75_11 = false
		local var_75_12 = {}
		
		for iter_75_8, iter_75_9 in pairs(var_75_5 or {}) do
			if iter_75_9.own or iter_75_9.reg_uid then
				local var_75_13 = iter_75_9.get_material and Account:getItemCount(iter_75_9.get_material) > 0
				local var_75_14 = not iter_75_9.is_lock_enter_condition
				local var_75_15 = not iter_75_9.under_level
				
				if iter_75_9.clear_enter and iter_75_9.get_material and var_75_13 and var_75_14 and iter_75_9.get_material and var_75_13 then
					var_75_11 = true
					
					table.insert(var_75_12, iter_75_9)
					
					var_75_5[iter_75_8] = nil
				elseif var_75_14 and var_75_15 and (not iter_75_9.get_material or var_75_13) then
					var_75_11 = true
					
					table.insert(var_75_12, iter_75_9)
					
					var_75_5[iter_75_8] = nil
				end
			end
		end
		
		local var_75_16 = {}
		
		for iter_75_10, iter_75_11 in pairs(var_75_5) do
			table.insert(var_75_16, iter_75_11)
		end
		
		local var_75_17 = -VIEW_WIDTH_RATIO
		
		if VIEW_WIDTH_RATIO <= 1 then
			local var_75_18 = var_75_17 * -1
		end
		
		local var_75_19 = VIEW_WIDTH / 2
		local var_75_20 = 1 + (1 - VIEW_WIDTH_RATIO)
		local var_75_21 = var_75_20 < 1 and 550 or 275
		
		for iter_75_12, iter_75_13 in pairs(var_75_8) do
			iter_75_13.popup_pos = iter_75_12 % 2 == 1 and var_75_19 + (var_75_20 < 1 and 150 or var_75_21) * var_75_20 or var_75_19 - var_75_20 * var_75_21
		end
		
		for iter_75_14, iter_75_15 in pairs(var_75_10) do
			iter_75_15.popup_pos = iter_75_14 % 2 == 1 and var_75_19 + (var_75_20 < 1 and 150 or var_75_21) * var_75_20 or var_75_19 - var_75_20 * var_75_21
		end
		
		for iter_75_16, iter_75_17 in pairs(var_75_12) do
			iter_75_17.popup_pos = iter_75_16 % 2 == 1 and var_75_19 + (var_75_20 < 1 and 150 or var_75_21) * var_75_20 or var_75_19 - var_75_20 * var_75_21
		end
		
		for iter_75_18, iter_75_19 in pairs(var_75_16) do
			iter_75_19.popup_pos = iter_75_18 % 2 == 1 and var_75_19 + (var_75_20 < 1 and 150 or var_75_21) * var_75_20 or var_75_19 - var_75_20 * var_75_21
		end
		
		local var_75_22
		
		arg_75_0.vars._finder = {}
		
		if var_75_7 then
			arg_75_0.vars.listView:addGroup({
				max_count = 2,
				title = ClassChangeMainList.already_progressed,
				count = var_75_6,
				is_top = var_75_22 == nil and true or false
			}, var_75_8)
			
			var_75_22 = true
			
			table.insert(arg_75_0.vars._finder, var_75_8)
		end
		
		if var_75_9 then
			arg_75_0.vars.listView:addGroup({
				title = "ui_classchange_item_title_recommend",
				recommend = true,
				is_top = var_75_22 == nil and true or false
			}, var_75_10)
			
			var_75_22 = true
			
			table.insert(arg_75_0.vars._finder, var_75_10)
		end
		
		if var_75_11 then
			arg_75_0.vars.listView:addGroup({
				title = ClassChangeMainList.possible,
				is_top = var_75_22 == nil and true or false
			}, var_75_12)
			
			var_75_22 = true
			
			table.insert(arg_75_0.vars._finder, var_75_12)
		end
		
		if table.count(var_75_16) > 0 then
			arg_75_0.vars.listView:addGroup({
				title = ClassChangeMainList.impossible,
				is_top = var_75_22 == nil and true or false
			}, var_75_16)
			
			local var_75_23 = true
			
			table.insert(arg_75_0.vars._finder, var_75_16)
		end
		
		local var_75_24 = ClassChange:getWnd()
		
		if var_75_24 and get_cocos_refid(var_75_24) then
			if_set_visible(var_75_24, "n_nolist", #var_75_3 <= 0)
		end
	end
end

function ClassChangeMainList.ratioJumper(arg_78_0, arg_78_1)
	local var_78_0
	local var_78_1
	local var_78_2
	
	for iter_78_0, iter_78_1 in pairs(arg_78_0.vars._finder) do
		for iter_78_2, iter_78_3 in pairs(iter_78_1) do
			if iter_78_3.db.char_id == arg_78_1 or iter_78_3.db.char_id_cc == arg_78_1 then
				var_78_0 = iter_78_0
				
				local var_78_3 = #iter_78_1
				
				var_78_2 = iter_78_2
				
				break
			end
		end
		
		if var_78_0 then
			break
		end
	end
	
	if not var_78_0 then
		return 
	end
	
	if var_78_0 == 1 and var_78_2 / 2 < 1.1 then
		return 
	end
	
	arg_78_0.vars.listView:jumpToIndex(var_78_0, var_78_2)
end

function ClassChangeMainList.updateItem(arg_79_0, arg_79_1, arg_79_2)
	UIUserData:call(arg_79_1:getChildByName("btn_start"):getChildByName("t_disc"), "SINGLE_WSCALE(280)")
	UIUserData:call(arg_79_1:getChildByName("btn_detail"):getChildByName("t_disc"), "SINGLE_WSCALE(280)")
	UIUserData:call(arg_79_1:getChildByName("btn_continue"):getChildByName("t_disc"), "SINGLE_WSCALE(280)")
	UIUserData:call(arg_79_1:getChildByName("btn_levelup"):getChildByName("t_disc"), "SINGLE_WSCALE(142)")
	UIUserData:call(arg_79_1:getChildByName("btn_destiny"):getChildByName("t_disc"), "SINGLE_WSCALE(142)")
	UIUserData:call(arg_79_1:getChildByName("btn_preview"):getChildByName("t_disc"), "SINGLE_WSCALE(142)")
	UIUserData:call(arg_79_1:getChildByName("btn_go"):getChildByName("t_disc"), "SINGLE_WSCALE(142)")
	
	if arg_79_2.state == 2 then
		if_set_visible(arg_79_1, "n_readytxt", false)
		if_set_visible(arg_79_1, "n_progress", false)
		if_set_visible(arg_79_1, "n_bar", false)
		if_set_opacity(arg_79_1, "n_bg", 100)
		if_set_opacity(arg_79_1, "n_char_info", 100)
		if_set_visible(arg_79_1, "n_skill_upgrade", false)
		if_set_visible(arg_79_1, "n_not_ready", true)
		if_set(arg_79_1, "n_disc", T("ui_cc_already_complete"))
		
		return arg_79_1
	end
	
	local var_79_0 = arg_79_2.own
	local var_79_1 = arg_79_2.under_level
	local var_79_2 = arg_79_2.blocked
	local var_79_3 = arg_79_2.is_lock_enter_condition
	local var_79_4 = Account:getItemCount(arg_79_2.db.get_material) > 0
	local var_79_5 = arg_79_2.db.destiny ~= nil and Account:getDestinyDataById(arg_79_2.db.destiny.id) or false
	
	if not var_79_0 or var_79_1 or var_79_3 or arg_79_2.db.get_material and not var_79_4 then
		if_set_visible(arg_79_1, "n_readytxt", false)
		if_set_visible(arg_79_1, "n_progress", false)
		if_set_visible(arg_79_1, "n_bar", false)
		if_set_opacity(arg_79_1, "n_bg", 100)
		if_set_opacity(arg_79_1, "n_char_info", 100)
		if_set_visible(arg_79_1, "n_not_ready", true)
		
		if not var_79_0 then
			if_set(arg_79_1, "n_disc", T("cc_list_none_hero"))
		elseif var_79_1 then
			if var_79_3 then
				local var_79_6, var_79_7 = DB("level_enter", arg_79_2.db.clear_enter, {
					"episode",
					"name"
				})
				
				if arg_79_2.db.get_material and not var_79_4 then
					if_set(arg_79_1, "n_disc", T(arg_79_2.db.lock_text_lv, {
						material_name = T(DB("item_material", arg_79_2.db.get_material, "name"))
					}))
				elseif var_79_6 then
					local var_79_8 = "ep_select_num" .. string.sub(var_79_6, #var_79_6)
					local var_79_9 = arg_79_2.db.lock_text_lv
					
					if_set(arg_79_1, "n_disc", T(var_79_9, {
						enter_name = T(var_79_7),
						episode = T(var_79_8)
					}))
				end
			elseif arg_79_2.db.get_material and not var_79_4 then
				if_set(arg_79_1, "n_disc", T(arg_79_2.db.lock_text_lv, {
					material_name = T(DB("item_material", arg_79_2.db.get_material, "name"))
				}))
			else
				if_set(arg_79_1, "n_disc", T("cc_list_lv_lack"))
			end
			
			local var_79_10 = arg_79_1:getChildByName("n_disc")
			
			if get_cocos_refid(var_79_10) then
				UIUserData:call(var_79_10, "MULTI_SCALE(3,60)")
			end
		elseif var_79_3 then
			local var_79_11, var_79_12 = DB("level_enter", arg_79_2.db.clear_enter, {
				"episode",
				"name"
			})
			
			if var_79_11 then
				local var_79_13 = "ep_select_num" .. string.sub(var_79_11, #var_79_11)
				
				if_set(arg_79_1, "n_disc", T("classchange_lock_enter", {
					enter_name = T(var_79_12),
					episode = T(var_79_13)
				}))
			end
		elseif arg_79_2.db.get_material and not var_79_4 then
			local var_79_14 = var_79_1 and arg_79_2.db.lock_text_lv or arg_79_2.db.lock_text
			
			if_set(arg_79_1, "n_disc", T(var_79_14, {
				material_name = T(DB("item_material", arg_79_2.db.get_material, "name") or "")
			}))
			
			local var_79_15 = arg_79_1:getChildByName("n_disc")
			
			if get_cocos_refid(var_79_15) then
				UIUserData:call(var_79_15, "MULTI_SCALE(3,60)")
			end
		end
		
		if_set_visible(arg_79_1, "btn_go", arg_79_2.db.btn_move and var_79_0 and var_79_3 and not var_79_1)
		if_set_visible(arg_79_1, "btn_detail", true)
		
		local var_79_16 = arg_79_1:getChildByName("btn_detail")
		
		if get_cocos_refid(var_79_16) then
			if_set(var_79_16, "t_disc", T("ui_classchange_card_btn_preview"))
			if_set(arg_79_1:getChildByName("btn_preview"), "t_disc", T("ui_classchange_card_btn_preview"))
		end
		
		if_set_visible(arg_79_1, "btn_detail", not arg_79_1:getChildByName("btn_go"):isVisible() and arg_79_2.db.destiny == nil and (arg_79_2.under_level ~= true or arg_79_2.own == false))
		if_set_visible(arg_79_1, "btn_preview", arg_79_1:getChildByName("btn_go"):isVisible() or arg_79_2.db.destiny ~= nil or arg_79_2.own == true and arg_79_2.under_level == true)
		if_set_visible(arg_79_1, "btn_destiny", arg_79_2.db.destiny ~= nil and arg_79_2.own == false and arg_79_2.under_level == true)
		if_set_visible(arg_79_1, "btn_levelup", (arg_79_2.db.destiny == nil or arg_79_1:getChildByName("btn_destiny"):isVisible() == false) and arg_79_2.own == true and arg_79_2.under_level == true)
		
		if arg_79_2.db.btn_move == nil and arg_79_2.db.get_material and not var_79_4 then
			if_set_visible(arg_79_1, "btn_preview", arg_79_1:getChildByName("btn_destiny"):isVisible() or arg_79_1:getChildByName("btn_levelup"):isVisible())
			if_set_visible(arg_79_1, "btn_detail", not arg_79_1:getChildByName("btn_destiny"):isVisible() and not arg_79_1:getChildByName("btn_levelup"):isVisible())
		end
		
		if arg_79_2.db.destiny and Account:getDestinyDataById(arg_79_2.db.destiny.id) and (not arg_79_2.under_level or not arg_79_2.own) then
			if_set_visible(arg_79_1, "btn_destiny", false)
			if_set_visible(arg_79_1, "btn_detail", true)
			if_set_visible(arg_79_1, "btn_preview", false)
		end
		
		if arg_79_2.db.destiny and arg_79_2.own == false and not var_79_5 then
			if_set(arg_79_1:getChildByName("n_not_ready"), "n_disc", T("ui_classchange_item_desc_destiny"))
		end
	else
		if_set_visible(arg_79_1, "n_not_ready", false)
		if_set_opacity(arg_79_1, "n_char_info", 255)
		if_set_opacity(arg_79_1, "btn_start", var_79_2 and 100 or 255)
		if_set_opacity(arg_79_1, "btn_continue", var_79_2 and 100 or 255)
		if_set_opacity(arg_79_1, "n_bg", var_79_2 and 100 or 255)
		
		if arg_79_2.state == 0 then
			if_set_visible(arg_79_1, "n_readytxt", true)
			if_set_visible(arg_79_1, "n_progress", false)
			if_set_visible(arg_79_1, "btn_start", true)
		else
			if_set_visible(arg_79_1, "n_readytxt", false)
			if_set_visible(arg_79_1, "n_progress", true)
			if_set(arg_79_1, "t_percent", arg_79_2.progress * 100 .. "%")
			if_set_percent(arg_79_1, "progress", arg_79_2.progress)
			
			if arg_79_2.progress >= 1 then
				if_set_opacity(arg_79_1, "btn_finish", 255)
				if_set_visible(arg_79_1, "icon_clan_0", true)
				if_set_color(arg_79_1, "progress", cc.c3b(107, 193, 27))
				if_set_color(arg_79_1, "t_title", cc.c3b(107, 193, 27))
				if_set(arg_79_1, "t_title", T("ui_classchange_card_progress_clear"))
			else
				if_set_opacity(arg_79_1, "btn_finish", 255)
				if_set_visible(arg_79_1, "icon_clan_0", true)
				if_set_color(arg_79_1, "progress", cc.c3b(146, 109, 62))
				if_set_color(arg_79_1, "t_title", cc.c3b(146, 109, 62))
				if_set(arg_79_1, "t_title", T("ui_classchange_list_progress"))
			end
			
			if arg_79_2.state < 0 then
				if_set_visible(arg_79_1, "btn_continue", true)
			elseif arg_79_2.state > 0 then
				if_set_visible(arg_79_1, "btn_detail", true)
			end
		end
		
		local var_79_17 = arg_79_1:getChildByName("btn_detail")
		
		if get_cocos_refid(var_79_17) then
			if_set(var_79_17, "t_disc", T("ui_classchange_card_btn_detail"))
		end
	end
end

function HANDLER.classchange_contents_tip(arg_80_0, arg_80_1)
	if get_cocos_refid(ClassChange.vars.tip_wnd) then
		BackButtonManager:pop("classchange.tip")
		ClassChange.vars.tip_wnd:removeFromParent()
	end
end

function ClassChange.getRecommandData(arg_81_0, arg_81_1)
	return (DBT("classchange_category", arg_81_1, {
		"recommend",
		"recommend_content_icon1",
		"recommend_content_title1",
		"recommend_content_desc1",
		"recommend_content_icon2",
		"recommend_content_title2",
		"recommend_content_desc2"
	}))
end

function ClassChange.showUnitRecommendTipPopup(arg_82_0, arg_82_1)
	if get_cocos_refid(arg_82_0.vars.tip_wnd) then
		BackButtonManager:pop("classchange.tip")
		arg_82_0.vars.tip_wnd:removeFromParent()
	else
		arg_82_0.vars.tip_wnd = load_control("wnd/classchange_contents_tip.csb")
		
		arg_82_0.vars.wnd:addChild(arg_82_0.vars.tip_wnd)
	end
	
	BackButtonManager:push({
		check_id = "classchange.tip",
		back_func = function()
			BackButtonManager:pop("classchange.tip")
			arg_82_0.vars.tip_wnd:removeFromParent()
		end,
		dlg = arg_82_0.vars.tip_wnd
	})
	
	local var_82_0 = arg_82_0:getRecommandData(arg_82_1.db.id)
	local var_82_1 = 0
	
	if var_82_0.recommend_content_icon2 then
		local var_82_2 = arg_82_0.vars.tip_wnd:getChildByName("n_contents1")
		
		if_set(var_82_2, "txt_name", T(var_82_0.recommend_content_title1))
		if_set(var_82_2, "txt_disc", T(var_82_0.recommend_content_desc1))
		if_set_sprite(var_82_2, "Sprite_1", "img/" .. var_82_0.recommend_content_icon1)
		
		var_82_1 = var_82_1 + var_82_2:getChildByName("txt_disc"):getTextBoxSize().height
		var_82_1 = var_82_1 + var_82_2:getChildByName("txt_name"):getContentSize().height
		
		local var_82_3 = arg_82_0.vars.tip_wnd:getChildByName("n_contents2")
		
		if_set(var_82_3, "txt_name", T(var_82_0.recommend_content_title2))
		if_set(var_82_3, "txt_disc", T(var_82_0.recommend_content_desc2))
		if_set_sprite(var_82_3, "Sprite_1", "img/" .. var_82_0.recommend_content_icon2)
		
		var_82_1 = var_82_1 + var_82_3:getChildByName("txt_disc"):getTextBoxSize().height
		var_82_1 = var_82_1 + var_82_3:getChildByName("txt_name"):getContentSize().height
		
		local var_82_4 = var_82_2:getChildByName("txt_disc"):getStringNumLines()
		local var_82_5 = 3
		
		if var_82_5 <= var_82_4 and not var_82_3.origin_y then
			var_82_3.origin_y = var_82_3:getPositionY()
			
			var_82_3:setPositionY(var_82_3:getPositionY() - (var_82_4 - var_82_5) * 15)
		end
		
		var_82_1 = var_82_1 + 120 + 28
	else
		local var_82_6 = arg_82_0.vars.tip_wnd:getChildByName("n_contents1")
		
		if_set(var_82_6, "txt_name", T(var_82_0.recommend_content_title1))
		if_set(var_82_6, "txt_disc", T(var_82_0.recommend_content_desc1))
		if_set_sprite(var_82_6, "Sprite_1", "img/" .. var_82_0.recommend_content_icon1)
		if_set_visible(arg_82_0.vars.tip_wnd, "n_contents2", false)
		
		var_82_1 = var_82_1 + var_82_6:getChildByName("txt_disc"):getTextBoxSize().height
		var_82_1 = var_82_1 + var_82_6:getChildByName("txt_name"):getContentSize().height
		var_82_1 = var_82_1 + 110 + 28
	end
	
	arg_82_0.vars.tip_wnd:getChildByName("bg"):setContentSize(550, var_82_1)
	arg_82_0.vars.tip_wnd:setAnchorPoint(0.5, 0.5)
	
	local var_82_7 = arg_82_0.vars.tip_wnd:getChildByName("n_contents_tooltip")
	
	var_82_7:setAnchorPoint(0.5, 0.5)
	arg_82_0.vars.tip_wnd:setPositionY(VIEW_HEIGHT / 2 - 60)
	var_82_7:setPositionX(arg_82_1.popup_pos)
end

ClassChangeSkillList = ClassChangeSkillList or {}

function ClassChangeSkillList.getInfo(arg_84_0, arg_84_1)
	local var_84_0 = {}
	
	for iter_84_0 = 1, 9999 do
		local var_84_1, var_84_2, var_84_3, var_84_4, var_84_5, var_84_6, var_84_7, var_84_8, var_84_9, var_84_10, var_84_11, var_84_12 = DBN("skill_tree_rune", iter_84_0, {
			"id",
			"type",
			"tooltip",
			"tooltip_value",
			"parent_skill_number",
			"stat",
			"same_eff_check",
			"same_eff_calc",
			"skill_number",
			"value",
			"skill_lv",
			"summary_sort"
		})
		
		if var_84_1 == nil then
			break
		end
		
		if var_84_1 and string.find(var_84_1, arg_84_1) then
			local var_84_13 = tostring(string.sub(var_84_3, 11, 12))
			
			if var_84_6 then
				var_84_0.stat = var_84_0.stat or {}
				var_84_0.stat[var_84_6] = var_84_0.stat[var_84_6] or {}
				var_84_0.stat[var_84_6].value = (var_84_0.stat[var_84_6].value == nil and 0 or var_84_0.stat[var_84_6].value) + var_84_10
				var_84_0.stat[var_84_6].tooltip = var_84_3
				var_84_0.stat[var_84_6].tooltip_value = var_84_4
				var_84_0.stat[var_84_6].parent_skill_number = var_84_5
				var_84_0.stat[var_84_6].skill_number = var_84_9 or var_84_5
				var_84_0.stat[var_84_6].summary_sort = to_n(var_84_12)
				
				if var_84_8 then
					var_84_0.stat[var_84_6].tooltip = var_84_8
					var_84_0.stat[var_84_6].duplicated_stat = true
					var_84_0.stat[var_84_6].stat = var_84_6
				end
			elseif var_84_5 then
				var_84_0.skill = var_84_0.skill or {}
				var_84_0.skill[var_84_5] = var_84_0.skill[var_84_5] or {}
				var_84_0.skill[var_84_5][var_84_13] = var_84_0.skill[var_84_5][var_84_13] or {}
				var_84_0.skill[var_84_5][var_84_13].id = var_84_1
				var_84_0.skill[var_84_5][var_84_13].type = var_84_2
				var_84_0.skill[var_84_5][var_84_13].tooltip = var_84_3
				var_84_0.skill[var_84_5][var_84_13].tooltip_value = var_84_4
				var_84_0.skill[var_84_5][var_84_13].parent_skill_number = var_84_5
				var_84_0.skill[var_84_5][var_84_13].same_eff_check = var_84_7
				var_84_0.skill[var_84_5][var_84_13].same_eff_calc = var_84_8
				var_84_0.skill[var_84_5][var_84_13].value = var_84_10
				var_84_0.skill[var_84_5][var_84_13].skill_number = var_84_9
				var_84_0.skill[var_84_5][var_84_13].summary_sort = to_n(var_84_12)
				
				if var_84_11 then
					if var_84_7 == "*ps_up" then
						local var_84_14 = to_n(string.sub(var_84_1, #var_84_1))
						local var_84_15, var_84_16 = DB("character", arg_84_1, {
							"grade",
							"face_id"
						})
						local var_84_17 = UNIT:create({
							code = var_84_16,
							g = var_84_15
						})
						local var_84_18 = {}
						
						for iter_84_1 = 1, #var_84_17:getSkillBundle()._slot do
							local var_84_19 = var_84_17:getSkillBundle():slot(iter_84_1):getPassive()
							
							if var_84_19 and string.ends(var_84_19, tostring(var_84_9)) then
								table.insert(var_84_18, var_84_19)
							end
						end
						
						for iter_84_2, iter_84_3 in pairs(var_84_18 or {}) do
							for iter_84_4 = 1, var_84_14 do
								local var_84_20 = iter_84_3 .. iter_84_4 .. "_1"
								local var_84_21 = to_n(DB("cs", var_84_20, {
									"cs_refer"
								}))
								local var_84_22 = (var_84_0.skill[var_84_5][var_84_13].skill_lv or 0) + var_84_21
								
								var_84_0.skill[var_84_5][var_84_13].skill_lv = var_84_22
							end
						end
					else
						local var_84_23 = (var_84_0.skill[var_84_5][var_84_13].skill_lv or 0) + to_n(DB("sklv", var_84_11, "add1"))
						
						var_84_0.skill[var_84_5][var_84_13].skill_lv = var_84_23
					end
				end
			end
		end
	end
	
	local var_84_24 = {}
	
	for iter_84_5, iter_84_6 in pairs(var_84_0.skill or {}) do
		for iter_84_7, iter_84_8 in pairs(iter_84_6) do
			if iter_84_8.same_eff_check and iter_84_8.same_eff_calc then
				var_84_24[iter_84_8.skill_number] = var_84_24[iter_84_8.skill_number] or {}
				
				table.insert(var_84_24[iter_84_8.skill_number], iter_84_8)
			end
		end
	end
	
	for iter_84_9, iter_84_10 in pairs(var_84_0.stat or {}) do
		if iter_84_10.duplicated_stat then
			var_84_24[iter_84_10.parent_skill_number] = var_84_24[iter_84_10.parent_skill_number] or {}
			iter_84_10.skill_lv = to_var_str(iter_84_10.value, iter_84_10.stat)
			
			if string.find(iter_84_10.skill_lv, "%%") then
				iter_84_10.skill_lv = string.sub(iter_84_10.skill_lv, 1, 2)
			end
			
			table.insert(var_84_24[iter_84_10.parent_skill_number], iter_84_10)
		end
	end
	
	local var_84_25 = table.clone(var_84_0)
	local var_84_26 = {}
	
	for iter_84_11, iter_84_12 in pairs(var_84_24) do
		for iter_84_13, iter_84_14 in pairs(iter_84_12) do
			local var_84_27 = iter_84_14.skill_number
			
			if var_84_26[var_84_27] == nil then
				var_84_26[var_84_27] = {}
			elseif var_84_26[var_84_27].stat ~= iter_84_14.stat then
				var_84_27 = iter_84_14.stat
				var_84_26[var_84_27] = {}
			end
			
			var_84_26[var_84_27].odd = var_84_26[var_84_27].odd or 0
			var_84_26[var_84_27].odd = var_84_26[var_84_27].odd + iter_84_14.skill_lv
			var_84_26[var_84_27].tooltip = iter_84_14.same_eff_calc or iter_84_14.tooltip
			var_84_26[var_84_27].tooltip_value = iter_84_14.tooltip_value
			var_84_26[var_84_27].parent_skill_number = iter_84_14.parent_skill_number
			var_84_26[var_84_27].skill_number = iter_84_14.skill_number
			var_84_26[var_84_27].same_eff_check = iter_84_14.same_eff_check
			var_84_26[var_84_27].same_eff_calc = iter_84_14.same_eff_calc
			var_84_26[var_84_27].stat = iter_84_14.stat
			var_84_26[var_84_27].summary_sort = iter_84_14.summary_sort
		end
	end
	
	for iter_84_15, iter_84_16 in pairs(var_84_26) do
		var_84_25.skill[iter_84_16.parent_skill_number] = var_84_25.skill[iter_84_16.parent_skill_number] or {}
		
		for iter_84_17, iter_84_18 in pairs(var_84_25.skill[iter_84_16.parent_skill_number]) do
			if iter_84_18.skill_number == iter_84_16.skill_number and iter_84_18.same_eff_calc == iter_84_16.same_eff_calc and iter_84_18.same_eff_check == iter_84_16.same_eff_check then
				var_84_25.skill[iter_84_16.parent_skill_number][iter_84_17] = nil
			end
		end
		
		var_84_25.skill[iter_84_16.parent_skill_number][iter_84_16.tooltip] = {}
		
		if string.ends(iter_84_16.tooltip, "_calc") and iter_84_16.odd < 1 then
			iter_84_16.odd = iter_84_16.odd * 100
		end
		
		var_84_25.skill[iter_84_16.parent_skill_number][iter_84_16.tooltip].odd = iter_84_16.odd
		var_84_25.skill[iter_84_16.parent_skill_number][iter_84_16.tooltip].tooltip = iter_84_16.tooltip
		var_84_25.skill[iter_84_16.parent_skill_number][iter_84_16.tooltip].summary_sort = iter_84_16.summary_sort
	end
	
	for iter_84_19, iter_84_20 in pairs(var_84_0.stat or {}) do
		var_84_25.skill[0] = var_84_25.skill[0] or {}
		var_84_25.skill[0][iter_84_19] = iter_84_20
	end
	
	var_84_25.stat = nil
	
	local var_84_28 = table.clone(var_84_25.skill)
	local var_84_29 = var_84_25.skill and var_84_25.skill[0]
	
	for iter_84_21, iter_84_22 in pairs(var_84_29 or {}) do
		if iter_84_22.stat and var_84_28[0][iter_84_22.stat] then
			var_84_28[0][iter_84_22.stat] = nil
		end
	end
	
	local var_84_30 = {}
	
	for iter_84_23, iter_84_24 in pairs(var_84_28 or {}) do
		var_84_30[iter_84_23] = {}
		var_84_30[iter_84_23].tooltips = {}
		var_84_30[iter_84_23].tooltips.skill_idx = tostring(iter_84_23)
		
		local var_84_31 = {}
		
		if iter_84_23 == 0 then
			for iter_84_25, iter_84_26 in pairs(iter_84_24) do
				local var_84_32 = {}
				
				if iter_84_26.odd then
					var_84_32.tooltip = iter_84_26.tooltip
					var_84_32.odd = iter_84_26.odd
				elseif iter_84_26.duplicated_stat then
					var_84_32.tooltip = iter_84_26.tooltip
					var_84_32.odd = iter_84_26.value
				else
					var_84_32.tooltip = iter_84_26.tooltip
					var_84_32.tooltip_value = iter_84_26.tooltip_value
				end
				
				var_84_32.summary_sort = iter_84_26.summary_sort
				var_84_32.stat = iter_84_25
				
				table.insert(var_84_31, var_84_32)
			end
			
			table.sort(var_84_31, function(arg_85_0, arg_85_1)
				return arg_85_0.summary_sort < arg_85_1.summary_sort
			end)
		else
			for iter_84_27, iter_84_28 in pairs(iter_84_24) do
				local var_84_33 = {}
				
				if iter_84_28.odd then
					var_84_33.skill_idx = iter_84_27
					var_84_33.tooltip = iter_84_28.tooltip
					var_84_33.odd = iter_84_28.odd
					var_84_33.summary_sort = iter_84_28.summary_sort
				elseif iter_84_28.duplicated_stat then
					var_84_33.tooltip = iter_84_28.tooltip
					var_84_33.odd = iter_84_28.value
					var_84_33.summary_sort = iter_84_28.summary_sort
				else
					var_84_33.skill_idx = iter_84_27
					var_84_33.tooltip = iter_84_28.tooltip
					var_84_33.tooltip_value = iter_84_28.tooltip_value
					var_84_33.summary_sort = iter_84_28.summary_sort
				end
				
				table.insert(var_84_31, var_84_33)
			end
			
			table.sort(var_84_31, function(arg_86_0, arg_86_1)
				return arg_86_0.summary_sort < arg_86_1.summary_sort
			end)
		end
		
		var_84_30[iter_84_23].tooltips.skill_info = var_84_31
	end
	
	return var_84_30
end

local function var_0_2(arg_87_0)
	local var_87_0 = table.clone(arg_87_0)
	
	var_87_0["0"] = nil
	var_87_0.skill_idx = nil
	
	local var_87_1 = ""
	local var_87_2 = 1
	
	for iter_87_0, iter_87_1 in pairs(arg_87_0["0"] or {}) do
		var_87_1 = var_87_1 .. "-" .. T(iter_87_1)
		
		if var_87_2 <= table.count(arg_87_0["0"]) then
			var_87_1 = var_87_1 .. "\n"
			var_87_2 = var_87_2 + 1
		end
	end
	
	local var_87_3 = 1
	
	for iter_87_2, iter_87_3 in pairs(var_87_0.skill_info) do
		if iter_87_3.odd then
			var_87_1 = var_87_1 .. "- " .. T(iter_87_3.tooltip, {
				tooltip_value = iter_87_3.odd
			})
		else
			var_87_1 = var_87_1 .. "- " .. T(iter_87_3.tooltip, {
				tooltip_value = iter_87_3.tooltip_value
			})
		end
		
		if var_87_3 < table.count(var_87_0.skill_info) then
			var_87_1 = var_87_1 .. "\n"
			var_87_3 = var_87_3 + 1
		end
	end
	
	return var_87_1
end

local function var_0_3(arg_88_0)
	local var_88_0 = 1
	local var_88_1 = ""
	
	for iter_88_0, iter_88_1 in pairs(arg_88_0.tooltips.skill_info) do
		if iter_88_1.odd then
			var_88_1 = var_88_1 .. "- " .. T(iter_88_1.tooltip, {
				tooltip_value = iter_88_1.odd
			})
		else
			var_88_1 = var_88_1 .. "- " .. T(iter_88_1.tooltip, {
				tooltip_value = iter_88_1.tooltip_value
			})
		end
		
		if var_88_0 <= table.count(arg_88_0.tooltips.skill_info) then
			var_88_1 = var_88_1 .. "\n"
			var_88_0 = var_88_0 + 1
		end
	end
	
	if var_88_0 == 2 then
		var_88_1 = var_88_1 .. "\n"
	end
	
	return var_88_1
end

local function var_0_4(arg_89_0, arg_89_1)
	local var_89_0 = arg_89_0:getChildByName("t_disc")
	
	if not get_cocos_refid(var_89_0) then
		return 
	end
	
	if_set_visible(arg_89_0, "n_general", true)
	if_set_visible(arg_89_0, "n_skill", false)
	
	local var_89_1 = var_0_2(arg_89_1)
	
	if_set(var_89_0, nil, var_89_1)
	var_89_0:setAnchorPoint(0, 0)
	
	local var_89_2 = var_89_0:getContentSize()
	
	var_89_2.height = var_89_0:getTextBoxSize().height
	
	var_89_0:setContentSize(var_89_2)
	arg_89_0:setContentSize(var_89_2)
end

local function var_0_5(arg_90_0, arg_90_1)
	local var_90_0 = arg_90_0:getChildByName("txt_skill_name")
	
	if not get_cocos_refid(var_90_0) then
		return 
	end
	
	local var_90_1 = arg_90_0:getChildByName("txt_skill_desc")
	
	if not get_cocos_refid(var_90_1) then
		return 
	end
	
	local var_90_2 = arg_90_0:getChildByName("n_skill_icon")
	
	if not get_cocos_refid(var_90_2) then
		return 
	end
	
	if_set_visible(arg_90_0, "n_general", false)
	if_set_visible(arg_90_0, "n_skill", true)
	
	local var_90_3 = DB("skill", arg_90_1.new_unit:getSkillByIndex(tonumber(arg_90_1.tooltips.skill_idx)), {
		"name"
	})
	
	if_set(var_90_1, nil, var_0_3(arg_90_1))
	
	local var_90_4 = var_90_1:getContentSize()
	
	var_90_4.height = var_90_1:getTextBoxSize().height
	
	var_90_1:setContentSize(var_90_4)
	
	local var_90_5 = var_90_4.height * var_90_1:getScale() + 10
	
	var_90_0:setPositionY(var_90_5)
	if_set(var_90_0, nil, T(var_90_3))
	
	local var_90_6 = var_90_0:getContentSize()
	
	var_90_6.height = var_90_0:getTextBoxSize().height
	
	var_90_0:setContentSize(var_90_6)
	
	local var_90_7 = var_90_6.height * var_90_0:getScale()
	local var_90_8 = UIUtil:getSkillIcon(arg_90_1.new_unit, tonumber(arg_90_1.tooltips.skill_idx), {
		tooltip_opts = {
			show_effs = "right",
			call_by_show = var_0_0
		}
	})
	
	var_90_2:removeAllChildren()
	var_90_2:addChild(var_90_8)
	var_90_2:setPositionY(var_90_5 - 15)
	
	arg_90_0:getContentSize().height = var_90_5 + var_90_7
	
	arg_90_0:setContentSize(var_90_4)
end

local function var_0_6(arg_91_0, arg_91_1, arg_91_2)
	if arg_91_2.skill_idx == "0" then
		UIUserData:call(arg_91_1:getChildByName("t_disc"), "RICH_LABEL(true)")
		var_0_4(arg_91_1, arg_91_2)
		
		return 
	end
	
	UIUserData:call(arg_91_1:getChildByName("txt_skill_desc"), "RICH_LABEL(true)")
	var_0_5(arg_91_1, arg_91_2)
end

local function var_0_7(arg_92_0, arg_92_1, arg_92_2)
	local var_92_0 = arg_92_0:getChildByName("t_disc")
	
	if not get_cocos_refid(var_92_0) then
		return 
	end
	
	if_set(var_92_0, nil, var_0_2(arg_92_2))
	
	local var_92_1 = arg_92_1:getContentSize()
	
	var_92_1.height = var_92_0:getTextBoxSize().height * var_92_0:getScale()
	
	arg_92_1:setContentSize(var_92_1)
	arg_92_1:setName("widget")
end

local function var_0_8(arg_93_0, arg_93_1, arg_93_2)
	local var_93_0 = arg_93_0:getChildByName("txt_skill_name")
	
	if not get_cocos_refid(var_93_0) then
		return 
	end
	
	local var_93_1 = arg_93_0:getChildByName("txt_skill_desc")
	
	if not get_cocos_refid(var_93_1) then
		return 
	end
	
	local var_93_2 = arg_93_0:getChildByName("n_skill_icon")
	
	if not get_cocos_refid(var_93_2) then
		return 
	end
	
	if_set(var_93_1, nil, var_0_3(arg_93_2))
	
	local var_93_3 = var_93_1:getTextBoxSize().height * var_93_1:getScale()
	local var_93_4 = DB("skill", arg_93_2.new_unit:getSkillByIndex(tonumber(arg_93_2.tooltips.skill_idx)), {
		"name"
	})
	
	if_set(var_93_0, nil, T(var_93_4))
	
	local var_93_5 = var_93_0:getTextBoxSize().height * var_93_0:getScale()
	local var_93_6 = arg_93_1:getContentSize()
	
	var_93_6.height = var_93_3 + var_93_5 + 20
	
	arg_93_1:setContentSize(var_93_6)
	arg_93_1:setName(var_93_4)
end

local function var_0_9(arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_4)
	if arg_94_4.skill_idx == "0" then
		UIUserData:call(arg_94_1:getChildByName("t_disc"), "RICH_LABEL(true)")
		var_0_7(arg_94_1, arg_94_3, arg_94_4)
		
		return 
	end
	
	UIUserData:call(arg_94_1:getChildByName("txt_skill_desc"), "RICH_LABEL(true)")
	var_0_8(arg_94_1, arg_94_3, arg_94_4)
end

function ClassChangeSkillList.init(arg_95_0, arg_95_1, arg_95_2)
	local var_95_0 = ClassChange:getDetailInfo()
	local var_95_1 = arg_95_1:getChildByName("listview")
	
	arg_95_0.vars = {}
	arg_95_0.vars.parent = arg_95_1
	arg_95_0.vars.info = ClassChange:getDetailInfo()
	
	local var_95_2 = arg_95_0.vars.info.db ~= nil and arg_95_0.vars.info.db.char_id_cc or nil
	
	if var_95_2 == nil and UnitZodiac.vars ~= nil then
		var_95_2 = UnitZodiac.vars.unit:isClassChangeableUnit()
	end
	
	local var_95_3, var_95_4 = DB("character", var_95_2, {
		"grade",
		"face_id"
	})
	local var_95_5 = UNIT:create({
		code = var_95_4,
		g = var_95_3
	})
	
	var_95_5.inst.zodiac = 6
	
	var_95_5:updateZodiacSkills()
	var_95_5:calc()
	
	arg_95_0.vars.listView = GroupListView:bindControl(var_95_1, {
		layout_type = ccui.LayoutType.VERTICAL
	})
	
	arg_95_0.vars.listView:setListViewCascadeOpacityEnabled(true)
	arg_95_0.vars.listView:setEnableMargin(true)
	
	if arg_95_2 then
		var_95_1:setContentSize(622, 486)
	end
	
	local var_95_6 = load_control("wnd/classchange_skill_summary_item_title.csb")
	local var_95_7 = {
		onUpdate = function(arg_96_0, arg_96_1, arg_96_2)
			if_set_visible(arg_96_1, "n_general", true)
			if_set_visible(arg_96_1, "n_title_genral", arg_96_2.type == "g")
			if_set_visible(arg_96_1, "n_title_skill", arg_96_2.type == "s")
		end
	}
	local var_95_8 = load_control("wnd/classchange_skill_summary_item.csb")
	local var_95_9 = {
		onUpdate = var_0_6,
		onSize = var_0_9
	}
	
	arg_95_0.vars.listView:setRenderer(var_95_6, var_95_8, var_95_7, var_95_9)
	
	local var_95_10 = arg_95_0:getInfo(var_95_0.db.char_id_cc)
	
	arg_95_0.vars.listView:addGroup({
		type = "g"
	}, var_95_10[0])
	
	local var_95_11 = {}
	
	for iter_95_0, iter_95_1 in pairs(var_95_10) do
		if iter_95_1.tooltips.skill_idx ~= "0" then
			iter_95_1.new_unit = var_95_5
			
			table.insert(var_95_11, iter_95_1)
		end
	end
	
	arg_95_0.vars.listView:addGroup({
		type = "s"
	}, var_95_11)
end

function ClassChangeMainList.onSelectScrollViewItem(arg_97_0, arg_97_1, arg_97_2)
end

UnitExtensionSkillList = {}

copy_functions(ClassChangeSkillList, UnitExtensionSkillList)

function UnitExtensionSkillList.init(arg_98_0, arg_98_1, arg_98_2)
	local var_98_0 = UnitDetail:isValid() and UnitDetail:getUnit() or UnitZodiac:isValid() and UnitZodiac:getUnit()
	
	if not var_98_0 then
		return 
	end
	
	local var_98_1 = arg_98_1:getChildByName("listview")
	
	arg_98_0.vars = {}
	arg_98_0.vars.parent = arg_98_1
	
	local var_98_2, var_98_3 = DB("character", var_98_0.db.code, {
		"grade",
		"face_id"
	})
	local var_98_4 = UNIT:create({
		code = var_98_3,
		g = var_98_2
	})
	
	var_98_4.inst.zodiac = 6
	
	var_98_4:updateZodiacSkills()
	var_98_4:calc()
	
	arg_98_0.vars.listView = GroupListView:bindControl(var_98_1, {
		layout_type = ccui.LayoutType.VERTICAL
	})
	
	arg_98_0.vars.listView:setListViewCascadeOpacityEnabled(true)
	arg_98_0.vars.listView:setEnableMargin(true)
	
	if arg_98_2 then
		var_98_1:setContentSize(622, 486)
	end
	
	local var_98_5 = load_control("wnd/classchange_skill_summary_item_title.csb")
	local var_98_6 = {
		onUpdate = function(arg_99_0, arg_99_1, arg_99_2)
			if_set_visible(arg_99_1, "n_general", true)
			if_set_visible(arg_99_1, "n_title_genral", arg_99_2.type == "g")
			if_set_visible(arg_99_1, "n_title_skill", arg_99_2.type == "s")
		end
	}
	local var_98_7 = load_control("wnd/classchange_skill_summary_item.csb")
	local var_98_8 = {
		onUpdate = var_0_6,
		onSize = var_0_9
	}
	
	arg_98_0.vars.listView:setRenderer(var_98_5, var_98_7, var_98_6, var_98_8)
	
	local var_98_9 = arg_98_0:getInfo(var_98_0.db.code)
	
	arg_98_0.vars.listView:addGroup({
		type = "g"
	}, var_98_9[0])
	
	local var_98_10 = {}
	
	for iter_98_0, iter_98_1 in pairs(var_98_9) do
		if iter_98_1.tooltips.skill_idx ~= "0" then
			iter_98_1.new_unit = var_98_4
			
			table.insert(var_98_10, iter_98_1)
		end
	end
	
	arg_98_0.vars.listView:addGroup({
		type = "s"
	}, var_98_10)
end

ClassChangeQuestList = ClassChangeQuestList or {}

function ClassChangeQuestList.init(arg_100_0, arg_100_1, arg_100_2)
	local var_100_0 = ClassChange:getDetailInfo()
	local var_100_1 = arg_100_0:getDatas(var_100_0.db.id)
	local var_100_2 = arg_100_1:getChildByName("listview")
	
	arg_100_0.vars = {}
	arg_100_0.vars.parent = arg_100_1
	arg_100_0.vars.itemView = ItemListView_v2:bindControl(var_100_2)
	arg_100_0.vars.data = var_100_1
	
	if arg_100_2 then
		var_100_2:setContentSize(622, 486)
	end
	
	ConditionContentsManager:checkState(CONTENTS_TYPE.CLASS_CHANGE_QUEST, {
		db_data = var_100_1
	})
	
	local var_100_3 = load_control("wnd/classchange_quest_item.csb")
	
	if var_100_2.STRETCH_INFO and not arg_100_2 then
		local var_100_4 = var_100_2:getContentSize()
		
		resetControlPosAndSize(var_100_3, var_100_4.width, var_100_2.STRETCH_INFO.width_prev)
	end
	
	local var_100_5 = {
		onUpdate = function(arg_101_0, arg_101_1, arg_101_2, arg_101_3)
			ClassChangeQuestList:updateItem(arg_101_1, arg_101_3, arg_100_2)
			
			return arg_101_3.id
		end
	}
	
	arg_100_0.vars.itemView:setRenderer(var_100_3, var_100_5)
	arg_100_0.vars.itemView:removeAllChildren()
	
	for iter_100_0, iter_100_1 in pairs(arg_100_0.vars.data) do
		arg_100_0.vars.data[iter_100_0].is_variable_y = false
	end
	
	arg_100_0.vars.itemView:setDataSource(arg_100_0.vars.data)
end

function ClassChangeQuestList.getDatas(arg_102_0, arg_102_1)
	local var_102_0 = {}
	
	for iter_102_0 = 1, 99 do
		local var_102_1 = string.format("%s_quest_%02d", arg_102_1, iter_102_0)
		local var_102_2 = DBT("classchange_quest", var_102_1, {
			"id",
			"category_name",
			"mission_name",
			"mission_icon_1",
			"mission_icon_2",
			"mission_desc",
			"condition",
			"give_code",
			"give_count",
			"enter_stage",
			"value",
			"enter_condition_state",
			"clear_story",
			"reward_id1",
			"reward_count1",
			"btn_move"
		})
		
		if not var_102_2 or not var_102_2.id then
			break
		end
		
		if var_102_2.condition and var_102_2.value then
			table.insert(var_102_0, var_102_2)
		end
	end
	
	return var_102_0
end

function ClassChangeQuestList.ItemListRefresh(arg_103_0)
	arg_103_0.vars.itemView:refresh()
end

function ClassChangeQuestList.enterBattle(arg_104_0, arg_104_1)
	if arg_104_1.enter_condition_state and not ConditionContentsState:getClearData(arg_104_1.enter_condition_state).is_cleared then
		balloon_message_with_sound("cc_quest_need_enter_condition_clear")
		
		return 
	end
	
	BattleReady:show({
		npc_text_change = true,
		enter_id = arg_104_1.enter_stage,
		callback = ClassChangeQuestList
	})
end

function ClassChangeQuestList.updateItem(arg_105_0, arg_105_1, arg_105_2, arg_105_3)
	if not ClassChange:getDetailInfo().reg_uid and not arg_105_3 then
	end
	
	local var_105_0 = Account:getClassChangeQuest(arg_105_2.id).state
	local var_105_1 = arg_105_1:getChildByName("btn_go")
	local var_105_2 = 255
	
	if var_105_0 == 2 and not arg_105_3 then
		var_105_2 = 150
	end
	
	local var_105_3 = {
		give = arg_105_2.give_code,
		battle = arg_105_2.enter_stage,
		active_text = T("condition_battle_text")
	}
	
	UIUtil:setColorRewardButtonState(var_105_0, arg_105_1, var_105_1, {
		give = arg_105_2.give_code,
		battle = arg_105_2.enter_stage
	})
	
	if arg_105_2.mission_icon_1 then
		local var_105_4 = 1.5
		
		if not DB("character", arg_105_2.mission_icon_1, "id") then
			var_105_4 = 1.3
		end
		
		local var_105_5 = UIUtil:getRewardIcon(nil, arg_105_2.mission_icon_1, {
			no_popup = true,
			no_grade = true,
			parent = arg_105_1:getChildByName("n_face"),
			scale = var_105_4
		})
		
		if_set_opacity(var_105_5, nil, var_105_2)
		if_set_visible(arg_105_1, "spr_icon", false)
	elseif arg_105_2.mission_icon_2 then
		arg_105_1:getChildByName("n_face"):removeAllChildren()
		if_set_visible(arg_105_1, "spr_icon", true)
		if_set_sprite(arg_105_1, "spr_icon", arg_105_2.mission_icon_2 .. ".png")
	end
	
	if var_105_0 == 2 then
		if_set_opacity(arg_105_1, "n_normal", var_105_2)
		if_set_opacity(arg_105_1, "n_right", var_105_2)
	end
	
	local var_105_6 = arg_105_2.condition_group_db
	local var_105_7 = ConditionContentsManager:getClassChangeQuest():getScore(arg_105_2.id)
	local var_105_8 = totable(arg_105_2.value).count
	
	if_set(arg_105_1, "txt_kind", T(arg_105_2.category_name))
	if_set(arg_105_1, "txt_title_1", T(arg_105_2.mission_name))
	UIUserData:call(arg_105_1:getChildByName("txt_title_1"), "MULTI_SCALE(2,50)")
	
	local var_105_9 = arg_105_1:getChildByName("txt_kind")
	local var_105_10 = arg_105_1:getChildByName("txt_title_1")
	
	if var_105_9 and get_cocos_refid(var_105_9) and var_105_10:getStringNumLines() == 2 and not arg_105_2.is_variable_y then
		var_105_9:setPositionY(var_105_9:getPositionY() + 20)
		
		arg_105_2.is_variable_y = true
	end
	
	if_set(arg_105_1, "txt_name", T(arg_105_2.mission_desc))
	
	local var_105_11 = math.min(var_105_7, var_105_8)
	
	if var_105_0 >= 1 then
		var_105_11 = var_105_8
	end
	
	if_set_percent(arg_105_1, "progress", var_105_11 / var_105_8)
	if_set(arg_105_1, "txt_progress", comma_value(var_105_11) .. " / " .. comma_value(var_105_8))
	
	local var_105_12 = ClassChange:getDetailInfo()
	
	if var_105_12 and var_105_12.state and var_105_12.reg_uid and var_105_12.state == 1 then
		var_105_1:setOpacity(255)
		var_105_1:getChildByName("noti"):setVisible(arg_105_2.give_code and var_105_0 == 0 and Account:getPropertyCount(arg_105_2.give_code) >= arg_105_2.give_count)
	else
		var_105_1:setOpacity(76.5)
		var_105_1:getChildByName("noti"):setVisible(false)
	end
	
	var_105_1.class_change_state = var_105_12.state
	var_105_1.contents_id = arg_105_2.id
	var_105_1.state = var_105_0
	var_105_1.give_code = arg_105_2.give_code
	var_105_1.give_count = arg_105_2.give_count
	var_105_1.btn_move = arg_105_2.btn_move
	var_105_1.enter_stage = arg_105_2.enter_stage
	var_105_1.enter_condition_state = arg_105_2.enter_condition_state
	
	if var_105_0 == 0 and not arg_105_2.btn_move and not arg_105_2.give_code and not arg_105_2.enter_stage then
		var_105_1:setVisible(false)
	end
end

function ClassChangeQuestList.onUpdateUI(arg_106_0, arg_106_1)
	if not arg_106_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_106_0.vars.parent) then
		return 
	end
	
	if not get_cocos_refid(arg_106_0.vars.itemView) then
		return 
	end
	
	arg_106_0:ItemListRefresh()
end

function ClassChangeQuestList.setTouchEnabled(arg_107_0, arg_107_1)
end

function ClassChangeQuestList.showPresentWnd(arg_108_0, arg_108_1, arg_108_2, arg_108_3, arg_108_4)
	local var_108_0 = Dialog:open("wnd/destiny_present", arg_108_0)
	
	arg_108_1 = arg_108_1 or SceneManager:getRunningNativeScene()
	
	arg_108_1:addChild(var_108_0)
	UIUtil:getRewardIcon(arg_108_4, arg_108_3, {
		show_name = true,
		detail = true,
		parent = var_108_0:getChildByName("n_item")
	})
	UIUtil:getRewardIcon(nil, arg_108_3, {
		no_frame = true,
		scale = 0.6,
		parent = var_108_0:getChildByName("n_pay_token")
	})
	if_set(var_108_0, "txt_price", comma_value(arg_108_4))
	if_set(var_108_0, "txt_item_hoiding", T("text_item_have_count", {
		count = comma_value(Account:getPropertyCount(arg_108_3) or 0)
	}))
	if_set(var_108_0, "txt_title", T("ui_classchange_present_title"))
	if_set(var_108_0, "txt_disc", T("ui_classchange_present_desc"))
	
	local var_108_1 = var_108_0:getChildByName("btn_present")
	
	var_108_1.give_code = arg_108_3
	var_108_1.give_count = arg_108_4
	var_108_1.contents_id = arg_108_2
	var_108_1.parent = arg_108_0
end

function ClassChangeQuestList.giveItem(arg_109_0, arg_109_1)
	if not arg_109_1 or not arg_109_1.give_code or not arg_109_1.give_code then
		return Log.e("destiny", "giveItem.null")
	end
	
	if Account:getPropertyCount(arg_109_1.give_code) < arg_109_1.give_count then
		balloon_message_with_sound("lack_give_currencies_count")
		
		return 
	end
	
	ConditionContentsManager:setIgnoreQuery(true)
	ConditionContentsManager:dispatch("classchange.give", {
		give = arg_109_1.contents_id
	})
	ConditionContentsManager:setIgnoreQuery(false)
	
	local var_109_0 = ConditionContentsManager:getUpdateConditions()
	
	if var_109_0 then
		query("give_classchange_quest", {
			contents_id = arg_109_1.contents_id,
			update_condition_groups = json.encode(var_109_0)
		})
	end
	
	Dialog:close("destiny_present")
end

function ClassChangeQuestList.slideEffect(arg_110_0)
	if not arg_110_0.vars then
		return 
	end
	
	local var_110_0 = arg_110_0.vars.itemView
	
	if not var_110_0 or not get_cocos_refid(var_110_0) then
		return 
	end
	
	for iter_110_0, iter_110_1 in pairs(var_110_0.vars.controls) do
		local var_110_1 = iter_110_0:getPositionX()
		local var_110_2 = iter_110_0:getPositionY()
		local var_110_3 = var_110_2 - VIEW_HEIGHT
		
		iter_110_0:setPositionY(var_110_3)
		UIAction:Add(SEQ(DELAY(to_n(0) + iter_110_1.index * 80), SPAWN(LOG(MOVE_TO(250, var_110_1, var_110_2), 200), RLOG(OPACITY(250, 0, 1)))), iter_110_0, "block")
	end
end

function ClassChangeQuestList.onStartBattle(arg_111_0, arg_111_1)
	if Account:getCurrentTeam()[1] == nil and Account:getCurrentTeam()[2] == nil and Account:getCurrentTeam()[3] == nil and Account:getCurrentTeam()[4] == nil and not arg_111_1.npcteam_id then
		message(T("worldmap_town_lua_1523"))
		
		return 
	end
	
	Dialog:closeAll()
	print("입장:" .. arg_111_1.enter_id)
	startBattle(arg_111_1.enter_id, arg_111_1)
	BattleReady:hide()
end
