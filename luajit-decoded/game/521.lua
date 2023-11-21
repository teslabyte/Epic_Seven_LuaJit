function HANDLER.clan_base(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_member" then
		query("get_clan_members", {
			clan_id = AccountData.clan_id
		})
	end
end

ClanBase = {}

function ClanBase.show(arg_2_0, arg_2_1, arg_2_2)
	arg_2_2 = arg_2_2 or {}
	arg_2_0.vars = {}
	arg_2_1 = arg_2_1 or arg_2_0.base_layer or SceneManager:getDefaultLayer()
	arg_2_0.base_layer = arg_2_1
	
	local var_2_0 = load_dlg("clan_base", true, "wnd")
	
	arg_2_0.base_layer:addChild(var_2_0)
	if_set_visible(var_2_0, "LEFT", false)
	
	arg_2_0.vars.wnd = var_2_0
	arg_2_0.vars.base_wnd = var_2_0:getChildByName("n_base")
	arg_2_0.vars.sub_wnd = var_2_0:getChildByName("n_sub")
	arg_2_0.vars.ui_back = var_2_0:getChildByName("n_ui_bg")
	arg_2_0.vars.ui_wnd = var_2_0:getChildByName("n_ui")
	arg_2_0.vars.top_wnd = var_2_0:getChildByName("n_top")
	arg_2_0.vars.bg = CACHE:getEffect("guild_back.scsp", "guild")
	
	local var_2_1 = var_2_0:getChildByName("n_bg_spine")
	
	var_2_1:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	var_2_1:setScale(2.22)
	var_2_1:addChild(arg_2_0.vars.bg)
	TopBarNew:create(T("clan_title"), arg_2_0.vars.top_wnd, function()
		Clan:onPushBack()
	end, nil, nil, "infoclan")
	TopBarNew:setCurrencies({
		"crystal",
		"gold",
		"clanexp",
		"honor",
		"clanpvpband"
	})
	
	if AccountData.clan_id then
		if_set_visible(arg_2_0.vars.ui_wnd, "RIGHT", true)
		if_set_visible(arg_2_0.vars.ui_wnd, "scrollview", true)
		ClanCategory:create(arg_2_0.vars.ui_wnd)
		arg_2_0:setVisible(false)
		query("clan_enter")
		query("get_request_clan_members", {
			clan_id = AccountData.clan_id
		})
		
		arg_2_0.vars.db = {}
		
		arg_2_0:loadDB()
		ClanCategory:setMode("main")
	else
		if_set_visible(arg_2_0.vars.ui_wnd, "RIGHT", false)
		if_set_visible(arg_2_0.vars.ui_wnd, "scrollview", false)
		query("get_clan_info_has_not")
		
		local var_2_2 = ClanJoin:show()
		
		arg_2_0.vars.ui_back:setVisible(true)
		arg_2_0.vars.sub_wnd:addChild(var_2_2)
		ClanRecommend:create(var_2_2)
		Account:reset_worldbossSupporterTeam()
		TutorialNotice:update("clan")
		
		if not TutorialGuide:isClearedTutorial("system_015") then
			TutorialGuide:startGuide("system_015")
		else
			local var_2_3 = Account:serverTimeDayLocalDetail()
			
			if SAVE:getKeep("clanjoin_info_p") ~= var_2_3 and not arg_2_2.leave then
				ClanJoinInfoPopup:show()
			end
		end
		
		local var_2_4 = Account:getClanJoinNoti() or 0
		local var_2_5 = Account:serverTimeWeekLocalDetail() or 0
		
		if var_2_4 ~= var_2_5 then
			Account:setClanJoinNoti(var_2_5)
		end
	end
	
	if not arg_2_2.no_sound_eff then
		SoundEngine:play("event:/ui/main_hud/btn_clan")
	end
end

function ClanBase.close(arg_4_0)
	if not arg_4_0.vars then
		return 
	end
	
	if arg_4_0.vars.wnd and arg_4_0.base_layer and get_cocos_refid(arg_4_0.base_layer) and get_cocos_refid(arg_4_0.vars.wnd) then
		arg_4_0.base_layer:removeChild(arg_4_0.vars.wnd)
	end
	
	arg_4_0.vars = nil
end

function ClanBase.loadDB(arg_5_0)
	arg_5_0.vars.db.attendance = {}
	
	for iter_5_0 = 1, 99 do
		local var_5_0, var_5_1, var_5_2, var_5_3, var_5_4, var_5_5, var_5_6, var_5_7, var_5_8 = DBN("clan_attendance", iter_5_0, {
			"id",
			"name",
			"atten_member",
			"reward_id1",
			"reward_id2",
			"reward_count1",
			"reward_count2",
			"clan_reward_type",
			"clan_reward_count"
		})
		
		if not var_5_0 then
			break
		end
		
		local var_5_9 = {
			id = var_5_0,
			name = var_5_1,
			atten_member = var_5_2,
			reward_id1 = var_5_3,
			reward_id2 = var_5_4,
			reward_count1 = var_5_5,
			reward_count2 = var_5_6,
			clan_reward_type = var_5_7,
			clan_reward_count = var_5_8
		}
		
		table.insert(arg_5_0.vars.db.attendance, var_5_9)
	end
	
	table.sort(arg_5_0.vars.db.attendance, function(arg_6_0, arg_6_1)
		return arg_6_0.atten_member < arg_6_1.atten_member
	end)
	
	arg_5_0.vars.db.atten_max = arg_5_0.vars.db.attendance[#arg_5_0.vars.db.attendance].atten_member
end

function ClanBase.getDB(arg_7_0)
	return arg_7_0.vars.db
end

function ClanBase.setMode(arg_8_0, arg_8_1)
	if arg_8_0.vars.mode == arg_8_1 then
		return 
	end
	
	local var_8_0 = {
		clanshop = "Shop",
		support = "Support",
		clanmastershop = "MasterShop",
		main = "Home",
		achieve = "Achieve",
		donate = "Donate",
		weeklyachieve = "WeeklyAchieve",
		clan_war = "BattleList"
	}
	
	arg_8_0.vars.sub_wnd:removeAllChildren()
	
	arg_8_0.vars.mode = arg_8_1
	
	if arg_8_1 == "main" then
		if not AccountData.clan_id then
		else
			arg_8_0.vars.sub_wnd:removeAllChildren()
			
			local var_8_1 = ClanHome:show()
			
			arg_8_0.vars.sub_wnd:addChild(var_8_1)
			arg_8_0:updateClanInfoUI()
			arg_8_0:updateAttenInfoUI()
			if_set_visible(arg_8_0.vars.ui_wnd, "LEFT", false)
		end
		
		arg_8_0.vars.ui_back:setVisible(false)
	else
		local var_8_2 = _G["Clan" .. var_8_0[arg_8_1]]:show()
		
		arg_8_0.vars.sub_wnd:addChild(var_8_2)
		arg_8_0.vars.ui_back:setVisible(true)
		if_set_visible(arg_8_0.vars.ui_wnd, "LEFT", true)
	end
	
	Analytics:toggleTab(arg_8_1)
end

function ClanBase.getMode(arg_9_0)
	return arg_9_0.vars.mode
end

function ClanBase.updateClanInfoUI(arg_10_0)
	if not arg_10_0.vars then
		return 
	end
	
	if not Clan:getClanInfo() or not get_cocos_refid(arg_10_0.vars.base_wnd) then
		return 
	end
	
	ClanHome:updateClanUI(Clan:getClanInfo())
	UIUtil:updateClanInfo(arg_10_0.vars.ui_wnd, Clan:getClanInfo(), {
		offset_x = 8
	})
	arg_10_0:updateRequestMemberNotiCount(Clan:getRequestMemberCount())
end

function ClanBase.updateAttenInfoUI(arg_11_0)
	ClanHome:updateAttenInfoUI()
end

function ClanBase.updateRequestMemberNotiCount(arg_12_0, arg_12_1)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.ui_wnd) then
		return 
	end
	
	if_set_visible(arg_12_0.vars.ui_wnd, "management_noti", arg_12_1 > 0)
end

function ClanBase.setVisible(arg_13_0, arg_13_1)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.wnd) then
		return 
	end
	
	if_set_visible(arg_13_0.vars.wnd, nil, arg_13_1)
end

function ClanBase.onAfterUpdate(arg_14_0)
	if not arg_14_0.vars then
		return 
	end
	
	if arg_14_0:getMode() == "clanmastershop" then
		local var_14_0 = os.time()
		
		if arg_14_0.vars.last_tick == var_14_0 then
			return 
		end
		
		arg_14_0.vars.last_tick = var_14_0
		
		ClanMasterShop:updateTimeLimitedItems(var_14_0)
	end
end

function ClanBase.onTouchMove(arg_15_0, arg_15_1, arg_15_2)
end

function ClanBase.onTouchDown(arg_16_0, arg_16_1, arg_16_2)
end

function ClanBase.onTouchUp(arg_17_0, arg_17_1, arg_17_2)
end

ClanCategory = {}

copy_functions(ScrollView, ClanCategory)

function ClanCategory.create(arg_18_0, arg_18_1)
	arg_18_0.vars = {}
	arg_18_0.vars.parent = arg_18_1
	arg_18_0.vars.scrollview = arg_18_1:getChildByName("scrollview")
	arg_18_0.vars.categories = {}
	
	for iter_18_0 = 1, 99 do
		local var_18_0, var_18_1, var_18_2, var_18_3 = DBN("clan_category", iter_18_0, {
			"id",
			"name",
			"sort",
			"icon"
		})
		local var_18_4 = {
			id = var_18_0,
			name = var_18_1,
			sort = var_18_2,
			icon = var_18_3
		}
		
		if not var_18_4.id then
			break
		end
		
		local var_18_5 = Account:serverTimeDayLocalDetail()
		
		if Account:isJPN() and var_18_5 < JPN_CLAN_WAR_OPEN_DAY and var_18_0 == "clan_war" then
		else
			table.insert(arg_18_0.vars.categories, var_18_4)
		end
	end
	
	table.sort(arg_18_0.vars.categories, function(arg_19_0, arg_19_1)
		local var_19_0 = (arg_19_0.group or {}).state or 0
		local var_19_1 = (arg_19_1.group or {}).state or 0
		
		if var_19_0 == var_19_1 then
			return arg_19_0.sort < arg_19_1.sort
		else
			return state_priority[var_19_0] > state_priority[var_19_1]
		end
	end)
	arg_18_0:initScrollView(arg_18_0.vars.scrollview, 290, 93, {
		fit_height = true
	})
	arg_18_0:createScrollViewItems(arg_18_0.vars.categories)
end

function ClanCategory.getScrollViewItem(arg_20_0, arg_20_1)
	local var_20_0 = load_dlg("clan_category_item", true, "wnd")
	
	var_20_0.info = arg_20_1
	
	if_set(var_20_0, "title", T(arg_20_1.name))
	if_set_sprite(var_20_0, "icon_menu", "img/" .. arg_20_1.icon .. ".png")
	if_set_visible(var_20_0, "n_cnt", false)
	
	if arg_20_1.id == "achieve" then
		local var_20_1 = var_20_0:findChildByName("icon_menu")
		local var_20_2 = var_20_0:findChildByName("title")
		
		if_set_visible(var_20_0, "icon_lock", true)
		var_20_1:setOpacity(76.5)
		var_20_2:setOpacity(76.5)
	else
		local var_20_3 = var_20_0:findChildByName("icon_menu")
		local var_20_4 = var_20_0:findChildByName("title")
		
		if_set_visible(var_20_0, "icon_lock", false)
		var_20_3:setOpacity(255)
		var_20_4:setOpacity(255)
	end
	
	arg_20_0:updateInfo(var_20_0, arg_20_1)
	
	return var_20_0
end

function ClanCategory.updateScrollView(arg_21_0)
	for iter_21_0, iter_21_1 in pairs(arg_21_0.ScrollViewItems or {}) do
		arg_21_0:updateInfo(iter_21_1.control, iter_21_1.item)
	end
end

function ClanCategory.updateInfo(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = false
	
	if arg_22_2.id == "weeklyachieve" then
		var_22_0 = Account:isClanMissionNoti()
	elseif arg_22_2.id == "clan_war" then
		var_22_0 = Clan:getWorldbossEnterable() or ClanWar:isRewardAble() or ClanWar:isWarReady()
	end
	
	if_set_visible(arg_22_1, "icon_alert", var_22_0)
end

function ClanCategory.setMode(arg_23_0, arg_23_1)
	for iter_23_0, iter_23_1 in pairs(arg_23_0.ScrollViewItems) do
		if iter_23_1.item.id == arg_23_1 then
			iter_23_1.control:getChildByName("bg"):setOpacity(255)
		else
			iter_23_1.control:getChildByName("bg"):setOpacity(0)
		end
	end
	
	arg_23_0.vars.mode = arg_23_1
	
	ClanBase:setMode(arg_23_1)
end

function ClanCategory.onSelectScrollViewItem(arg_24_0, arg_24_1, arg_24_2)
	if UIAction:Find("block") then
		return 
	end
	
	SoundEngine:play("event:/ui/category/select")
	
	if ContentDisable:byButton(arg_24_2.item.id) then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	if arg_24_2.item.id == "achieve" then
		balloon_message_with_sound("level_battlemenu_desc_unlock_3")
		
		return 
	end
	
	arg_24_0:setMode(arg_24_2.item.id)
end
