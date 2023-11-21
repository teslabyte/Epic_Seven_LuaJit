TournamentTeam = TournamentTeam or {}

copy_functions(UnitTeam, TournamentTeam)

function HANDLER.tournament_ready(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_go" then
		TournamentTeam:onStartBattle()
	end
end

function TournamentTeam.show(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.vars = {}
	arg_2_0.vars.opts = arg_2_2 or {}
	arg_2_0.vars.info = arg_2_1 or {}
	arg_2_0.vars.info = {}
	arg_2_0.vars.parent = arg_2_0.vars.opts.parent or SceneManager:getDefaultLayer()
	arg_2_0.vars.tournament_id = arg_2_2.tournament_id
	
	if arg_2_1 and arg_2_1.enemy_info then
		local var_2_0 = {}
		
		for iter_2_0, iter_2_1 in pairs(arg_2_1.enemy_info.units) do
			local var_2_1 = UNIT:create(iter_2_1.unit)
			
			for iter_2_2, iter_2_3 in pairs(iter_2_1.equips) do
				if iter_2_3.p == iter_2_1.unit.id then
					local var_2_2 = EQUIP:createByInfo(iter_2_3)
					
					if var_2_2 then
						var_2_1:addEquip(var_2_2, true)
					end
				end
			end
			
			var_2_1:calc()
			
			var_2_0[iter_2_1.pos] = var_2_1
		end
		
		local var_2_3 = {}
		
		for iter_2_4, iter_2_5 in pairs(var_2_0) do
			var_2_3[iter_2_4] = iter_2_5
		end
		
		local var_2_4 = {
			my_score = arg_2_1.my_info.score,
			enemy_team = var_2_3,
			enemy_info = {
				enemy_uid = arg_2_1.enemy_uid,
				name = arg_2_1.enemy_info.name,
				level = arg_2_1.enemy_info.level,
				score = arg_2_1.enemy_score,
				revenge_id = arg_2_1.revenge_id
			}
		}
		
		UnitMain:beginTournamentMode(arg_2_0.vars.parent, var_2_4, arg_2_0.vars.opts.hide_layer, arg_2_0.vars.opts.currencies)
		
		return 
	end
	
	Log.e("PvpSATeam.show - info is nil")
end

function TournamentTeam.onStartBattle(arg_3_0, arg_3_1)
	if not arg_3_0.vars.enterable then
		balloon_message_with_sound("not_enough_enter_token")
		
		return 
	end
	
	if not arg_3_1 then
		arg_3_0:playPvPReadyAnimation()
		UIAction:Add(SEQ(DELAY(800), CALL(TournamentTeam.onStartBattle, arg_3_0, true)), arg_3_0, "block")
		
		return 
	end
	
	local var_3_0 = SubstoryManager:findContentsScheduleID(SUBSTORY_CONTENTS_TYPE.TOURNAMENT)
	
	if var_3_0 == nil or SubstoryManager:isActiveSchedule(var_3_0, SUBSTORY_CONSTANTS.ONE_WEEK) == false then
		balloon_message_with_sound("err_tournament_invalid_time")
		
		return 
	end
	
	local var_3_1 = Account:saveTeamInfo(true)
	local var_3_2 = Account:getCurrentTeamIndex() or nil
	
	Account:saveLocalTeamIndex("tournament001", var_3_2)
	
	local var_3_3 = {
		point = 0,
		team_idx = var_3_2,
		team = {}
	}
	local var_3_4 = Account:getTeam(var_3_2)
	local var_3_5 = 0
	
	if var_3_4 then
		for iter_3_0 = 1, 5 do
			if var_3_4[iter_3_0] then
				if not var_3_4[iter_3_0]:isSummon() then
					var_3_5 = var_3_5 + 1
				end
				
				var_3_3.point = var_3_3.point + var_3_4[iter_3_0]:getPoint()
				var_3_3.team[iter_3_0] = var_3_4[iter_3_0].inst.uid
			end
		end
	end
	
	if var_3_5 == 0 then
		balloon_message_with_sound("no_unit")
		
		return 
	end
	
	local var_3_6 = "tournament00100"
	
	PreLoad:beforeReqBattle(var_3_6)
	
	local var_3_7 = SubstoryManager:getInfo().id
	
	StoryLogger:destroyWithViewer()
	query("tournament_enter", {
		tournament_id = arg_3_0.vars.tournament_id,
		substory_id = var_3_7,
		team_info = json.encode(var_3_3),
		update_team_info = var_3_1
	})
end

function TournamentTeam.onEnter(arg_4_0, arg_4_1, arg_4_2)
	arg_4_2 = arg_4_2 or {}
	
	local var_4_0 = UnitMain:getPortrait()
	
	if get_cocos_refid(var_4_0) then
		UnitMain:leavePortrait(nil, false)
	end
	
	if arg_4_1 == "Detail" then
		arg_4_0:updateTeamPoint(Account:getTeam(arg_4_0.vars.team_idx))
		arg_4_0:updateHeroTags()
		SoundEngine:play("event:/ui/menu/menu_1")
	end
	
	local var_4_1 = arg_4_0.vars.wnd:getChildByName("LEFT")
	local var_4_2 = arg_4_0.vars.wnd:getChildByName("CENTER")
	local var_4_3 = arg_4_0.vars.wnd:getChildByName("FORMATION")
	
	UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(200, NotchStatus:getNotchBaseLeft()), 100)), var_4_1, "block")
	UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(200, nil, 0), 100)), var_4_2, "block")
	
	if var_4_3 then
		UIAction:Add(SEQ(SHOW(true), LOG(MOVE_TO(200, nil, 0), 100)), var_4_3, "block")
	end
	
	local var_4_4 = HeroBelt:getCurrentControl()
	
	if var_4_4 then
		var_4_4.add:setVisible(true)
	end
	
	arg_4_0:setNormalMode()
	
	if arg_4_0.vars.pvp_info and not arg_4_0.vars.pvp_info.defend_mode and not arg_4_0.vars.pvp_peer_formation_editor then
		local var_4_5 = {}
		
		copy_functions(FormationEditor, var_4_5)
		FormationEditor:initFormationEditor(var_4_5, {
			tagScale = 1,
			hide_hpbar = true,
			flip_model = true,
			useSimpleTag = true,
			tagOffsetY = 80,
			model_scale = 0.77,
			notUseTouchHandler = true,
			hide_hpbar_color = true,
			wnd = arg_4_0.vars.wnd:getChildByName("n_peer_formation"),
			pvp_info = arg_4_0.vars.pvp_info,
			tournament_id = arg_4_0.vars.tournament_id,
			callbackUpdateFormation = function(arg_5_0)
				HeroBelt:updateTeamMarkers()
			end,
			callbackSelectUnit = function(arg_6_0)
				HeroBelt:scrollToUnit(arg_6_0)
			end,
			callbackSelectTeam = function(arg_7_0)
				arg_4_0:setTeam(arg_7_0)
			end
		})
		var_4_5:updateFormation(arg_4_0.vars.pvp_info.enemy_team)
		
		arg_4_0.vars.pvp_peer_formation_editor = var_4_5
	end
	
	arg_4_0:setFormationEditMode(true)
	if_set_visible(arg_4_0.vars.wnd, "noti_support", Account:getTeam(12)[1] == nil)
	
	if arg_4_0.removeDedicationEffect then
		arg_4_0:removeDedicationEffect()
	end
end

function TournamentTeam.create(arg_8_0, arg_8_1)
	print("create!!!!!")
	
	arg_8_1 = arg_8_1 or {}
	arg_8_0.vars.pvp_info = arg_8_1.pvp_info
	
	local var_8_0 = 1
	local var_8_1
	
	arg_8_0.vars.wnd = load_dlg("tournament_ready", true, "wnd")
	
	local var_8_2 = load_dlg("pvp_team_formation", true, "wnd")
	
	var_8_2.class = arg_8_0
	
	local var_8_3 = 0.77
	
	arg_8_0.vars.wnd.class = arg_8_0
	
	arg_8_0.vars.wnd:getChildByName("n_pos_formation"):addChild(var_8_2)
	FormationEditor:initFormationEditor(arg_8_0, {
		hide_hpbar = true,
		useSimpleTag = true,
		tagScale = 1,
		tagOffsetY = 80,
		hide_hpbar_color = true,
		wnd = var_8_2,
		pvp_info = arg_8_0.vars.pvp_info,
		tournament_id = arg_8_0.vars.tournament_id,
		model_scale = var_8_3,
		callbackUpdateFormation = function(arg_9_0)
			HeroBelt:updateTeamMarkers()
		end,
		callbackSelectUnit = function(arg_10_0)
			HeroBelt:scrollToUnit(arg_10_0)
		end,
		callbackSelectTeam = function(arg_11_0)
			arg_8_0:setTeam(arg_11_0)
		end
	})
	
	if arg_8_0.vars.pvp_info then
		arg_8_0:updateInfo(arg_8_0.vars.wnd:getChildByName("n_my_formation"))
		arg_8_0:updateInfo(arg_8_0.vars.wnd:getChildByName("n_peer_formation"), true)
	end
	
	local var_8_4 = arg_8_0.vars.wnd:getChildByName("LEFT")
	local var_8_5 = arg_8_0.vars.wnd:getChildByName("CENTER")
	local var_8_6 = arg_8_0.vars.wnd:getChildByName("FORMATION")
	
	var_8_4:setPositionX(var_8_4:getPositionX() - 250)
	var_8_5:setPositionY(-800)
	
	if var_8_6 then
		var_8_6:setPositionY(-800)
	end
	
	if_set_visible(arg_8_0.vars.wnd, "txt_rating", false)
	if_set_visible(arg_8_0.vars.wnd, "n_clan", false)
	
	arg_8_0.vars.enterable, arg_8_0.vars.type_enterpoint = Tournament:setButtonEnterInfo(arg_8_0.vars.wnd:getChildByName("btn_go"), arg_8_0.vars.tournament_id)
end

function TournamentTeam.updateInfo(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_1 or not get_cocos_refid(arg_12_1) then
		return 
	end
	
	local var_12_0
	local var_12_1
	local var_12_2
	local var_12_3
	local var_12_4
	
	if not arg_12_2 then
		var_12_1 = AccountData.name
		var_12_0 = AccountData.level
		var_12_2 = Clan:getClanInfo()
	elseif arg_12_0.vars.pvp_info.enemy_info then
		var_12_1 = arg_12_0.vars.pvp_info.enemy_info.name
		var_12_0 = arg_12_0.vars.pvp_info.enemy_info.level
		var_12_2 = arg_12_0.vars.pvp_info.enemy_info.clan
		
		if arg_12_0.vars.pvp_info.enemy_info.enemy_uid then
			local var_12_5 = string.split(arg_12_0.vars.pvp_info.enemy_info.enemy_uid, ":")
			
			if var_12_5[1] == "npc" then
				local var_12_6 = tonumber(var_12_5[2])
				local var_12_7 = var_12_5[3]
			end
		end
	end
	
	if arg_12_0.vars.tournament_id and arg_12_2 then
		if_set_visible(arg_12_1, "infor_npc", true)
		if_set_visible(arg_12_1, "infor", false)
		
		local var_12_8 = arg_12_1:getChildByName("infor_npc")
		local var_12_9 = Tournament:getTournamentDB(arg_12_0.vars.tournament_id)
		
		if_set(var_12_8, "txt_name", T(var_12_9.name))
		
		local var_12_10 = var_12_9.reward1
		local var_12_11 = var_12_9.count1
		local var_12_12 = var_12_9.reward2
		local var_12_13 = var_12_9.count2
		
		if get_cocos_refid(var_12_8) then
			UIUtil:getRewardIcon(var_12_11, var_12_10, {
				show_small_count = true,
				artifact_multiply_scale = 0.52,
				skill_preview = true,
				hero_multiply_scale = 0.8,
				scale = 1,
				multiply_scale = 0.7,
				parent = var_12_8:getChildByName("n_item_reward1")
			})
			
			if var_12_12 and var_12_13 then
				UIUtil:getRewardIcon(var_12_13, var_12_12, {
					show_small_count = true,
					artifact_multiply_scale = 0.52,
					skill_preview = true,
					hero_multiply_scale = 0.8,
					scale = 1,
					multiply_scale = 0.7,
					parent = var_12_8:getChildByName("n_item_reward2")
				})
			end
		end
	elseif arg_12_0.vars.tournament_id then
		if_set_visible(arg_12_1, "infor_npc", false)
		if_set_visible(arg_12_1, "infor", true)
		
		local var_12_14 = arg_12_1:getChildByName("infor")
		
		if_set(var_12_14, "txt_name", var_12_1)
		
		local var_12_15 = var_12_14:getChildByName("n_rank")
		
		if var_12_15 and var_12_0 then
			UIUtil:setLevel(var_12_15, var_12_0, MAX_ACCOUNT_LEVEL, 2)
		end
		
		local var_12_16 = var_12_14:getChildByName("n_clan")
		
		if var_12_2 then
			if_set_visible(var_12_14, "n_clan", true)
			if_set(var_12_16, "txt_clan", var_12_2.name)
		else
			if var_12_15 then
				var_12_15:setPositionY(var_12_15:getPositionY() + 23)
			end
			
			if_set_visible(var_12_14, "n_clan", false)
		end
	end
end

function TournamentTeam.getSceneState(arg_13_0)
	if not arg_13_0.vars then
		return {}
	end
	
	return {
		mode = arg_13_0.vars.info.mode
	}
end

function TournamentTeam.onUnitDetail(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.vars.pvp_info ~= nil
	
	UnitMain:setMode("Detail", {
		unit = arg_14_1,
		pvp_mode = var_14_0
	})
end
