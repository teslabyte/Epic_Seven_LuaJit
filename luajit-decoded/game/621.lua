WorldBossReady = {}
WorldBossSupport = {}

local var_0_0 = 5
local var_0_1 = 3

function HANDLER.clan_worldboss_ready(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_organ" then
		WorldBossReady:setBestFormation()
	elseif arg_1_1 == "btn_ignore" then
		local var_1_0 = WorldBossReady:getGroupEditor()
		
		if var_1_0 then
			var_1_0:setNormalMode()
		end
	elseif arg_1_1 == "btn_supporter" then
		WorldBossReady:setNormalMode()
		WorldBossPopup:setMode("supporter")
	elseif arg_1_1 == "btn_go" then
		WorldBossReady:checkEnterable()
	end
end

function HANDLER.clan_worldboss_support_sel(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_go" then
		if WorldBossReady:isShow() and WorldBossSupport:getCurSupportTeam() then
			WorldBossReady:setSupporterTeam(WorldBossSupport:getCurSupportTeam())
			WorldBossSupport:onHide()
			WorldBossPopup:setMode("ready")
		elseif WorldBossSupport:getCurSupportTeam() then
			WorldBossPopup:setMode("ready")
		end
	end
end

function HANDLER.clan_worldboss_support_sel_item(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_dedi" then
		if arg_3_0.item then
			FormationEditor:showDedicationPopupExtension(arg_3_0.item)
		end
	elseif arg_3_1 == "btn_more" then
		WorldBossSupport:req_PlayerSupporterTeams()
	end
end

function ErrHandler.worldboss_battle(arg_4_0, arg_4_1, arg_4_2)
	if Clan:noClanSendToLobby(arg_4_1) then
		return 
	end
	
	if WorldBossReady:noSendToClan(arg_4_1) then
		return 
	end
	
	if WorldBossMap:sendToWorldboss_map(arg_4_1) then
		return 
	end
	
	Dialog:msgBox(T(arg_4_1))
end

function MsgHandler.worldboss_clan_support_list(arg_5_0)
	if arg_5_0 and arg_5_0.supporter_list and table.count(arg_5_0.supporter_list) > 5 then
		WorldBossSupport:createPlayerSupporterTeams(arg_5_0)
	elseif WorldBossSupport:getSupporterList_page() <= 2 then
		WorldBossSupport:createPlayerSupporterTeams(arg_5_0)
	else
		WorldBossSupport:res_morePlayerSupporterTeams(arg_5_0)
	end
end

function MsgHandler.worldboss_battle(arg_6_0)
	local var_6_0 = arg_6_0
	
	if var_6_0.res == "ok" then
		ConditionContentsManager:dispatch("worldboss.clear")
		
		for iter_6_0, iter_6_1 in pairs(var_6_0.reward_result) do
			Account:addReward(iter_6_1)
		end
		
		Singular:event("join_worldboss")
		Account:updateCurrencies(var_6_0.static_result)
		Account:updateCurrencies(var_6_0.update_currencies, {
			use_stamina = GAME_STATIC_VARIABLE.worldboss_join_stamina
		})
		
		var_6_0.season_data = WorldBossSupport:getCurrentWorldboss_info()
		
		TopBarNew:pop()
		
		local var_6_1, var_6_2 = WorldBossUtil:getWorldbossStory(var_6_0.season_data.boss_id)
		
		local function var_6_3()
			var_6_0.supporter_userInfo = WorldBossReady:get_supporterUserInfo()
			
			startWorldboss(var_6_0)
		end
		
		if WorldBossReady.vars and WorldBossReady.vars.isPlayStory then
			var_6_0.isPlayStory = WorldBossReady.vars.isPlayStory
			var_6_0.isPlayEndStory = WorldBossReady.vars.isPlayEndStory
			var_6_0.endStoryID = var_6_2
			
			Account:mergePlayedStories(var_6_0.played_stories)
			play_story(var_6_1, {
				force_on_finish = true,
				force = true,
				on_finish = function()
					var_6_3()
				end
			})
		else
			var_6_3()
		end
	end
end

WorldBossPopup = {}

function WorldBossPopup.onEnter(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0.vars = {}
	arg_9_0.vars.base = cc.Layer:create()
	
	WorldBossMap:getWnd():addChild(arg_9_0.vars.base)
	TopBarNew:createFromPopup(T("worldboss_main_title"), arg_9_0.vars.base, function()
		WorldBossPopup:onLeave()
	end)
	
	arg_9_0.vars.bossInfo = arg_9_1
	arg_9_0.vars.bonus_data = arg_9_2
	arg_9_0.vars.mode = "supporter"
	
	arg_9_0:setMode(arg_9_0.vars.mode)
end

function WorldBossPopup.getLayer(arg_11_0)
	return arg_11_0.vars.base
end

function WorldBossPopup.setMode(arg_12_0, arg_12_1)
	if not arg_12_0.vars or not arg_12_1 then
		return 
	end
	
	if arg_12_1 == "supporter" then
		WorldBossSupport:onEnter(arg_12_0.vars.bossInfo, arg_12_0.vars.bonus_data)
		WorldBossReady:onHide()
		TopBarNew:checkhelpbuttonID("infowboss")
		TopBarNew:setEnableTopRight()
		
		arg_12_0.vars.mode = arg_12_1
	elseif arg_12_1 == "ready" then
		WorldBossReady:onEnter(WorldBossSupport:getCurSupportTeam(), WorldBossSupport:getCurrentWorldboss_info(), WorldBossSupport:getBonusData())
		WorldBossSupport:onHide()
		TopBarNew:checkhelpbuttonID("infowboss")
		TopBarNew:setDisableTopRight()
		
		arg_12_0.vars.mode = arg_12_1
	end
end

function WorldBossPopup.onLeave(arg_13_0)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.base) then
		return 
	end
	
	BackButtonManager:pop()
	TopBarNew:pop()
	arg_13_0.vars.base:removeFromParent()
	
	arg_13_0.vars = {}
	WorldBossReady.vars = {}
	WorldBossSupport.vars = {}
end

local var_0_2 = {
	"warrior",
	"knight",
	"assassin",
	"ranger",
	"mage",
	"manauser"
}

function WorldBossReady.isShow(arg_14_0)
	if not arg_14_0.vars or not get_cocos_refid(arg_14_0.vars.wnd) then
		return false
	end
	
	return true
end

function WorldBossReady.onEnter(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	if not arg_15_1 then
		Log.e("Error 서포터없이는 입장불가")
		
		return 
	end
	
	if arg_15_0:isShow() then
		arg_15_0:onShow()
		
		return 
	end
	
	arg_15_0.vars = {}
	arg_15_0.vars.team1 = {}
	arg_15_0.vars.team2 = {}
	arg_15_0.vars.team3 = {}
	arg_15_0.vars.bossInfo = arg_15_2
	arg_15_0.vars.worldboss_color = arg_15_2.color
	arg_15_0.vars.strong_roles = arg_15_3
	arg_15_0.vars.except_units = WorldBossMap:getLimitUnits("unit")
	arg_15_0.vars.wnd = load_dlg("clan_worldboss_ready", true, "wnd")
	
	;(WorldBossPopup:getLayer(arg_15_0) or SceneManager:getRunningNativeScene()):addChild(arg_15_0.vars.wnd)
	arg_15_0:init()
	arg_15_0:setSupporterTeam(arg_15_1)
	TutorialGuide:procGuide()
end

function WorldBossReady.isShow(arg_16_0)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.wnd) then
		return false
	end
	
	return true
end

function WorldBossReady.onShow(arg_17_0)
	if not arg_17_0.vars or not get_cocos_refid(arg_17_0.vars.wnd) then
		return 
	end
	
	arg_17_0.vars.wnd:setVisible(true)
end

function WorldBossReady.changeSupporterTeam(arg_18_0, arg_18_1)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.wnd) then
		return 
	end
	
	arg_18_0:setSupporterTeam(arg_18_0, arg_18_1)
	arg_18_0:update_roleCount()
end

function WorldBossReady.setSupporterTeam(arg_19_0, arg_19_1)
	if arg_19_0.vars.supporter_team == arg_19_1 then
		return 
	end
	
	arg_19_0.vars.supporter_team = arg_19_1
	
	if not arg_19_1 then
		return 
	end
	
	arg_19_0:setSupporterUI(arg_19_1)
end

function WorldBossReady.setSupporterUI(arg_20_0, arg_20_1)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.wnd) then
		return 
	end
	
	if not arg_20_1 then
	end
	
	local var_20_0 = arg_20_0.vars.wnd:getChildByName("btn_supporter")
	local var_20_1 = true
	local var_20_2
	local var_20_3 = 0
	
	for iter_20_0 = 1, 4 do
		if_set_visible(var_20_0, "mob_icon" .. iter_20_0, false)
	end
	
	for iter_20_1, iter_20_2 in pairs(arg_20_1) do
		local var_20_4 = var_20_0:getChildByName("mob_icon" .. iter_20_1)
		
		if not var_20_4 then
			break
		end
		
		var_20_4:setVisible(true)
		
		if iter_20_2.owner_info then
			var_20_1 = false
			var_20_2 = iter_20_2.owner_info
			
			if iter_20_2.team_power then
				var_20_3 = iter_20_2.team_power
			end
		end
		
		UIUtil:getUserIcon(iter_20_2, {
			no_popup = true,
			no_tooltip = true,
			parent = var_20_4
		})
	end
	
	if var_20_1 then
		if_set_visible(var_20_0, "n_npc", true)
		if_set_visible(var_20_0, "n_name", false)
		
		local var_20_5 = Team:makeTeamData(arg_20_1)
		local var_20_6 = Team:makeTeam(var_20_5)
		
		if_set_visible(var_20_0, "n_npc_power", true)
		if_set(var_20_0:getChildByName("n_npc_power"), "txt_point", comma_value(var_20_6:getPoint()))
	else
		if_set_visible(var_20_0, "n_npc", false)
		if_set_visible(var_20_0, "n_name", true)
		
		if var_20_2 then
			if_set(var_20_0, "t_name", var_20_2.name)
			UIUtil:setLevel(var_20_0:getChildByName("n_name"):getChildByName("n_lv"), var_20_2.level, MAX_ACCOUNT_LEVEL, 2)
			arg_20_0:set_supporterUserInfo(var_20_2)
		end
		
		if var_20_3 > 0 and var_20_0:getChildByName("n_power") then
			if_set(var_20_0:getChildByName("n_power"), "txt_point", comma_value(var_20_3))
		end
	end
	
	WorldBossReady:update_roleCount()
end

function WorldBossReady.init(arg_21_0)
	if_set_visible(arg_21_0.vars.wnd, "n_dedi_tooltip_slide", false)
	
	local var_21_0 = load_dlg("clan_worldboss_formation", true, "wnd")
	local var_21_1 = load_dlg("clan_worldboss_formation", true, "wnd")
	local var_21_2 = load_dlg("clan_worldboss_formation", true, "wnd")
	
	if_set_visible(var_21_0, "bar_visible", false)
	
	local var_21_3 = var_21_2:getChildByName("n_btn_dedi")
	
	if var_21_3 then
		var_21_3:setPositionX(var_21_3:getPositionX() + 29)
	end
	
	arg_21_0.vars.wnd:getChildByName("round1"):addChild(var_21_0)
	arg_21_0.vars.wnd:getChildByName("round2"):addChild(var_21_1)
	arg_21_0.vars.wnd:getChildByName("round3"):addChild(var_21_2)
	var_21_0:setAnchorPoint(0, 0)
	var_21_1:setAnchorPoint(0, 0)
	var_21_2:setAnchorPoint(0, 0)
	var_21_0:setPosition(0, 0)
	var_21_1:setPosition(0, 0)
	var_21_2:setPosition(0, 0)
	
	local var_21_4 = {
		{
			group_name = "world_boss_team1",
			max_unit = 4,
			can_edit = true,
			custom = true,
			wnd = var_21_0,
			title = {
				cont = "txt_round",
				ignore_team_selector = true,
				max_unit = 4,
				text = T("ui_clan_worldboss_formation_team", {
					team_number = 1
				})
			}
		},
		{
			group_name = "world_boss_team2",
			max_unit = 4,
			can_edit = true,
			custom = true,
			wnd = var_21_1,
			title = {
				cont = "txt_round",
				ignore_team_selector = true,
				max_unit = 4,
				text = T("ui_clan_worldboss_formation_team", {
					team_number = 2
				})
			}
		},
		{
			group_name = "world_boss_team3",
			max_unit = 4,
			can_edit = true,
			custom = true,
			wnd = var_21_2,
			title = {
				cont = "txt_round",
				ignore_team_selector = true,
				max_unit = 4,
				text = T("ui_clan_worldboss_formation_team", {
					team_number = 3
				})
			}
		}
	}
	local var_21_5 = {}
	
	GroupFormationEditor:initFormationEditor(var_21_5, {
		sprite_mode = true,
		least_unit = 0,
		notUseTouchHandler = true,
		hide_hpbar = true,
		useSimpleTag = true,
		tagScale = 1,
		tagOffsetY = 45,
		max_unit = 4,
		hide_hpbar_color = true,
		infos = var_21_4,
		callbackUpdateFormation = function(arg_22_0)
			HeroBelt:updateTeamMarkers()
			WorldBossReady:update_roleCount()
		end,
		callbackSelectUnit = function(arg_23_0)
			HeroBelt:scrollToUnit(arg_23_0)
		end,
		callbackSelectTeam = function(arg_24_0)
			arg_21_0:setTeam(arg_24_0)
		end,
		callbackUpdatePoint = function(arg_25_0)
			arg_21_0:updatePoint(arg_25_0)
		end,
		callbackCanAddUnit = function(arg_26_0)
			return true
		end
	})
	
	arg_21_0.vars.group_editor = var_21_5
	
	arg_21_0:createHeroBelt("worldboss")
	arg_21_0:updateGroupFormation()
	
	local var_21_6 = WorldBossUtil:getBossHP(arg_21_0.vars.bossInfo.start_time, arg_21_0.vars.bossInfo.end_time)
	
	WorldBossUtil:setHPBar(arg_21_0.vars.wnd:getChildByName("n_gauge"), var_21_6)
	
	local var_21_7 = "img/cm_icon_pro"
	
	if arg_21_0.vars.worldboss_color == "light" or arg_21_0.vars.worldboss_color == "dark" then
		var_21_7 = var_21_7 .. "m"
	end
	
	local var_21_8 = var_21_7 .. arg_21_0.vars.worldboss_color .. ".png"
	
	if_set_sprite(arg_21_0.vars.wnd, "icon_element", var_21_8)
	
	local var_21_9 = arg_21_0.vars.wnd:getChildByName("btn_go")
	
	if var_21_9 then
		if_set(var_21_9, "cost", GAME_STATIC_VARIABLE.worldboss_join_stamina .. "/" .. Account:getCurrency("stamina"))
	end
	
	local var_21_10 = WorldBossUtil:getWorldbossCharID(arg_21_0.vars.bossInfo.boss_id)
	
	UIUtil:getUserIcon(var_21_10, {
		no_lv = true,
		no_role = true,
		no_grade = true,
		parent = arg_21_0.vars.wnd:getChildByName("mob_icon")
	})
	
	local var_21_11 = WorldBossUtil:getWorldbossName(arg_21_0.vars.bossInfo.boss_id)
	
	if_set(arg_21_0.vars.wnd, "t_boss_name", var_21_11)
	
	for iter_21_0, iter_21_1 in pairs(arg_21_0.vars.strong_roles) do
		if_set_sprite(arg_21_0.vars.wnd, "icon_role" .. iter_21_0, "img/cm_icon_role_" .. iter_21_1 .. ".png")
	end
end

function WorldBossReady.set_supporterUserInfo(arg_27_0, arg_27_1)
	if not arg_27_0.vars or not arg_27_1 then
		return 
	end
	
	arg_27_0.vars.supporter_userInfo = arg_27_1
end

function WorldBossReady.get_supporterUserInfo(arg_28_0)
	if not arg_28_0.vars or not arg_28_0.vars.supporter_userInfo then
		return nil
	end
	
	return arg_28_0.vars.supporter_userInfo
end

function WorldBossReady.getGroupEditor(arg_29_0)
	if not arg_29_0.vars or not arg_29_0.vars.group_editor then
		return false
	end
	
	return arg_29_0.vars.group_editor
end

function WorldBossReady.updateGroupFormation(arg_30_0)
	arg_30_0.vars.group_editor:updateGroupFormation("world_boss_team1", arg_30_0.vars.team1)
	arg_30_0.vars.group_editor:updateGroupFormation("world_boss_team2", arg_30_0.vars.team2)
	arg_30_0.vars.group_editor:updateGroupFormation("world_boss_team3", arg_30_0.vars.team3)
end

function WorldBossReady.setNormalMode(arg_31_0)
	local var_31_0 = WorldBossReady:getGroupEditor()
	
	if var_31_0 then
		var_31_0:setNormalMode()
	end
end

function WorldBossReady.setBestFormation(arg_32_0)
	arg_32_0:setNormalMode()
	
	local var_32_0 = get_best_formation(arg_32_0.vars.supporter_team, arg_32_0.vars.except_units, arg_32_0.vars.strong_roles, arg_32_0.vars.worldboss_color)
	local var_32_1 = 1
	local var_32_2 = 1
	local var_32_3 = {}
	local var_32_4 = {}
	local var_32_5 = {}
	local var_32_6
	
	if #var_32_0 == 8 then
		for iter_32_0, iter_32_1 in pairs(var_32_0) do
			if var_32_1 <= 3 then
				table.insert(var_32_3, iter_32_1)
			elseif var_32_1 <= 6 then
				if var_32_2 >= 4 then
					var_32_2 = 0
				end
				
				table.insert(var_32_4, iter_32_1)
			else
				if var_32_2 >= 4 then
					var_32_2 = 0
				end
				
				table.insert(var_32_5, iter_32_1)
			end
			
			var_32_1 = var_32_1 + 1
			var_32_2 = var_32_2 + 1
		end
	elseif #var_32_0 == 9 then
		for iter_32_2, iter_32_3 in pairs(var_32_0) do
			if var_32_1 <= 4 then
				table.insert(var_32_3, iter_32_3)
			elseif var_32_1 <= 7 then
				if var_32_2 >= 4 then
					var_32_2 = 0
				end
				
				table.insert(var_32_4, iter_32_3)
			else
				if var_32_2 >= 4 then
					var_32_2 = 0
				end
				
				table.insert(var_32_5, iter_32_3)
			end
			
			var_32_1 = var_32_1 + 1
			var_32_2 = var_32_2 + 1
		end
	elseif #var_32_0 == 10 then
		for iter_32_4, iter_32_5 in pairs(var_32_0) do
			if var_32_1 <= 4 then
				table.insert(var_32_3, iter_32_5)
			elseif var_32_1 <= 7 then
				if var_32_2 >= 4 then
					var_32_2 = 0
				end
				
				table.insert(var_32_4, iter_32_5)
			else
				if var_32_2 >= 4 then
					var_32_2 = 0
				end
				
				table.insert(var_32_5, iter_32_5)
			end
			
			var_32_1 = var_32_1 + 1
			var_32_2 = var_32_2 + 1
		end
	else
		var_32_6 = 1
		
		for iter_32_6, iter_32_7 in pairs(var_32_0) do
			if var_32_6 <= 4 then
				table.insert(var_32_3, iter_32_7)
			elseif var_32_6 <= 8 then
				table.insert(var_32_4, iter_32_7)
			else
				table.insert(var_32_5, iter_32_7)
			end
			
			var_32_6 = var_32_6 + 1
		end
	end
	
	local var_32_7 = true
	
	if table.count(var_32_3) ~= table.count(arg_32_0.vars.team1) or table.count(var_32_4) ~= table.count(arg_32_0.vars.team2) or table.count(var_32_5) ~= table.count(arg_32_0.vars.team3) then
		var_32_7 = false
	end
	
	local var_32_8 = 0
	
	for iter_32_8, iter_32_9 in pairs(arg_32_0.vars.team1) do
		for iter_32_10, iter_32_11 in pairs(var_32_3) do
			if iter_32_9:getUID() == iter_32_11:getUID() then
				var_32_8 = var_32_8 + 1
				
				break
			end
		end
	end
	
	if var_32_8 < 4 then
		var_32_7 = false
	end
	
	local var_32_9 = 0
	
	for iter_32_12, iter_32_13 in pairs(arg_32_0.vars.team2) do
		for iter_32_14, iter_32_15 in pairs(var_32_4) do
			if iter_32_13:getUID() == iter_32_15:getUID() then
				var_32_9 = var_32_9 + 1
				
				break
			end
		end
	end
	
	if var_32_9 < 4 then
		var_32_7 = false
	end
	
	local var_32_10 = 0
	
	for iter_32_16, iter_32_17 in pairs(arg_32_0.vars.team3) do
		for iter_32_18, iter_32_19 in pairs(var_32_5) do
			if iter_32_17:getUID() == iter_32_19:getUID() then
				var_32_10 = var_32_10 + 1
				
				break
			end
		end
	end
	
	if var_32_10 < 4 then
		var_32_7 = false
	end
	
	local var_32_11 = 0
	
	if var_32_7 then
		return 
	end
	
	arg_32_0.vars.team1 = var_32_3
	arg_32_0.vars.team2 = var_32_4
	arg_32_0.vars.team3 = var_32_5
	
	arg_32_0:updateGroupFormation()
	TutorialGuide:procGuide()
end

function WorldBossReady.resetAllFormation(arg_33_0)
	arg_33_0.vars.team1 = {}
	arg_33_0.vars.team2 = {}
	arg_33_0.vars.team3 = {}
end

function WorldBossReady.update_roleCount(arg_34_0)
	arg_34_0.vars.role_count = {}
	arg_34_0.vars.strongColor_count = 0
	
	for iter_34_0, iter_34_1 in pairs(var_0_2) do
		arg_34_0.vars.role_count[iter_34_1] = 0
	end
	
	for iter_34_2 = 1, 3 do
		local var_34_0 = "world_boss_team" .. iter_34_2
		local var_34_1 = arg_34_0.vars.group_editor:getGroupEditor(var_34_0)
		
		if not var_34_1 then
			break
		end
		
		local var_34_2 = var_34_1:getTeam()
		
		if not var_34_2 then
			break
		end
		
		local var_34_3 = WorldBossUtil:getRoleCount(var_34_2)
		
		for iter_34_3, iter_34_4 in pairs(var_0_2) do
			arg_34_0.vars.role_count[iter_34_4] = arg_34_0.vars.role_count[iter_34_4] + var_34_3[iter_34_4]
		end
		
		arg_34_0.vars.strongColor_count = arg_34_0.vars.strongColor_count + WorldBossUtil:getStrongColorCount(var_34_2, arg_34_0.vars.worldboss_color)
	end
	
	if arg_34_0.vars.supporter_team then
		local var_34_4 = WorldBossUtil:getRoleCount(arg_34_0.vars.supporter_team)
		
		for iter_34_5, iter_34_6 in pairs(var_0_2) do
			arg_34_0.vars.role_count[iter_34_6] = arg_34_0.vars.role_count[iter_34_6] + var_34_4[iter_34_6]
		end
		
		arg_34_0.vars.strongColor_count = arg_34_0.vars.strongColor_count + WorldBossUtil:getStrongColorCount(arg_34_0.vars.supporter_team, arg_34_0.vars.worldboss_color)
	end
	
	local var_34_5 = arg_34_0.vars.wnd:getChildByName("n_count")
	
	for iter_34_7, iter_34_8 in pairs(var_0_2) do
		local var_34_6 = var_34_5:getChildByName("icon_" .. iter_34_8)
		
		if not var_34_6 then
			break
		end
		
		if_set(var_34_6, "t_count", arg_34_0.vars.role_count[iter_34_8])
	end
	
	local var_34_7 = arg_34_0.vars.wnd:getChildByName("n_mission")
	local var_34_8 = 0
	
	for iter_34_9, iter_34_10 in pairs(arg_34_0.vars.strong_roles) do
		local var_34_9 = arg_34_0.vars.role_count[iter_34_10]
		local var_34_10 = var_34_7:getChildByName("icon_role" .. iter_34_9)
		
		if var_34_9 >= 4 then
			var_34_9 = 4
			var_34_8 = var_34_8 + 1
			
			if_set_color(var_34_10, nil, tocolor("#FFFFFF"))
		else
			if_set_color(var_34_10, nil, tocolor("#ac0000"))
		end
		
		if var_34_10 then
			if_set(var_34_10, "t_count", var_34_9 .. "/4")
		end
	end
	
	if_set_visible(var_34_7, "cm_icon_check", var_34_8 >= 2)
	
	if var_34_8 >= 2 then
		if_set_color(var_34_7, "bg1", tocolor("#64CB00"))
	else
		if_set_color(var_34_7, "bg1", tocolor("#ac0000"))
	end
	
	local var_34_11 = arg_34_0.vars.wnd:getChildByName("n_count")
	
	if var_34_11 then
		local var_34_12 = var_34_11:getChildByName("icon_element")
		
		if_set(var_34_12, "t_count", arg_34_0.vars.strongColor_count)
	end
	
	arg_34_0:updateRoleIcons()
	arg_34_0:updateBonus()
end

function WorldBossReady.updateRoleIcons(arg_35_0)
	local var_35_0 = arg_35_0.vars.wnd:getChildByName("n_party_composition")
	
	for iter_35_0, iter_35_1 in pairs(var_0_2) do
		local var_35_1 = var_35_0:getChildByName("icon_" .. iter_35_1)
		
		if not var_35_1 then
			break
		end
		
		if arg_35_0.vars.role_count[iter_35_1] < 2 then
			if_set_color(var_35_1, nil, tocolor("#ac0000"))
		else
			if_set_color(var_35_1, nil, tocolor("#FFFFFF"))
		end
	end
end

function WorldBossReady.updateBonus(arg_36_0)
	local var_36_0 = 0 + arg_36_0:checkStrongColorBonus() + arg_36_0:checkStrongRoleBonus()
	local var_36_1, var_36_2 = arg_36_0:checkRoleBonus()
	local var_36_3 = var_36_0 + var_36_2
	local var_36_4 = 1000
	
	if_set(arg_36_0.vars.wnd, "t_set_count", var_36_1 .. "/2")
	
	if not arg_36_0.vars.bonusPoint then
		arg_36_0.vars.bonusPoint = var_36_3
		
		UIAction:Add(SEQ(INC_NUMBER(0, var_36_3, "%", 0)), arg_36_0.vars.wnd:getChildByName("t_bonus_up"), "inc_bonus")
	end
	
	if arg_36_0.vars.bonusPoint ~= var_36_3 then
		UIAction:Add(SEQ(INC_NUMBER(var_36_4, var_36_3, "%", 0)), arg_36_0.vars.wnd:getChildByName("t_bonus_up"), "inc_bonus")
		
		arg_36_0.vars.bonusPoint = var_36_3
	end
end

function WorldBossReady.checkStrongColorBonus(arg_37_0)
	return arg_37_0.vars.strongColor_count * GAME_STATIC_VARIABLE.worldboss_attribute_bonus * 100
end

function WorldBossReady.checkStrongRoleBonus(arg_38_0)
	local var_38_0 = 0
	
	for iter_38_0, iter_38_1 in pairs(arg_38_0.vars.strong_roles) do
		if arg_38_0.vars.role_count[iter_38_1] >= 4 then
			var_38_0 = var_38_0 + 1
		end
	end
	
	if var_38_0 == 2 then
		return GAME_STATIC_VARIABLE.worldboss_role_bonus * 100
	end
	
	return 0
end

function WorldBossReady.checkRoleBonus(arg_39_0)
	local var_39_0 = 2
	
	for iter_39_0, iter_39_1 in pairs(var_0_2) do
		local var_39_1 = arg_39_0.vars.role_count[iter_39_1]
		
		if var_39_1 <= 0 then
			return 0, 0
		elseif var_39_1 == 1 then
			var_39_0 = 1
		end
	end
	
	return var_39_0, var_39_0 * GAME_STATIC_VARIABLE.worldboss_role_complete_bonus * 100
end

function WorldBossReady.createHeroBelt(arg_40_0, arg_40_1)
	if not arg_40_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_40_0.vars.unit_dock) then
		arg_40_0.vars.unit_doc = nil
		
		HeroBelt:destroy()
	end
	
	arg_40_0.vars.unit_dock = HeroBelt:create(arg_40_1)
	
	arg_40_0.vars.unit_dock:setEventHandler(arg_40_0.onHeroListEvent, arg_40_0)
	arg_40_0.vars.unit_dock:getWindow():setLocalZOrder(9999)
	arg_40_0.vars.wnd:addChild(arg_40_0.vars.unit_dock:getWindow())
	
	local var_40_0 = arg_40_0:checkHeros()
	
	HeroBelt:resetData(var_40_0, arg_40_1, nil, nil, nil)
	
	local var_40_1 = arg_40_0.vars.unit_dock:getWindow():getPositionX()
	
	arg_40_0.vars.unit_dock:getWindow():setPositionX(var_40_1)
end

function WorldBossReady.checkHeros(arg_41_0)
	local var_41_0 = {}
	local var_41_1 = table.shallow_clone(Account.units)
	
	for iter_41_0, iter_41_1 in pairs(arg_41_0.vars.except_units) do
		for iter_41_2, iter_41_3 in pairs(var_41_1) do
			if tonumber(iter_41_3:getUID()) == tonumber(iter_41_1) then
				iter_41_3.isExclude = true
				
				break
			end
		end
	end
	
	for iter_41_4, iter_41_5 in pairs(var_41_1) do
		if iter_41_5:isGrowthBoostRegistered() then
			iter_41_5.isExclude = true
			
			break
		end
	end
	
	return var_41_1
end

function WorldBossReady.onHeroListEvent(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	if arg_42_0.vars and arg_42_0.vars.group_editor then
		if arg_42_2 and arg_42_2.isExclude and (arg_42_1 == "select" or arg_42_1 == "add") then
		else
			arg_42_0.vars.group_editor:onHeroListEventForFormationEditor(arg_42_1, arg_42_2, arg_42_3)
		end
		
		arg_42_0:setUnitBar(arg_42_1, arg_42_2, arg_42_3)
	end
end

function WorldBossReady.setUnitBar(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	if arg_43_1 == "change" then
		local var_43_0 = HeroBelt:getControl(arg_43_2)
		
		if var_43_0 then
			if_set_visible(var_43_0, "add", false)
		end
		
		local var_43_1 = HeroBelt:getControl(arg_43_3)
		
		if var_43_1 then
			if_set_visible(var_43_1, "add", not arg_43_3.isExclude)
		end
	end
end

function WorldBossReady.updatePoint(arg_44_0, arg_44_1)
	arg_44_1 = arg_44_1 or {}
	
	if arg_44_1.wnd then
		local var_44_0 = arg_44_1.wnd:getChildByName("txt_point")
		
		if var_44_0 then
			UIAction:Add(INC_NUMBER(400, arg_44_1.cur, nil, arg_44_1.pre), var_44_0)
		end
	end
end

function WorldBossReady.checkUnitCount(arg_45_0)
	local var_45_0 = 0
	
	for iter_45_0, iter_45_1 in pairs(arg_45_0.vars.team1) do
		var_45_0 = var_45_0 + 1
	end
	
	for iter_45_2, iter_45_3 in pairs(arg_45_0.vars.team2) do
		var_45_0 = var_45_0 + 1
	end
	
	for iter_45_4, iter_45_5 in pairs(arg_45_0.vars.team3) do
		var_45_0 = var_45_0 + 1
	end
	
	if var_45_0 < 8 then
		return false
	end
	
	return true
end

function WorldBossReady.updateStamina(arg_46_0)
	if not arg_46_0.vars or not get_cocos_refid(arg_46_0.vars.wnd) then
		return 
	end
	
	local var_46_0 = arg_46_0.vars.wnd:getChildByName("btn_go")
	
	if var_46_0 then
		if_set(var_46_0, "cost", GAME_STATIC_VARIABLE.worldboss_join_stamina .. "/" .. Account:getCurrency("stamina"))
	end
end

function WorldBossReady.checkEnterable(arg_47_0)
	if not arg_47_0:checkUnitCount() then
		balloon_message_with_sound("msg_clan_wb_member_limit")
		
		return 
	end
	
	if GAME_STATIC_VARIABLE.worldboss_join_stamina > Account:getCurrency("stamina") then
		UIUtil:wannaBuyStamina("worldboss")
		
		return 
	end
	
	local var_47_0 = {}
	
	for iter_47_0, iter_47_1 in pairs(WorldBossReady.vars.team1) do
		local var_47_1 = tostring(iter_47_1:getUID())
		
		if table.find(arg_47_0.vars.except_units, var_47_1) then
			return 
		end
		
		var_47_0[var_47_1] = {
			party = 1,
			pos = iter_47_0,
			code = iter_47_1.inst.code
		}
	end
	
	for iter_47_2, iter_47_3 in pairs(WorldBossReady.vars.team2) do
		local var_47_2 = tostring(iter_47_3:getUID())
		
		if table.find(arg_47_0.vars.except_units, var_47_2) then
			return 
		end
		
		var_47_0[var_47_2] = {
			party = 2,
			pos = iter_47_2,
			code = iter_47_3.inst.code
		}
	end
	
	for iter_47_4, iter_47_5 in pairs(WorldBossReady.vars.team3) do
		local var_47_3 = tostring(iter_47_5:getUID())
		
		if table.find(arg_47_0.vars.except_units, var_47_3) then
			return 
		end
		
		var_47_0[var_47_3] = {
			party = 3,
			pos = iter_47_4,
			code = iter_47_5.inst.code
		}
	end
	
	local var_47_4
	local var_47_5
	local var_47_6 = WorldBossReady.vars.supporter_team or WorldBossSupport:getCurSupportTeam()
	
	for iter_47_6, iter_47_7 in pairs(var_47_6) do
		if iter_47_7.isNPC_team then
			var_47_4 = iter_47_7.npc_team_id
		elseif iter_47_7.owner_info then
			var_47_5 = iter_47_7.owner_info.id
		end
		
		var_47_0[tostring(iter_47_7:getUID())] = {
			party = 4,
			pos = iter_47_6,
			code = iter_47_7.inst.code
		}
	end
	
	local var_47_7 = {
		units = json.encode(var_47_0),
		npc_team_id = var_47_4,
		supporter_id = var_47_5
	}
	
	if var_47_5 and var_47_6 then
		var_47_7.supporter_units_uid = {}
		
		for iter_47_8, iter_47_9 in pairs(var_47_6) do
			if iter_47_9.getUID then
				table.insert(var_47_7.supporter_units_uid, iter_47_9:getUID())
			end
		end
		
		var_47_7.supporter_units_uid = json.encode(var_47_7.supporter_units_uid)
	end
	
	var_47_7.season_id = arg_47_0.vars.bossInfo.season_id
	
	if DEBUG.DEBUG_NO_ENTER_LIMIT then
		var_47_7.test = true
		var_47_7.ignore_limit = true
	end
	
	arg_47_0.vars.isPlayStory = false
	arg_47_0.vars.isPlayEndStory = false
	
	local var_47_8, var_47_9 = WorldBossUtil:getWorldbossStory(arg_47_0.vars.bossInfo.boss_id)
	
	if not Account:isPlayedStory(var_47_8) then
		arg_47_0.vars.isPlayStory = true
		
		local var_47_10 = {}
		
		table.insert(var_47_10, var_47_8)
		table.insert(var_47_10, var_47_9)
		
		var_47_7.played_stories = array_to_json(var_47_10)
	end
	
	if not Account:isPlayedStory(var_47_9) then
		arg_47_0.vars.isPlayEndStory = true
	end
	
	query("worldboss_battle", var_47_7)
end

function WorldBossReady.noSendToClan(arg_48_0, arg_48_1)
	if arg_48_1 == "invalid_season" or arg_48_1 == "invalid_season_id" then
		Dialog:msgBox(T("msg_clan_wb_already_end"), {
			handler = function()
				SceneManager:nextScene("clan")
			end
		})
		
		return true
	end
end

function WorldBossReady.isShow(arg_50_0)
	if not arg_50_0.vars or not get_cocos_refid(arg_50_0.vars.wnd) then
		return false
	end
	
	return true
end

function WorldBossReady.onHide(arg_51_0)
	if not arg_51_0.vars or not get_cocos_refid(arg_51_0.vars.wnd) then
		return 
	end
	
	arg_51_0.vars.wnd:setVisible(false)
end

copy_functions(ScrollView, WorldBossSupport)

function WorldBossSupport.onEnter(arg_52_0, arg_52_1, arg_52_2)
	if WorldBossSupport:isShow() then
		WorldBossSupport:onShow()
		
		return 
	end
	
	if not arg_52_1 or not arg_52_2 then
		return 
	end
	
	arg_52_0:init(arg_52_1, arg_52_2)
	Analytics:setPopup("worldboss_select_support")
end

function WorldBossSupport.isShow(arg_53_0)
	if not arg_53_0.vars or not get_cocos_refid(arg_53_0.vars.wnd) then
		return false
	end
	
	return true
end

function WorldBossSupport.onShow(arg_54_0)
	if not arg_54_0.vars or not get_cocos_refid(arg_54_0.vars.wnd) then
		return 
	end
	
	arg_54_0.vars.wnd:setVisible(true)
	Analytics:toggleTab("worldboss_select_support")
end

function WorldBossSupport.onHide(arg_55_0)
	if not arg_55_0.vars or not get_cocos_refid(arg_55_0.vars.wnd) then
		return 
	end
	
	arg_55_0.vars.wnd:setVisible(false)
	Analytics:toggleTab("worldboss_ready")
end

function WorldBossSupport.init(arg_56_0, arg_56_1, arg_56_2)
	if not arg_56_0.vars then
		arg_56_0.vars = {}
	end
	
	arg_56_0.vars.sp_tb_debug = {}
	arg_56_0.vars.bossInfo = arg_56_1
	arg_56_0.vars.worldboss_color = arg_56_1.color
	arg_56_0.vars.bonus_data = arg_56_2
	arg_56_0.vars.refresh_count = 1
	arg_56_0.vars.wnd = load_dlg("clan_worldboss_support_sel", true, "wnd")
	
	local var_56_0 = WorldBossUtil:getWorldbossCharID(arg_56_1.boss_id)
	
	UIUtil:getUserIcon(var_56_0, {
		no_lv = true,
		no_role = true,
		no_grade = true,
		parent = arg_56_0.vars.wnd:getChildByName("mob_icon")
	})
	
	local var_56_1 = WorldBossUtil:getWorldbossName(arg_56_1.boss_id)
	
	if_set(arg_56_0.vars.wnd, "t_boss_name", var_56_1)
	
	local var_56_2 = WorldBossUtil:getBossHP(arg_56_1.start_time, arg_56_1.end_time)
	
	WorldBossUtil:setHPBar(arg_56_0.vars.wnd:getChildByName("n_gauge"), var_56_2)
	;(WorldBossPopup:getLayer() or SceneManager:getRunningNativeScene()):addChild(arg_56_0.vars.wnd)
	
	arg_56_0.vars.scrollview = arg_56_0.vars.wnd:getChildByName("ScrollView")
	
	arg_56_0:initScrollView(arg_56_0.vars.scrollview, 884, 204)
	
	arg_56_0.vars.support_teams = {}
	arg_56_0.vars.support_teams_show = {}
	arg_56_0.vars.supporter_list_page = 1
	
	local function var_56_3()
		local var_57_0 = arg_56_0.vars.worldboss_color
		local var_57_1 = Account:get_worldbossSupporterTeam() or {}
		
		if not arg_56_0.vars.worldboss_color or not var_57_1[var_57_0] then
			return 0
		end
		
		local var_57_2 = var_57_1[var_57_0]
		local var_57_3 = {}
		local var_57_4 = Account:getUnits()
		
		if not var_57_1.update_day then
			var_57_1.update_day = {}
		end
		
		local var_57_5 = var_57_1.update_day or {}
		local var_57_6 = var_57_5[var_57_0] or 0
		local var_57_7 = Account:serverTimeDayLocalDetail()
		
		if var_57_6 == var_57_7 then
			return 0
		end
		
		var_57_5[var_57_0] = var_57_7
		
		for iter_57_0, iter_57_1 in pairs(var_57_2) do
			local var_57_8 = Account:getUnit(iter_57_1)
			
			if var_57_8 then
				table.insert(var_57_3, var_57_8)
			end
		end
		
		if table.empty(var_57_3) then
			return 0
		end
		
		return TeamUtil:getTeamPoint(nil, nil, {
			team = var_57_3
		}) or 0
	end
	
	local var_56_4 = false
	local var_56_5 = var_56_3() or 0
	
	if var_56_5 > 0 then
		var_56_4 = true
	end
	
	arg_56_0:req_PlayerSupporterTeams(var_56_4, var_56_5)
	
	for iter_56_0, iter_56_1 in pairs(arg_56_0.vars.bonus_data) do
		if_set_sprite(arg_56_0.vars.wnd, "icon_role" .. iter_56_0, "img/cm_icon_role_" .. iter_56_1 .. ".png")
	end
	
	local var_56_6 = arg_56_0.vars.wnd:getChildByName("LEFT")
	
	var_56_6:setPositionX(-300 + VIEW_BASE_LEFT)
	
	if not (NOTCH_LEFT_WIDTH > 0) or not NOTCH_LEFT_WIDTH then
		local var_56_7 = NOTCH_WIDTH
	end
	
	local var_56_8 = (DEBUG.ORIENTAION_TEST or getenv("device.orientation") == "landscape_left") and 0 or  / 2
	
	UIAction:Add(LOG(MOVE_TO(250, VIEW_BASE_LEFT + var_56_8, 0)), var_56_6, "block")
	TutorialGuide:procGuide()
end

function WorldBossSupport.createNPCSupporterTeams(arg_58_0, arg_58_1)
	local var_58_0 = WorldBossMap:getLimitUnits("npc")
	
	for iter_58_0 = 1, 99 do
		local var_58_1, var_58_2, var_58_3, var_58_4 = DBN("clan_worldboss_npc", iter_58_0, {
			"id",
			"start_level",
			"attribute",
			"data"
		})
		local var_58_5 = false
		
		for iter_58_1, iter_58_2 in pairs(var_58_0) do
			if iter_58_2 == var_58_1 then
				var_58_5 = true
				
				break
			end
		end
		
		if not var_58_1 then
			break
		end
		
		if arg_58_0.vars.bossInfo.color == var_58_3 and arg_58_0:checkSupporterLevel(var_58_2) and not var_58_5 then
			local var_58_6 = json.decode(Base64.decode(var_58_4))
			
			if not var_58_6 or not var_58_6.units then
				Log.e("데이터 잘못들어간것", var_58_1)
			end
			
			if var_58_6.units then
				local var_58_7 = arg_58_0:createSupporterUnits(var_58_6.units, var_58_1)
				
				table.insert(arg_58_1, var_58_7)
				table.insert(arg_58_0.vars.support_teams_show, var_58_7)
			end
		end
	end
end

function WorldBossSupport.req_PlayerSupporterTeams(arg_59_0, arg_59_1, arg_59_2)
	local var_59_0 = not PRODUCTION_MODE and DEBUG.DEBUG_NO_ENTER_LIMIT == true
	local var_59_1 = arg_59_1 or false
	local var_59_2 = arg_59_2 or 0
	
	query("worldboss_clan_support_list", {
		id = Account:getUserId(),
		page = arg_59_0.vars.supporter_list_page,
		range = var_0_0,
		test = var_59_0,
		updateteampoint = var_59_1,
		mysupporterteampoint = var_59_2
	})
	
	arg_59_0.vars.supporter_list_page = arg_59_0.vars.supporter_list_page + 1
end

function WorldBossSupport.getSupporterList_page(arg_60_0)
	return arg_60_0.vars.supporter_list_page
end

function WorldBossSupport.createPlayerSupporterTeams(arg_61_0, arg_61_1)
	if not arg_61_1 or not arg_61_1.supporter_list or not arg_61_1.member_count then
		return 
	end
	
	arg_61_0:clearScrollViewItems()
	
	local var_61_0 = arg_61_0:_createPlayerSupporterTeams(arg_61_1.supporter_list)
	
	if table.empty(arg_61_0.vars.support_teams) then
		arg_61_0:createNPCSupporterTeams(arg_61_0.vars.support_teams)
	elseif table.count(arg_61_1.supporter_list) >= var_0_0 then
		local var_61_1 = {}
		
		var_61_1.next_item = true
		
		table.insert(arg_61_0.vars.support_teams_show, var_61_1)
	end
	
	arg_61_0:createScrollViewItems(arg_61_0.vars.support_teams_show)
	
	if arg_61_0.ScrollViewItems[1] then
		arg_61_0:onSelectScrollViewItem(1, arg_61_0.ScrollViewItems[1])
	end
	
	arg_61_0.vars.member_count = arg_61_1.member_count
end

function WorldBossSupport._createPlayerSupporterTeams(arg_62_0, arg_62_1, arg_62_2)
	if not arg_62_1 then
		return 
	end
	
	local var_62_0 = arg_62_2 or {}
	local var_62_1 = 0
	local var_62_2 = {}
	
	for iter_62_0, iter_62_1 in pairs(arg_62_1) do
		if iter_62_1.units and not table.empty(iter_62_1.units) and iter_62_1.user and iter_62_1.user.id ~= Account:getUserId() then
			local var_62_3 = {}
			local var_62_4 = arg_62_0:isLimited_userID(iter_62_1.user.id)
			local var_62_5 = true
			
			if not var_62_4 then
				for iter_62_2, iter_62_3 in pairs(iter_62_1.units) do
					if iter_62_3.unit and iter_62_3.pos then
						local var_62_6 = UNIT:create(iter_62_3.unit)
						
						var_62_6.isNPC_team = false
						var_62_6.owner_info = iter_62_1.user
						var_62_6.team_power = iter_62_1.power
						var_62_3[iter_62_3.pos] = var_62_6
					end
				end
				
				if not table.empty(var_62_3) then
					if not PRODUCTION_MODE then
						if not arg_62_0.vars.sp_tb_debug then
							arg_62_0.vars.sp_tb_debug = {}
						end
						
						table.insert(arg_62_0.vars.sp_tb_debug, {
							iter_62_1.user.id,
							iter_62_1.user.name
						})
					end
					
					if not arg_62_0.vars.support_teams[iter_62_1.user.id] then
						if not PRODUCTION_MODE then
							print("WB_Supporter_added_user_id: ", iter_62_1.user.id)
						end
						
						arg_62_0.vars.support_teams[iter_62_1.user.id] = var_62_3
						var_62_1 = var_62_1 + 1
						
						table.insert(var_62_2, var_62_3)
						
						var_62_5 = false
					else
						if not PRODUCTION_MODE then
							table.print(arg_62_0.vars.support_teams, 1)
						end
						
						Log.e("Err: world_boss_supporter_duplicate_data_exist", iter_62_1.user.id)
					end
				end
				
				if var_62_0.addToScrollView and not var_62_5 then
					arg_62_0:addScrollViewItem(var_62_3)
				end
			end
		end
	end
	
	for iter_62_4, iter_62_5 in pairs(var_62_2) do
		table.insert(arg_62_0.vars.support_teams_show, iter_62_5)
	end
	
	return var_62_1
end

function WorldBossSupport.isLimited_userID(arg_63_0, arg_63_1)
	if not arg_63_1 then
		return true
	end
	
	local var_63_0 = WorldBossMap:getLimitUnits("support")
	local var_63_1 = false
	
	if not var_63_0 or table.empty(var_63_0) then
		return false
	end
	
	for iter_63_0, iter_63_1 in pairs(var_63_0) do
		local var_63_2 = string.split(iter_63_1, ":")
		
		if var_63_2 and var_63_2[1] and tonumber(var_63_2[1]) == arg_63_1 then
			var_63_1 = true
			
			break
		end
	end
	
	return var_63_1
end

function WorldBossSupport.res_morePlayerSupporterTeams(arg_64_0, arg_64_1)
	if not arg_64_1 or not arg_64_1.supporter_list or not arg_64_1.member_count then
		return 
	end
	
	if arg_64_1.member_count and arg_64_0.vars.member_count and arg_64_0.vars.member_count ~= arg_64_1.member_count and arg_64_0.vars.refresh_count < var_0_1 then
		Log.e("Err: WorldBoss Supporter Count Mismatch", arg_64_0.vars.member_count, arg_64_1.member_count)
		
		arg_64_0.vars.member_count = arg_64_1.member_count
		arg_64_0.vars.refresh_count = arg_64_0.vars.refresh_count + 1
		
		arg_64_0:refresh_supporterList(arg_64_1)
		
		return 
	end
	
	arg_64_0.vars.member_count = arg_64_1.member_count
	
	local var_64_0
	
	for iter_64_0, iter_64_1 in pairs(arg_64_0.vars.support_teams_show) do
		if iter_64_1.next_item then
			var_64_0 = iter_64_0
			
			break
		end
	end
	
	if var_64_0 then
		table.remove(arg_64_0.vars.support_teams_show, var_64_0)
		arg_64_0:removeScrollViewItemAt(var_64_0)
	end
	
	local var_64_1 = table.count(arg_64_0.vars.support_teams_show)
	local var_64_2
	local var_64_3
	
	arg_64_0.vars.moreList_exist = false
	
	if arg_64_1.supporter_list and not table.empty(arg_64_1.supporter_list) then
		if table.count(arg_64_1.supporter_list) >= var_0_0 then
			arg_64_0.vars.moreList_exist = true
		end
		
		local var_64_4, var_64_5 = arg_64_0:getInnerSizeAndPos()
		
		var_64_2 = var_64_4
		
		local var_64_6 = arg_64_0:_createPlayerSupporterTeams(arg_64_1.supporter_list, {
			addToScrollView = true
		})
		local var_64_7, var_64_8 = arg_64_0:getInnerSizeAndPos()
		
		var_64_3 = var_64_5.height - var_64_8.height
		
		if table.count(arg_64_1.supporter_list) <= 0 or table.count(arg_64_1.supporter_list) < var_0_0 then
			arg_64_0.vars.moreList_exist = false
		end
	end
	
	if arg_64_0.vars.moreList_exist then
		local var_64_9 = {}
		
		var_64_9.next_item = true
		
		table.insert(arg_64_0.vars.support_teams_show, var_64_9)
		arg_64_0:addScrollViewItem(var_64_9)
	end
	
	if table.count(arg_64_0.vars.support_teams_show) > 1 and var_64_2 and var_64_3 then
		var_64_2.y = var_64_2.y + var_64_3
		
		arg_64_0.scrollview:setInnerContainerPosition(var_64_2)
		arg_64_0.scrollview:forceDoLayout()
		arg_64_0.scrollview:stopAutoScroll()
	end
	
	if false then
	end
end

function WorldBossSupport.refresh_supporterList(arg_65_0, arg_65_1)
	if not arg_65_0.vars or not arg_65_1 then
		return 
	end
	
	local var_65_0 = table.count(arg_65_0.vars.support_teams)
	
	if arg_65_1.supporter_list and not table.empty(arg_65_1.supporter_list) then
		local var_65_1 = var_65_0 + table.count(arg_65_1.supporter_list)
	end
	
	arg_65_0.vars.support_teams = {}
	arg_65_0.vars.support_teams_show = {}
	
	arg_65_0:clearScrollViewItems()
	
	local var_65_2 = not PRODUCTION_MODE and DEBUG.DEBUG_NO_ENTER_LIMIT == true
	
	arg_65_0.vars.supporter_list_page = arg_65_0.vars.supporter_list_page - 1
	
	query("worldboss_clan_support_list", {
		page = 1,
		id = Account:getUserId(),
		range = (arg_65_0.vars.supporter_list_page - 1) * var_0_0,
		test = var_65_2
	})
end

function WorldBossSupport.checkSupporterLevel(arg_66_0, arg_66_1)
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.WORLD_BOSS) then
		return true
	end
	
	if not arg_66_1 then
		return false
	end
	
	local var_66_0 = Account:getLevel()
	local var_66_1 = string.split(arg_66_1, "/")
	local var_66_2 = false
	
	if not var_66_1[2] then
		var_66_2 = true
	end
	
	if var_66_2 and var_66_0 >= 60 then
		return true
	end
	
	if not var_66_1[2] then
		return false
	end
	
	if var_66_0 >= tonumber(var_66_1[1]) and var_66_0 <= tonumber(var_66_1[2]) then
		return true
	end
	
	return false
end

function WorldBossSupport.createSupporterUnits(arg_67_0, arg_67_1, arg_67_2)
	local var_67_0 = {}
	
	for iter_67_0, iter_67_1 in pairs(arg_67_1) do
		local var_67_1 = UNIT:create(iter_67_1.unit)
		
		if var_67_1 then
			for iter_67_2, iter_67_3 in pairs(iter_67_1.equips) do
				local var_67_2 = EQUIP:createByInfo(iter_67_3)
				
				if var_67_2 then
					var_67_1:addEquip(var_67_2)
				end
			end
			
			var_67_1.isNPC_team = true
			var_67_1.pos = iter_67_1.pos
			var_67_1.npc_team_id = arg_67_2
			
			table.insert(var_67_0, var_67_1)
		end
	end
	
	return var_67_0
end

function WorldBossSupport.getScrollViewItem(arg_68_0, arg_68_1)
	local var_68_0 = load_control("wnd/clan_worldboss_support_sel_item.csb")
	local var_68_1 = arg_68_1
	
	if_set_visible(var_68_0, "select", false)
	
	if arg_68_1.next_item then
		if_set_visible(var_68_0, "n_info", false)
		if_set_visible(var_68_0, "n_party", false)
		if_set_visible(var_68_0, "n_formation", false)
		if_set_visible(var_68_0, "btn_ignore", false)
		if_set_visible(var_68_0, "page_next", true)
		
		return var_68_0
	end
	
	local var_68_2 = false
	local var_68_3
	local var_68_4
	
	for iter_68_0, iter_68_1 in pairs(var_68_1) do
		if iter_68_1.isNPC_team then
			var_68_2 = true
		end
		
		if iter_68_1.owner_info then
			var_68_3 = iter_68_1.owner_info
			var_68_4 = iter_68_1.team_power
		end
		
		local var_68_5 = var_68_0:getChildByName("mob_icon" .. iter_68_0)
		
		if not var_68_5 then
			break
		end
		
		local var_68_6 = {
			no_popup = true,
			name = false,
			no_lv = false,
			no_grade = false,
			parent = var_68_5,
			zodiac = iter_68_1:getZodiacGrade()
		}
		
		UIUtil:getUserIcon(iter_68_1, var_68_6)
	end
	
	if_set_visible(var_68_0, "n_member_info", not var_68_2)
	if_set_visible(var_68_0, "n_npc", var_68_2)
	
	local var_68_7
	
	for iter_68_2, iter_68_3 in pairs(IS_STRONG_COLOR_AGAINST) do
		if WorldBossUtil:isStrongColor(iter_68_2, arg_68_0.vars.worldboss_color) then
			var_68_7 = iter_68_2
			
			break
		end
	end
	
	local var_68_8 = "img/cm_icon_pro"
	
	if var_68_7 == "light" or var_68_7 == "dark" then
		var_68_8 = var_68_8 .. "m"
	end
	
	local var_68_9 = var_68_8 .. var_68_7 .. ".png"
	
	if_set_sprite(var_68_0, "icon_element", var_68_9)
	
	local var_68_10 = WorldBossUtil:getRoleCount(var_68_1)
	
	for iter_68_4, iter_68_5 in pairs(var_68_10) do
		local var_68_11 = var_68_0:getChildByName("icon_" .. iter_68_4)
		
		if not var_68_11 then
			break
		end
		
		if_set(var_68_11, "t_count", iter_68_5)
	end
	
	local var_68_12 = WorldBossUtil:getStrongColorCount(var_68_1, arg_68_0.vars.worldboss_color)
	
	if_set(var_68_0:getChildByName("icon_element"), "t_count", var_68_12)
	
	local var_68_13 = Team:makeTeamData(var_68_1)
	local var_68_14 = Team:makeTeam(var_68_13)
	local var_68_15 = var_68_4 or var_68_14:getPoint()
	
	if_set(var_68_0:getChildByName("n_power"), "txt_point", comma_value(var_68_15))
	
	local var_68_16 = WorldBossUtil:change_buttonImg(var_68_14)
	
	if_set_sprite(var_68_0, "hero_dedi", var_68_16)
	
	local var_68_17 = var_68_0:getChildByName("btn_dedi")
	
	if var_68_17 then
		var_68_17.item = arg_68_1
	end
	
	if var_68_3 then
		local var_68_18 = var_68_0:getChildByName("n_member_info")
		
		if_set(var_68_18, "t_name", var_68_3.name)
		UIUtil:setLevel(var_68_18:getChildByName("n_lv"), var_68_3.level, MAX_ACCOUNT_LEVEL, 3, false, nil, 18)
		if_set_visible(var_68_18, "n_assist", false)
		if_set_visible(var_68_18, "tag_count", false)
	end
	
	return var_68_0
end

function WorldBossSupport.getCurrentWorldboss_info(arg_69_0)
	if not arg_69_0.vars or not arg_69_0.vars.bossInfo then
		return 
	end
	
	return arg_69_0.vars.bossInfo
end

function WorldBossSupport.getBonusData(arg_70_0)
	if not arg_70_0.vars or not arg_70_0.vars.bonus_data then
		return 
	end
	
	return arg_70_0.vars.bonus_data
end

function WorldBossSupport.onSelectScrollViewItem(arg_71_0, arg_71_1, arg_71_2)
	if arg_71_2.item.next_item ~= nil then
		return 
	end
	
	local var_71_0 = arg_71_2.control
	
	if_set_visible(var_71_0, "select", true)
	
	arg_71_0.vars.cur_supporterTeam = arg_71_2
	
	for iter_71_0, iter_71_1 in pairs(arg_71_0.ScrollViewItems) do
		if iter_71_0 ~= arg_71_1 then
			local var_71_1 = iter_71_1.control
			
			if var_71_1 then
				if_set_visible(var_71_1, "select", false)
			end
		end
	end
end

function WorldBossSupport.getCurSupportTeam(arg_72_0)
	if not arg_72_0.vars or not arg_72_0.vars.cur_supporterTeam then
		return false
	end
	
	return arg_72_0.vars.cur_supporterTeam.item
end
