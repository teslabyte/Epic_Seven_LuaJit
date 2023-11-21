CoopReadyBG = ClassDef()

function CoopReadyBG.getLayoutData(arg_1_0, arg_1_1)
	return arg_1_0.layout_data[arg_1_1]
end

function CoopReadyBG.layoutModel(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0:getLayoutData(arg_2_2)
	
	arg_2_1:setPosition(var_2_0.x, var_2_0.y)
	
	if var_2_0.flip then
		arg_2_1:setScaleX(-arg_2_1:getScaleX())
		
		arg_2_1.camp_flip = true
	end
	
	arg_2_1.camp_z = arg_2_1:getLocalZOrder()
	
	arg_2_1:setLocalZOrder(arg_2_2)
end

function CoopReadyBG.constructor(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.layer, arg_3_0.field = FIELD_NEW:create(arg_3_2, VIEW_WIDTH * 2, false)
	
	arg_3_0.layer:setName("coop_bg")
	arg_3_0.layer:setPosition(-445, -220)
	arg_3_0.layer:setScale(1)
	arg_3_0.field:setViewPortPosition(DESIGN_WIDTH * 0.5)
	arg_3_0.field:updateViewport()
	
	arg_3_0.layout_data = {
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
	}
	
	arg_3_1:addChild(arg_3_0.layer)
end

function CoopReadyBG.release(arg_4_0)
	if get_cocos_refid(arg_4_0.layer) then
		arg_4_0.layer:removeFromParent()
	end
end

function CoopReadyBG.addUnit(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:removeUnit(arg_5_1)
	
	if not arg_5_2 then
		return 
	end
	
	if not (arg_5_1 < 5) or arg_5_2:isSummon() then
		return 
	end
	
	local var_5_0 = CACHE:getModelWithCheckAnim(arg_5_2.db.model_id, arg_5_2.db.skin, "camping", "idle", arg_5_2.db.atlas, arg_5_2.db.model_opt)
	
	if not get_cocos_refid(var_5_0) then
		return 
	end
	
	arg_5_0.field.main.layer:addChild(var_5_0)
	arg_5_0:layoutModel(var_5_0, arg_5_1)
	var_5_0:setName("model_" .. arg_5_1)
	
	return var_5_0
end

function CoopReadyBG.removeUnit(arg_6_0, arg_6_1)
	if not arg_6_0.field then
		return 
	end
	
	local var_6_0 = arg_6_0.field.main.layer:findChildByName("model_" .. arg_6_1)
	
	if get_cocos_refid(var_6_0) then
		var_6_0:cleanupReferencedObject()
		var_6_0:removeFromParent()
	end
end

function CoopReadyBG.removeAllUnit(arg_7_0)
	local var_7_0 = table.count(arg_7_0.layout_data)
	
	for iter_7_0 = 1, var_7_0 do
		arg_7_0:removeUnit(iter_7_0)
	end
end

CoopReady = ClassDef()

function CoopReady.constructor(arg_8_0, arg_8_1)
	arg_8_0.vars = {}
	arg_8_0.vars.args = arg_8_1
end

function CoopReady.getDefaultDialogOpts(arg_9_0)
	return {
		title = T("expedition_enterfail_title"),
		handler = function()
			CoopMission:onPushBackButton()
		end
	}
end

function CoopReady.responseExpedition(arg_11_0, arg_11_1)
	if arg_11_0.vars then
		arg_11_0.vars.last_response_tm = os.time()
	end
	
	if arg_11_1.user_info and get_cocos_refid(arg_11_0.vars.wnd) then
		arg_11_0:dataSetting(arg_11_1.user_info)
		arg_11_0.vars.listView:setDataSource(arg_11_0.vars.list_data)
	end
	
	if arg_11_1.expedition_info and get_cocos_refid(arg_11_0.vars.wnd) then
		arg_11_0:updateHp(arg_11_1.expedition_info)
		
		local var_11_0 = arg_11_1.expedition_info
		local var_11_1 = arg_11_0:getBossInfo()
		
		for iter_11_0, iter_11_1 in pairs(var_11_0) do
			if var_11_1[iter_11_0] then
				var_11_1[iter_11_0] = iter_11_1
			end
		end
		
		arg_11_0.vars.update_user_count = var_11_1.user_count
		
		arg_11_0:updateRankUI(arg_11_0.vars.args)
		
		local var_11_2 = CoopUtil:getLevelData(var_11_1)
		local var_11_3 = to_n(var_11_1.user_id)
		local var_11_4 = to_n(Account:getUserId())
		
		if arg_11_0.vars.update_user_count >= var_11_2.party_max and arg_11_0.vars.my_rank == nil and var_11_3 ~= var_11_4 then
			if arg_11_0:getExitReason() ~= nil then
				return 
			end
			
			Dialog:msgBox(T("expedition_enterfail_desc_partymax"), arg_11_0:getDefaultDialogOpts())
			arg_11_0:setExitReason("party_max")
		end
	end
end

function CoopReady.requestExpedition(arg_12_0)
	local var_12_0 = arg_12_0:getBossInfo()
	
	query("coop_battle_sync", {
		boss_id = var_12_0.boss_id
	})
end

function CoopReady.checkRequestTime(arg_13_0, arg_13_1, arg_13_2)
	arg_13_2 = arg_13_2 or arg_13_0.vars.last_response_tm
	
	if arg_13_0.vars.last_response_tm then
		if arg_13_0.vars.prv_last_request_sync <= arg_13_0.vars.last_response_tm and arg_13_1 - arg_13_2 >= 10 and not arg_13_0.vars.expire_room then
			arg_13_0.vars.prv_last_request_sync = arg_13_1
			
			arg_13_0:requestExpedition()
		end
	elseif not arg_13_0.vars.prv_last_request_sync and not arg_13_0.vars.expire_room then
		arg_13_0.vars.prv_last_request_sync = arg_13_1
		
		arg_13_0:requestExpedition()
	end
end

function CoopReady.onUpdate(arg_14_0)
	if not arg_14_0.vars or arg_14_0.vars.expire_room or not get_cocos_refid(arg_14_0.vars.wnd) then
		return 
	end
	
	local var_14_0 = os.time()
	
	arg_14_0:updateTime(arg_14_0.vars.args)
	
	if arg_14_0.vars.prv_last_request_sync == "test" then
		return 
	end
	
	arg_14_0:checkRequestTime(var_14_0)
	arg_14_0:checkRemoveEff()
end

function CoopReady.hideInOut(arg_15_0, arg_15_1)
	local var_15_0 = 1000
	local var_15_1 = "hide_event"
	local var_15_2 = arg_15_1 and 1 or 1.74
	local var_15_3 = arg_15_1 and 640 or 360
	local var_15_4 = arg_15_1 and 312 or 362
	local var_15_5 = arg_15_1 and SEQ(SHOW(true), LOG(FADE_IN(var_15_0))) or SEQ(LOG(FADE_OUT(var_15_0)), SHOW(false))
	local var_15_6 = arg_15_0.vars.wnd:findChildByName("LEFT")
	local var_15_7
	
	for iter_15_0, iter_15_1 in pairs(arg_15_0.vars.wnd:getChildren()) do
		if iter_15_1:getName() == "RIGHT" then
			var_15_7 = iter_15_1
		end
	end
	
	if not var_15_7 then
		return 
	end
	
	local var_15_8 = arg_15_0.vars.wnd:findChildByName("_grow")
	
	UIAction:Add(SPAWN(LOG(SCALE_TO(1000, var_15_2)), LOG(MOVE_TO(1000, var_15_3, var_15_4))), arg_15_0.vars.wnd:findChildByName("n_bg"), var_15_1)
	UIAction:Add(var_15_5, var_15_6, var_15_1)
	UIAction:Add(var_15_5, var_15_7, var_15_1)
	UIAction:Add(var_15_5, var_15_8, var_15_1)
	TopBarNew:fadeInOut(arg_15_1, 1000)
end

function CoopReady.onTickUpdate(arg_16_0)
	if not arg_16_0.vars or arg_16_0.vars.expire_room or not get_cocos_refid(arg_16_0.vars.wnd) then
		return 
	end
	
	local var_16_0 = SceneManager:getRunningScene()
	
	if not var_16_0 or not var_16_0.getTouchEventTime then
		return 
	end
	
	local var_16_1 = var_16_0:getTouchEventTime() or arg_16_0.vars.open_tm
	local var_16_2 = os.time()
	local var_16_3 = 30
	
	if UnitMain:isVisible() then
		arg_16_0.vars.last_response_tm = var_16_2
		
		if not arg_16_0.vars.obscured then
			arg_16_0.vars.obscured_request_tm = arg_16_0.vars.prv_last_request_sync
			arg_16_0.vars.obscured = true
		end
		
		return 
	elseif arg_16_0.vars.obscured then
		arg_16_0:checkRequestTime(var_16_2, arg_16_0.vars.obscured_request_tm)
		
		arg_16_0.vars.obscured_request_tm = nil
		arg_16_0.vars.obscured = false
		
		return 
	end
	
	if var_16_3 < var_16_2 - var_16_1 then
		arg_16_0.vars.last_response_tm = var_16_2
		
		if not arg_16_0.vars.fade_out then
			UIAction:Remove("hide_event")
			UIAction:Remove("TopBarNew.Fade")
			
			if not arg_16_0.vars.battle_ready and not TutorialGuide:isPlayingTutorial() and not BattleReady:isValid() then
				arg_16_0:hideInOut(false)
			end
			
			arg_16_0.vars.fade_out_request_tm = arg_16_0.vars.prv_last_request_sync
			arg_16_0.vars.fade_out = true
		end
	elseif var_16_3 > var_16_2 - var_16_1 and arg_16_0.vars.fade_out then
		UIAction:Remove("hide_event")
		UIAction:Remove("TopBarNew.Fade")
		
		if not arg_16_0.vars.battle_ready and not TutorialGuide:isPlayingTutorial() and not BattleReady:isValid() then
			arg_16_0:hideInOut(true)
		end
		
		arg_16_0:checkRequestTime(var_16_2, arg_16_0.vars.fade_out_request_tm)
		
		arg_16_0.vars.fade_out_tm = nil
		arg_16_0.vars.fade_out = false
	end
end

function CoopReady.onTouchDown(arg_17_0, arg_17_1, arg_17_2)
end

function CoopReady.show(arg_18_0, arg_18_1)
	local var_18_0 = load_dlg("expedition_ready", true, "wnd")
	
	arg_18_0.vars.wnd = var_18_0
	arg_18_0.vars.parent = arg_18_1
	arg_18_0.vars.fade_out = false
	arg_18_0.vars.obscured = false
	arg_18_0.vars.open_tm = os.time()
	
	arg_18_0:uiSetting(arg_18_0.vars.args)
	arg_18_0:bgSetting(arg_18_0.vars.args)
	arg_18_0:playMusic()
	arg_18_1:addChild(var_18_0)
end

function CoopReady.isFreeEnterPoint(arg_19_0)
	return arg_19_0:isMyRoom() and arg_19_0:getPlayCount() == 0
end

function CoopReady.displayDiscountPopup(arg_20_0)
	local var_20_0 = arg_20_0.vars.wnd:findChildByName("RIGHT"):findChildByName("n_recommend")
	local var_20_1 = false
	local var_20_2 = arg_20_0:getPlayCount()
	local var_20_3 = arg_20_0:isMyRoom()
	
	if arg_20_0:isFreeEnterPoint() then
		if_set(var_20_0, "disc", T("expedition_enter_free"))
		
		var_20_1 = true
	elseif not var_20_3 and var_20_2 > 0 and var_20_2 < 3 or var_20_3 and var_20_2 > 1 and var_20_2 < 3 then
		if_set(var_20_0, "disc", T("expedition_enter_sale"))
		
		var_20_1 = true
	end
	
	if_set_visible(var_20_0, nil, var_20_1)
end

function CoopReady.getReplaceEnterPoint(arg_21_0)
	local var_21_0 = "stamina"
	
	if arg_21_0:isMyRoom() then
		var_21_0 = var_21_0 .. "_host_lv"
	else
		var_21_0 = var_21_0 .. "_guest_lv"
	end
	
	local var_21_1 = arg_21_0:getBossInfo()
	local var_21_2 = var_21_0 .. var_21_1.difficulty
	local var_21_3 = DB("expedition_config", var_21_2, "client_value")
	local var_21_4 = string.split(var_21_3, ",") or {}
	local var_21_5 = arg_21_0:getPlayCount()
	
	if var_21_4[var_21_5 + 1] then
		return to_n(var_21_4[var_21_5 + 1])
	end
	
	local var_21_6 = CoopUtil:getLevelData(var_21_1)
	
	return (DB("level_enter", var_21_6.level_enter, "use_enterpoint"))
end

function CoopReady.onResponse(arg_22_0, arg_22_1)
	arg_22_0.vars.rtn = arg_22_1
	arg_22_0.vars.prv_last_request_sync = nil
	
	arg_22_0:dataSetting(arg_22_1.coop_members)
	arg_22_0:listSetting(arg_22_0.vars.rtn)
	Scheduler:addSlow(arg_22_0.vars.wnd, arg_22_0.onUpdate, arg_22_0)
	Scheduler:add(arg_22_0.vars.wnd, arg_22_0.onTickUpdate, arg_22_0)
	arg_22_0:setButtonEnterInfo()
	arg_22_0:showLimitInfo(true)
	arg_22_0:updateRankUI(arg_22_0.vars.args)
	arg_22_0:displayDiscountPopup()
	TutorialGuide:onEnterCoopReady()
	arg_22_0:updateOpenUI()
end

function CoopReady.getStartArgs(arg_23_0)
	return arg_23_0.vars.args
end

function CoopReady.updateCachedCoopSharedList(arg_24_0, arg_24_1, arg_24_2)
	arg_24_0.vars.cached_coop_shared_list[arg_24_2].list = arg_24_1
end

function CoopReady.cachingCoopSharedList(arg_25_0, arg_25_1, arg_25_2)
	if not arg_25_0.vars.cached_coop_shared_list then
		arg_25_0.vars.cached_coop_shared_list = {}
	end
	
	arg_25_0.vars.cached_coop_shared_list[arg_25_2] = arg_25_1
end

function CoopReady.getCacheCoopSharedList(arg_26_0)
	return arg_26_0.vars.cached_coop_shared_list
end

function CoopReady.enterFormation(arg_27_0)
	UnitMain:beginCoopMode(arg_27_0.vars.parent, arg_27_0.vars.wnd, function()
		arg_27_0.vars.bg:removeAllUnit()
		arg_27_0:teamSetting()
	end)
end

function CoopReady.updateUserInfo(arg_29_0, arg_29_1)
	arg_29_0.vars.update_my_count = arg_29_1.count
	arg_29_0.vars.update_my_score = arg_29_1.total_score
	
	for iter_29_0, iter_29_1 in pairs(arg_29_1) do
		if arg_29_0.vars.args[iter_29_0] then
			arg_29_0.vars.args[iter_29_0] = iter_29_1
		end
	end
end

function CoopReady.dataSetting(arg_30_0, arg_30_1)
	arg_30_0.vars.list_data = CoopUtil:makeCoopMemberArray(arg_30_1)
	
	if table.count(arg_30_0.vars.list_data) == 0 then
		local var_30_0 = CoopUtil:findUserData(arg_30_1, Account:getUserId())
		
		if var_30_0 then
			arg_30_0:updateUserInfo(var_30_0)
		end
		
		return 
	end
	
	arg_30_0.vars.list_data = CoopUtil:getRankList(arg_30_0.vars.list_data)
	arg_30_0.vars.my_rank = nil
	
	for iter_30_0, iter_30_1 in pairs(arg_30_0.vars.list_data) do
		if iter_30_1.uid == Account:getUserId() then
			arg_30_0.vars.my_rank = iter_30_0
			
			arg_30_0:updateUserInfo(iter_30_1)
			
			break
		end
	end
end

function CoopReady.procCheckEnter(arg_31_0, arg_31_1)
	if not UIUtil:checkUnitInven() then
		return 
	end
	
	if not UIUtil:checkTotalInven() then
		return 
	end
	
	local var_31_0 = arg_31_0:getBossInfo()
	
	if not var_31_0 then
		return 
	end
	
	if Account:getTeamMemberCount(CoopUtil:getTeamIdx(var_31_0.boss_code), true) < 1 then
		balloon_message_with_sound("hero_cant_getin")
		
		return 
	end
	
	local var_31_1 = CoopUtil:getConfigDBValue("expedition_enter_limit")
	local var_31_2 = arg_31_0:getPlayCount()
	
	if not DEBUG.DEBUG_NO_ENTER_LIMIT and var_31_1 <= var_31_2 then
		balloon_message_with_sound("expedition_limit_pop_cant")
		
		return 
	end
	
	if var_31_0.last_hp ~= nil and var_31_0.last_hp <= 0 then
		if arg_31_0:getExitReason() ~= nil then
			return 
		end
		
		Dialog:msgBox(T("expedition_result_win_desc"), arg_31_0:getDefaultDialogOpts())
		arg_31_0:setExitReason("boss_dead")
		
		return 
	end
	
	local var_31_3 = DB("level_enter", arg_31_1.level_enter, "type_enterpoint")
	local var_31_4 = arg_31_0:getReplaceEnterPoint()
	
	if DEBUG.DEBUG_NO_ENTER_LIMIT then
		var_31_4 = 0
	end
	
	if arg_31_0:isFreeEnterPoint() then
		var_31_4 = 0
	end
	
	local var_31_5 = false
	
	if to_n(var_31_4) > 0 then
		local var_31_6 = DB("item_token", var_31_3, "type")
		
		if var_31_4 > Account:getCurrency(var_31_6) then
			var_31_5 = true
		end
	end
	
	if var_31_5 then
		UIUtil:wannaBuyStamina("battle.ready")
		
		return 
	end
	
	return true
end

function CoopReady.getExitReason(arg_32_0)
	if not arg_32_0.vars then
		return 
	end
	
	return arg_32_0.vars.expire_reason
end

function CoopReady.setExitReason(arg_33_0, arg_33_1)
	if not arg_33_0.vars then
		return 
	end
	
	arg_33_0.vars.expire_room = true
	arg_33_0.vars.expire_reason = arg_33_1
end

function CoopReady.setButtonEnterInfo(arg_34_0)
	local var_34_0 = CoopUtil:getLevelData(arg_34_0:getBossInfo())
	local var_34_1 = arg_34_0.vars.wnd:findChildByName("btn_go")
	
	if not var_34_0 then
		Log.e("!NO LEVEL DATA!")
		
		return 
	end
	
	local var_34_2 = DB("level_enter", var_34_0.level_enter, "type_enterpoint")
	local var_34_3 = arg_34_0:getReplaceEnterPoint()
	local var_34_4, var_34_5 = DB("item_token", var_34_2, {
		"type",
		"icon"
	})
	
	if not var_34_4 or not var_34_5 then
		return 
	end
	
	local var_34_6 = Account:getCurrency(var_34_2)
	
	SpriteCache:resetSprite(var_34_1:getChildByName("icon_res"), "item/" .. var_34_5 .. ".png")
	if_set(var_34_1, "cost", var_34_3 .. "/" .. var_34_6)
end

function CoopReady.showLimitInfo(arg_35_0, arg_35_1)
	if not get_cocos_refid(arg_35_0.vars.wnd) then
		return 
	end
	
	local var_35_0 = arg_35_0.vars.wnd:findChildByName("talk_bg")
	
	if not var_35_0 then
		return 
	end
	
	if arg_35_1 then
		local var_35_1 = arg_35_0:getUserInfo()
		local var_35_2 = var_35_1 and var_35_1.count or 0
		local var_35_3 = CoopUtil:getConfigDBValue("expedition_enter_limit")
		local var_35_4 = var_35_2 == var_35_3 and "expedition_limit_pop_cant" or "expedition_limit_pop"
		
		if_set(var_35_0, "txt_limit", T(var_35_4, {
			count = var_35_3 - var_35_2
		}))
		if_set(var_35_0, "txt_count", var_35_3 - var_35_2 .. "/" .. var_35_3)
		var_35_0:setVisible(true)
		var_35_0:setScale(0)
		UIAction:Add(SEQ(LOG(SCALE(80, 0, 1))), var_35_0)
	elseif var_35_0:isVisible() then
		UIAction:Add(SEQ(RLOG(SCALE(80, 1, 0)), SHOW(false)), var_35_0)
	end
end

function CoopReady.updateTime(arg_36_0, arg_36_1)
	if not arg_36_0.vars or arg_36_0.vars.expire_room or not get_cocos_refid(arg_36_0.vars.wnd) then
		return 
	end
	
	local var_36_0 = to_n(CoopUtil:getConfigDBValue("expedition_tm_bonus"))
	local var_36_1 = os.time()
	local var_36_2 = arg_36_1.boss_info or arg_36_1
	local var_36_3 = var_36_2.start_tm
	local var_36_4 = var_36_2.expire_tm
	local var_36_5 = arg_36_0.vars.wnd:findChildByName("n_time")
	local var_36_6 = var_36_5:findChildByName("time_save_bonus")
	
	if_set(var_36_5, "t_time_left", CoopUtil:getTextLeftTime(var_36_4, var_36_1, "expedition_hour_min"))
	
	local var_36_7 = var_36_0 > var_36_1 - var_36_3 and var_36_1 - var_36_3 > 0
	
	if not CoopUtil:isUsableBonusTime() then
		var_36_7 = false
	end
	
	if_set_visible(var_36_6, nil, var_36_7)
	
	if var_36_7 then
		local var_36_8 = var_36_6:findChildByName("disc")
		
		if_set(var_36_8, nil, CoopUtil:getTextLeftTime(var_36_3 + var_36_0, var_36_1, "expedition_left_bonus"))
		
		local var_36_9 = var_36_6:findChildByName("icon_time")
		
		UIUserData:call(var_36_9, "RELATIVE_Y_POS(../disc, -0.5, -5)")
	end
	
	if var_36_4 <= var_36_1 then
		if arg_36_0:getExitReason() ~= nil then
			return 
		end
		
		Dialog:msgBox(T("expedition_enterfail_desc_timeover"), {
			title = T("expedition_enterfail_title"),
			handler = function()
				if arg_36_0.vars and arg_36_0.vars.prv_last_request_sync == "test" then
					arg_36_0:release()
				else
					CoopMission:onPushBackButton()
				end
			end
		})
		arg_36_0:setExitReason("expire_tm")
		
		return 
	end
end

function CoopReady.updateHp(arg_38_0, arg_38_1)
	if not arg_38_0.vars or arg_38_0.vars.expire_room or not get_cocos_refid(arg_38_0.vars.wnd) then
		return 
	end
	
	local var_38_0 = arg_38_0.vars.wnd:findChildByName("n_gauge")
	local var_38_1 = var_38_0:findChildByName("hp_red")
	local var_38_2 = var_38_0:findChildByName("hp")
	
	if arg_38_1.last_hp <= 0 then
		Dialog:msgBox(T("expedition_enterfail_desc_bosskill"), {
			title = T("expedition_enterfail_title"),
			handler = function()
				if arg_38_0.vars.prv_last_request_sync == "test" then
					arg_38_0:release()
				else
					CoopMission:onPushBackButton()
				end
			end
		})
		arg_38_0:setExitReason("boss_dead")
		
		return 
	end
	
	local var_38_3 = CoopUtil:getBossHpRate(arg_38_1.max_hp, arg_38_1.last_hp)
	
	var_38_2:setScaleX(var_38_3)
	
	if arg_38_0.vars.hp_rate and arg_38_0.vars.hp_rate ~= var_38_3 then
		UIAction:Add(SEQ(LOG(SCALE_TO_X(1000, var_38_3))), var_38_1, "block")
	else
		var_38_1:setScaleX(var_38_3)
	end
	
	arg_38_0.vars.hp_rate = var_38_3
end

function CoopReady.updateBtnAll(arg_40_0, arg_40_1)
	arg_40_1 = arg_40_1 or arg_40_0.vars.wnd:findChildByName("LEFT")
	
	local var_40_0 = cc.c3b(255, 255, 255)
	local var_40_1 = arg_40_0:getBossInfo().boss_id
	
	if CoopUtil:isExistsInviteAllList(var_40_1) then
		var_40_0 = cc.c3b(76, 76, 76)
	end
	
	if_set_color(arg_40_1, "btn_all", var_40_0)
end

function CoopReady.updateUserCount(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	local var_41_0 = arg_41_2.boss_info or arg_41_2
	local var_41_1 = CoopUtil:getLevelData(var_41_0)
	
	if_set(arg_41_1, "txt_count", tostring(arg_41_3) .. "/" .. var_41_1.party_max)
end

function CoopReady.updateRankUI(arg_42_0, arg_42_1, arg_42_2)
	arg_42_2 = arg_42_2 or arg_42_0.vars.wnd:findChildByName("LEFT")
	
	local var_42_0 = table.count(arg_42_0.vars.list_data or {}) == 0
	local var_42_1 = arg_42_2:findChildByName("n_rank")
	
	if_set_visible(var_42_1, "n_no_data", var_42_0)
	if_set_visible(var_42_1, "ScrollView", not var_42_0)
	
	local var_42_2 = arg_42_0.vars.update_my_count or arg_42_1.count
	local var_42_3 = var_42_1:findChildByName("n_my")
	
	CoopUtil:setRankText(var_42_3, arg_42_0.vars.my_rank, var_42_2, arg_42_0.vars.update_my_score or arg_42_1.total_score)
	
	local var_42_4 = arg_42_1.boss_info or arg_42_1
	
	arg_42_0:updateUserCount(arg_42_2, arg_42_1, arg_42_0.vars.update_user_count or var_42_4.user_count)
end

function CoopReady.uiSetting(arg_43_0, arg_43_1)
	if not arg_43_1 then
		return 
	end
	
	local var_43_0 = arg_43_1.boss_info or arg_43_1
	local var_43_1 = arg_43_0.vars.wnd:findChildByName("LEFT")
	
	if not var_43_1 then
		return 
	end
	
	local var_43_2 = CoopUtil:getLevelData(var_43_0)
	
	if not var_43_2 or not var_43_2.level_enter then
		Log.e(" NO LEVEL DATA!  ")
		
		return 
	end
	
	local var_43_3 = CoopUtil:getBossLevelFromLevelData(var_43_2)
	
	UIUtil:getRewardIcon(nil, var_43_2.character_id, {
		hide_lv = true,
		hide_star = true,
		tier = "boss",
		show_color_right = true,
		no_grade = true,
		parent = var_43_1:findChildByName("mob_icon"),
		lv = var_43_3
	})
	
	local var_43_4 = DB("character", var_43_2.character_id, "name")
	local var_43_5 = var_43_1:findChildByName("n_boss")
	
	if_set(var_43_5, "t_name", T(var_43_4))
	CoopUtil:setDifficulty(var_43_1:findChildByName("n_difficulty"), tonumber(var_43_0.difficulty))
	arg_43_0:updateRankUI(arg_43_1, var_43_1)
	arg_43_0:updateHp(var_43_0)
	arg_43_0:updateTime(arg_43_1)
	
	local var_43_6 = arg_43_0.vars.wnd:findChildByName("LEFT")
	
	if_set_visible(var_43_6, "btn_sharing", arg_43_0:isMyRoom())
	if_set_visible(var_43_6, "btn_all", arg_43_0:isMyRoom())
	arg_43_0:updateBtnAll(var_43_6)
	
	local var_43_7 = string.format("%s_%d", var_43_0.boss_code, var_43_0.difficulty)
	local var_43_8 = CoopUtil:getRewardPreviewItem(var_43_7, "camp") or CoopUtil:getRewardPreviewItem(var_43_0.boss_code, "camp")
	
	if not var_43_8 then
		return 
	end
	
	local var_43_9 = var_43_6:findChildByName("n_reward_info")
	
	for iter_43_0 = 1, 4 do
		local var_43_10 = "n_reward_item" .. iter_43_0
		local var_43_11 = var_43_8[iter_43_0]
		local var_43_12 = var_43_9:findChildByName(var_43_10)
		
		if get_cocos_refid(var_43_12) and var_43_11 then
			var_43_12:setVisible(true)
			UIUtil:getRewardIcon(nil, var_43_11.item_id, {
				parent = var_43_12
			})
		end
	end
	
	local var_43_13 = table.count(var_43_8)
	local var_43_14 = var_43_9:findChildByName("n_info")
	
	if get_cocos_refid(var_43_14) and var_43_13 > 2 then
		var_43_14:setPositionX(var_43_14:getPositionX() + 71 * (var_43_13 - 2))
	end
	
	arg_43_0:updateOpenUI()
end

function CoopReady.updateOpenUI(arg_44_0)
	if get_cocos_refid(arg_44_0.vars.btn_open_eff) then
		arg_44_0.vars.btn_open_eff:removeFromParent()
		
		arg_44_0.vars.btn_open_eff = nil
	end
	
	local var_44_0 = arg_44_0:getBossInfo()
	local var_44_1 = CoopUtil:getLevelData(var_44_0)
	local var_44_2 = CoopUtil:isUnlockOpenDifficulty(var_44_1.id)
	local var_44_3 = arg_44_0:isOpenRoom()
	local var_44_4 = arg_44_0:isMyRoom()
	local var_44_5 = arg_44_0.vars.wnd:getChildByName("btn_public")
	local var_44_6 = arg_44_0.vars.wnd:getChildByName("icon_etclock")
	local var_44_7 = true
	
	if not var_44_4 then
		var_44_5:setVisible(false)
		var_44_6:setVisible(false)
	else
		local var_44_8 = 255
		local var_44_9 = arg_44_0:isTimeOut()
		
		if var_44_3 or var_44_4 and arg_44_0:getPlayCount() == 0 or not var_44_2 or var_44_9 then
			var_44_8 = 76.5
			var_44_7 = false
		end
		
		var_44_6:setVisible(not var_44_2)
		var_44_5:setVisible(true)
		var_44_5:setOpacity(var_44_8)
		
		if var_44_7 and not arg_44_0.vars.btn_open_eff then
			arg_44_0.vars.btn_open_eff = EffectManager:Play({
				pivot_y = 0,
				pivot_x = 0,
				fn = "expedition_open_party_botton.cfx",
				layer = var_44_5
			})
			
			arg_44_0.vars.btn_open_eff:setPosition(100, 36)
		end
	end
	
	local var_44_10 = arg_44_0:getJoinType()
	local var_44_11 = arg_44_0.vars.wnd:getChildByName("n_bonus")
	local var_44_12
	
	if var_44_4 then
		var_44_12 = not var_44_3
	elseif var_44_10 and var_44_10 == 0 then
		var_44_12 = true
	elseif not var_44_3 then
		var_44_12 = true
	end
	
	local var_44_13 = CoopMission:getCurrentTab()
	
	if not var_44_4 and var_44_13 and var_44_13 == "share" then
		var_44_12 = true
	end
	
	local var_44_14 = arg_44_0.vars.wnd:findChildByName("LEFT"):getChildByName("n_difficulty")
	local var_44_15 = var_44_14:getChildByName("txt_level")
	
	if get_cocos_refid(var_44_15) then
		local var_44_16 = var_44_15:getContentSize()
		
		var_44_11:setPositionX(var_44_14:getPositionX() + var_44_16.width * var_44_15:getScaleX() + 10 + 40)
	end
	
	if_set_visible(var_44_11, nil, var_44_12)
end

function CoopReady.checkRemoveEff(arg_45_0)
	if not arg_45_0.vars or not get_cocos_refid(arg_45_0.vars.wnd) then
		return 
	end
	
	local var_45_0 = arg_45_0:isMyRoom()
	local var_45_1 = arg_45_0:isOpenRoom()
	
	if not var_45_0 or var_45_1 or not get_cocos_refid(arg_45_0.vars.btn_open_eff) then
		return 
	end
	
	if arg_45_0:isTimeOut() then
		if get_cocos_refid(arg_45_0.vars.btn_open_eff) then
			arg_45_0.vars.btn_open_eff:removeFromParent()
			
			arg_45_0.vars.btn_open_eff = nil
		end
		
		local var_45_2 = arg_45_0.vars.wnd:getChildByName("btn_public")
		
		if get_cocos_refid(var_45_2) then
			var_45_2:setOpacity(76.5)
		end
	end
end

function CoopReady.isTimeOut(arg_46_0)
	local var_46_0 = arg_46_0:getBossInfo()
	
	if not var_46_0 then
		return 
	end
	
	local var_46_1 = var_46_0.start_tm
	local var_46_2 = var_46_0.expire_tm
	
	return math.floor((var_46_2 - os.time()) / 60) < 10
end

function CoopReady.req_open_room(arg_47_0)
	local var_47_0 = arg_47_0:getBossInfo()
	local var_47_1 = CoopUtil:getLevelData(var_47_0)
	local var_47_2 = CoopUtil:isUnlockOpenDifficulty(var_47_1.id)
	local var_47_3 = arg_47_0:isOpenRoom()
	local var_47_4 = arg_47_0:isMyRoom()
	local var_47_5 = arg_47_0:isTimeOut()
	local var_47_6
	
	if var_47_3 then
		var_47_6 = "expedition_open_condition_complete"
	elseif not var_47_2 then
		if not UnlockSystem:isUnlockSystemAndMsg({
			exclude_story = true,
			id = CoopUtil:getUnlockOpenId(var_47_1.id)
		}, function()
		end) then
			return 
		end
		
		return 
	elseif var_47_5 then
		var_47_6 = "expedition_open_condition_time_up"
	elseif var_47_4 and arg_47_0:getPlayCount() == 0 then
		var_47_6 = "expedition_open_condition_battle"
	elseif not var_47_4 then
		return 
	end
	
	if var_47_6 then
		balloon_message_with_sound(var_47_6)
		
		return 
	end
	
	arg_47_0.vars.open_msg_box = Dialog:msgBox(T("expedition_open_pop_desc"), {
		yesno = true,
		title = T("expedition_open_pop_title"),
		warning = T("expedition_open_pop_desc2"),
		ok_text = T("ui_msgbox_ok"),
		handler = function()
			if arg_47_0:isTimeOut() then
				Dialog:msgBox(T("expedition_open_condition_time_up2"), {
					title = T("expedition_open_pop_title")
				})
			else
				query("coop_set_boss_open", {
					boss_id = var_47_0.boss_id
				})
			end
		end
	})
end

function CoopReady.res_open_room(arg_50_0, arg_50_1)
	if not arg_50_1 or not arg_50_1.room_info then
		return 
	end
	
	local var_50_0 = arg_50_1.room_info
	local var_50_1 = var_50_0.boss_id
	
	arg_50_0:setBossInfo(var_50_0)
	
	local var_50_2 = arg_50_0:getBossInfo()
	
	if var_50_1 then
		local var_50_3 = (Account:getCoopMissionData() or {}).my_lists[tostring(var_50_1)]
		
		if var_50_3 and var_50_3.boss_info then
			local var_50_4
			
			if var_50_3.boss_info.boss_user_info then
				var_50_0.boss_user_info = var_50_3.boss_info.boss_user_info
			end
			
			var_50_3.boss_info = var_50_0
		end
	end
	
	arg_50_0:updateOpenUI()
end

function CoopReady.getJoinType(arg_51_0)
	if not arg_51_0.vars or not arg_51_0.vars.args then
		return 
	end
	
	return arg_51_0.vars.args.join_type
end

function CoopReady.isOpenRoom(arg_52_0)
	local var_52_0 = arg_52_0:getBossInfo()
	
	if not var_52_0 then
		return 
	end
	
	return var_52_0.open_tm
end

function CoopReady.isMyRoom(arg_53_0)
	local var_53_0 = arg_53_0:getBossInfo()
	
	if not var_53_0 then
		return 
	end
	
	return var_53_0.user_id == Account:getUserId()
end

function CoopReady.teamSetting(arg_54_0)
	local var_54_0 = arg_54_0:getBossInfo().boss_code
	local var_54_1 = Account:getTeam(CoopUtil:getTeamIdx(var_54_0))
	
	for iter_54_0 = 1, 4 do
		local var_54_2 = var_54_1[iter_54_0]
		
		arg_54_0.vars.bg:addUnit(iter_54_0, var_54_2)
	end
	
	arg_54_0.vars.last_team = var_54_1
end

function CoopReady.bgSetting(arg_55_0, arg_55_1)
	arg_55_0.vars.bg = CoopReadyBG(arg_55_0.vars.wnd:findChildByName("n_bg"), "camping2")
	
	arg_55_0:teamSetting()
end

function CoopReady.listSetting(arg_56_0, arg_56_1)
	arg_56_0.vars.listView = CoopUtil:makeRankingListView(arg_56_0.vars.wnd:findChildByName("ScrollView"), arg_56_0.vars.list_data)
end

function CoopReady.isValid(arg_57_0)
	return get_cocos_refid(arg_57_0.vars.wnd)
end

function CoopReady.playMusic(arg_58_0)
	if arg_58_0.vars.snd then
		return 
	end
	
	arg_58_0.vars.snd = SoundEngine:play("event:/effect/expedition_bonfire")
end

function CoopReady.stopMusic(arg_59_0)
	if get_cocos_refid(arg_59_0.vars.snd) then
		arg_59_0.vars.snd:stop()
		
		arg_59_0.vars.snd = nil
	end
end

function CoopReady.destroy(arg_60_0)
	if not arg_60_0.vars then
		return 
	end
	
	UIAction:Remove("hide_event")
	UIAction:Remove("TopBarNew.Fade")
	TopBarNew:restoreTopBar()
	
	if get_cocos_refid(arg_60_0.vars.open_msg_box) then
		arg_60_0.vars.open_msg_box:removeFromParent()
		
		arg_60_0.vars.open_msg_box = nil
	end
	
	arg_60_0.vars.wnd:removeFromParent()
	arg_60_0:stopMusic()
	
	arg_60_0.vars = nil
end

function CoopReady.openBattleReady(arg_61_0, arg_61_1)
	arg_61_0:stopMusic()
	
	arg_61_0.vars.battle_ready = true
	
	BattleReady:show({
		force_show_enter_point = true,
		enter_id = arg_61_1.level_enter,
		currencies = {
			"crystal",
			"gold",
			"stamina"
		},
		callback = {
			onCloseBattleReadyDialog = function()
				if not arg_61_0.vars then
					return 
				end
				
				arg_61_0.vars.battle_ready = false
				
				arg_61_0.vars.bg:removeAllUnit()
				arg_61_0:playMusic()
				arg_61_0:teamSetting()
			end
		},
		replace_enterpoint = arg_61_0:getReplaceEnterPoint()
	})
end

function CoopReady.getUserList(arg_63_0)
	return arg_63_0.vars.list_data
end

function CoopReady.getPlayCount(arg_64_0)
	local var_64_0 = arg_64_0.vars.update_my_count
	local var_64_1 = arg_64_0:getUserInfo()
	
	if var_64_0 then
		return var_64_0
	end
	
	if not var_64_0 and var_64_1 then
		return var_64_1.count
	end
	
	return 0
end

function CoopReady.getUserInfo(arg_65_0)
	if not arg_65_0.vars.args.boss_info then
		return 
	end
	
	return arg_65_0.vars.args
end

function CoopReady.setBossInfo(arg_66_0, arg_66_1)
	if not arg_66_1 then
		return 
	end
	
	if arg_66_0.vars then
		if arg_66_0.vars.args and arg_66_0.vars.args.boss_info then
			if arg_66_0.vars.args.boss_info.boss_user_info then
				arg_66_1.boss_user_info = arg_66_0.vars.args.boss_info.boss_user_info
			end
			
			arg_66_0.vars.args.boss_info = arg_66_1
		else
			if arg_66_0.vars.args.boss_user_info then
				arg_66_1.boss_user_info = arg_66_0.vars.args.boss_user_info
			end
			
			arg_66_0.vars.args = arg_66_1
		end
	end
end

function CoopReady.getBossInfo(arg_67_0)
	return arg_67_0.vars.args.boss_info or arg_67_0.vars.args
end

function user_add_coop(arg_68_0, arg_68_1)
	query("cheat_user_add_coop", {
		add_user_id = arg_68_0,
		boss_id = arg_68_1
	})
end

function coop_ready_bg_test()
	local var_69_0 = {
		leader_code = "c1050_s01",
		name = "HaruGakkaP",
		total_score = 2331,
		boss_code = "ex_s1_boss_3",
		last_attack_tm = 1591782327,
		reward_tm = 0,
		max_score = 0,
		border_code = "ma_border1",
		count = 3,
		season_no = 1,
		boss_id = 133,
		boss_info = {
			start_tm = 1591777409,
			user_id = 12609751,
			boss_code = "ex_s1_boss_3",
			last_hp = 0,
			boss_id = 133,
			season_no = 1,
			user_count = 1,
			max_hp = 1000000,
			difficulty = 3,
			expire_tm = os.time() + 10,
			boss_user_info = {
				login_tm = 1591837402,
				name = "HaruGakkaP",
				border_code = "ma_border1",
				clan_id = 527,
				id = 12609751,
				leader_code = "c1050_s01",
				friend_count = 0,
				level = 1
			}
		}
	}
	local var_69_1 = CoopReady(var_69_0)
	
	var_69_1:show(SceneManager:getRunningNativeScene())
	
	var_69_1.vars.prv_last_request_sync = "test"
	
	Scheduler:addSlow(var_69_1.vars.wnd, var_69_1.onUpdate, var_69_1)
end
