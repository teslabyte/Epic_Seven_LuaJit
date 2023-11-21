ClanWarDetail = {}
CLAN_TOWER_BTN_STATE = {
	REMOVE = 1,
	SWAP = 2,
	ADD = 0,
	NONE = -1
}

function HANDLER.clan_war_detail(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_bg" then
		ClanWarDetail:zoomOut()
	end
	
	if arg_1_1 == "btn_organize" then
		ClanWarDetail:toggleEditView()
		TutorialGuide:procGuide()
	end
	
	if string.starts(arg_1_1, "btn_base_") then
		ClanWarDetail:focusIn(string.sub(arg_1_1, 10, -1))
	end
	
	if string.starts(arg_1_1, "btn_save") then
		ClanWarDetail:saveModify()
		TutorialGuide:procGuide()
	end
	
	if string.starts(arg_1_1, "btn_auto_place") then
		ClanWarDetail:autoModify()
		TutorialGuide:procGuide()
	end
	
	if string.starts(arg_1_1, "btn_arrange") or string.starts(arg_1_1, "btn_change") then
		ClanWarDetail:onEditMember(arg_1_0)
	end
	
	if arg_1_1 == "btn_history" then
		ClanWarHistory:open()
	end
	
	if arg_1_1 == "btn_member" then
		ClanWarStatusMain:open()
	end
end

function HANDLER.clan_war_base_info(arg_2_0, arg_2_1)
	if string.starts(arg_2_1, "btn_sel") then
		ClanWarDetail:focusIn(tostring(getParentWindow(arg_2_0).base_no))
	elseif string.starts(arg_2_1, "btn_add") then
		ClanWarDetail:onEditTower(arg_2_0, "add")
	elseif string.starts(arg_2_1, "btn_remove") then
		ClanWarDetail:onEditTower(arg_2_0, "remove")
	elseif string.starts(arg_2_1, "btn_change") then
		ClanWarDetail:onEditTower(arg_2_0, "swap")
	end
end

function ClanWarDetail.convertSlotIdToTowerId(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = ClanWarMain:getSubDB()[arg_3_1]
	
	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		if iter_3_1.slot == tonumber(arg_3_2) then
			local var_3_1 = string.sub(iter_3_1.id, -2)
			
			return tonumber(var_3_1)
		end
	end
	
	return nil
end

function ClanWarDetail.convertTowerIdToSlotId(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = tostring(arg_4_1) .. "_" .. string.format("%02d", arg_4_2)
	local var_4_1 = ClanWarMain:getSubDB()[arg_4_1][var_4_0] or {}
	
	return tostring(var_4_1.slot)
end

function ClanWarDetail.getBGInfo(arg_5_0)
	local var_5_0 = {}
	local var_5_1 = arg_5_0.vars.is_nexus and "castle" or "tower"
	local var_5_2 = arg_5_0.vars.is_enemy and "e" or "f"
	local var_5_3 = "clanwardepth02" .. var_5_1 .. var_5_2 .. ".png"
	
	var_5_0.bg = cc.Sprite:create("worldmap/" .. var_5_3)
	
	if arg_5_0.vars.is_nexus then
		var_5_0.offsetX = -200
		var_5_0.offsetY = 0
		var_5_0.touch_enable = false
	else
		var_5_0.touch_enable = true
	end
	
	return var_5_0
end

function ClanWarDetail.show(arg_6_0, arg_6_1, arg_6_2)
	arg_6_2 = arg_6_2 or {}
	arg_6_0.vars = {}
	arg_6_0.vars.is_nexus = arg_6_2.is_nexus
	arg_6_0.vars.is_enemy = string.starts(arg_6_2.fortress, "e")
	arg_6_0.vars.can_edit = Clan:isExecutAbleGrade(Clan:getMemberGrade(), "clan_war_defence_edit") and ClanWar:getMode() == CLAN_WAR_MODE.READY
	arg_6_0.vars.toggle_edit_view = false
	arg_6_0.vars.wnd = load_dlg("clan_war_detail", true, "wnd")
	
	local var_6_0 = arg_6_0:getBGInfo()
	
	var_6_0.bg:setPositionX(var_6_0.offsetX or 0)
	var_6_0.bg:setPositionY(var_6_0.offsetY or 0)
	arg_6_0.vars.wnd.c.n_bg:removeAllChildren()
	arg_6_0.vars.wnd.c.n_bg:addChild(var_6_0.bg)
	arg_6_0.vars.wnd.c.scrollview:setTouchEnabled(var_6_0.touch_enable)
	
	arg_6_0.vars.war_node = arg_6_0.vars.wnd:getChildByName("n_ing")
	
	arg_6_0.vars.war_node:setVisible(ClanWar:getMode() == CLAN_WAR_MODE.WAR)
	if_set_visible(arg_6_0.vars.wnd, "n_arange", false)
	if_set_visible(arg_6_0.vars.wnd, "n_right_team", arg_6_0.vars.can_edit)
	if_set_visible(arg_6_0.vars.wnd, "n_prepare_left", arg_6_0.vars.can_edit)
	
	local var_6_1 = arg_6_0.vars.wnd:getChildByName("btn_member")
	
	if var_6_1 and ClanWar:getMode() == CLAN_WAR_MODE.WAR then
		var_6_1:setPositionX(var_6_1:getPositionX() + 60)
	end
	
	arg_6_0.vars.wnd:setOpacity(0)
	UIAction:Add(SEQ(DELAY(400), FADE_IN(100)), arg_6_0.vars.wnd)
	arg_6_1:addChild(arg_6_0.vars.wnd)
	arg_6_0:initWarInfo()
	arg_6_0:initMapInfo()
	arg_6_0:initMemeberListView()
	arg_6_0:updateBuildingList()
	arg_6_0:updateMemberList()
	arg_6_0:setNormalState()
	
	local var_6_2 = arg_6_0.vars.wnd.c.scrollview:getContentSize()
	local var_6_3 = arg_6_0.vars.wnd.c.scrollview:getInnerContainerSize()
	
	var_6_3.width = var_6_2.width + (var_6_2.width - VIEW_WIDTH)
	
	arg_6_0.vars.wnd.c.scrollview:setInnerContainerSize(var_6_3)
	
	if arg_6_0.vars.is_nexus then
		local var_6_4 = 1
		local var_6_5, var_6_6 = arg_6_0.vars.wnd.c.n_base_1:getPosition()
		local var_6_7 = var_6_5 + 871 + VIEW_BASE_LEFT + ClanWarDetail.vars.wnd.c.scrollview:getInnerContainerPosition().x * (1 / var_6_4)
		local var_6_8 = var_6_6 + 45
		
		arg_6_0:resetAnchor(var_6_7, var_6_8)
		arg_6_0.vars.wnd.c.p_detail:setPosition(var_6_7, var_6_8)
	end
	
	return arg_6_0.vars.wnd
end

function ClanWarDetail.initMemeberListView(arg_7_0)
	local var_7_0 = arg_7_0.vars.wnd:getChildByName("ScrollView")
	
	arg_7_0.vars.memberListView = ItemListView_v2:bindControl(var_7_0)
	
	local var_7_1 = load_control("wnd/clan_war_member_item.csb")
	local var_7_2 = {
		onUpdate = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
			ClanWarDetail:updateItem(arg_8_1, arg_8_3)
			
			return arg_8_3.user_info.id
		end
	}
	
	arg_7_0.vars.memberListView:setRenderer(var_7_1, var_7_2)
	arg_7_0.vars.memberListView:removeAllChildren()
	arg_7_0.vars.memberListView:setDataSource({})
end

function ClanWarDetail.initWarInfo(arg_9_0)
	if ClanWar:getMode() == CLAN_WAR_MODE.READY then
		return 
	end
	
	UIUtil:updateClanEmblem(arg_9_0.vars.wnd:getChildByName("n_m_emblem"), Clan:getClanInfo())
	UIUtil:updateClanEmblem(arg_9_0.vars.wnd:getChildByName("n_e_emblem"), ClanWar:getEnemyClanInfo())
	
	local var_9_0 = ClanWarMain:getTotalScore(false)
	local var_9_1 = ClanWarMain:getTotalScore(true)
	
	arg_9_0:updateWarInfo(var_9_0, var_9_1)
end

function ClanWarDetail.getBaseMax(arg_10_0)
	local var_10_0 = 9
	
	if Account:getCurrentWarUId() >= 11 then
		var_10_0 = 10
	end
	
	return var_10_0
end

function ClanWarDetail.initMapInfo(arg_11_0)
	arg_11_0.vars.bases = {}
	
	local var_11_0 = ClanWarMain:getSelectedTowerID()
	local var_11_1 = arg_11_0:getBaseMax()
	
	for iter_11_0 = 1, var_11_1 do
		local var_11_2 = arg_11_0.vars.wnd.c["n_base_" .. iter_11_0]
		
		if not var_11_2 then
			break
		end
		
		local var_11_3 = load_control("wnd/clan_war_base_info.csb")
		
		if var_11_3 then
			var_11_3:setName("clan_war_base_info")
			var_11_3:setVisible(false)
			
			var_11_3.base_no = iter_11_0
			
			var_11_2:addChild(var_11_3)
		end
		
		local var_11_4 = arg_11_0:convertTowerIdToSlotId(var_11_0, iter_11_0)
		
		arg_11_0.vars.bases[iter_11_0] = {
			slot_id = var_11_4,
			base = var_11_2,
			info = var_11_3
		}
	end
end

function ClanWarDetail.updateWarInfo(arg_12_0, arg_12_1, arg_12_2)
	if ClanWar:getMode() == CLAN_WAR_MODE.READY then
		return 
	end
	
	if_set(arg_12_0.vars.war_node, "txt_my_point", tostring(arg_12_1))
	if_set(arg_12_0.vars.war_node, "txt_enemy_point", tostring(arg_12_2))
	
	local var_12_0 = arg_12_0.vars.war_node:getChildByName("pogress_bar_green")
	local var_12_1 = arg_12_1 + arg_12_2
	
	if var_12_1 == 0 then
		var_12_0:setPercent(50)
	else
		var_12_0:setPercent(math.clamp(arg_12_1 * 100 / var_12_1, 0, 100))
	end
	
	arg_12_0.vars.curMyPoint = arg_12_1
	arg_12_0.vars.curEnemyPoint = arg_12_2
end

function ClanWarDetail.getSubTowerIcon(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = tostring(arg_13_1) .. "_" .. string.format("%02d", arg_13_2)
	local var_13_1 = ClanWarMain:getSubDB()[arg_13_1][var_13_0] or {}
	
	if arg_13_3 > 0.5 then
		return var_13_1.default_icon, nil
	elseif arg_13_3 > 0 then
		return var_13_1.hp50_icon, var_13_1.hp50_effect
	else
		return var_13_1.hp0_icon, var_13_1.hp0_effect
	end
end

function ClanWarDetail.updateTowerState(arg_14_0)
	local var_14_0 = ClanWarMain:getSelectedTowerID()
	local var_14_1 = arg_14_0:getBaseMax()
	
	for iter_14_0 = 1, var_14_1 do
		local var_14_2 = arg_14_0.vars.bases[iter_14_0].base
		
		if not var_14_2 then
			break
		end
		
		local var_14_3 = arg_14_0.vars.bases[iter_14_0].slot_id
		local var_14_4, var_14_5 = ClanWarMain:getTowerHP(var_14_3, arg_14_0.vars.is_enemy)
		local var_14_6 = math.clamp(var_14_4 / var_14_5, 0, 1)
		local var_14_7, var_14_8 = arg_14_0:getSubTowerIcon(var_14_0, iter_14_0, var_14_6)
		local var_14_9 = ClanWarMain:isEmptySlot(var_14_3, arg_14_0.vars.is_enemy, {
			infos = arg_14_0.vars.towerInfos
		})
		
		if var_14_8 and (not var_14_2.cached_effect or var_14_2.cached_effect ~= var_14_8) then
			var_14_2:removeChildByName("townEffect")
			
			local var_14_10 = CACHE:getEffect(var_14_8)
			
			var_14_10:setName("townEffect")
			var_14_10:setPosition(0, iter_14_0 == 1 and -72 or -36)
			var_14_10:setLocalZOrder(99998)
			var_14_2:addChild(var_14_10)
			var_14_10:setVisible(true)
			var_14_10:start()
			
			var_14_2.cached_effect = var_14_8
		end
		
		if var_14_7 and (not var_14_2.cached_icon or var_14_2.cached_icon ~= var_14_7) then
			var_14_2:removeChildByName("townBG")
			
			local var_14_11 = SpriteCache:getSprite("map/" .. tostring(var_14_7))
			
			var_14_11:setName("townBG")
			var_14_11:setPosition(0, 0)
			var_14_11:setAnchorPoint(0.5, 0.5)
			var_14_2:addChild(var_14_11)
			
			var_14_2.cached_icon = var_14_7
		end
		
		if_set_color(var_14_2, "townBG", var_14_9 and cc.c3b(88, 88, 88) or cc.c3b(255, 255, 255))
		
		local var_14_12 = arg_14_0.vars.bases[iter_14_0].info
		
		if var_14_12 then
			var_14_12:setLocalZOrder(99999)
			var_14_12:getChildByName("n_hp"):setVisible(not var_14_9)
			var_14_12:getChildByName("hp"):setScaleX(var_14_6)
		end
	end
end

function ClanWarDetail.updateTowerMember(arg_15_0)
	local var_15_0 = ClanWarMain:getSelectedTowerID()
	
	for iter_15_0, iter_15_1 in pairs(arg_15_0.vars.towerInfos) do
		local var_15_1 = arg_15_0:convertSlotIdToTowerId(var_15_0, iter_15_1.slot) or 0
		local var_15_2 = (arg_15_0.vars.bases[var_15_1] or {}).info
		
		if var_15_2 then
			var_15_2:setVisible(true)
			
			if iter_15_1.user_info and iter_15_1.user_info.id then
				local var_15_3 = var_15_2:getChildByName("n_hero_leader")
				local var_15_4 = var_15_2:getChildByName("n_hero_general")
				
				var_15_3:setVisible(false)
				var_15_4:setVisible(false)
				
				local var_15_5 = iter_15_1.user_info.leader_code
				local var_15_6 = var_15_4
				
				var_15_6:setVisible(true)
				UIUtil:getRewardIcon(nil, var_15_5, {
					no_db_grade = true,
					no_popup = true,
					no_grade = true,
					parent = var_15_6:getChildByName("mob_icon"),
					is_enemy = arg_15_0.vars.is_enemy,
					border_code = iter_15_1.user_info.border_code
				})
				
				local var_15_7 = ClanWar:getMode() == CLAN_WAR_MODE.READY and ClanWar:isEmptyEquipUser(iter_15_1)
				
				if_set_visible(var_15_2, "talk_unequip", var_15_7)
				
				local var_15_8 = var_15_6:getChildByName("t_name")
				local var_15_9 = var_15_6:getChildByName("btn_hero")
				local var_15_10 = string.gsub(iter_15_1.user_info.name, "\n", "")
				
				var_15_8:setString(var_15_10)
				UIUserData:proc(var_15_9)
			else
				var_15_2:getChildByName("n_hero_leader"):setVisible(false)
				var_15_2:getChildByName("n_hero_general"):setVisible(false)
				if_set_visible(var_15_2, "talk_unequip", false)
			end
		end
	end
end

function ClanWarDetail.updateBuildingList(arg_16_0)
	arg_16_0.vars.towerInfos = {}
	
	local var_16_0 = {}
	
	arg_16_0.vars.towerInfos = table.clone(ClanWar:getBuildingMembers(arg_16_0.vars.is_enemy) or {})
	
	if arg_16_0.vars.is_enemy then
		var_16_0 = ClanWar:getEnemyUserInfos()
	else
		local var_16_1 = Clan:getMembers() or {}
		
		for iter_16_0, iter_16_1 in pairs(var_16_1) do
			if iter_16_1.user_info then
				var_16_0[iter_16_1.user_info.id] = iter_16_1.user_info
			end
		end
	end
	
	for iter_16_2, iter_16_3 in pairs(arg_16_0.vars.towerInfos) do
		if iter_16_3.defense_user_id then
			arg_16_0.vars.towerInfos[iter_16_2].user_info = iter_16_3.defense_user_info or var_16_0[tostring(iter_16_3.defense_user_id)]
		end
	end
end

function ClanWarDetail.updateMemberList(arg_17_0)
	arg_17_0.vars.memberInfos = {}
	
	local function var_17_0(arg_18_0, arg_18_1)
		arg_18_0 = arg_18_0 or {}
		arg_18_1 = arg_18_1 or {}
		
		for iter_18_0, iter_18_1 in pairs(arg_18_1) do
			local var_18_0 = UNIT:create(iter_18_1.unit)
			
			var_18_0:calc()
			
			for iter_18_2, iter_18_3 in pairs(iter_18_1.equips or {}) do
				local var_18_1 = EQUIP:createByInfo(iter_18_3)
				
				if var_18_1 then
					var_18_0:addEquip(var_18_1, true)
				end
			end
			
			table.insert(arg_18_0, var_18_0)
		end
	end
	
	local function var_17_1(arg_19_0, arg_19_1)
		for iter_19_0, iter_19_1 in pairs(arg_19_1 or {}) do
			if iter_19_1.unit and iter_19_1.unit.id then
				local var_19_0 = table.clone(Account:getUnit(iter_19_1.unit.id))
				
				if var_19_0 then
					table.insert(arg_19_0, var_19_0)
				end
			end
		end
	end
	
	local var_17_2 = {}
	
	for iter_17_0, iter_17_1 in pairs(Clan:getMembers()) do
		var_17_2[tostring(iter_17_1.user_info.id)] = iter_17_1.user_info
	end
	
	local var_17_3 = 0
	
	for iter_17_2, iter_17_3 in pairs(ClanWarMain:getLocalDefenseAbleMembers()) do
		local var_17_4 = {}
		
		if var_17_2[tostring(iter_17_2)] then
			var_17_4.user_info = var_17_2[tostring(iter_17_2)]
			var_17_4.team1 = {}
			var_17_4.team2 = {}
			
			if tonumber(iter_17_2) == tonumber(AccountData.id) then
				var_17_1(var_17_4.team1, iter_17_3.team1_units)
				var_17_1(var_17_4.team2, iter_17_3.team2_units)
			else
				var_17_0(var_17_4.team1, iter_17_3.team1_units)
				var_17_0(var_17_4.team2, iter_17_3.team2_units)
			end
			
			var_17_4.point = iter_17_3.team1_point + iter_17_3.team2_point
			var_17_4.arranged = arg_17_0:isMemberArranged(var_17_4.user_info.id)
			var_17_3 = var_17_3 + 1
			var_17_4.sort_point = var_17_4.point
			
			if var_17_4.arranged then
				var_17_4.sort_point = var_17_4.sort_point - 10000000
			end
			
			table.insert(arg_17_0.vars.memberInfos, var_17_4)
		end
	end
	
	table.sort(arg_17_0.vars.memberInfos, function(arg_20_0, arg_20_1)
		return arg_20_0.sort_point > arg_20_1.sort_point
	end)
	arg_17_0.vars.memberListView:removeAllChildren()
	arg_17_0.vars.memberListView:setDataSource(arg_17_0.vars.memberInfos)
	
	local var_17_5 = getChildByPath(arg_17_0.vars.wnd, "n_arange/n_arrange")
	
	if var_17_5 then
		if_set(var_17_5, "txt_title", T("war_ui_0007", {
			count = var_17_3
		}))
	end
end

function ClanWarDetail.updateItem(arg_21_0, arg_21_1, arg_21_2)
	local function var_21_0(arg_22_0, arg_22_1, arg_22_2)
		for iter_22_0, iter_22_1 in pairs(arg_22_2) do
			local var_22_0 = "mob_icon" .. tostring(arg_22_1)
			
			UIUtil:getRewardIcon(nil, iter_22_1:getDisplayCode(), {
				no_db_grade = true,
				role = true,
				no_popup = true,
				parent = arg_22_0:getChildByName(var_22_0),
				lv = iter_22_1:getLv(),
				max_lv = iter_22_1:getMaxLevel(),
				grade = iter_22_1:getGrade(),
				zodiac = iter_22_1:getZodiacGrade(),
				awake = iter_22_1:getAwakeGrade(),
				is_enemy = arg_21_0.vars.is_enemy
			})
			
			arg_22_1 = arg_22_1 + 1
		end
	end
	
	if arg_21_1.data ~= arg_21_2 then
		UIUtil:setLevel(arg_21_1:getChildByName("n_lv"), arg_21_2.user_info.level, MAX_ACCOUNT_LEVEL, 2)
		if_set(arg_21_1, "t_name", arg_21_2.user_info.name)
		if_set(arg_21_1, "txt_point", comma_value(arg_21_2.point))
		if_set(arg_21_1, "t_last_login", T("friend_logout", {
			time = sec_to_string(os.time() - arg_21_2.user_info.login_tm)
		}))
		
		if arg_21_2.user_info then
			local var_21_1 = arg_21_1:getChildByName("btn_arrange")
			local var_21_2 = arg_21_1:getChildByName("btn_change")
			local var_21_3 = arg_21_2.arranged
			
			if var_21_1 then
				var_21_1.user_id = arg_21_2.user_info.id
				
				var_21_1:setVisible(not var_21_3)
			end
			
			if var_21_2 then
				var_21_2.user_id = arg_21_2.user_info.id
				
				var_21_2:setVisible(var_21_3)
			end
			
			if_set_visible(arg_21_1, "n_change_info", var_21_3)
		end
		
		var_21_0(arg_21_1, 1, arg_21_2.team1)
		var_21_0(arg_21_1, 4, arg_21_2.team2)
	end
end

function ClanWarDetail.focusIn(arg_23_0, arg_23_1)
	local var_23_0 = ClanWarMain:getSelectedTowerID()
	local var_23_1 = arg_23_0:convertTowerIdToSlotId(var_23_0, arg_23_1)
	
	if ClanWarMain:isEmptySlot(var_23_1, arg_23_0.vars.is_enemy, {
		infos = arg_23_0.vars.towerInfos
	}) then
		return 
	end
	
	if arg_23_0.vars.tower then
		return 
	end
	
	if arg_23_0.vars.toggle_edit_view then
		return 
	end
	
	if not arg_23_0.vars.is_nexus then
		arg_23_0.vars.wnd.c.scrollview:stopAutoScroll()
		arg_23_0.vars.wnd.c.scrollview:setTouchEnabled(false)
	end
	
	eff_slide_out(arg_23_0.vars.wnd, "n_detail_left", 300, 0, false, -300)
	if_set_visible(arg_23_0.vars.wnd, "n_arange", false)
	if_set_visible(arg_23_0.vars.wnd, "n_prepare_left", false)
	if_set_visible(arg_23_0.vars.wnd, "btn_member", false)
	ClanWarReady:show(arg_23_0.vars.wnd.c.n_ready_ui_layer, var_23_1, arg_23_0.vars.is_enemy)
	arg_23_0:zoomIn(arg_23_1)
end

function ClanWarDetail.focusOut(arg_24_0, arg_24_1)
	eff_slide_in(arg_24_0.vars.wnd, "n_detail_left", 300, 0, false, 300)
	
	if not arg_24_0.vars.is_nexus then
		arg_24_0.vars.wnd.c.scrollview:setTouchEnabled(true)
	end
	
	ClanWarReady:hide()
	if_set_visible(arg_24_0.vars.wnd, "n_prepare_left", arg_24_0.vars.can_edit)
	if_set_visible(arg_24_0.vars.wnd, "btn_member", true)
	
	if arg_24_1 then
		UIAction:Add(SEQ(DELAY(400), CALL(function()
			arg_24_0:refresh()
		end)), arg_24_0, "block")
	end
	
	arg_24_0:zoomOut()
end

function ClanWarDetail.zoomIn(arg_26_0, arg_26_1)
	local var_26_0 = 1
	local var_26_1, var_26_2 = arg_26_0.vars.wnd.c["n_base_" .. arg_26_1]:getPosition()
	local var_26_3 = var_26_1 + 685 + VIEW_BASE_LEFT + ClanWarDetail.vars.wnd.c.scrollview:getInnerContainerPosition().x * (1 / var_26_0)
	local var_26_4 = var_26_2 + 45
	
	arg_26_0:resetAnchor(var_26_3, var_26_4)
	arg_26_0.vars.wnd.c.p_detail:setPosition(var_26_3, var_26_4)
	UIAction:Add(LOG(SPAWN(SCALE(400, 1, var_26_0), MOVE_TO(400, 640, 360))), arg_26_0.vars.wnd.c.p_detail)
	
	arg_26_0.vars.tower = arg_26_1
	
	arg_26_0:updateTowerTag()
end

function ClanWarDetail.zoomOut(arg_27_0)
	if not arg_27_0.vars.focus_pt then
		return 
	end
	
	local var_27_0 = 1
	
	arg_27_0:resetAnchor(arg_27_0.vars.focus_pt.x, arg_27_0.vars.focus_pt.y)
	arg_27_0.vars.wnd.c.p_detail:setVisible(true)
	arg_27_0.vars.wnd.c.p_detail:setOpacity(255)
	UIAction:Add(LOG(SPAWN(SCALE(400, var_27_0, 1), MOVE_TO(400, arg_27_0.vars.focus_pt.x, arg_27_0.vars.focus_pt.y))), arg_27_0.vars.wnd.c.p_detail)
	
	arg_27_0.vars.focus_pt = nil
	arg_27_0.vars.tower = nil
	
	arg_27_0:updateTowerTag()
end

function ClanWarDetail.resetAnchor(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0 = arg_28_1 / 1280
	local var_28_1 = arg_28_2 / 720
	
	arg_28_0.vars.focus_pt = {
		x = arg_28_1,
		y = arg_28_2
	}
	
	arg_28_0.vars.wnd.c.p_detail:setAnchorPoint(var_28_0, var_28_1)
end

function ClanWarDetail.onPushBackGround(arg_29_0)
	print("not implement yet")
end

function ClanWarDetail.onPushBackButton(arg_30_0)
	if arg_30_0.vars.toggle_edit_view then
		arg_30_0:updateBuildingList()
		arg_30_0:updateMemberList()
		arg_30_0:setNormalState()
		arg_30_0:toggleEditView()
		
		return 
	elseif not arg_30_0.vars.tower then
		ClanWarMain:focusOut()
		
		return 
	end
	
	arg_30_0:focusOut()
end

function ClanWarDetail.setNormalState(arg_31_0)
	arg_31_0.vars.selectedMember = nil
	
	arg_31_0:updateTowerState()
	arg_31_0:updateTowerMember()
	arg_31_0:updateTowerTag()
	arg_31_0:updateButtonStates()
	arg_31_0.vars.memberListView:refresh()
end

function ClanWarDetail.refresh(arg_32_0)
	if not arg_32_0.vars then
		return 
	end
	
	if not get_cocos_refid(arg_32_0.vars.wnd) then
		return 
	end
	
	arg_32_0:updateBuildingList()
	arg_32_0:updateMemberList()
	arg_32_0:setNormalState()
	ClanWarReady:refresh()
end

function ClanWarDetail.FindMemberInfo(arg_33_0, arg_33_1)
	for iter_33_0, iter_33_1 in pairs(arg_33_0.vars.memberInfos) do
		if arg_33_1 == iter_33_1.user_info.id then
			return iter_33_1
		end
	end
	
	return nil
end

function ClanWarDetail.FindSlotByUserId(arg_34_0, arg_34_1)
	for iter_34_0, iter_34_1 in pairs(arg_34_0.vars.towerInfos) do
		if iter_34_1.user_info and iter_34_1.user_info.id == arg_34_1 then
			return tostring(iter_34_1.slot)
		end
	end
	
	return nil
end

function ClanWarDetail.isMemberArranged(arg_35_0, arg_35_1)
	for iter_35_0, iter_35_1 in pairs(arg_35_0.vars.towerInfos) do
		if iter_35_1.user_info and iter_35_1.user_info.id == arg_35_1 then
			return true
		end
	end
	
	return false
end

function ClanWarDetail.onEditMember(arg_36_0, arg_36_1)
	arg_36_0.vars.selectedMember = arg_36_0:FindMemberInfo(arg_36_1.user_id)
	
	print("onEditMember step1", arg_36_0.vars.selectedMember, arg_36_1.user_id)
	arg_36_0:showEditView(true)
end

function ClanWarDetail.onEditTower(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = ClanWarMain:getSelectedTowerID()
	local var_37_1 = getParentWindow(arg_37_1).base_no
	local var_37_2 = arg_37_0:convertTowerIdToSlotId(var_37_0, var_37_1)
	
	print("onEditTower", arg_37_2, var_37_0, var_37_1, var_37_2)
	
	if arg_37_2 == "add" then
		arg_37_0:addAction(var_37_2)
	elseif arg_37_2 == "remove" then
		arg_37_0:removeAction(var_37_2)
	elseif arg_37_2 == "swap" then
		arg_37_0:swapAction(var_37_2)
	end
	
	arg_37_0:updateMemberList()
	arg_37_0:setNormalState()
end

function ClanWarDetail.addAction(arg_38_0, arg_38_1)
	if not arg_38_0.vars.towerInfos[arg_38_1] then
		return 
	end
	
	local var_38_0 = arg_38_0:FindSlotByUserId(arg_38_0.vars.selectedMember.user_info.id)
	
	if var_38_0 then
		arg_38_0:removeAction(var_38_0)
	end
	
	arg_38_0.vars.towerInfos[arg_38_1].user_info = arg_38_0.vars.selectedMember.user_info
	arg_38_0.vars.towerInfos[arg_38_1].team1 = arg_38_0.vars.selectedMember.team1
	arg_38_0.vars.towerInfos[arg_38_1].team2 = arg_38_0.vars.selectedMember.team2
end

function ClanWarDetail.removeAction(arg_39_0, arg_39_1)
	if not arg_39_0.vars.towerInfos[arg_39_1] then
		return 
	end
	
	arg_39_0.vars.towerInfos[arg_39_1].user_info = nil
	arg_39_0.vars.towerInfos[arg_39_1].defense_user_info = nil
	arg_39_0.vars.towerInfos[arg_39_1].team1 = nil
	arg_39_0.vars.towerInfos[arg_39_1].team2 = nil
end

function ClanWarDetail.swapAction(arg_40_0, arg_40_1)
	arg_40_0:addAction(arg_40_1)
end

function ClanWarDetail.toggleEditView(arg_41_0)
	arg_41_0.vars.toggle_edit_view = not arg_41_0.vars.toggle_edit_view
	
	if arg_41_0.vars.toggle_edit_view then
		eff_slide_in(arg_41_0.vars.wnd, "n_arange", 300, 0, false, -300)
		if_set_visible(arg_41_0.vars.wnd, "n_btn_left", true)
		if_set_visible(arg_41_0.vars.wnd, "n_prepare_left", false)
		if_set_visible(arg_41_0.vars.wnd, "btn_member", false)
		if_set_visible(arg_41_0.vars.wnd, "btn_history", true)
		arg_41_0:showEditView(true)
		
		if arg_41_0.vars.is_nexus then
			arg_41_0:zoomIn("1")
		elseif arg_41_0.vars.can_edit then
			local var_41_0 = 516
			local var_41_1 = arg_41_0.vars.wnd.c.scrollview:getInnerContainerSize()
			
			var_41_1.width = var_41_1.width + var_41_0
			
			arg_41_0.vars.wnd.c.scrollview:setInnerContainerSize(var_41_1)
		end
	else
		eff_slide_out(arg_41_0.vars.wnd, "n_arange", 300, 0, false, 300)
		if_set_visible(arg_41_0.vars.wnd, "n_btn_left", false)
		if_set_visible(arg_41_0.vars.wnd, "n_prepare_left", arg_41_0.vars.can_edit)
		if_set_visible(arg_41_0.vars.wnd, "btn_member", true)
		if_set_visible(arg_41_0.vars.wnd, "btn_history", false)
		arg_41_0:showEditView(false)
		
		if arg_41_0.vars.is_nexus then
			arg_41_0:zoomOut()
		elseif arg_41_0.vars.can_edit then
			local var_41_2 = 516
			local var_41_3 = arg_41_0.vars.wnd.c.scrollview:getInnerContainerSize()
			
			var_41_3.width = var_41_3.width - var_41_2
			
			arg_41_0.vars.wnd.c.scrollview:setInnerContainerSize(var_41_3)
		end
	end
end

function ClanWarDetail.showEditView(arg_42_0, arg_42_1)
	arg_42_0:updateTowerTag()
	arg_42_0:updateButtonStates()
	
	if arg_42_1 then
		print("clan.build_start")
		LuaEventDispatcher:dispatchEvent("clan.build_start", {})
	end
end

function ClanWarDetail.updateTowerWarTag(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
	local var_43_0 = ClanWarMain:getSelectedTowerID()
	local var_43_1 = tonumber(arg_43_0:convertTowerIdToSlotId(var_43_0, arg_43_3))
	local var_43_2 = ClanWar:getSubTowerAttackers(var_43_1, arg_43_0.vars.is_enemy)
	local var_43_3 = not arg_43_4 and arg_43_2 and #var_43_2 > 0
	
	if_set_visible(arg_43_1, "n_ing", var_43_3)
	
	if var_43_3 then
		if_set(arg_43_1, "t_count", T("war_ui_0088", {
			count = #var_43_2
		}))
	end
	
	local var_43_4, var_43_5 = ClanWarMain:canAttack(var_43_1, arg_43_0.vars.is_enemy)
	local var_43_6 = not arg_43_4 and (#var_43_2 >= 3 or var_43_5 == "same_enemy")
	
	if_set_visible(arg_43_1, "already", arg_43_0.vars.is_enemy and var_43_6)
	
	if Account:getCurrentWarUId() >= 4 then
		if_set_visible(arg_43_1, "n_protect", not arg_43_4 and var_43_5 == "remain_tower")
	else
		if_set_visible(arg_43_1, "n_protect", not arg_43_4 and (var_43_5 == "remain_building" or var_43_5 == "remain_tower"))
	end
end

function ClanWarDetail.updateTowerBtnTag(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	arg_44_1:getChildByName("n_btns"):setVisible(arg_44_2)
end

function ClanWarDetail.updateTowerTag(arg_45_0)
	print("CLAN WAR MODE", ClanWar:getMode(), arg_45_0.vars.toggle_edit_view)
	
	local var_45_0 = arg_45_0:getBaseMax()
	
	for iter_45_0 = 1, var_45_0 do
		local var_45_1 = arg_45_0.vars.tower ~= nil
		
		if not arg_45_0.vars.bases[iter_45_0] then
			break
		end
		
		local var_45_2 = arg_45_0.vars.bases[iter_45_0].info
		
		if not var_45_2 then
			break
		end
		
		if ClanWar:getMode() == CLAN_WAR_MODE.READY and arg_45_0.vars.toggle_edit_view then
			arg_45_0:updateTowerWarTag(var_45_2, false, iter_45_0, var_45_1)
			arg_45_0:updateTowerBtnTag(var_45_2, true)
		elseif ClanWar:getMode() == CLAN_WAR_MODE.READY then
			arg_45_0:updateTowerWarTag(var_45_2, false, iter_45_0, var_45_1)
			arg_45_0:updateTowerBtnTag(var_45_2, false)
		elseif ClanWar:getMode() == CLAN_WAR_MODE.WAR then
			arg_45_0:updateTowerWarTag(var_45_2, true, iter_45_0, var_45_1)
			arg_45_0:updateTowerBtnTag(var_45_2, false)
		end
	end
end

function ClanWarDetail.updateButtonStates(arg_46_0)
	local var_46_0 = arg_46_0:getBaseMax()
	
	for iter_46_0 = 1, var_46_0 do
		if not arg_46_0.vars.bases[iter_46_0] then
			break
		end
		
		local var_46_1 = arg_46_0.vars.bases[iter_46_0].info
		
		if not var_46_1 then
			break
		end
		
		arg_46_0:changeButtonState(var_46_1, iter_46_0)
	end
end

function ClanWarDetail.changeButtonState(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = ClanWarMain:getSelectedTowerID()
	local var_47_1 = arg_47_0:convertTowerIdToSlotId(var_47_0, arg_47_2)
	local var_47_2 = arg_47_0.vars.towerInfos[var_47_1]
	
	if not var_47_2 then
		print("no tower info", var_47_1)
		arg_47_0:changeButton(arg_47_1, CLAN_TOWER_BTN_STATE.NONE)
		
		return 
	end
	
	if arg_47_0.vars.selectedMember then
		if not var_47_2.user_info then
			arg_47_0:changeButton(arg_47_1, CLAN_TOWER_BTN_STATE.ADD)
		elseif var_47_2.user_info.id ~= arg_47_0.vars.selectedMember.user_info.id then
			arg_47_0:changeButton(arg_47_1, CLAN_TOWER_BTN_STATE.SWAP)
		else
			arg_47_0:changeButton(arg_47_1, CLAN_TOWER_BTN_STATE.NONE)
		end
	elseif var_47_2.user_info then
		arg_47_0:changeButton(arg_47_1, CLAN_TOWER_BTN_STATE.REMOVE)
	else
		arg_47_0:changeButton(arg_47_1, CLAN_TOWER_BTN_STATE.NONE)
	end
end

function ClanWarDetail.changeButton(arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = arg_48_1:getChildByName("btn_add")
	local var_48_1 = arg_48_1:getChildByName("btn_remove")
	local var_48_2 = arg_48_1:getChildByName("btn_change")
	
	if CLAN_TOWER_BTN_STATE.ADD == arg_48_2 then
		var_48_1:setVisible(false)
		var_48_2:setVisible(false)
		var_48_0:setVisible(true)
	elseif CLAN_TOWER_BTN_STATE.REMOVE == arg_48_2 then
		var_48_1:setVisible(true)
		var_48_2:setVisible(false)
		var_48_0:setVisible(false)
	elseif CLAN_TOWER_BTN_STATE.SWAP == arg_48_2 then
		var_48_1:setVisible(false)
		var_48_2:setVisible(true)
		var_48_0:setVisible(false)
	elseif CLAN_TOWER_BTN_STATE.NONE == arg_48_2 then
		var_48_1:setVisible(false)
		var_48_2:setVisible(false)
		var_48_0:setVisible(false)
	end
end

function ClanWarDetail.autoModify(arg_49_0)
	local var_49_0 = ClanWarMain:getSelectedTowerID()
	
	local function var_49_1()
		for iter_50_0, iter_50_1 in pairs(arg_49_0.vars.memberInfos) do
			if not arg_49_0:isMemberArranged(iter_50_1.user_info.id) then
				return iter_50_1
			end
		end
		
		return nil
	end
	
	local var_49_2 = arg_49_0:getBaseMax()
	
	for iter_49_0 = 1, var_49_2 do
		local var_49_3 = arg_49_0:convertTowerIdToSlotId(var_49_0, iter_49_0)
		local var_49_4 = arg_49_0.vars.towerInfos[var_49_3]
		
		if var_49_4 and not var_49_4.user_info then
			arg_49_0.vars.selectedMember = var_49_1()
			
			if arg_49_0.vars.selectedMember then
				arg_49_0:addAction(var_49_3)
			end
			
			arg_49_0.vars.selectedMember = nil
		end
	end
	
	arg_49_0:setNormalState()
end

function ClanWarDetail.isTowerSlotEmpty(arg_51_0)
	if Account:getCurrentWarUId() < 4 then
		return false
	end
	
	if not arg_51_0.vars or not arg_51_0.vars.bases or not arg_51_0.vars.bases[1] then
		return 
	end
	
	local var_51_0 = arg_51_0:getBaseMax()
	
	for iter_51_0 = 1, var_51_0 do
		local var_51_1 = arg_51_0.vars.bases[iter_51_0].slot_id
		
		if not ClanWarMain:isEmptySlot(var_51_1, arg_51_0.vars.is_enemy, {
			infos = arg_51_0.vars.towerInfos
		}) then
			local var_51_2 = arg_51_0.vars.bases[1].slot_id
			
			return (ClanWarMain:isEmptySlot(var_51_2, arg_51_0.vars.is_enemy, {
				infos = arg_51_0.vars.towerInfos
			}))
		end
	end
	
	return false
end

function ClanWarDetail.saveModify(arg_52_0)
	local function var_52_0()
		local var_53_0 = {}
		
		for iter_53_0, iter_53_1 in pairs(arg_52_0.vars.towerInfos) do
			if iter_53_1.slot and iter_53_1.user_info and iter_53_1.user_info.id then
				local var_53_1 = {
					slot = iter_53_1.slot,
					id = iter_53_1.user_info.id
				}
				
				table.insert(var_53_0, var_53_1)
			end
		end
		
		return var_53_0
	end
	
	if not arg_52_0.vars.towerInfos or not arg_52_0.vars.towerInfos["1"] or not arg_52_0.vars.towerInfos["1"].user_info then
		Dialog:msgBox(T("war_ui_desc5"))
		
		return 
	end
	
	if ClanWarDetail:isTowerSlotEmpty() then
		Dialog:msgBox(T("war_ui_desc12"))
		
		return 
	end
	
	local var_52_1 = var_52_0()
	
	ClanWar:query("set_clan_war_building_member_list", nil, {
		member_list = json.encode(var_52_1)
	})
end
