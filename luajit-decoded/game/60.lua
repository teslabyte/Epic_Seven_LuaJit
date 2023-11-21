ShopExclusiveEquip = {}
ShopExclusiveEquip_result = {}

copy_functions(ScrollView, ShopExclusiveEquip)
copy_functions(ShopCommon, ShopExclusiveEquip)

function MsgHandler.get_exclusive_shop_items(arg_1_0)
	AccountData.shop_exclusive = arg_1_0.exclusive_shop
	AccountData.shop_trialhall = arg_1_0.trialhall_shop
	
	ShopExclusiveEquip:show()
end

function HANDLER.equip_exclusive_result(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_bg" then
		ShopExclusiveEquip_result:closeResultDlg()
	elseif arg_2_1 == "btn_lock" or arg_2_1 == "btn_lock_done" then
		ShopExclusiveEquip_result:LockUnLock_resultItem(arg_2_1)
	elseif arg_2_1 == "btn_sell" then
		balloon_message_with_sound("cannot_sell_exclusive_de")
	end
end

function HANDLER.shop_private(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		ShopExclusiveEquip:close()
	elseif string.find(arg_3_1, "btn_job") then
		ShopExclusiveEquip:selectRoleTab(string.sub(arg_3_1, -1, -1))
	elseif string.find(arg_3_1, "btn_tab") then
		ShopExclusiveEquip:selectCategoryTab(tonumber(string.sub(arg_3_1, -1, -1)))
	elseif arg_3_1 == "btn_go" then
		ShopExclusiveEquip:reqBuy(arg_3_0.item)
	end
end

local var_0_0 = {
	"all",
	"knight",
	"warrior",
	"ranger",
	"assassin",
	"manauser",
	"mage"
}

function ShopExclusiveEquip.show(arg_4_0, arg_4_1)
	if not AccountData.shop_exclusive then
		return 
	end
	
	local var_4_0 = {}
	
	for iter_4_0, iter_4_1 in pairs(AccountData.shop_exclusive) do
		table.insert(var_4_0, iter_4_1)
	end
	
	table.sort(var_4_0, function(arg_5_0, arg_5_1)
		return arg_5_0.sort < arg_5_1.sort
	end)
	
	AccountData.shop_exclusive = var_4_0
	
	local var_4_1 = {}
	
	for iter_4_2, iter_4_3 in pairs(AccountData.shop_trialhall) do
		table.insert(var_4_1, iter_4_3)
	end
	
	table.sort(var_4_1, function(arg_6_0, arg_6_1)
		return arg_6_0.sort < arg_6_1.sort
	end)
	
	AccountData.shop_trialhall = var_4_1
	
	local var_4_2
	
	var_4_2 = arg_4_1 or {}
	
	local var_4_3 = DungeonList:getWndControl("n_trial_shop")
	
	arg_4_0.vars = {}
	arg_4_0.vars.DB = {}
	arg_4_0.vars.wnd = load_dlg("shop_private", true, "wnd", function()
		ShopExclusiveEquip:close()
	end)
	
	var_4_3:addChild(arg_4_0.vars.wnd)
	
	for iter_4_4, iter_4_5 in pairs(AccountData.shop_trialhall) do
		arg_4_0.vars.DB[iter_4_5.id] = iter_4_5
	end
	
	ShopExclusiveEquip:init()
	UIUtil:slideOpen(arg_4_0.vars.wnd, arg_4_0.vars.wnd.c.n_window, true)
	TutorialGuide:procGuide()
	
	local var_4_4 = DungeonList:getWndControl("btn_exchange_private")
	
	if get_cocos_refid(var_4_4) then
		var_4_4:setVisible(false)
	end
	
	local var_4_5 = DungeonList:getWndControl("btn_story")
	
	if get_cocos_refid(var_4_5) then
		var_4_5:setVisible(false)
	end
	
	local var_4_6 = DungeonList:getWndControl("Image_1")
	
	if get_cocos_refid(var_4_6) then
		var_4_6:setVisible(false)
	end
end

function ShopExclusiveEquip.isShow(arg_8_0)
	return arg_8_0.vars and get_cocos_refid(arg_8_0.vars.wnd)
end

function ShopExclusiveEquip.init(arg_9_0)
	arg_9_0.vars.items = {}
	arg_9_0.vars.roleTab = "all"
	arg_9_0.vars.categoryTab = 1
	
	local var_9_0 = os.time()
	
	arg_9_0.vars.items = {}
	
	for iter_9_0, iter_9_1 in pairs(var_0_0) do
		arg_9_0.vars.items[iter_9_1] = {}
	end
	
	for iter_9_2, iter_9_3 in pairs(AccountData.shop_exclusive) do
		if iter_9_3.category == "exclusive" then
			local var_9_1 = true
			
			if iter_9_3.start_time and var_9_0 < iter_9_3.start_time then
				var_9_1 = false
			end
			
			if iter_9_3.end_time and var_9_0 > iter_9_3.end_time then
				var_9_1 = false
			end
			
			if var_9_1 then
				local var_9_2 = DB("equip_item", iter_9_3.type, {
					"role"
				})
				
				iter_9_3.role = var_9_2
				
				table.push(arg_9_0.vars.items[var_9_2], iter_9_3)
				table.push(arg_9_0.vars.items.all, iter_9_3)
			end
		end
	end
	
	local var_9_3 = FastListView_v2:bindControl(arg_9_0.vars.wnd:getChildByName("listview"))
	local var_9_4 = {
		onUpdate = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			if not arg_10_3 then
				return 
			end
			
			if var_9_3.STRETCH_INFO then
				local var_10_0 = var_9_3:getContentSize()
				
				resetControlPosAndSize(arg_10_1, var_10_0.width, var_9_3.STRETCH_INFO.width_prev)
			end
			
			ShopExclusiveEquip:updateListViewItem(arg_10_1, arg_10_3)
			
			return arg_10_2
		end
	}
	local var_9_5 = load_control("wnd/shop_private_card.csb")
	
	var_9_5:setCascadeOpacityEnabled(true)
	var_9_3:setListViewCascadeEnabled(true)
	var_9_3:setRenderer(var_9_5, var_9_4, 10)
	var_9_3:removeAllChildren()
	
	arg_9_0.vars.role_view = var_9_3
	arg_9_0.vars.categoryTab = 2
	
	arg_9_0:updateTrialHallItems()
	
	arg_9_0.vars.categoryTab = 1
	
	arg_9_0:updateTrialHallItems()
	
	for iter_9_4 = 1, 6 do
		if_set_visible(arg_9_0.vars.wnd:getChildByName("btn_job_tab" .. iter_9_4), "bg_tab", false)
	end
	
	if_set_visible(arg_9_0.vars.wnd:getChildByName("btn_tab2"), "bg_tab", false)
	
	local var_9_6 = UIUtil:getPortraitAni("npc1025", {})
	
	if var_9_6 then
		arg_9_0.vars.wnd:getChildByName("n_portrait"):addChild(var_9_6)
		var_9_6:setName("@portrait")
		var_9_6:setScale(0.7)
	end
end

function ShopExclusiveEquip.updateTrialHallItems(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.wnd) then
		return 
	end
	
	arg_11_0.vars.etcItems = {}
	
	for iter_11_0, iter_11_1 in pairs(AccountData.shop_trialhall) do
		if iter_11_1.category == "trialhall" then
			local var_11_0 = true
			
			if iter_11_1.start_time and iter_11_1.start_time > now then
				var_11_0 = false
			end
			
			if iter_11_1.end_time and iter_11_1.end_time < now then
				var_11_0 = false
			end
			
			if var_11_0 then
				table.push(arg_11_0.vars.etcItems, iter_11_1)
			end
		end
	end
	
	arg_11_0:setItemsByCategoryTab()
end

function ShopExclusiveEquip.setItemsByCategoryTab(arg_12_0)
	if arg_12_0.vars.categoryTab == 1 then
		arg_12_0.vars.role_view:setDataSource(arg_12_0.vars.items[arg_12_0.vars.roleTab])
		arg_12_0.vars.role_view:jumpToTop()
	elseif arg_12_0.vars.categoryTab == 2 then
		arg_12_0:initScrollView(arg_12_0.vars.wnd:findChildByName("scrollview_shop_card"), 690, 168)
		arg_12_0:setScrollViewItems(arg_12_0.vars.etcItems)
		arg_12_0:updateTimeLimitedItems(os.time())
		table.sort(arg_12_0.vars.etcItems, function(arg_13_0, arg_13_1)
			if arg_13_0.rest_count and arg_13_0.rest_count <= 0 then
				return false
			end
			
			if arg_13_1.rest_count and arg_13_1.rest_count <= 0 then
				return true
			end
			
			return arg_13_0.sort < arg_13_1.sort
		end)
		arg_12_0:setScrollViewItems(arg_12_0.vars.etcItems)
	end
end

function ShopExclusiveEquip.selectRoleTab(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_1 + 1
	
	if arg_14_0.vars.roleTab == var_0_0[var_14_0] then
		return 
	end
	
	arg_14_0.vars.roleTab = var_0_0[var_14_0] or "all"
	
	arg_14_0.vars.role_view:clearListView()
	arg_14_0.vars.role_view:setDataSource(arg_14_0.vars.items[arg_14_0.vars.roleTab])
	arg_14_0.vars.role_view:jumpToTop()
	
	for iter_14_0 = 0, 6 do
		if_set_visible(arg_14_0.vars.wnd:getChildByName("btn_job_tab" .. iter_14_0), "bg_tab", false)
	end
	
	if_set_visible(arg_14_0.vars.wnd:getChildByName("btn_job_tab" .. arg_14_1), "bg_tab", true)
end

function ShopExclusiveEquip.selectCategoryTab(arg_15_0, arg_15_1)
	if arg_15_0.vars.categoryTab == arg_15_1 then
		return 
	end
	
	arg_15_0.vars.categoryTab = arg_15_1
	
	arg_15_0:updateCenterUI()
end

function ShopExclusiveEquip.updateCenterUI(arg_16_0)
	for iter_16_0 = 1, 2 do
		if_set_visible(arg_16_0.vars.wnd:getChildByName("btn_tab" .. iter_16_0), "bg_tab", arg_16_0.vars.categoryTab == iter_16_0)
	end
	
	local var_16_0 = arg_16_0.vars.categoryTab == 1
	
	if_set_visible(arg_16_0.vars.wnd, "listview", var_16_0)
	if_set_visible(arg_16_0.vars.wnd, "n_tab_job", var_16_0)
	if_set_visible(arg_16_0.vars.wnd, "scrollview_shop_card", not var_16_0)
	arg_16_0:setItemsByCategoryTab()
end

function ShopExclusiveEquip.getScrollViewItem(arg_17_0, arg_17_1)
	if arg_17_0.vars.categoryTab == 1 then
	else
		arg_17_1.is_limit_button = arg_17_0.vars.DB and arg_17_0.vars.DB[arg_17_1.id] and arg_17_0.vars.DB[arg_17_1.id].limit_count
		arg_17_1.control = arg_17_0:makeShopItem(arg_17_1, "wnd/shop_card.csb")
		
		return arg_17_1.control
	end
	
	return arg_17_1.control
end

function ShopExclusiveEquip.updateListViewItem(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_1:getChildByName("n_skill"):getChildByName("bg")
	
	if var_18_0._TOUCH_LISTENER then
		var_18_0._TOUCH_LISTENER:removeFromParent()
		
		var_18_0._TOUCH_LISTENER = nil
	end
	
	WidgetUtils:setupTooltip({
		control = var_18_0,
		creator = function()
			return ItemTooltip:getItemTooltip({
				code = arg_18_2.type
			})
		end
	})
	
	local var_18_1, var_18_2, var_18_3 = DB("equip_item", arg_18_2.type, {
		"exclusive_unit",
		"name",
		"exclusive_skill"
	})
	local var_18_4 = UNIT:create({
		code = var_18_1
	})
	local var_18_5 = {
		no_popup = true,
		name = false,
		no_role = true,
		no_lv = true,
		no_grade = true,
		parent = arg_18_1:getChildByName("n_face")
	}
	local var_18_6 = UIUtil:getUserIcon(var_18_4, var_18_5)
	
	UIUtil:getRewardIcon("equip", arg_18_2.type, {
		grade = 5,
		no_lv = true,
		parent = arg_18_1:getChildByName("n_item_pos")
	})
	if_set(arg_18_1, "txt_shop_name", T(var_18_2))
	UIUtil:getRewardIcon(nil, arg_18_2.token, {
		no_count = true,
		scale = 0.6,
		no_frame = true,
		parent = arg_18_1:getChildByName("n_pay_token")
	})
	if_set(arg_18_1, "txt_price", arg_18_2.price)
	arg_18_1:getChildByName("txt_shop_type"):setTextColor(cc.c3b(165, 92, 255))
	if_set_visible(arg_18_1, "icon_badge_cir", false)
	if_set_visible(arg_18_1, "period_badge", false)
	if_set_visible(arg_18_1, "pickup_badge", false)
	if_set_visible(arg_18_1, "priceup_badge", false)
	if_set_visible(arg_18_1, "icon_badge", false)
	
	local var_18_7, var_18_8, var_18_9 = DB("character", var_18_1, {
		"skill1",
		"skill2",
		"skill3"
	})
	local var_18_10 = UNIT:create({
		code = var_18_1
	})
	local var_18_11 = UIUtil:getSkillIcon(var_18_10, var_18_7, {
		no_tooltip = true
	})
	local var_18_12 = UIUtil:getSkillIcon(var_18_10, var_18_8, {
		no_tooltip = true
	})
	local var_18_13 = UIUtil:getSkillIcon(var_18_10, var_18_9, {
		no_tooltip = true
	})
	
	for iter_18_0 = 1, 3 do
		local var_18_14 = var_18_3 .. "_0" .. iter_18_0
		local var_18_15, var_18_16, var_18_17, var_18_18 = DB("skill_equip", var_18_14, {
			"exc_number",
			"exc_effect",
			"exc_desc",
			"exc_change_desc"
		})
		
		if not var_18_15 then
		end
		
		local var_18_19 = arg_18_1:getChildByName("n_skill_icon" .. iter_18_0)
		
		var_18_19:removeAllChildren()
		
		local var_18_20 = var_18_11
		
		if var_18_15 == 1 then
			var_18_20 = var_18_11:clone()
		elseif var_18_15 == 2 then
			var_18_20 = var_18_12:clone()
		elseif var_18_15 == 3 then
			var_18_20 = var_18_13:clone()
		end
		
		if_set_visible(var_18_20, "n_skill_num", true)
		if_set_sprite(var_18_20, "img_skill_num_roma", "img/itxt_num" .. iter_18_0 .. "_roma_b")
		var_18_19:addChild(var_18_20)
		if_set_visible(var_18_20, "soul1", false)
	end
	
	if arg_18_2.custom_tag then
		if_set_visible(arg_18_1, "n_custom_badge", true)
		
		local var_18_21 = arg_18_1:getChildByName("n_custom_badge")
		
		if var_18_21 then
			if string.starts(arg_18_2.custom_tag, "pvpseason:") then
				if_set_visible(var_18_21, "icon_badge", false)
				if_set_visible(var_18_21, "n_shop_titlebg", true)
				
				local var_18_22 = string.split(arg_18_2.custom_tag, ":")
				local var_18_23 = var_18_21:getChildByName("n_shop_titlebg")
				
				if var_18_23 then
					if get_cocos_refid(var_18_23) then
						var_18_23:setPositionY(var_18_23:getPositionY() + 13)
					end
					
					local var_18_24 = cont:getChildByName("n_base")
					local var_18_25 = var_18_24:getChildByName("icon_item")
					
					if get_cocos_refid(var_18_25) then
						var_18_25:setPositionY(var_18_25:getPositionY() + 13)
					end
					
					local var_18_26 = var_18_24:getChildByName("n_reward_item")
					
					if get_cocos_refid(var_18_26) then
						var_18_26:setPositionY(var_18_26:getPositionY() + 13)
					end
					
					local var_18_27 = var_18_24:getChildByName("n_item_art_icon")
					
					if get_cocos_refid(var_18_27) then
						var_18_27:setPositionY(var_18_27:getPositionY() + 13)
					end
					
					local var_18_28 = var_18_24:getChildByName("n_mob_icon")
					
					if get_cocos_refid(var_18_28) then
						var_18_28:setPositionY(var_18_28:getPositionY() + 13)
					end
					
					local var_18_29 = var_18_24:getChildByName("n_pet_icon")
					
					if get_cocos_refid(var_18_29) then
						var_18_29:setPositionY(var_18_29:getPositionY() + 13)
					end
					
					local var_18_30
					
					if UIUtil:isChangeSeasonLabelPosition() then
						var_18_30 = var_18_23:getChildByName("n_season_2/2")
						
						var_18_30:setVisible(true)
						if_set_visible(var_18_23, "n_season_1/2", false)
					else
						var_18_30 = var_18_23:getChildByName("n_season_1/2")
						
						var_18_30:setVisible(true)
						if_set_visible(var_18_23, "n_season_2/2", false)
					end
					
					if_set(var_18_30, "txt", T(var_18_22[2]))
					if_set(var_18_30, "txt_season", T("pvp_season_label"))
					if_set_visible(var_18_21, "period_badge", false)
				end
			else
				if_set_visible(var_18_21, "icon_badge_cir", true)
				if_set_visible(var_18_21, "n_shop_titlebg", false)
				if_set_sprite(var_18_21, "icon_badge_cir", "img/" .. arg_18_2.custom_tag .. ".png")
				if_set_visible(var_18_21, "period_badge", arg_18_2.is_timelimited == "y")
			end
		end
	end
	
	local var_18_31 = arg_18_1:getChildByName("btn_go")
	
	if get_cocos_refid(var_18_31) then
		var_18_31.item = arg_18_2
	end
end

function ShopExclusiveEquip.close(arg_20_0)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop({
		dlg = arg_20_0.vars.wnd
	})
	UIUtil:slideOpen(arg_20_0.vars.wnd, arg_20_0.vars.wnd.c.n_window, false)
	
	arg_20_0.vars = nil
	
	local var_20_0 = DungeonList:getWndControl("btn_exchange_private")
	
	if get_cocos_refid(var_20_0) then
		var_20_0:setVisible(true)
	end
	
	local var_20_1 = DungeonList:getWndControl("btn_story")
	
	if get_cocos_refid(var_20_1) then
		var_20_1:setVisible(true)
	end
	
	local var_20_2 = DungeonList:getWndControl("Image_1")
	
	if get_cocos_refid(var_20_2) then
		var_20_2:setVisible(true)
	end
end

function ShopExclusiveEquip.reqBuy(arg_21_0, arg_21_1, arg_21_2)
	if not arg_21_1 then
		return 
	end
	
	if arg_21_0.vars.categoryTab == 2 then
		query("buy", {
			caller = "shop_trialhall",
			shop = "shop_trialhall",
			item = arg_21_1.id,
			type = arg_21_1.type,
			multiply = arg_21_2 or 1
		})
		
		return 
	end
	
	if Account:getCurrency("exclusive") < (arg_21_1.price or 999999) then
		UIUtil:checkCurrencyDialog(arg_21_1.token)
		
		return 
	end
	
	arg_21_1.grade = 5
	
	local var_21_0 = ShopCommon:ShowConfirmDialog(arg_21_1, function(arg_22_0, arg_22_1)
		query("buy", {
			caller = "exclusive_buy",
			shop = "shop_exclusive",
			item = arg_21_1.id,
			callback = MsgHandler.exclusive_buy,
			type = arg_21_1.type,
			multiply = arg_21_2 or 1
		})
	end)
	
	if not get_cocos_refid(var_21_0) then
		return 
	end
	
	local var_21_1 = arg_21_1
	local var_21_2 = var_21_0:getChildByName("txt_shop_type")
	local var_21_3 = UIUtil:getRewardIcon(var_21_1.value, var_21_1.type, {
		no_resize_name = true,
		show_name = true,
		grade = 5,
		parent = var_21_0:getChildByName("n_item_pos"),
		txt_name = var_21_0:getChildByName("txt_shop_name"),
		txt_type = var_21_2
	})
	
	var_21_2:ignoreContentAdaptWithSize(false)
	var_21_2:setTextAreaSize(var_21_2:getAutoRenderSize())
	if_set_visible(var_21_0, "icon_item", false)
end

function ShopExclusiveEquip_result.open_resultPopup(arg_23_0, arg_23_1, arg_23_2)
	arg_23_0.vars = {}
	
	local var_23_0 = arg_23_2 or {}
	
	if not arg_23_1 or not arg_23_1.rewards or arg_23_1.rewards == nil or not arg_23_1.rewards.new_equips or arg_23_1.rewards.new_equips == nil then
		return 
	end
	
	local var_23_1
	local var_23_2 = arg_23_1.rewards
	
	if var_23_2.new_equips then
		local var_23_3 = var_23_2.new_equips
		
		for iter_23_0, iter_23_1 in pairs(var_23_3) do
			if iter_23_1.id then
				var_23_1 = Account:getEquip(iter_23_1.id)
			end
		end
	end
	
	if not var_23_1 or var_23_1 == nil or not var_23_1.code then
		Log.e("구매결과아이템이 없다.")
		
		return 
	end
	
	if DB("equip_item", var_23_1.code, {
		"type"
	}) ~= "exclusive" then
		return 
	end
	
	arg_23_0.vars.item = var_23_1
	
	local var_23_4 = SceneManager:getRunningPopupScene()
	
	arg_23_0.vars.wnd = load_dlg("equip_exclusive_result", true, "wnd", function()
		ShopExclusiveEquip_result:closeResultDlg()
	end)
	
	local var_23_5 = arg_23_0.vars.wnd
	
	if_set_visible(arg_23_0.vars.wnd, "n_btn", true)
	
	local var_23_6 = arg_23_0.vars.wnd:getChildByName("btn_sell")
	
	if get_cocos_refid(var_23_6) then
		var_23_6:setOpacity(76.5)
	end
	
	if_set_visible(arg_23_0.vars.wnd, "btn_lock", true)
	if_set_visible(arg_23_0.vars.wnd, "btn_lock_done", false)
	LuaEventDispatcher:addIfNotEventListener("update.equip.lock", LISTENER(ShopExclusiveEquip_result.updateEquipLock, arg_23_0), "exclusive.equip.result.popup")
	
	local var_23_7 = load_dlg("item_detail_sub", true, "wnd")
	
	var_23_7:setAnchorPoint(0.5, 0.5)
	var_23_7:setPosition(0, 0)
	var_23_5:getChildByName("n_pos_detail"):addChild(var_23_7)
	
	local var_23_8 = ItemTooltip:getItemDetail({
		detail = true,
		wnd = var_23_7,
		equip = var_23_1
	})
	
	ItemTooltip:updateItemInformation({
		detail = true,
		wnd = var_23_7,
		equip = var_23_1
	}, nil, var_23_8)
	
	local var_23_9 = var_23_7
	local var_23_10 = 24
	local var_23_11 = 0
	local var_23_12 = var_23_8.heights
	local var_23_13 = var_23_10 + var_23_12.exclusive + var_23_12.main_stat
	local var_23_14 = arg_23_0.vars.wnd:getChildByName("cm_tooltipbox")
	local var_23_15 = var_23_14:getContentSize()
	local var_23_16 = var_23_13 + var_23_12.head + 94
	
	if var_23_16 < var_23_15.height then
		var_23_16 = var_23_15.height
	end
	
	var_23_14:setContentSize({
		width = var_23_15.width,
		height = var_23_16
	})
	if_set(var_23_5, "txt_type", T("item_type_exclusive"))
	
	local var_23_17 = var_23_7:getContentSize()
	local var_23_18 = var_23_16 - var_23_15.height
	local var_23_19 = var_23_16 / var_23_15.height
	local var_23_20 = EffectManager:Play({
		fn = "ui_equip_pack_eff.cfx",
		layer = var_23_7,
		x = var_23_17.width * 0.5,
		y = (var_23_17.height - var_23_18) * 0.5,
		scaleY = var_23_19
	})
	
	UIAction:Add(SEQ(DELAY(800)), var_23_5, "block")
	
	if not Account:getPropertyCount("to_exclusive") then
		local var_23_21 = 0
	end
	
	TutorialGuide:_startGuideFromCallback(UNLOCK_ID.EXCLUSIVE)
	
	if var_23_0.type and (var_23_0.type == "substory_achievement" or var_23_0.type == "post_box" or var_23_0.type == "substory_travel") then
		if_set(arg_23_0.vars.wnd, "txt", T("exclusive_04_title"))
	elseif var_23_0.type and var_23_0.type == "sanctuary_alchemy" then
		if_set(arg_23_0.vars.wnd, "txt", T("ui_alchemist_result_title"))
		
		arg_23_0.vars.isAlchemy = true
	end
	
	var_23_4:addChild(var_23_5)
end

function ShopExclusiveEquip_result.LockUnLock_resultItem(arg_25_0, arg_25_1)
	if not arg_25_0.vars or not get_cocos_refid(arg_25_0.vars.wnd) or not arg_25_0.vars.item then
		return 
	end
	
	if arg_25_1 == "btn_lock" then
		query("lock_equip", {
			equip = arg_25_0.vars.item.id
		})
	elseif arg_25_1 == "btn_lock_done" then
		query("unlock_equip", {
			equip = arg_25_0.vars.item.id
		})
	end
end

function ShopExclusiveEquip_result.updateEquipLock(arg_26_0, arg_26_1)
	if not arg_26_0.vars or not arg_26_0.vars.wnd or not get_cocos_refid(arg_26_0.vars.wnd) or not arg_26_0.vars.item then
		return 
	end
	
	local var_26_0 = arg_26_0.vars.wnd
	
	if_set_visible(var_26_0, "btn_lock", not arg_26_1)
	if_set_visible(var_26_0, "btn_lock_done", arg_26_1)
	if_set_visible(var_26_0, "locked", arg_26_1)
end

function ShopExclusiveEquip_result.closeResultDlg(arg_27_0)
	if arg_27_0.vars and get_cocos_refid(arg_27_0.vars.wnd) then
		UIAction:Add(SEQ(FADE_OUT(150), REMOVE()), arg_27_0.vars.wnd, "block")
		BackButtonManager:pop("equip_exclusive_result")
		
		if arg_27_0.vars.isAlchemy then
			AlchemistSelect:closeResultPopup()
		end
		
		arg_27_0.vars = {}
	end
end
