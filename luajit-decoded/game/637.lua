ArenaNetReadyDraft = {}
ArenaNetReadyDraftSpectator = {}

copy_functions(ArenaNetReadySpectator, ArenaNetReadyDraft)
copy_functions(ArenaNetReadySpectator, ArenaNetReadyDraftSpectator)

function ArenaNetReadyDraft.setUserInfo(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_0.vars.service:getSeasonId()
	local var_1_1 = arg_1_2.league_id
	local var_1_2, var_1_3 = getArenaNetRankInfo(var_1_0, var_1_1)
	local var_1_4 = (arg_1_2.win or 0) + (arg_1_2.draw or 0) + (arg_1_2.lose or 0) < ARENA_MATCH_BATCH_COUNT
	
	UIUtil:getUserIcon(arg_1_2.leader_code, {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		scale = 1,
		no_grade = true,
		parent = arg_1_1:getChildByName("mob_icon"),
		border_code = arg_1_2.border_code
	})
	if_set(arg_1_1, "txt_nation", getRegionText(arg_1_2.world))
	if_set(arg_1_1, "txt_name", arg_1_2.name)
	
	if var_1_4 then
		SpriteCache:resetSprite(arg_1_1:getChildByName("emblem"), "emblem/" .. ARENA_UNRANK_ICON)
	else
		SpriteCache:resetSprite(arg_1_1:getChildByName("emblem"), "emblem/" .. var_1_3 .. ".png")
	end
	
	if_set(arg_1_1, "txt_clan", clanNameFilter(arg_1_2.clan_name))
	UIUtil:updateClanEmblem(arg_1_1:getChildByName("n_emblem"), {
		emblem = arg_1_2.clan_emblem
	})
	if_set_visible(arg_1_1, "n_emblem", string.len(arg_1_2.clan_name or "") > 0)
	
	local var_1_5 = string.len(arg_1_2.clan_name or "") > 0 and 0 or -13
	local var_1_6 = string.len(arg_1_2.clan_name or "") > 0 and 0 or 13
	
	if_set_add_position_y(arg_1_1, "txt_name", var_1_5)
	if_set_add_position_y(arg_1_1, "icon_menu_global", var_1_6)
	if_set_add_position_y(arg_1_1, "txt_nation", var_1_6)
	if_set_add_position_y(arg_1_1, "n_ping", var_1_6)
end

function ArenaNetReadyDraft.createFormation(arg_2_0)
	local var_2_0 = arg_2_0.vars.wnd:getChildByName("n_my_formation")
	
	var_2_0:removeAllChildren()
	
	local var_2_1 = load_dlg("pvplive_ready_formation", true, "wnd")
	
	var_2_1.class = arg_2_0
	
	var_2_0:addChild(var_2_1)
	
	local var_2_2 = {}
	
	CustomFormationEditor:initFormationEditor(var_2_2, {
		useSimpleTag = true,
		tagScale = 1,
		tagOffsetY = 80,
		model_scale = 1,
		hide_hpbar = true,
		hide_hpbar_color = true,
		wnd = var_2_1,
		callbackUpdateFormation = function(arg_3_0)
			arg_2_0:sendChangeInfo()
		end
	})
	var_2_1:setPosition(var_2_1:getContentSize().width * 0.5, var_2_1:getContentSize().height * 0.5)
	
	arg_2_0.vars.formation_editor = var_2_2
end

function ArenaNetReadyDraft.updateFormation(arg_4_0)
	if not arg_4_0.vars.team_info then
		arg_4_0.vars.team_info = arg_4_0:createTeamFromSlots(arg_4_0.vars.user_uid)
		
		arg_4_0.vars.formation_editor:updateFormation(arg_4_0.vars.team_info)
	end
end

function ArenaNetReadyDraft.updatePortrait(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	if arg_5_0.vars.seq_info.seq ~= "BAN" then
		return 
	end
	
	if arg_5_0.prev_code == arg_5_2.db.code then
		return 
	end
	
	local var_5_0 = arg_5_0.vars.wnd:getChildByName("n_portrait")
	local var_5_1 = DB("character", arg_5_2:getDisplayCode(), "face_id")
	local var_5_2 = DB("character", arg_5_2.db.code, "emotion_id")
	
	if var_5_1 then
		local var_5_3, var_5_4 = UIUtil:getPortraitAni(var_5_1)
		
		if var_5_3 then
			var_5_0:removeAllChildren()
			var_5_0:addChild(var_5_3)
			var_5_3:setColor(arg_5_3 or cc.c3b(255, 255, 255))
			
			if not var_5_4 then
				var_5_3:setScale(0.8)
				var_5_3:setPositionY(550)
			end
			
			arg_5_0.vars.portrait = var_5_3
		end
	end
	
	arg_5_0.prev_code = arg_5_2.db.code
end

function ArenaNetReadyDraft.updateAccumulatePrebanInfo(arg_6_0, arg_6_1)
end

function ArenaNetReadyDraft.updatePrebanInfo(arg_7_0, arg_7_1)
end

function ArenaNetReadyDraft.updateTimeInfo(arg_8_0, arg_8_1)
	if not arg_8_1 then
		return 
	end
	
	local var_8_0 = arg_8_0.vars.seq_info.user
	
	if ArenaNetCardSelector:isActing() then
		if_set_visible(arg_8_0.vars.wnd, "n_turn", false)
		if_set_visible(arg_8_0.vars.wnd, "n_top", false)
	else
		if_set_visible(arg_8_0.vars.wnd, "n_top", true)
		
		if arg_8_0.vars.seq_info.seq == "PICK" then
			if_set_visible(arg_8_0.vars.wnd, "n_turn", true)
		else
			if_set_visible(arg_8_0.vars.wnd, "n_turn", false)
			if_set_visible(arg_8_0.vars.wnd, "t_my_turn", false)
			if_set_visible(arg_8_0.vars.wnd, "t_enemy_turn", false)
		end
		
		arg_8_0:updateTimeProgress(arg_8_1)
	end
end

function ArenaNetReadyDraft.updateSlotVoice(arg_9_0, arg_9_1)
end

function ArenaNetReadyDraft.updateBanInfo(arg_10_0, arg_10_1)
	if arg_10_1 then
		arg_10_0.vars.ban_info = arg_10_1
		
		local var_10_0 = table.count(arg_10_0.vars.ban_info)
		
		for iter_10_0, iter_10_1 in pairs(arg_10_1 or {}) do
			for iter_10_2, iter_10_3 in pairs(iter_10_1) do
				table.each(arg_10_0.vars.slot_lists[iter_10_0], function(arg_11_0, arg_11_1)
					if not arg_11_1.ban and iter_10_3 and arg_11_1.unit and iter_10_3.uid == arg_11_1.unit:getUID() then
						arg_10_0.vars.wnd:getChildByName("n_ban"):removeAllChildren()
						EffectManager:Play({
							pivot_x = 0,
							fn = "ui_livepvp_bann_eff.cfx",
							pivot_y = 0,
							pivot_z = 99998,
							layer = arg_10_0.vars.wnd:getChildByName("n_ban")
						})
						arg_10_0:resetBlinkSlot(iter_10_0, arg_11_0, arg_11_1)
						if_set_visible(arg_10_0.vars.wnd, "n_ban", arg_10_0.vars.seq_info.seq ~= "CHANGE")
						if_set_visible(arg_10_0.vars.wnd, "n_ban_ing", false)
						
						arg_11_1.ban = true
						
						arg_10_0:updatePortrait(iter_10_0, arg_11_1.unit, cc.c3b(95, 95, 95))
					end
				end)
			end
		end
		
		if arg_10_0.vars.seq_info.seq == "CHANGE" then
			arg_10_0:updateFormation()
			if_set_visible(arg_10_0.vars.wnd, "n_ban", arg_10_0.vars.is_spectator)
			if_set_visible(arg_10_0.vars.wnd, "n_ban_ing", false)
			if_set_visible(arg_10_0.vars.wnd, "n_portrait", arg_10_0.vars.is_spectator)
			if_set_visible(arg_10_0.vars.wnd, "n_my_formation", true)
			
			for iter_10_4, iter_10_5 in pairs(arg_10_0.vars.ban_info or {}) do
				for iter_10_6, iter_10_7 in pairs(arg_10_0.vars.slot_lists[iter_10_4]) do
					if iter_10_7.ban then
						local var_10_1 = iter_10_7:getChildByName("n_ban")
						
						if not var_10_1:isVisible() then
							EffectManager:Play({
								pivot_x = 0,
								fn = "ui_livepvp_bann_eff.cfx",
								pivot_y = 0,
								pivot_z = 99998,
								scale = 0.5,
								layer = var_10_1
							})
						end
						
						var_10_1:setVisible(true)
						
						local var_10_2 = cc.c3b(75, 75, 75)
						
						if_set_color(iter_10_7, "img_bg", var_10_2)
						if_set_color(iter_10_7, "n_unit", var_10_2)
					else
						iter_10_7:getChildByName("n_ban"):setVisible(false)
						
						local var_10_3 = cc.c3b(255, 255, 255)
						
						if_set_color(iter_10_7, "img_bg", var_10_3)
						if_set_color(iter_10_7, "n_unit", var_10_3)
					end
				end
			end
		end
	end
end

local function var_0_0(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = ArenaService:getGameInfo()
	local var_12_1 = string.starts(arg_12_0.name, "my")
	local var_12_2
	
	if var_12_0 and var_12_0.rule == ARENA_NET_BATTLE_RULE.DRAFT then
		var_12_2 = UNIT:create({
			g = 6,
			z = 6,
			d = 7,
			exp = 5000000000,
			f = 10,
			id = arg_12_1.uid,
			code = arg_12_1.code
		})
		var_12_2.draft_info = arg_12_1
	else
		var_12_2 = var_12_1 and Account:getUnit(arg_12_1.uid) or UNIT:create({
			id = arg_12_1.uid,
			code = arg_12_1.code,
			exp = arg_12_1.exp,
			g = arg_12_1.grade,
			z = arg_12_1.zodiac
		})
		
		if var_12_1 then
			var_12_2 = var_12_2:clone()
			
			GrowthBoost:apply(var_12_2)
		end
	end
	
	if arg_12_1.skin_code then
		var_12_2:changeSkin(arg_12_1.skin_code)
	end
	
	SpriteCache:resetSprite(arg_12_0:getChildByName("face"), "face/" .. (var_12_2.db.face_id or "") .. "_l.png")
	SpriteCache:resetSprite(arg_12_0:getChildByName("role"), "img/cm_icon_role_" .. var_12_2.db.role .. ".png")
	SpriteCache:resetSprite(arg_12_0:getChildByName("element"), UIUtil:getColorIcon(var_12_2))
	
	if arg_12_3 then
		arg_12_0:getChildByName("face"):setFlippedX(false)
	elseif not arg_12_3 and var_12_1 then
		arg_12_0:getChildByName("face"):setFlippedX(true)
	end
	
	UIUtil:setLevel(arg_12_0, arg_12_1.g_lv or var_12_2:getLv(), arg_12_1.g_max_lv or var_12_2:getMaxLevel(), 6)
	UIUtil:setStarsByUnit(arg_12_0, var_12_2)
	if_set_visible(arg_12_0, "n_unit", true)
	if_set_visible(arg_12_0, "img_bg", not arg_12_2)
	
	return var_12_2
end

function ArenaNetReadyDraft.updateSlotInfo(arg_13_0, arg_13_1)
	local function var_13_0(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
		local var_14_0 = ArenaService:getGameInfo()
		local var_14_1 = string.starts(arg_14_0.name, "my")
		local var_14_2
		
		if var_14_0 and var_14_0.rule == ARENA_NET_BATTLE_RULE.DRAFT then
			var_14_2 = UNIT:create({
				g = 6,
				z = 6,
				d = 7,
				exp = 5000000000,
				f = 10,
				id = arg_14_1.uid,
				code = arg_14_1.code
			})
			var_14_2.draft_info = arg_14_1
		else
			var_14_2 = var_14_1 and Account:getUnit(arg_14_1.uid) or UNIT:create({
				id = arg_14_1.uid,
				code = arg_14_1.code,
				exp = arg_14_1.exp,
				g = arg_14_1.grade,
				z = arg_14_1.zodiac
			})
			
			if var_14_1 then
				var_14_2 = var_14_2:clone()
				
				GrowthBoost:apply(var_14_2)
			end
		end
		
		if arg_14_1.skin_code then
			var_14_2:changeSkin(arg_14_1.skin_code)
		end
		
		SpriteCache:resetSprite(arg_14_0:getChildByName("face"), "face/" .. (var_14_2.db.face_id or "") .. "_l.png")
		SpriteCache:resetSprite(arg_14_0:getChildByName("role"), "img/cm_icon_role_" .. var_14_2.db.role .. ".png")
		SpriteCache:resetSprite(arg_14_0:getChildByName("element"), UIUtil:getColorIcon(var_14_2))
		
		if arg_14_3 then
			arg_14_0:getChildByName("face"):setFlippedX(false)
		elseif not arg_14_3 and var_14_1 then
			arg_14_0:getChildByName("face"):setFlippedX(true)
		end
		
		UIUtil:setLevel(arg_14_0, arg_14_1.g_lv or var_14_2:getLv(), arg_14_1.g_max_lv or var_14_2:getMaxLevel(), 6)
		UIUtil:setStarsByUnit(arg_14_0, var_14_2)
		if_set_visible(arg_14_0, "n_unit", true)
		if_set_visible(arg_14_0, "img_bg", not arg_14_2)
		
		return var_14_2
	end
	
	if arg_13_1 then
		arg_13_0.vars.pick_info = arg_13_1
		
		for iter_13_0, iter_13_1 in pairs(arg_13_1 or {}) do
			for iter_13_2, iter_13_3 in pairs(iter_13_1) do
				local var_13_1 = arg_13_0.vars.slot_lists[iter_13_0][iter_13_2]
				
				if iter_13_3 and var_13_1 and not var_13_1.is_update then
					var_13_1.is_update = true
					
					local var_13_2 = false
					
					if iter_13_0 == arg_13_0.vars.user_uid and table.find(not_allow_flip_units, iter_13_3.code) then
						var_13_2 = true
					end
					
					UIAction:Add(SEQ(CALL(function()
						arg_13_0:pickSlot(iter_13_0, iter_13_2, var_13_1, true)
					end), DELAY(600), CALL(function()
						local var_16_0 = var_13_0(var_13_1, iter_13_3, false, var_13_2)
						
						var_13_1.unit = var_16_0
						
						local var_16_1 = arg_13_0.vars.seq_info.seq == "PICK" and cc.c3b(255, 255, 255) or cc.c3b(95, 95, 95)
						
						if arg_13_0.vars.seq_info.seq ~= "BAN" then
							arg_13_0:updatePortrait(iter_13_0, var_16_0, var_16_1)
						end
						
						arg_13_0:updateSlotVoice(var_13_1)
					end)), var_13_1, "draft.seq.bindUnitSlot")
				elseif not iter_13_3 then
					var_13_1.unit = nil
					
					if_set_visible(var_13_1, "n_unit", false)
				end
			end
		end
		
		if HeroBelt:isValid() then
			HeroBelt:updateCurrentViewItems(9)
		end
	end
end

function ArenaNetReadyDraft.sendChangeInfo(arg_17_0)
	local var_17_0 = arg_17_0.vars.rest_time[arg_17_0.vars.user_uid]
	
	if not var_17_0 then
		return 
	end
	
	if var_17_0 < 0 or var_17_0 > 2 then
		return 
	end
	
	if arg_17_0.vars.seq_info.seq == "PICK_DRAFT" then
		local var_17_1, var_17_2 = ArenaNetCardSelector:getPickInfos()
		
		if not var_17_1 or not var_17_2 then
			return 
		end
		
		arg_17_0.vars.service:query("command", {
			type = "draftselecting",
			stage = var_17_1,
			slot_id = var_17_2
		})
	end
end

function ArenaNetReadyDraftSpectator.updatePortrait(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
end

function ArenaNetReadyDraftSpectator.updateSlotInfo(arg_19_0, arg_19_1)
	if arg_19_1 then
		arg_19_0.vars.pick_info = arg_19_1
		
		local var_19_0 = {}
		
		for iter_19_0, iter_19_1 in pairs(arg_19_1 or {}) do
			for iter_19_2, iter_19_3 in pairs(iter_19_1) do
				if not var_19_0[iter_19_2] then
					var_19_0[iter_19_2] = {}
				end
				
				local var_19_1 = {
					user = iter_19_0,
					unit = iter_19_3
				}
				
				table.insert(var_19_0[iter_19_2], var_19_1)
			end
		end
		
		for iter_19_4, iter_19_5 in pairs(var_19_0 or {}) do
			if iter_19_5 and table.count(iter_19_5) >= 2 then
				for iter_19_6, iter_19_7 in pairs(iter_19_5) do
					if iter_19_7.user and iter_19_7.unit then
						local var_19_2 = iter_19_7.user
						local var_19_3 = iter_19_7.unit
						local var_19_4 = arg_19_0.vars.slot_lists[var_19_2][iter_19_4]
						
						if var_19_3 and var_19_4 and not var_19_4.is_update then
							var_19_4.is_update = true
							
							local var_19_5 = false
							
							if var_19_2 == arg_19_0.vars.user_uid and table.find(not_allow_flip_units, var_19_3.code) then
								var_19_5 = true
							end
							
							UIAction:Add(SEQ(CALL(function()
								arg_19_0:pickSlot(var_19_2, iter_19_4, var_19_4, true)
							end), DELAY(600), CALL(function()
								local var_21_0 = var_0_0(var_19_4, var_19_3, false, var_19_5)
								
								var_19_4.unit = var_21_0
								
								local var_21_1 = arg_19_0.vars.seq_info.seq == "PICK" and cc.c3b(255, 255, 255) or cc.c3b(95, 95, 95)
								
								if arg_19_0.vars.seq_info.seq ~= "BAN" then
									arg_19_0:updatePortrait(var_19_2, var_21_0, var_21_1)
								end
							end)), var_19_4, "draft.seq.bindUnitSlot")
						elseif not var_19_3 then
							var_19_4.unit = nil
							
							if_set_visible(var_19_4, "n_unit", false)
						end
					end
				end
			end
		end
		
		if HeroBelt:isValid() then
			HeroBelt:updateCurrentViewItems(9)
		end
	end
end
