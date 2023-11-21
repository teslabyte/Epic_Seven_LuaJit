LotaEnterUI = {}

function HANDLER.clan_heritage(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_go" then
		LotaEnterUI:btnGo()
	end
	
	if arg_1_1 == "btn_status" then
		LotaStatusUI:open(SceneManager:getRunningPopupScene(), LotaUtil:getMyUserInfo())
	end
	
	if arg_1_1 == "btn_relices" then
		LotaStatusLegacyUI:open(SceneManager:getRunningPopupScene(), LotaUtil:getMyUserInfo())
	end
	
	if arg_1_1 == "btn_ranking_board" then
		if LotaEnterUI:isExistUserData() then
			LotaNetworkSystem:sendQuery("lota_ranking_board")
		else
			balloon_message_with_sound("msg_clanheritage_rank_error")
		end
	end
	
	if arg_1_1 == "btn_exchange" then
		LotaNetworkSystem:sendQuery("lota_shop")
	end
	
	if arg_1_1 == "btn_member" then
		LotaNetworkSystem:sendQuery("lota_clan_status")
	end
	
	if arg_1_1 == "btn_reward" then
		LotaEnterUI:showPreRewards()
	end
	
	if arg_1_1 == "btn_noti" then
		if LotaEnterUI:isExistUserData() then
			LotaReminderUI:init(SceneManager:getRunningPopupScene())
		else
			balloon_message_with_sound("msg_clanheritage_rank_error")
		end
	end
	
	if arg_1_1 == "btn_video" then
		LotaEnterUI:showVideo()
	end
	
	if arg_1_1 == "btn_low" then
		LotaEnterUI:toggleLowSpec()
	end
	
	if arg_1_1 == "btn_notice" then
		LotaNotiPopupUI:openNoticePopup()
	end
end

function LotaEnterUI.btnGo(arg_2_0)
	local var_2_0, var_2_1 = arg_2_0:isCanEnter()
	
	if not var_2_0 then
		local var_2_2 = ""
		local var_2_3, var_2_4 = LotaUtil:getRequireEnterCondition()
		
		if var_2_1 == "req_more_member" then
			var_2_2 = T("ui_clan_heritage_condition_yet", {
				number = var_2_3
			})
		elseif var_2_1 == "req_more_level" then
			var_2_2 = T("ui_clan_heritage_condition_rank_yet", {
				rank = var_2_4
			})
		elseif var_2_1 == "no_data" or var_2_1 == "not_open" then
			var_2_2 = T("ui_clan_heritage_not_open_period")
		end
		
		balloon_message(var_2_2)
		
		return 
	end
	
	TutorialGuide:procGuide()
	LotaNetworkSystem:sendQuery("lota_lobby")
end

function LotaEnterUI.init(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.vars = {}
	arg_3_0.vars.info = arg_3_2
	arg_3_0.vars.dlg = LotaUtil:getUIDlg("clan_heritage")
	
	arg_3_0.vars.dlg:setLocalZOrder(2)
	
	arg_3_0.vars.parent_layer = arg_3_1
	
	LotaNetworkSystem:refreshRetryCount()
	arg_3_0:setupData(arg_3_0.vars.info)
	arg_3_0:setVideo()
	arg_3_0:setupUI()
	TopBarNew:create(T("ui_clan_heritage_main_title"), arg_3_0.vars.dlg, function()
		LotaEnterUI:onPushBackButton()
	end)
	TopBarNew:setCurrencies({
		"clanheritage",
		"clanheritagecoin"
	})
	TopBarNew:checkhelpbuttonID("heritage")
	TopBarNew:setDisableLobbyAuto()
	arg_3_1:addChild(arg_3_0.vars.dlg)
	
	local var_3_0 = LotaUserData:getCurrentSeasonDB(arg_3_0.vars.current_schedule)
	local var_3_1 = var_3_0 and var_3_0.bgm or "ancinetruins_lobby"
	
	SoundEngine:playBGM("event:/bgm/" .. var_3_1)
	
	local var_3_2, var_3_3 = arg_3_0:isCanEnter()
	
	if var_3_2 then
		TutorialGuide:startGuide("tuto_heritage_open")
	end
	
	Account:setClanLotaEnterDay()
end

function LotaEnterUI.showPreRewards(arg_5_0)
	local var_5_0 = {
		onUpdate = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			local var_6_0 = arg_6_1:getChildByName("reward_item")
			
			UIUtil:getRewardIcon(nil, arg_6_3.reward_id, {
				show_small_count = true,
				no_hero_name = true,
				detail = true,
				parent = var_6_0,
				count = arg_6_3.reward_count,
				set_drop = arg_6_3.set_drop,
				grade_rate = arg_6_3.grade_rate
			})
			
			local var_6_1 = arg_6_1:getChildByName("mob_icon")
			
			UIUtil:getRewardIcon(nil, arg_6_3.mission_target, {
				no_db_grade = true,
				hide_star = true,
				monster = true,
				hide_lv = true,
				scale = 1,
				parent = var_6_1,
				lv = arg_6_3.target_level
			})
			
			local var_6_2 = T(DB("character", arg_6_3.mission_target, "name"))
			
			if_set(arg_6_1, "t_name", var_6_2)
			
			local var_6_3 = LotaEnterUI:isPreRewardReceived(arg_6_3.reward_id)
			
			if_set_visible(arg_6_1, "n_already", var_6_3)
			if_set_visible(arg_6_1, "txt", not var_6_3)
			arg_6_1:setColor(var_6_3 and cc.c3b(76, 76, 76) or cc.c3b(255, 255, 255))
			
			return arg_6_3.id
		end
	}
	
	MazeRaidRewards:show(LotaEnterUI:getPreRewardId(), {
		db_id = "clan_heritage_pre_reward_data",
		item_count = 4,
		col_list = {
			"object_id_",
			"target_id_",
			"target_level_",
			"reward_id_",
			"reward_count_",
			"grade_rate_",
			"set_drop_"
		},
		list_updater = var_5_0
	})
end

function LotaEnterUI.isEditable(arg_7_0)
	if not Clan:isExecutAbleGrade(Clan:getMemberGrade(), "clan_heritage_notice") then
		return false, "clan_heritage_notice"
	end
	
	if not arg_7_0:isUserInfoExist() then
		return false, "need_user_info"
	end
	
	return true
end

function LotaEnterUI.getNoticeOnlyMsgOnClanInfo(arg_8_0)
	if not arg_8_0.vars.lota_clan_info then
		return nil
	end
	
	local var_8_0 = "@^ye%"
	
	return string.split(arg_8_0.vars.lota_clan_info.notice_msg or "", var_8_0)[1]
end

function LotaEnterUI.getNoticeMsg(arg_9_0)
	if not arg_9_0.vars.lota_clan_info or arg_9_0.vars.lota_clan_info.notice_msg == nil or arg_9_0.vars.lota_clan_info.notice_msg == "" then
		return T("ui_clan_heritage_order_default")
	end
	
	return arg_9_0.vars.lota_clan_info.notice_msg
end

function LotaEnterUI.updateNoticeMsg(arg_10_0, arg_10_1)
	arg_10_0.vars.lota_clan_info = arg_10_1.clan_base
	
	arg_10_0:setupUINotice()
end

function LotaEnterUI.isUserInfoExist(arg_11_0)
	return arg_11_0.vars.is_user_info_exist
end

function LotaEnterUI.addLimitData(arg_12_0, arg_12_1)
	if not arg_12_0.vars.limit_data then
		arg_12_0.vars.limit_data = {}
	end
	
	table.insert(arg_12_0.vars.limit_data, arg_12_1)
end

function LotaEnterUI.isPreRewardReceived(arg_13_0, arg_13_1)
	if not arg_13_1 then
		return 
	end
	
	if table.isInclude(arg_13_0.vars.limit_data, arg_13_1) then
		return true
	end
	
	return false
end

function LotaEnterUI.receiveSyncData(arg_14_0, arg_14_1)
	if arg_14_1.battle_data then
		LotaBattleDataSystem:updateReward(arg_14_1.battle_data)
	end
	
	if arg_14_1.box_list then
		LotaBoxSystem:updateBoxList(arg_14_1.box_list)
	end
	
	LotaReminderUI:onResponse()
end

function LotaEnterUI.getPreRewardId(arg_15_0)
	local var_15_0 = LotaUserData:getCurrentSeasonDB(arg_15_0.vars.current_schedule)
	
	if var_15_0 then
		for iter_15_0 = 1, 100 do
			local var_15_1, var_15_2 = DBN("clan_heritage_pre_reward_data", iter_15_0, {
				"id",
				"season_id"
			})
			
			if var_15_0.id == var_15_2 then
				return var_15_1
			end
		end
	end
end

function LotaEnterUI.getCurrentSchedule(arg_16_0)
	return arg_16_0.vars.current_schedule
end

function LotaEnterUI.getShopSchedule(arg_17_0)
	if LotaUtil:isShopEnable(arg_17_0.vars.schedules) then
		return LotaUtil:getLatestScheduleData(arg_17_0.vars.schedules)
	end
end

function LotaEnterUI.isExistUserData(arg_18_0)
	return arg_18_0.vars.is_user_info_exist
end

function LotaEnterUI.getFloorRewardStep(arg_19_0)
	if not arg_19_0.vars.info.lota_user_info then
		return 
	end
	
	return arg_19_0.vars.lota_user_info.floor_reward_step
end

function LotaEnterUI.updateRankerInfo(arg_20_0, arg_20_1)
	arg_20_0.vars.ranker_info = arg_20_1 or {}
	arg_20_0.vars.ranking_last_clear_floor = 0
	
	for iter_20_0 = 1, 4 do
		local var_20_0 = "floor_" .. iter_20_0 .. "_clan"
		
		if arg_20_0.vars.ranker_info[var_20_0] then
			arg_20_0.vars.ranking_last_clear_floor = iter_20_0
		end
	end
end

function LotaEnterUI.setupData(arg_21_0, arg_21_1)
	LotaWhiteboard:init()
	
	local var_21_0 = table.clone(LotaUserDataInfoInterface)
	
	arg_21_0.vars.is_user_info_exist = arg_21_1.lota_user_info ~= nil
	arg_21_0.vars.limit_data = arg_21_1.limit_data or {}
	
	local var_21_1 = arg_21_1.lota_user_info or {}
	
	for iter_21_0, iter_21_1 in pairs(var_21_0) do
		local var_21_2 = var_21_1[iter_21_0]
		
		if var_21_2 then
			var_21_0[iter_21_0] = var_21_2
		end
	end
	
	LotaUserData:init(var_21_0)
	
	arg_21_0.vars.current_schedule = LotaUtil:getCurrentScheduleData(arg_21_1.schedule_info)
	arg_21_0.vars.schedules = arg_21_1.schedule_info
	arg_21_0.vars.lota_user_info = arg_21_1.lota_user_info
	arg_21_0.vars.lota_clan_info = arg_21_1.lota_clan_info
	arg_21_0.vars.lota_member_info = arg_21_1.lota_member_info
	arg_21_0.vars.boss_dead_count = arg_21_1.boss_dead_count
	
	arg_21_0:updateRankerInfo(arg_21_1.ranker_info)
	LotaBattleDataSystem:init()
	LotaBoxSystem:init()
	
	local var_21_3 = arg_21_1.user_battle_data
	
	for iter_21_2, iter_21_3 in pairs(var_21_3 or {}) do
		LotaBattleDataSystem:addReward(iter_21_3)
	end
	
	LotaBoxSystem:updateBoxList(arg_21_1.box_list or {})
end

function LotaEnterUI.getClanFloor(arg_22_0)
	local var_22_0 = 1
	local var_22_1 = arg_22_0.vars.lota_member_info or {}
	
	for iter_22_0, iter_22_1 in pairs(var_22_1) do
		if iter_22_1 > 0 then
			var_22_0 = math.max(to_n(iter_22_0), var_22_0)
		end
	end
	
	return var_22_0
end

function LotaEnterUI.isCanEnter(arg_23_0)
	local var_23_0 = arg_23_0.vars.schedules or {}
	
	return LotaUtil:isAvailableEnter(var_23_0, arg_23_0.vars.lota_clan_info)
end

function LotaEnterUI.injectionPivotFunctions(arg_24_0)
	arg_24_0.vars.pivot._setPosition = arg_24_0.vars.pivot.setPosition
	arg_24_0.vars.pivot._setPositionX = arg_24_0.vars.pivot.setPositionX
	arg_24_0.vars.pivot._setPositionY = arg_24_0.vars.pivot.setPositionY
	arg_24_0.vars.pivot._setScale = arg_24_0.vars.pivot.setScale
	arg_24_0.vars.pivot._setScaleX = arg_24_0.vars.pivot.setScaleX
	arg_24_0.vars.pivot._setScaleY = arg_24_0.vars.pivot.setScaleY
	
	function arg_24_0.vars.pivot.setPosition(arg_25_0, arg_25_1, arg_25_2)
		arg_25_0:_setPosition(arg_25_1, arg_25_2)
		
		if get_cocos_refid(arg_24_0.vars.renderer_parent) then
			arg_24_0.vars.renderer_parent:setPosition(arg_25_1, arg_25_2)
		end
	end
	
	function arg_24_0.vars.pivot.setPositionX(arg_26_0, arg_26_1)
		arg_26_0:_setPositionX(arg_26_1)
		
		if get_cocos_refid(arg_24_0.vars.renderer_parent) then
			arg_24_0.vars.renderer_parent:setPositionX(arg_26_1)
		end
	end
	
	function arg_24_0.vars.pivot.setPositionY(arg_27_0, arg_27_1)
		arg_27_0:_setPositionX(arg_27_1)
		
		if get_cocos_refid(arg_24_0.vars.renderer_parent) then
			arg_24_0.vars.renderer_parent:setPositionX(arg_27_1)
		end
	end
	
	function arg_24_0.vars.pivot.setScale(arg_28_0, arg_28_1)
		arg_28_0:_setScale(arg_28_1)
		LotaCameraSystem:setScaleJustValue(arg_28_1)
		
		if get_cocos_refid(arg_24_0.vars.renderer_parent) then
			arg_24_0.vars.renderer_parent:setScale(arg_28_1)
		end
	end
	
	function arg_24_0.vars.pivot.setScaleX(arg_29_0, arg_29_1)
		arg_29_0:_setScaleX(arg_29_1)
		LotaCameraSystem:setScaleJustValue(arg_29_1)
		
		if get_cocos_refid(arg_24_0.vars.renderer_parent) then
			arg_24_0.vars.renderer_parent:setScaleX(arg_29_1)
		end
	end
	
	function arg_24_0.vars.pivot.setScaleY(arg_30_0, arg_30_1)
		arg_30_0:_setScaleY(arg_30_1)
		LotaCameraSystem:setScaleJustValue(arg_30_1)
		
		if get_cocos_refid(arg_24_0.vars.renderer_parent) then
			arg_24_0.vars.renderer_parent:setScaleY(arg_30_1)
		end
	end
end

function pp_layer_test()
	local var_31_0 = su.SimplePostProcessLayer:create()
	local var_31_1 = cc.GLProgramCache:getInstance():getGLProgram("sprite_grayscale")
	
	if var_31_1 then
		local var_31_2 = cc.GLProgramState:create(var_31_1)
		
		if var_31_2 then
			var_31_2:setUniformVec2("u_resolution", {
				x = VIEW_WIDTH,
				y = VIEW_HEIGHT
			})
			var_31_2:setUniformVec2("u_direction", {
				x = 1,
				y = 0
			})
			var_31_2:setUniformFloat("u_range", 20)
			var_31_2:setUniformFloat("u_sample", 3)
			var_31_2:setUniformFloat("u_ratio", 0.3)
			var_31_0:setPostProcessEnabled(true)
			var_31_0:addProcessGLProgramState(var_31_2, "", 5, 0)
		end
	end
	
	LotaWhiteboard:init()
	LotaWhiteboard:set("ambient_color", cc.c3b(255, 255, 255))
	
	local var_31_3 = cc.Node:create()
	
	LotaTileMapSystem:init(var_31_3, "heritage_shandra01")
	var_31_0:addChild(var_31_3)
	SceneManager:getRunningNativeScene():addChild(var_31_0)
end

function LotaEnterUI.setupRenderer(arg_32_0)
	arg_32_0.vars.parent = cc.Node:create()
	
	local var_32_0 = su.SimplePostProcessLayer:create()
	local var_32_1 = cc.GLProgramCache:getInstance():getGLProgram("pp_color_blend")
	
	if var_32_1 then
		local var_32_2 = cc.GLProgramState:create(var_32_1)
		
		if var_32_2 then
			local var_32_3 = 0.2
			local var_32_4 = cc.mat4.new({
				0.967,
				0.033,
				0,
				0,
				0,
				0.733,
				0.267,
				0,
				0,
				0.183,
				0.817,
				0,
				0,
				0,
				0,
				1
			})
			
			var_32_2:setUniformMat4("u_ColorMatrix", var_32_4)
			var_32_2:setUniformVec4("u_BlendColor", cc.vec4(1, 1, 1, var_32_3 or 0))
			var_32_0:setPostProcessEnabled(true)
			var_32_0:addProcessGLProgramState(var_32_2, "", 5, 0)
		end
	end
	
	arg_32_0.vars.pp_layer = var_32_0
	
	arg_32_0.vars.pp_layer:ignoreAnchorPointForPosition(true)
	
	arg_32_0.vars.renderer_parent = cc.Node:create()
	arg_32_0.vars.tile_map = cc.Node:create()
	arg_32_0.vars.fog_layer = cc.Node:create()
	arg_32_0.vars.object_parent = cc.Node:create()
	arg_32_0.vars.movable_parent = cc.Node:create()
	arg_32_0.vars.effect_parent = cc.Node:create()
	arg_32_0.vars.pivot = cc.Node:create()
	
	local var_32_5 = cc.Node:create()
	
	var_32_5:setPositionX(VIEW_BASE_LEFT)
	var_32_5:addChild(arg_32_0.vars.pp_layer)
	var_32_5:setLocalZOrder(-999)
	arg_32_0.vars.dlg:addChild(var_32_5)
	arg_32_0.vars.renderer_parent:addChild(arg_32_0.vars.tile_map)
	arg_32_0.vars.renderer_parent:addChild(arg_32_0.vars.fog_layer)
	arg_32_0.vars.renderer_parent:addChild(arg_32_0.vars.object_parent)
	arg_32_0.vars.renderer_parent:addChild(arg_32_0.vars.movable_parent)
	arg_32_0.vars.renderer_parent:addChild(arg_32_0.vars.effect_parent)
	arg_32_0.vars.renderer_parent:addChild(arg_32_0.vars.pivot)
	arg_32_0.vars.parent:addChild(arg_32_0.vars.renderer_parent)
	arg_32_0.vars.parent:setLocalZOrder(999)
	arg_32_0.vars.tile_map:setLocalZOrder(995)
	arg_32_0.vars.object_parent:setLocalZOrder(996)
	arg_32_0.vars.movable_parent:setLocalZOrder(997)
	arg_32_0.vars.effect_parent:setLocalZOrder(998)
	arg_32_0:injectionPivotFunctions()
	
	local var_32_6 = "FFFFFF"
	local var_32_7 = "#" .. var_32_6
	
	LotaWhiteboard:set("ambient_color", tocolor(var_32_7))
	LotaTileMapSystem:init(arg_32_0.vars.tile_map, "LUA_TABLE_enter_ui_map")
	LotaObjectSystem:init(arg_32_0.vars.object_parent, "LUA_TABLE_enter_ui_map")
	LotaMovableSystem:init(arg_32_0.vars.movable_parent, true)
	LotaEffectRenderer:init(arg_32_0.vars.effect_parent)
	LotaFogSystem:init(arg_32_0.vars.fog_layer, "heritage_shandra01")
	LotaFogSystem:onlyDiscover(21, 6, 8, LotaFogVisibilityEnum.VISIBLE)
	arg_32_0.vars.fog_layer:setVisible(false)
	LotaCameraSystem:init(arg_32_0.vars.parent, arg_32_0.vars.pp_layer, arg_32_0.vars.pivot)
	LotaCameraSystem:setZOrder(1000)
	
	local var_32_8 = table.clone(LotaEffectDataInterface)
	
	var_32_8.pos = table.clone({
		x = 23,
		y = 6
	})
	
	LotaEffectRenderer:addEffectData(var_32_8)
	
	local var_32_9 = table.clone(LotaObjectInterface)
	local var_32_10 = LotaTileMapSystem:getTileByPos({
		x = 25,
		y = 8
	})
	
	var_32_9.object_id = "camping_1"
	var_32_9.tile_id = tostring(var_32_10:getTileId())
	
	local var_32_11 = Account:getMainUnit()
	
	if not var_32_11 or not var_32_11.db.code then
		return 
	end
	
	local var_32_12 = arg_32_0:addMovable(1, var_32_11.db.code, 25, 2)
	local var_32_13 = LotaMovableSystem:getMovableById(1)
	local var_32_14 = LotaMovableRenderer:getDrawObject(var_32_13)
	local var_32_15, var_32_16 = var_32_14:getPosition()
	
	var_32_14:setPosition(var_32_15 + 120, var_32_16 + 200)
	var_32_14.model:setAnimation(0, "camping", true)
	var_32_14.model.shadow:removeFromParent()
	
	local var_32_17 = LotaUtil:calcTilePosToWorldPos(var_32_12.pos)
	
	var_32_17.y = var_32_17.y
	
	arg_32_0.vars.parent:setPositionX(-2286)
	
	local var_32_18 = 2.6
	
	LotaCameraSystem:setScale(var_32_18, var_32_17)
	arg_32_0.vars.parent:setPositionY(-125)
	arg_32_0:setting1()
	arg_32_0:setting2()
	arg_32_0:setting3()
	
	for iter_32_0, iter_32_1 in pairs(LotaObjectRenderer.vars.object_hash) do
		iter_32_1:setVisible(true)
	end
	
	LotaTileRenderer:createAllTile()
end

function LotaEnterUI.getPartyUnit(arg_33_0, arg_33_1)
	local var_33_3
	
	if not arg_33_0.vars._party_unit_list then
		arg_33_0.vars._party_unit_list = {}
		
		local var_33_0 = {}
		
		for iter_33_0, iter_33_1 in pairs(Account:getUnits()) do
			var_33_0[iter_33_1.db.code] = iter_33_1.db.code
		end
		
		local var_33_1 = {}
		local var_33_2 = Account:getMainUnit().db.code
		
		for iter_33_2, iter_33_3 in pairs(var_33_0) do
			if iter_33_3 ~= var_33_2 then
				table.insert(var_33_1, iter_33_3)
			end
		end
		
		var_33_3 = table.clone(var_33_1)
		
		table.shuffle(var_33_3)
		
		for iter_33_4 = 1, 4 do
			local var_33_4 = var_33_3[iter_33_4]
			
			if not var_33_4 then
				break
			end
			
			arg_33_0.vars._party_unit_list[iter_33_4] = var_33_4
		end
	end
	
	return arg_33_0.vars._party_unit_list[arg_33_1]
end

function LotaEnterUI.setting1(arg_34_0)
	local var_34_0 = arg_34_0:getPartyUnit(2)
	
	if not var_34_0 then
		return 
	end
	
	arg_34_0:addMovable(2, var_34_0, 23, 6)
	
	local var_34_1 = LotaMovableSystem:getMovableById(2)
	
	LotaMovableRenderer:startCampingAnimation(var_34_1)
	
	local var_34_2 = LotaMovableRenderer:getDrawObject(var_34_1)
	local var_34_3 = var_34_2.model
	
	if var_34_3 then
		var_34_3.shadow:removeFromParent()
	end
	
	local var_34_4, var_34_5 = var_34_2:getPosition()
	
	var_34_2:setScaleX(var_34_2:getScaleX() * -1)
	var_34_2:setPosition(var_34_4 + 100, var_34_5)
end

function LotaEnterUI.setting2(arg_35_0)
	local var_35_0 = arg_35_0:getPartyUnit(3)
	
	if not var_35_0 then
		return 
	end
	
	arg_35_0:addMovable(3, var_35_0, 25, 6)
	
	local var_35_1 = LotaMovableSystem:getMovableById(3)
	local var_35_2 = LotaMovableRenderer:getDrawObject(var_35_1)
	local var_35_3 = var_35_2.model
	
	if var_35_3 then
		var_35_3.shadow:removeFromParent()
		var_35_3:setAnimation(0, "camping", true)
	end
	
	local var_35_4, var_35_5 = var_35_2:getPosition()
	
	var_35_2:setScaleX(var_35_2:getScaleX() * -1)
	var_35_2:setPosition(var_35_4 + 50, var_35_5 + 30)
end

function LotaEnterUI.setting3(arg_36_0)
	local var_36_0 = arg_36_0:getPartyUnit(4)
	
	if not var_36_0 then
		return 
	end
	
	arg_36_0:addMovable(4, var_36_0, 26, 5)
	
	local var_36_1 = LotaMovableSystem:getMovableById(4)
	local var_36_2 = LotaMovableRenderer:getDrawObject(var_36_1)
	local var_36_3 = var_36_2.model
	
	if var_36_3 then
		var_36_3.shadow:removeFromParent()
		var_36_3:setAnimation(0, "camping", true)
	end
	
	local var_36_4, var_36_5 = var_36_2:getPosition()
	
	var_36_2:setScaleX(var_36_2:getScaleX())
	var_36_2:setPosition(var_36_4 + 120, var_36_5 + 60)
end

function LotaEnterUI.addMovable(arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	local var_37_0 = table.clone(LotaMovableDataInterface)
	
	var_37_0.id = arg_37_1
	var_37_0.leader_code = arg_37_2
	var_37_0.pos = {
		x = arg_37_3,
		y = arg_37_4
	}
	
	LotaMovableSystem:addMovable(var_37_0)
	
	return var_37_0
end

function LotaEnterUI.updateUI(arg_38_0)
	if not arg_38_0.vars then
		return 
	end
	
	arg_38_0.vars.info = LotaUtil:getMyUserInfo()
	
	arg_38_0:updateExplorePoint()
	arg_38_0:updateSetVisibleNoti()
end

function LotaEnterUI.updateExplorePoint(arg_39_0)
	if not arg_39_0.vars or not get_cocos_refid(arg_39_0.vars.dlg) then
		return 
	end
	
	local var_39_0 = arg_39_0.vars.dlg:findChildByName("n_exploration_level_progress")
	
	LotaUtil:updateUserInfoUI(var_39_0, arg_39_0.vars.info)
	
	local var_39_1 = arg_39_0.vars.info.exp
	local var_39_2 = LotaUtil:getNeedExp(var_39_1)
	local var_39_3 = LotaUtil:getPrvNeedExp(var_39_1)
	local var_39_4 = var_39_0:findChildByName("progress_exploration_level")
	local var_39_5 = var_39_1 - var_39_3
	local var_39_6 = var_39_2 - var_39_3
	
	if_set_percent(var_39_4, "progress_bar", var_39_5 / var_39_6)
	if_set(var_39_4, "t_percent", tostring(math.floor(var_39_5 / var_39_6 * 100)) .. "%")
end

function LotaEnterUI.updateSetVisibleNoti(arg_40_0)
	if not arg_40_0.vars or not get_cocos_refid(arg_40_0.vars.dlg) then
		return 
	end
	
	local var_40_0 = arg_40_0.vars.dlg:findChildByName("btn_noti")
	local var_40_1 = arg_40_0:isExistUserData()
	local var_40_2 = LotaBattleDataSystem:isActiveRewardExist() or LotaBoxSystem:isActiveRewardExist()
	
	if_set_visible(var_40_0, "icon_noti", var_40_1 and var_40_2)
	
	local var_40_3 = arg_40_0.vars.dlg:findChildByName("btn_ranking_board")
	
	if var_40_1 and arg_40_0.vars.current_schedule then
		local var_40_4 = LotaUserData:getLastRewardFloor()
		local var_40_5 = arg_40_0.vars.ranking_last_clear_floor
		
		if_set_visible(var_40_3, "icon_noti", var_40_4 < var_40_5)
	else
		if_set_visible(var_40_3, "icon_noti", false)
	end
end

function LotaEnterUI.setupUIButton(arg_41_0)
	local var_41_0 = arg_41_0.vars.dlg:findChildByName("LEFT")
	local var_41_1 = arg_41_0.vars.dlg:findChildByName("RIGHT")
	
	local function var_41_2(arg_42_0)
		if IS_PUBLISHER_ZLONG then
			return false
		end
		
		if not arg_41_0.vars.link then
			return false
		end
		
		return arg_42_0
	end
	
	local function var_41_3(arg_43_0)
		if_set_visible(var_41_0, "btn_noti", arg_43_0)
		if_set_visible(var_41_0, "btn_video", var_41_2(arg_43_0))
		if_set_visible(var_41_1, "btn_exchange", arg_43_0)
	end
	
	local function var_41_4(arg_44_0)
		if_set_visible(var_41_0, "btn_member", arg_44_0)
		if_set_visible(var_41_0, "btn_ranking_board", arg_44_0)
		if_set_visible(var_41_0, "btn_reward", arg_44_0)
	end
	
	local var_41_5 = arg_41_0.vars.current_schedule
	
	if not var_41_5 then
		if LotaUtil:isShopEnable(arg_41_0.vars.schedules) then
			var_41_3(true)
			var_41_4(false)
		else
			var_41_3(false)
			var_41_4(false)
		end
	elseif os.time() < var_41_5.start_time then
		var_41_3(false)
		var_41_4(false)
	else
		var_41_3(true)
		var_41_4(true)
	end
end

function LotaEnterUI.setupUIProgress(arg_45_0)
	LotaEnterUI:updateUI()
	
	local var_45_0, var_45_1 = arg_45_0:isCanEnter()
	local var_45_2 = arg_45_0.vars.current_schedule
	local var_45_3 = false
	
	if var_45_0 or var_45_2 and var_45_2.start_time < os.time() and var_45_1 == "req_more_level" then
		var_45_3 = true
	end
	
	local var_45_4 = arg_45_0.vars.dlg:findChildByName("RIGHT")
	
	if_set_visible(var_45_4, "n_info", var_45_3)
	if_set_visible(var_45_4, "n_none", not var_45_3)
	
	if not var_45_0 then
		local var_45_5 = arg_45_0.vars.dlg:findChildByName("n_none")
		
		if_set(var_45_5, "label", T("ui_clan_heritage_closed"))
	end
end

function LotaEnterUI.setupUIPeriod(arg_46_0)
	local function var_46_0(arg_47_0, arg_47_1)
		if_set(arg_47_0, "label_period", T("ui_clan_heritage_period", {
			start_year = arg_47_1.start_year,
			start_month = arg_47_1.start_month,
			start_day = arg_47_1.start_day,
			start_hour = arg_47_1.start_hour,
			start_min = arg_47_1.start_min,
			end_year = arg_47_1.end_year,
			end_month = arg_47_1.end_month,
			end_day = arg_47_1.end_day,
			end_hour = arg_47_1.end_hour,
			end_min = arg_47_1.end_min
		}))
	end
	
	local var_46_1 = arg_46_0.vars.dlg:findChildByName("RIGHT")
	local var_46_2 = var_46_1:findChildByName("label_remine_time")
	local var_46_3 = var_46_1:findChildByName("contents")
	local var_46_4 = arg_46_0.vars.current_schedule
	
	if_set_visible(var_46_1, "n_period", true)
	if_set_visible(var_46_1, "btn_go", true)
	if_set_visible(var_46_1, "n_notice", true)
	if_set_visible(var_46_3, "-", true)
	
	if not var_46_4 then
		if LotaUtil:isShopEnable(arg_46_0.vars.schedules) then
			if_set_visible(var_46_1, "label_period", true)
			
			local var_46_5 = LotaUtil:getLatestScheduleData(arg_46_0.vars.schedules)
			local var_46_6 = os.time()
			local var_46_7 = var_46_5.end_time
			local var_46_8 = var_46_5.end_time + 604800
			local var_46_9
			local var_46_10
			local var_46_11 = timeToStringDef({
				preceding_with_zeros = true,
				start_time = var_46_7,
				end_time = var_46_8
			})
			
			var_46_0(var_46_1, var_46_11)
			
			local var_46_12 = sec_to_full_string(var_46_8 - var_46_6)
			
			if_set(var_46_2, nil, T("ui_clan_heritage_remain", {
				remain_time = var_46_12
			}))
		else
			if_set_visible(var_46_1, "n_period", false)
			if_set_visible(var_46_1, "btn_go", false)
			if_set_visible(var_46_1, "n_notice", false)
			if_set_visible(var_46_3, "-", false)
			if_set(var_46_2, nil, T("ui_clan_heritage_open_yet"))
		end
		
		if_set_visible(var_46_1, "n_check_low", false)
	else
		local var_46_13 = os.time()
		local var_46_14 = var_46_4.start_time
		local var_46_15 = var_46_4.end_time
		local var_46_16
		local var_46_17
		local var_46_18
		
		if var_46_14 < var_46_13 then
			var_46_16 = sec_to_full_string(var_46_15 - var_46_13)
			var_46_18 = "ui_clan_heritage_remain"
		else
			var_46_16 = sec_to_full_string(var_46_14 - var_46_13)
			var_46_18 = "ui_clan_heritage_open_remain"
		end
		
		if_set(var_46_2, nil, T(var_46_18, {
			remain_time = var_46_16
		}))
		if_set_visible(var_46_1, "label_period", true)
		if_set_visible(var_46_1, "n_check_low", var_46_14 <= var_46_13)
		
		local var_46_19 = timeToStringDef({
			preceding_with_zeros = true,
			start_time = var_46_14,
			end_time = var_46_15
		})
		
		var_46_0(var_46_1, var_46_19)
	end
	
	local var_46_20 = arg_46_0:isCanEnter()
	local var_46_21 = cc.c3b(255, 255, 255)
	
	if not var_46_20 then
		var_46_21 = cc.c3b(76, 76, 76)
		
		if not LotaUtil:isShopEnable(arg_46_0.vars.schedules) then
			if_set_visible(var_46_1, "n_notice", false)
		end
	end
	
	if_set_color(var_46_1, "btn_go", var_46_21)
	
	local var_46_22 = arg_46_0:getClanFloor()
	
	if var_46_4 then
		local var_46_23 = LotaUtil:getMaxFloor(var_46_4.id)
		local var_46_24 = arg_46_0.vars.boss_dead_count or 0
		
		if var_46_23 <= var_46_22 and var_46_24 > 0 then
			if_set(var_46_1, "label_progress_disc", T("ui_clan_heritage_ongoing_3"))
		else
			if_set(var_46_1, "label_progress_disc", T("ui_clan_heritage_ongoing_1", {
				floor = var_46_22
			}))
		end
	end
end

function LotaEnterUI.setVideo(arg_48_0)
	local var_48_0 = arg_48_0.vars.current_schedule
	local var_48_1 = SubstoryUIUtil:load_link_url(var_48_0, "link")
	
	arg_48_0.vars.link = var_48_1 and var_48_1.link or nil
end

function LotaEnterUI.setupUILow(arg_49_0)
	local var_49_0 = arg_49_0.vars.dlg:getChildByName("check_box_low")
	
	var_49_0:setSelected(SAVE:get("lota_low_spec", false))
	
	local var_49_1 = arg_49_0.vars.dlg:getChildByName("t_check_low")
	local var_49_2 = 5
	local var_49_3 = var_49_1:getContentSize().width * var_49_1:getScaleX() * 0.5 + var_49_0:getContentSize().width * var_49_0:getScaleX() * 0.5 + var_49_2
	
	var_49_0:setPositionX(-1 * var_49_3)
end

function LotaEnterUI.toggleLowSpec(arg_50_0)
	local var_50_0 = arg_50_0.vars.dlg:getChildByName("check_box_low")
	local var_50_1 = not var_50_0:isSelected()
	
	var_50_0:setSelected(var_50_1)
	SAVE:set("lota_low_spec", var_50_1)
	
	if var_50_1 then
		Dialog:msgBox(T("ui_clanheritage_low_performance"))
	end
end

function LotaEnterUI.showVideo(arg_51_0)
	if arg_51_0.vars.link then
		Stove:openVideoPage(arg_51_0.vars.link)
	end
end

function LotaEnterUI.setupUIDesc(arg_52_0)
	local var_52_0 = arg_52_0.vars.dlg:findChildByName("RIGHT"):findChildByName("n_disc")
	local var_52_1 = var_52_0:findChildByName("label")
	local var_52_2 = arg_52_0.vars.current_schedule
	local var_52_3 = LotaUserData:getCurrentSeasonDB(var_52_2)
	local var_52_4
	local var_52_5
	
	if not var_52_3 then
		var_52_4 = T("ui_clan_heritage_area_default_title")
		var_52_5 = T("ui_clan_heritage_area_default_desc")
		
		if get_cocos_refid(var_52_1) then
			var_52_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
			var_52_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		end
	elseif os.time() < var_52_2.start_time then
		var_52_4 = T("ui_clan_heritage_area_default_title")
		var_52_5 = T("ui_clan_heritage_area_default_desc")
		
		if get_cocos_refid(var_52_1) then
			var_52_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
			var_52_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_CENTER)
		end
	else
		var_52_4 = T(var_52_3.name)
		var_52_5 = T(var_52_3.desc)
		
		if get_cocos_refid(var_52_1) then
			var_52_1:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
			var_52_1:setTextVerticalAlignment(cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		end
	end
	
	if_set(var_52_0, "label_title", var_52_4)
	if_set(var_52_0, "label", var_52_5)
end

local function var_0_0(arg_53_0, arg_53_1)
	local var_53_0 = ccui.Button:create()
	
	var_53_0:setTouchEnabled(true)
	var_53_0:ignoreContentAdaptWithSize(false)
	var_53_0:setContentSize(arg_53_0:getContentSize().width, arg_53_0:getContentSize().height)
	var_53_0:setAnchorPoint(0, 0)
	var_53_0:addTouchEventListener(arg_53_1)
	arg_53_0:addChild(var_53_0)
end

function LotaEnterUI.setupUIForBG(arg_54_0)
	local var_54_0 = arg_54_0.vars.dlg:findChildByName("label_progress_disc")
	
	var_0_0(var_54_0, function(arg_55_0, arg_55_1)
		if arg_55_1 ~= 2 then
			return 
		end
		
		if arg_54_0._month == nil or arg_54_0._day == nil then
			arg_54_0._month = 0
			arg_54_0._day = 0
		end
		
		arg_54_0._month = arg_54_0._month + 1
		
		local var_55_0 = arg_54_0.vars.dlg:findChildByName("INLINE")
		
		if arg_54_0._month >= 2 and arg_54_0._day >= 17 and var_55_0:isVisible() and not get_cocos_refid(arg_54_0.vars.parent) then
			arg_54_0:setupRenderer()
			UIAction:Add(SEQ(FADE_OUT(1000), SHOW(false)), var_55_0)
		end
	end)
	
	local var_54_1 = arg_54_0.vars.dlg:findChildByName("RIGHT"):findChildByName("n_info"):findChildByName("n_expedition_level"):findChildByName("bg")
	
	var_0_0(var_54_1, function(arg_56_0, arg_56_1)
		if arg_56_1 ~= 2 then
			return 
		end
		
		if arg_54_0._month == nil or arg_54_0._day == nil then
			arg_54_0._month = 0
			arg_54_0._day = 0
		end
		
		arg_54_0._day = arg_54_0._day + 1
		
		local var_56_0 = arg_54_0.vars.dlg:findChildByName("INLINE")
		
		if arg_54_0._month >= 2 and arg_54_0._day >= 17 and var_56_0:isVisible() and not get_cocos_refid(arg_54_0.vars.parent) then
			arg_54_0:setupRenderer()
			UIAction:Add(SEQ(FADE_OUT(1000), SHOW(false)), var_56_0)
		end
	end)
end

function LotaEnterUI.setupUINotice(arg_57_0)
	local var_57_0 = arg_57_0:getNoticeMsg()
	local var_57_1 = "@^ye%"
	local var_57_2 = string.split(var_57_0, var_57_1)
	local var_57_3 = var_57_2[1]
	local var_57_4 = arg_57_0.vars.dlg:getChildByName("txt_select_talk")
	
	UIUtil:updateTextWrapMode(var_57_4, var_57_3, 20)
	set_ellipsis_label2(var_57_4, var_57_3, 2)
	
	local var_57_5 = var_57_2[2]
	local var_57_6
	local var_57_7
	local var_57_8
	
	if table.count(Clan:getMembers()) ~= 0 then
		var_57_6 = Clan:getMemberInfoById(var_57_5)
		var_57_8 = Clan:getClanMaster().user_info
	else
		local var_57_9 = {}
		
		var_57_8 = {}
	end
	
	if var_57_5 and not var_57_6 then
		local var_57_10 = {}
		
		var_57_8 = {}
	elseif not var_57_5 then
	else
		local var_57_11 = var_57_6
		
		var_57_8 = var_57_6.user_info
	end
	
	local var_57_12 = CLAN_GRADE.master
	
	if var_57_6 and var_57_6.grade then
		var_57_12 = var_57_6.grade
	end
	
	if var_57_12 == CLAN_GRADE.master then
		if_set_color(arg_57_0.vars.dlg, "icon_leader", cc.c3b(255, 255, 255))
	else
		if_set_color(arg_57_0.vars.dlg, "icon_leader", tocolor("#2A78C3"))
	end
	
	if_set(arg_57_0.vars.dlg:getChildByName("n_noti_small"), "txt_name", var_57_8.name or T("ui_clan_home_notice_unknown_member"))
	
	local var_57_13 = var_57_8.leader_code or "m0000"
	
	UIUtil:getRewardIcon(nil, var_57_13, {
		no_popup = true,
		character_type = "character",
		scale = 1,
		no_grade = true,
		parent = arg_57_0.vars.dlg:getChildByName("mob_icon"),
		border_code = var_57_8.border_code
	})
end

function LotaEnterUI.setupUI(arg_58_0)
	arg_58_0:setupUIButton()
	arg_58_0:setupUIProgress()
	arg_58_0:setupUIDesc()
	arg_58_0:setupUIPeriod()
	arg_58_0:setupUILow()
	arg_58_0:setupUIForBG()
	arg_58_0:setupUINotice()
end

function LotaEnterUI.hide(arg_59_0)
	UIAction:Add(FADE_OUT(600, true), arg_59_0.vars.dlg, "block")
end

function LotaEnterUI.show(arg_60_0)
	UIAction:Add(FADE_IN(600), arg_60_0.vars.dlg, "block")
end

function LotaEnterUI.onPushBackButton(arg_61_0)
	TopBarNew:pop()
	SceneManager:resetSceneFlow()
	SceneManager:nextScene("clan")
end
