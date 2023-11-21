SanctuaryCraft = {}
SanctuaryCraftMain = {}
SanctuaryCraftCategories = {}
SanctuaryMain.MODE_LIST.Craft = SanctuaryCraftMain
CraftMassPopup = {}
CraftEpicPopup = {}

local var_0_0 = 10

function HANDLER.equip_craft_landing(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_eqmade" then
		SanctuaryCraftMain:setMode("equip_craft")
	elseif arg_1_1 == "btn_eqreforging" then
		SanctuaryCraftMain:setMode("equip_upgrade_select")
	elseif arg_1_1 == "btn_eqreset" then
		SanctuaryCraftMain:setMode("equip_reset")
	elseif arg_1_1 == "btn_craft_event" then
		SanctuaryCraftMain:setMode("equip_craft_event")
	end
end

function HANDLER_BEFORE.equip_craft(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_obtainable" then
		SanctuaryCraft:showSetInfo(true)
	elseif arg_2_1 == "btn_info_point" then
		SanctuaryCraft:showPointInfo(true)
	end
end

function HANDLER_CANCEL.equip_craft(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_obtainable" then
		SanctuaryCraft:showSetInfo(false)
	elseif arg_3_1 == "btn_info_point" then
		SanctuaryCraft:showPointInfo(false)
	end
end

function HANDLER.equip_craft(arg_4_0, arg_4_1)
	if arg_4_1 == "btn_obtainable" then
		SanctuaryCraft:showSetInfo(false)
	elseif arg_4_1 == "btn_info_point" then
		SanctuaryCraft:showPointInfo(false)
	end
	
	if string.starts(arg_4_1, "btn_tab") then
		SoundEngine:play("event:/ui/category/select")
		
		if SanctuaryCraft:selectSet(tonumber(string.sub(arg_4_1, 8, -1))) then
			SanctuaryCraft:updateItems()
		end
	end
	
	if string.starts(arg_4_1, "btn_equip_") then
		SoundEngine:play("event:/ui/category/select")
		
		if SanctuaryCraft:selectCategory(string.sub(arg_4_1, #"btn_equip_" + 1, -1)) then
			SanctuaryCraft:updateItems()
		end
	end
	
	if arg_4_1 == "btn_ok" then
		SanctuaryCraft:reqCraft()
	elseif arg_4_1 == "btn_legendary" then
		SanctuaryCraft:setCraftEpic(true)
	elseif arg_4_1 == "btn_cancel" then
		SanctuaryCraft:setCraftEpic(false)
	end
end

function HANDLER.equip_craft_result(arg_5_0, arg_5_1)
	if EquipCraftEvent:isActiveDlg() then
		EquipCraftEvent:dlgHandler(arg_5_0, arg_5_1)
		
		return 
	end
	
	if SubstoryBurningShop:isActiveDlg() then
		SubstoryBurningShop:dlgHandler(arg_5_0, arg_5_1)
		
		return 
	end
	
	if arg_5_1 == "btn_bg" then
		SanctuaryCraft:closeResultDlg()
	elseif arg_5_1 == "btn_lock" or arg_5_1 == "btn_lock_done" then
		SanctuaryCraft:LockUnLock_resultItem(arg_5_1)
	elseif arg_5_1 == "btn_sell" then
		SanctuaryCraft:sellResultItem()
	elseif arg_5_1 == "btn_extract" then
		SanctuaryCraft:extractResultItem()
	end
end

function HANDLER.equip_craft_bar(arg_6_0, arg_6_1)
	local var_6_0 = getParentWindow(arg_6_0)
	
	SanctuaryCraft:onPushCraft(arg_6_1, var_6_0.item)
end

function HANDLER.equip_craft_confirm(arg_7_0, arg_7_1)
	if arg_7_1 == "btn_go" then
		SanctuaryCraft:playCraftMass()
	elseif arg_7_1 == "btn_cancel" then
		SanctuaryCraft:closeCraftMassConfirmPopup()
	end
end

function HANDLER.equip_craft_legen_sel(arg_8_0, arg_8_1)
	if string.starts(arg_8_1, "btn_set_sel") then
		CraftEpicPopup:selectSet(string.sub(arg_8_1, -1, -1))
	elseif arg_8_1 == "btn_ok" then
		CraftEpicPopup:playCraftEpic()
	elseif arg_8_1 == "btn_cancel" then
		CraftEpicPopup:closeEpicPopup()
	end
end

function HANDLER_BEFORE.equip_craft_result10_item(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_1 == "btn_select" then
		arg_9_0.touch_tick = systick()
	end
end

function HANDLER.equip_craft_result10_item(arg_10_0, arg_10_1)
	if arg_10_1 == "btn_select" and systick() - to_n(arg_10_0.touch_tick) < 180 then
		CraftMassPopup:selectItem(arg_10_0:getParent(), arg_10_0.item)
	end
end

function HANDLER.equip_craft_result10(arg_11_0, arg_11_1)
	if arg_11_1 == "btn_organize" then
		CraftMassPopup:toggleSellMode(true)
	elseif arg_11_1 == "btn_cancel" then
		CraftMassPopup:toggleSellMode(false)
	elseif arg_11_1 == "btn_confirm" then
		CraftMassPopup:closeCraftMassPopup()
	elseif arg_11_1 == "btn_sell" then
		CraftMassPopup:req_sellItems()
	elseif arg_11_1 == "btn_extract" then
		CraftMassPopup:req_extractItems()
	elseif arg_11_1 == "btn_lock" then
		CraftMassPopup:req_lockItems()
	elseif arg_11_1 == "btn_go_again" then
		SanctuaryCraft:reqCraftMassAgain()
	end
end

function SanctuaryCraftMain.onEnter(arg_12_0, arg_12_1)
	SoundEngine:play("event:/ui/sanctuary/enter_craft")
	
	arg_12_0.vars = {}
	arg_12_0.vars.parent_layer = arg_12_1
	arg_12_0.vars.mode_list = {
		equip_craft_landing = {
			onEnter = function()
				SanctuaryCraftMain:onShow()
			end,
			onLeave = function(arg_14_0)
				if arg_14_0 == "equip_craft_event" then
					return 
				end
				
				SanctuaryCraftMain:onHide()
			end
		},
		equip_craft = {
			onEnter = function()
				SanctuaryCraft:onEnter(arg_12_1)
			end,
			onLeave = function()
				SanctuaryCraft:onLeave()
			end
		},
		equip_reset = {
			disable_top_right = true,
			disable_upgrade_bar = true,
			onEnter = function()
				SanctuaryCraftReset:onEnter({
					layer = arg_12_1
				})
			end,
			onLeave = function()
				SanctuaryCraftReset:onLeave()
			end,
			canLeave = function()
				return SanctuaryCraftReset:canLeave()
			end
		},
		equip_upgrade_select = {
			disable_top_right = true,
			onEnter = function()
				SanctuaryCraftUpgradeSelect:onShow()
			end,
			onLeave = function(arg_21_0)
				if arg_21_0 == "equip_upgrade" then
					SanctuaryCraftUpgradeSelect:onHide()
				else
					SanctuaryCraftUpgradeSelect:onLeave()
				end
			end
		},
		equip_upgrade = {
			disable_top_right = true,
			disable_upgrade_bar = true,
			onEnter = function()
				SanctuaryCraftUpgradeSelect:enterMode()
			end,
			onLeave = function()
				SanctuaryCraftUpgrade:onLeave()
			end,
			canLeave = function()
				return SanctuaryCraftUpgrade:canLeave()
			end
		},
		equip_craft_event = {
			onEnter = function()
				query("get_equip_craft_info")
			end,
			onLeave = function()
				EquipCraftEvent:remove()
			end
		}
	}
	arg_12_0.vars.mode = "equip_craft_landing"
	arg_12_0.vars.wnd = load_dlg("equip_craft_landing", true, "wnd")
	
	arg_12_1:addChild(arg_12_0.vars.wnd)
	arg_12_0:init()
	arg_12_0:updateUI()
	arg_12_0:setUIAction()
	GrowthGuideNavigator:proc()
end

function SanctuaryCraftMain.updateUI(arg_27_0)
	if not arg_27_0.vars or not get_cocos_refid(arg_27_0.vars.wnd) then
		return 
	end
	
	local var_27_0 = EquipCraftEventUtil:findScheduleByAccountData()
	local var_27_1 = arg_27_0.vars.wnd:findChildByName("n_menu_normal")
	
	if var_27_0 then
		var_27_1 = arg_27_0.vars.wnd:findChildByName("n_menu_3")
	end
	
	if_set_visible(arg_27_0.vars.wnd, "n_menu_normal", not var_27_0)
	if_set_visible(arg_27_0.vars.wnd, "n_menu_3", var_27_0)
	
	local var_27_2 = var_27_1:findChildByName("n_eqmade")
	local var_27_3 = var_27_1:findChildByName("n_eqreforging")
	local var_27_4 = var_27_1:findChildByName("n_eqreset")
	
	if_set_visible(var_27_2, "icon_locked", not UnlockSystem:isUnlockSystem(UNLOCK_ID.SANC_CRAFT))
	if_set_visible(var_27_3, "icon_locked", not UnlockSystem:isUnlockSystem(UNLOCK_ID.EQUIP_UPGRADE))
	if_set_visible(var_27_4, "icon_locked", not UnlockSystem:isUnlockSystem(UNLOCK_ID.SANC_CRAFT))
	if_set_opacity(var_27_2, nil, not UnlockSystem:isUnlockSystem(UNLOCK_ID.SANC_CRAFT) and 76.5 or 255)
	if_set_opacity(var_27_3, nil, not UnlockSystem:isUnlockSystem(UNLOCK_ID.EQUIP_UPGRADE) and 76.5 or 255)
	if_set_opacity(var_27_4, nil, not UnlockSystem:isUnlockSystem(UNLOCK_ID.SANC_CRAFT) and 76.5 or 255)
	
	if var_27_0 then
		local var_27_5 = var_27_1:findChildByName("n_craft_event")
		
		if_set_visible(var_27_5, "icon_locked", not UnlockSystem:isUnlockSystem(UNLOCK_ID.SANC_CRAFT))
		if_set_opacity(var_27_5, nil, not UnlockSystem:isUnlockSystem(UNLOCK_ID.SANC_CRAFT) and 76.5 or 255)
		EquipCraftEventUtil:updateTimeTooltip(var_27_5:findChildByName("cm_time_tooltip"))
	end
end

function SanctuaryCraftMain.get_equip_made_button(arg_28_0)
	if not arg_28_0.vars or not get_cocos_refid(arg_28_0.vars.wnd) then
		return 
	end
	
	local var_28_0 = EquipCraftEventUtil:findScheduleByAccountData()
	local var_28_1
	
	if var_28_0 then
		var_28_1 = arg_28_0.vars.wnd:findChildByName("n_menu_3")
	else
		var_28_1 = arg_28_0.vars.wnd:findChildByName("n_menu_normal")
	end
	
	return var_28_1:getChildByName("btn_eqmade")
end

function SanctuaryCraftMain.get_equip_reforging_button(arg_29_0)
	if not arg_29_0.vars or not get_cocos_refid(arg_29_0.vars.wnd) then
		return 
	end
	
	local var_29_0 = EquipCraftEventUtil:findScheduleByAccountData()
	local var_29_1
	
	if var_29_0 then
		var_29_1 = arg_29_0.vars.wnd:findChildByName("n_menu_3")
	else
		var_29_1 = arg_29_0.vars.wnd:findChildByName("n_menu_normal")
	end
	
	return var_29_1:getChildByName("btn_eqreforging")
end

function SanctuaryCraftMain.setUIAction(arg_30_0)
	local var_30_0 = 300
	
	arg_30_0.vars.wnd:setOpacity(0)
	UIAction:Add(SEQ(FADE_IN(300)), arg_30_0.vars.wnd, "block")
	
	local var_30_1 = arg_30_0.vars.wnd:getChildByName("portrait")
	local var_30_2 = var_30_1:getPositionX()
	local var_30_3 = var_30_1:getPositionY()
	
	var_30_1:setPositionY(-700)
	UIAction:Add(LOG(MOVE_TO(var_30_0 - 80, var_30_2, var_30_3)), var_30_1, "block")
	
	local var_30_4 = EquipCraftEventUtil:findScheduleByAccountData()
	local var_30_5
	
	if var_30_4 then
		var_30_5 = arg_30_0.vars.wnd:findChildByName("n_menu_3")
	else
		var_30_5 = arg_30_0.vars.wnd:findChildByName("n_menu_normal")
	end
	
	if not get_cocos_refid(var_30_5) then
		return 
	end
	
	local function var_30_6(arg_31_0)
		local var_31_0 = var_30_5:getChildByName(arg_31_0)
		
		if get_cocos_refid(var_31_0) then
			local var_31_1, var_31_2 = var_31_0:getPosition()
			local var_31_3 = DESIGN_WIDTH / 2
			
			if math.abs(var_31_3 - var_31_1) < 5 then
				return 
			end
			
			var_31_0:setPositionX(var_31_3)
			UIAction:Add(LOG(MOVE_TO(var_30_0, var_31_1, var_31_2)), var_31_0, "block")
		end
	end
	
	var_30_6("n_eqmade")
	var_30_6("n_eqreforging")
	var_30_6("n_eqreset")
	var_30_6("n_craft_event")
end

function SanctuaryCraftMain.init(arg_32_0)
	local var_32_0 = UIUtil:getPortraitAni("npc1126", {})
	
	if var_32_0 then
		arg_32_0.vars.wnd:getChildByName("portrait"):addChild(var_32_0)
		var_32_0:setName("@portrait")
	end
end

function SanctuaryCraftMain.setMode(arg_33_0, arg_33_1)
	if arg_33_1 == "equip_craft" and not UnlockSystem:isUnlockSystem(UNLOCK_ID.SANC_CRAFT) then
		return 
	end
	
	if arg_33_1 == "equip_craft" and ContentDisable:byAlias("craft") then
		balloon_message(T("content_disable"))
		
		return 
	end
	
	if arg_33_1 == "equip_upgrade_select" and not UnlockSystem:isUnlockSystem(UNLOCK_ID.EQUIP_UPGRADE) then
		Dialog:msgBox(T("ui_reforge_level_error"), {
			fade_in = 250,
			title = T("system_craft_title")
		})
		
		return 
	end
	
	local var_33_0 = arg_33_0.vars.mode
	
	arg_33_0.vars.mode = arg_33_1
	
	TopBarNew:setEnableTopRight()
	SanctuaryMain:showUpgradeBar(true)
	
	local var_33_1 = arg_33_0.vars.mode_list[var_33_0]
	
	if var_33_1 and type(var_33_1.onLeave) == "function" then
		var_33_1.onLeave(arg_33_1)
	end
	
	local var_33_2 = arg_33_0.vars.mode_list[arg_33_1]
	
	if var_33_2 then
		if var_33_2.disable_top_right then
			TopBarNew:setDisableTopRight()
		end
		
		if var_33_2.disable_upgrade_bar then
			SanctuaryMain:showUpgradeBar(false)
		end
		
		if type(var_33_2.onEnter) == "function" then
			var_33_2.onEnter(var_33_0)
		end
	end
end

function SanctuaryCraftMain.getMode(arg_34_0)
	if not arg_34_0.vars then
		return 
	end
	
	return arg_34_0.vars.mode
end

function SanctuaryCraftMain.getParentLayer(arg_35_0)
	return arg_35_0.vars.parent_layer
end

function SanctuaryCraftMain.onPushBackButton(arg_36_0)
	if SceneManager:getCurrentSceneName() == "equip_craft" then
		SceneManager:popScene()
	elseif arg_36_0:getMode() == "equip_craft_landing" then
		SanctuaryMain:setMode("Main")
	else
		SanctuaryCraftMain:onLeave()
	end
end

function SanctuaryCraftMain.onShow(arg_37_0)
	if not arg_37_0.vars or not get_cocos_refid(arg_37_0.vars.wnd) then
		return 
	end
	
	arg_37_0:updateUI()
	arg_37_0.vars.wnd:setVisible(true)
end

function SanctuaryCraftMain.onHide(arg_38_0)
	if not arg_38_0.vars or not get_cocos_refid(arg_38_0.vars.wnd) then
		return 
	end
	
	arg_38_0.vars.wnd:setVisible(false)
end

function SanctuaryCraftMain.onLeave(arg_39_0)
	if not arg_39_0.vars then
		return 
	end
	
	local var_39_0 = arg_39_0:getMode()
	local var_39_1 = arg_39_0.vars.mode_list[var_39_0]
	
	if var_39_1 and type(var_39_1.canLeave) == "function" and not var_39_1:canLeave() then
		return 
	end
	
	if var_39_0 == "equip_upgrade" then
		arg_39_0:setMode("equip_upgrade_select")
	elseif var_39_0 == "equip_craft_landing" then
		UIAction:Add(SEQ(FADE_OUT(150), REMOVE()), arg_39_0.vars.wnd, "block")
		
		arg_39_0.vars = nil
	else
		arg_39_0:setMode("equip_craft_landing")
	end
end

function SanctuaryCraftMain.CheckNotification(arg_40_0)
	if TutorialCondition:isEnable("system_070") then
		return true
	end
	
	if TutorialCondition:isEnable("item_reforge") then
		return true
	end
	
	if not UnlockSystem:isUnlockSystem(UNLOCK_ID.SANC_CRAFT) then
		return false
	end
	
	return SanctuaryMain:GetTotalLevel("Craft") < 9 and Account:getCurrency("stone") > 0
end

function SanctuaryCraftMain.onUpdateUpgrade(arg_41_0)
	if arg_41_0:getMode() == "equip_craft" then
		SanctuaryCraft:onUpdateUpgrade()
	end
end

function SanctuaryCraft.onEnter(arg_42_0, arg_42_1, arg_42_2)
	arg_42_0.vars = {}
	arg_42_0.vars.wnd = arg_42_0:show(arg_42_1)
end

function SanctuaryCraft.onLeave(arg_43_0)
	if not arg_43_0.vars or not get_cocos_refid(arg_43_0.vars.wnd) then
		return 
	end
	
	TopBarNew:setCurrencies({
		"crystal",
		"gold",
		"stone"
	})
	arg_43_0:close()
	
	arg_43_0.vars = {}
end

copy_functions(ScrollView, SanctuaryCraft)
copy_functions(ScrollView, SanctuaryCraftCategories)

function SanctuaryCraftCategories.select(arg_44_0, arg_44_1)
	for iter_44_0, iter_44_1 in pairs(arg_44_0.ScrollViewItems) do
		if_set_visible(iter_44_1.control, "bg", arg_44_1 == iter_44_1.item.craft_id)
	end
	
	return arg_44_0.ScrollViewItems[arg_44_1].item
end

function SanctuaryCraftCategories.update(arg_45_0)
	for iter_45_0, iter_45_1 in pairs(arg_45_0.ScrollViewItems) do
		arg_45_0:updateScrollViewItem(iter_45_1.control, iter_45_1.item)
	end
end

function SanctuaryCraftCategories.updateScrollViewItem(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = false
	
	if_set_visible(arg_46_1, "n_condition_unlocked", not var_46_0)
	if_set_visible(arg_46_1, "n_condition_locked", var_46_0)
	
	if var_46_0 then
		if_set(arg_46_1:getChildByName("img_up2"), "txt_lv", arg_46_2.lv)
	end
end

function SanctuaryCraftCategories.getScrollViewItem(arg_47_0, arg_47_1)
	local var_47_0 = load_control("wnd/equip_craft_cat.csb")
	
	var_47_0.guide_tag = tostring(arg_47_1.craft_id)
	
	if_set(var_47_0, "name", T(arg_47_1.category))
	if_set(var_47_0, "name_req", T(arg_47_1.category))
	if_set_sprite(var_47_0, "icon", "img/" .. arg_47_1.icon .. ".png")
	if_set_sprite(var_47_0, "icon_req", "img/" .. arg_47_1.icon .. ".png")
	arg_47_0:updateScrollViewItem(var_47_0, arg_47_1)
	
	return var_47_0
end

function SanctuaryCraftCategories.onSelectScrollViewItem(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
	if SanctuaryCraft:selectSet(arg_48_2.item.craft_id) then
		SanctuaryCraft:updateItems()
	end
end

function SanctuaryCraftCategories.init(arg_49_0, arg_49_1)
	arg_49_0:initScrollView(arg_49_1, 260, 92, {
		fit_height = true
	})
	
	arg_49_0.categories = {}
	
	for iter_49_0 = 1, 99 do
		local var_49_0 = SLOW_DB_ALL("item_craft_category", tostring(iter_49_0))
		
		if not var_49_0.id then
			break
		end
		
		table.push(arg_49_0.categories, var_49_0)
	end
	
	arg_49_0:createScrollViewItems(arg_49_0.categories)
	GrowthGuideNavigator:proc()
end

function SanctuaryCraft.onPushCraft(arg_50_0, arg_50_1, arg_50_2)
	arg_50_0.vars.cur_item = arg_50_2
	
	if arg_50_0.vars.craft_epic then
		if arg_50_1 == "btn_go_10" then
			balloon_message_with_sound("ui_equipcraft_epic_10_msg")
			
			return 
		else
			arg_50_0:reqCraftEpic()
		end
	elseif arg_50_1 == "btn_go_10" then
		arg_50_0:reqCraftMass()
	else
		arg_50_0:reqCraft()
	end
end

function SanctuaryCraft.getCurItem(arg_51_0)
	if not arg_51_0.vars or not arg_51_0.vars.cur_item then
		return 
	end
	
	return arg_51_0.vars.cur_item
end

function SanctuaryCraft.reqCraft(arg_52_0, arg_52_1)
	arg_52_1 = arg_52_1 or arg_52_0.vars.cur_item
	
	local var_52_0 = arg_52_0:checkCraftErrCode(arg_52_1)
	
	if var_52_0 == "res1" or var_52_0 == "res2" then
		balloon_message_with_sound("need_material")
		
		return 
	end
	
	if var_52_0 == "gold" and not UIUtil:checkCurrencyDialog("gold") then
		return 
	end
	
	if Account:getCurrentEquipCount() <= Account:getFreeEquipCount() then
		Dialog:msgBox(T("too_many_equip"), {
			yesno = true,
			handler = function()
				UIUtil:showIncEquipInvenDialog()
			end
		})
		
		return 
	end
	
	Dialog:msgBox(T("msg_start_craft"), {
		yesno = true,
		yes_text = T("system_009_title"),
		handler = function(arg_54_0)
			query("craft_equip", {
				craft_key = arg_52_0.vars.cur_item.craft_key,
				col = arg_52_0.vars.cur_item.col
			})
			TutorialGuide:procGuide("system_070")
		end
	})
	TutorialGuide:procGuide("system_070")
	GrowthGuideNavigator:proc()
end

function SanctuaryCraft.showPointInfo(arg_55_0, arg_55_1)
	if not arg_55_0.vars then
		return 
	end
	
	if_set_visible(arg_55_0.vars.wnd, "n_point", arg_55_1)
end

function SanctuaryCraft.getMileageType(arg_56_0)
	local var_56_0
	
	if arg_56_0.vars.set_index then
		local var_56_1 = DB("item_craft_category", tostring(arg_56_0.vars.set_index), "category")
		
		var_56_0 = string.sub(var_56_1, 5, -4)
	end
	
	return var_56_0
end

function SanctuaryCraft.getEpicCraftCount(arg_57_0, arg_57_1)
	local var_57_0 = arg_57_1 or arg_57_0:getMileageType()
	
	if not var_57_0 then
		return 
	end
	
	local var_57_1 = Account:getEquipMileage(var_57_0)
	local var_57_2 = GAME_CONTENT_VARIABLE.epic_equip_craft
	
	return math.floor(var_57_1 / var_57_2)
end

function SanctuaryCraft.setCraftEpic(arg_58_0, arg_58_1, arg_58_2)
	if arg_58_1 and arg_58_0:getEpicCraftCount() < 1 then
		balloon_message_with_sound("ui_equipcraft_epic_count_msg")
		
		return 
	end
	
	if arg_58_1 == arg_58_0.vars.craft_epic then
		return 
	end
	
	arg_58_0.vars.craft_epic = arg_58_1
	
	if arg_58_1 then
		arg_58_0:selectCategory("all")
		if_set_visible(arg_58_0.vars.wnd, "btn_legendary", false)
		if_set_visible(arg_58_0.vars.wnd, "btn_cancel", true)
	else
		arg_58_0:selectCategory("weapon")
		if_set_visible(arg_58_0.vars.wnd, "btn_legendary", true)
		if_set_visible(arg_58_0.vars.wnd, "btn_cancel", false)
	end
	
	if not arg_58_2 then
		arg_58_0:updateItems()
	end
end

function SanctuaryCraft.reqCraftEpic(arg_59_0, arg_59_1)
	arg_59_1 = arg_59_1 or arg_59_0.vars.cur_item
	
	if arg_59_0:getEpicCraftCount() < 1 then
		balloon_message_with_sound("ui_equipcraft_epic_count_msg")
		
		return 
	end
	
	local var_59_0 = arg_59_0:checkCraftErrCode(arg_59_1)
	
	if var_59_0 == "res1" or var_59_0 == "res2" then
		balloon_message_with_sound("need_material")
		
		return 
	end
	
	if var_59_0 == "gold" and not UIUtil:checkCurrencyDialog("gold") then
		return 
	end
	
	if Account:getCurrentEquipCount() <= Account:getFreeEquipCount() then
		Dialog:msgBox(T("too_many_equip"), {
			yesno = true,
			handler = function()
				UIUtil:showIncEquipInvenDialog()
			end
		})
		
		return 
	end
	
	CraftEpicPopup:openEpicPopup({
		item = arg_59_1,
		set_infos = arg_59_0.vars.set_infos
	})
end

function CraftEpicPopup.openEpicPopup(arg_61_0, arg_61_1)
	arg_61_0.vars = {}
	arg_61_0.vars.opts = arg_61_1
	arg_61_0.vars.idx_selected = nil
	
	local var_61_0 = arg_61_1.layer or SceneManager:getRunningNativeScene()
	
	arg_61_0.vars.wnd = load_dlg("equip_craft_legen_sel", true, "wnd", function()
		CraftEpicPopup:closeEpicPopup()
	end)
	
	var_61_0:addChild(arg_61_0.vars.wnd)
	arg_61_0.vars.wnd:bringToFront()
	
	if arg_61_0.vars.opts.is_burning then
		if_set(arg_61_0.vars.wnd, "t_disc", T("bshop_equipcraft_desc"))
	end
	
	local var_61_1 = arg_61_1.set_infos
	
	for iter_61_0 = 1, 4 do
		local var_61_2 = arg_61_0.vars.wnd:getChildByName("n_set" .. iter_61_0)
		
		if not var_61_1[iter_61_0] then
			if_set_visible(var_61_2, nil, false)
			
			break
		end
		
		local var_61_3 = DB("item_set", var_61_1[iter_61_0], {
			"name",
			"icon"
		})
		local var_61_4 = "img/icon_menu_" .. var_61_1[iter_61_0] .. ".png"
		
		if_set(var_61_2, "t_set" .. iter_61_0, T(var_61_3))
		if_set_sprite(var_61_2, "icon_menu_set" .. iter_61_0, var_61_4)
		if_set_visible(var_61_2, "select", false)
	end
	
	if table.count(var_61_1) == 4 then
		local var_61_5 = arg_61_0.vars.wnd:getChildByName("set_sel")
		
		if_set_position_x(var_61_5, nil, var_61_5:getPositionX() - 70)
	end
	
	local var_61_6 = arg_61_1.item
	local var_61_7 = arg_61_0.vars.wnd:getChildByName("btn_ok")
	
	if_set(var_61_7, "label", comma_value(var_61_6.price))
	if_set_opacity(var_61_7, nil, 76.5)
	
	if var_61_6.token then
		local var_61_8 = DB("item_token", var_61_6.token, "icon")
		
		if var_61_8 then
			if_set_sprite(var_61_7, "icon", "item/" .. var_61_8 .. ".png")
		else
			if_set_sprite(var_61_7, "icon", "item/" .. var_61_6.token .. ".png")
		end
	end
end

function CraftEpicPopup.selectSet(arg_63_0, arg_63_1)
	if not arg_63_0.vars or not get_cocos_refid(arg_63_0.vars.wnd) then
		return 
	end
	
	if arg_63_0.vars.idx_selected then
		local var_63_0 = arg_63_0.vars.wnd:getChildByName("n_set" .. arg_63_0.vars.idx_selected)
		
		if_set_visible(var_63_0, "select", false)
	end
	
	local var_63_1 = arg_63_0.vars.wnd:getChildByName("n_set" .. arg_63_1)
	
	if_set_visible(var_63_1, "select", true)
	if_set_opacity(arg_63_0.vars.wnd, "btn_ok", 255)
	
	arg_63_0.vars.idx_selected = to_n(arg_63_1)
end

function CraftEpicPopup.closeEpicPopup(arg_64_0)
	if not arg_64_0.vars or not get_cocos_refid(arg_64_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("equip_craft_legen_sel")
	arg_64_0.vars.wnd:removeFromParent()
	
	arg_64_0.vars.wnd = nil
end

function CraftEpicPopup.playCraftEpic(arg_65_0)
	if not arg_65_0.vars or not get_cocos_refid(arg_65_0.vars.wnd) then
		return 
	end
	
	if not arg_65_0.vars.idx_selected then
		balloon_message_with_sound("ui_equip_craft_set_select")
		
		return 
	end
	
	if arg_65_0.vars.opts and arg_65_0.vars.opts.playCraftEpicFunc then
		arg_65_0.vars.opts.playCraftEpicFunc(arg_65_0.vars.idx_selected)
	else
		local var_65_0 = arg_65_0.vars.opts.item
		local var_65_1 = arg_65_0.vars.opts.set_infos[arg_65_0.vars.idx_selected]
		
		query("craft_equip", {
			craft_key = var_65_0.craft_key,
			col = var_65_0.col,
			fix_set = var_65_1
		})
	end
	
	arg_65_0:closeEpicPopup()
end

function MsgHandler.craft_equip(arg_66_0)
	SanctuaryCraft:playCraft(arg_66_0)
end

function MsgHandler.craft_equip_mass(arg_67_0)
	SanctuaryCraft:res_playCraftMass(arg_67_0)
end

function MsgHandler.lock_equip_mass(arg_68_0)
	CraftMassPopup:res_lockItems(arg_68_0)
end

function SanctuaryCraft.reqCraftMass(arg_69_0)
	if not arg_69_0.vars or not get_cocos_refid(arg_69_0.vars.wnd) or not arg_69_0.vars.cur_item then
		return 
	end
	
	local var_69_0 = arg_69_0.vars.cur_item
	local var_69_1 = arg_69_0:checkCraftErrCode(var_69_0, var_0_0)
	
	if var_69_1 == "res1" or var_69_1 == "res2" then
		balloon_message_with_sound("need_material")
		
		return 
	end
	
	if var_69_1 == "gold" and not UIUtil:checkCurrencyDialog("gold") then
		return 
	end
	
	if Account:getCurrentEquipCount() <= Account:getFreeEquipCount() then
		Dialog:msgBox(T("too_many_equip"), {
			yesno = true,
			handler = function()
				UIUtil:showIncEquipInvenDialog()
			end
		})
		
		return 
	end
	
	if not arg_69_0.vars.cur_item.craft_key or not arg_69_0.vars.cur_item.col then
		return 
	end
	
	arg_69_0.vars.craftConfirm_wnd = load_dlg("equip_craft_confirm", true, "wnd", function()
		SanctuaryCraft:closeCraftMassConfirmPopup()
	end)
	
	SceneManager:getRunningNativeScene():addChild(arg_69_0.vars.craftConfirm_wnd)
	arg_69_0.vars.craftConfirm_wnd:bringToFront()
	
	local var_69_2 = arg_69_0.vars.craftConfirm_wnd:getChildByName("n_item_require")
	
	if_set_visible(var_69_2, "item", true)
	
	local var_69_3 = UIUtil:getRewardIcon(var_69_0.count1_10, var_69_0.material1, {
		show_count = true,
		parent = var_69_2:getChildByName("item")
	})
	
	var_69_3:setPosition(0, 0)
	var_69_3:setAnchorPoint(0, 0)
	if_set(arg_69_0.vars.craftConfirm_wnd:getChildByName("btn_go"), "label", comma_value(var_69_0.price_10))
	
	local var_69_4 = arg_69_0.vars.craftConfirm_wnd:getChildByName("n_craft")
	local var_69_5 = var_69_4:getChildByName("txt_name")
	
	ItemTooltip:updateItemInformation({
		no_resize_name = true,
		no_tooltip = true,
		no_resize = true,
		detail = true,
		wnd = var_69_4,
		code = var_69_0.code,
		txt_name = var_69_5
	})
	if_set_visible(var_69_4, "txt_type", false)
	GrowthGuideNavigator:proc()
end

function SanctuaryCraft.reqCraftMassAgain(arg_72_0)
	arg_72_0:reqCraftMass()
end

function SanctuaryCraft.closeCraftMassConfirmPopup(arg_73_0)
	if not arg_73_0.vars or not get_cocos_refid(arg_73_0.vars.craftConfirm_wnd) then
		return 
	end
	
	BackButtonManager:pop("equip_craft_confirm")
	arg_73_0.vars.craftConfirm_wnd:removeFromParent()
	
	arg_73_0.vars.craftConfirm_wnd = nil
end

function SanctuaryCraft.playCraftMass(arg_74_0)
	arg_74_0:closeCraftMassConfirmPopup()
	CraftMassPopup:closeCraftMassPopup()
	query("craft_equip_mass", {
		craft_key = arg_74_0.vars.cur_item.craft_key,
		col = arg_74_0.vars.cur_item.col
	})
end

function SanctuaryCraft.res_playCraftMass(arg_75_0, arg_75_1)
	local var_75_0 = Account:addReward(arg_75_1)
	local var_75_1 = arg_75_1.new_equips[1].code
	local var_75_2 = DB("equip_item", var_75_1, "type")
	
	ConditionContentsManager:dispatch("equip.craft", {
		add_count = 10,
		equiptype = var_75_2,
		code = var_75_1
	})
	
	for iter_75_0, iter_75_1 in pairs(arg_75_1.items) do
		Account:setItemCount(iter_75_0, iter_75_1)
	end
	
	Account:updateCurrencies(arg_75_1)
	arg_75_0:updateCurrencies(arg_75_1.items)
	Account:updateEquipMileage(arg_75_1.mileages)
	arg_75_0:updateEquipMileage()
	TopBarNew:topbarUpdate(true)
	CraftMassPopup:openCraftMassPopup(var_75_0.rewards)
	
	for iter_75_2, iter_75_3 in pairs(arg_75_0.ScrollViewItems) do
		arg_75_0:updateScrollViewItem(iter_75_3.control, iter_75_3.item)
	end
end

function CraftMassPopup.openCraftMassPopup(arg_76_0, arg_76_1)
	arg_76_0.vars = {}
	arg_76_0.vars.sellMode = false
	arg_76_0.vars.items = arg_76_1 or {}
	arg_76_0.vars.selectedItems = {}
	arg_76_0.vars.wnd = load_dlg("equip_craft_result10", true, "wnd", function()
		CraftMassPopup:closeCraftMassPopup()
	end)
	
	if_set_visible(arg_76_0.vars.wnd, "n_btn_normal", true)
	if_set_visible(arg_76_0.vars.wnd, "n_btn_organize", false)
	
	local var_76_0 = arg_76_0.vars.wnd:getChildByName("btn_go_again")
	local var_76_1 = SanctuaryCraft:getCurItem() or {}
	
	if get_cocos_refid(var_76_0) and var_76_1.price_10 then
		if_set(var_76_0, "label", comma_value(var_76_1.price_10))
	end
	
	local var_76_2 = SanctuaryCraft:checkCraftErrCode(var_76_1, 10)
	
	if var_76_2 and var_76_2 == "gold" then
		if_set_color(var_76_0, "label", cc.c3b(255, 0, 0))
	else
		if_set_color(var_76_0, "label", cc.c3b(255, 255, 255))
	end
	
	SceneManager:getRunningNativeScene():addChild(arg_76_0.vars.wnd)
	arg_76_0:toggleSellMode(false)
	if_set_visible(arg_76_0.vars.wnd, "n_title", false)
	if_set_visible(arg_76_0.vars.wnd, "n_item", false)
	if_set_visible(arg_76_0.vars.wnd, "n_bottom", false)
	
	local var_76_3 = 2000
	local var_76_4 = var_76_3 + 200
	local var_76_5 = 200
	
	UIAction:Add(SEQ(DELAY(var_76_4), FADE_IN(var_76_5)), CraftMassPopup.vars.wnd:getChildByName("n_title"), "block")
	UIAction:Add(SEQ(DELAY(var_76_4), FADE_IN(var_76_5)), CraftMassPopup.vars.wnd:getChildByName("n_item"), "block")
	UIAction:Add(SEQ(DELAY(var_76_4), FADE_IN(var_76_5)), CraftMassPopup.vars.wnd:getChildByName("n_bottom"), "block")
	EffectManager:Play({
		pivot_x = 629,
		fn = "itembuild_10_f.cfx",
		pivot_y = 365,
		pivot_z = 99998,
		layer = CraftMassPopup.vars.wnd:getChildByName("n_eff_front")
	})
	EffectManager:Play({
		fn = "ui_reward_popup_eff.cfx",
		pivot_z = 99998,
		layer = CraftMassPopup.vars.wnd,
		delay = var_76_4,
		pivot_x = DESIGN_WIDTH / 2,
		pivot_y = CraftMassPopup.vars.wnd:getChildByName("title_bg"):getPositionY()
	})
end

function CraftMassPopup.openRewardMassPopup(arg_78_0, arg_78_1, arg_78_2)
	arg_78_0.vars = {}
	arg_78_0.vars.sellMode = false
	arg_78_0.vars.rewardMode = true
	arg_78_0.vars.selectedItems = {}
	arg_78_2 = arg_78_2 or {}
	arg_78_0.vars.opts = arg_78_2
	arg_78_1 = arg_78_1 or {}
	arg_78_0.vars.items = arg_78_1
	arg_78_0.vars.wnd = load_dlg("equip_craft_result10", true, "wnd", function()
		CraftMassPopup:closeCraftMassPopup()
	end)
	
	if_set_visible(arg_78_0.vars.wnd, "n_btn_normal", false)
	if_set_visible(arg_78_0.vars.wnd, "n_btn_organize", false)
	;(arg_78_2.layer or SceneManager:getRunningNativeScene()):addChild(arg_78_0.vars.wnd)
	arg_78_0:toggleSellMode(false)
	if_set_visible(arg_78_0.vars.wnd, "n_item", false)
	if_set_visible(arg_78_0.vars.wnd, "n_bottom", false)
	
	local var_78_0 = arg_78_0.vars.wnd:getChildByName("n_title")
	
	if_set_visible(var_78_0, nil, false)
	if_set_visible(var_78_0, "txt", false)
	if_set_visible(var_78_0, "t_title_count", true)
	
	local var_78_1 = arg_78_0.vars.wnd:getChildByName("n_btn_box_open")
	
	if_set_visible(var_78_1, nil, true)
	if_set_visible(var_78_1, "btn_next", false)
	if_set_visible(var_78_1, "btn_confirm", true)
	
	local var_78_2 = 200
	local var_78_3 = 200
	
	UIAction:Add(SEQ(DELAY(var_78_2), FADE_IN(var_78_3)), var_78_0, "block")
	UIAction:Add(SEQ(DELAY(var_78_2), FADE_IN(var_78_3)), CraftMassPopup.vars.wnd:getChildByName("n_item"), "block")
	UIAction:Add(SEQ(DELAY(var_78_2), FADE_IN(var_78_3)), CraftMassPopup.vars.wnd:getChildByName("n_bottom"), "block")
	EffectManager:Play({
		fn = "ui_reward_popup_eff.cfx",
		pivot_z = 99998,
		layer = CraftMassPopup.vars.wnd,
		delay = var_78_2,
		pivot_x = DESIGN_WIDTH / 2,
		pivot_y = CraftMassPopup.vars.wnd:getChildByName("title_bg"):getPositionY()
	})
end

function CraftMassPopup._setItemStats(arg_80_0, arg_80_1, arg_80_2)
	local var_80_0
	local var_80_1
	local var_80_2
	local var_80_3
	local var_80_4, var_80_5, var_80_6, var_80_7 = arg_80_2:getMainStat()
	
	if_set(arg_80_1, "txt_main_stat", to_var_str(var_80_4, var_80_5))
	SpriteCache:resetSprite(arg_80_1:getChildByName("main_icon"), "img/cm_icon_stat_" .. string.gsub(var_80_5, "_rate", "") .. ".png")
	
	local var_80_8 = {}
	local var_80_9 = {}
	local var_80_10 = 0
	
	for iter_80_0 = 2, 99 do
		if not arg_80_2.op[iter_80_0] then
			break
		end
		
		local var_80_11 = arg_80_2.op[iter_80_0][1]
		local var_80_12 = arg_80_2.op[iter_80_0][2]
		
		if not var_80_9[var_80_11] then
			var_80_10 = var_80_10 + 1
			var_80_9[var_80_11] = var_80_10
		end
		
		if type(var_80_12) == "table" then
			var_80_8[var_80_11] = var_80_12
		else
			var_80_8[var_80_11] = (var_80_8[var_80_11] or 0) + var_80_12
		end
	end
	
	for iter_80_1, iter_80_2 in pairs(var_80_8) do
		local var_80_13 = var_80_9[iter_80_1]
		
		if_set_visible(arg_80_1, "icon_type" .. var_80_13, true)
		if_set_visible(arg_80_1, "txt_stat" .. var_80_13, true)
		if_set(arg_80_1, "txt_stat" .. var_80_13, getStatName(iter_80_1))
		
		if type(iter_80_2) == "table" then
			if_set(arg_80_1, "txt_stat" .. var_80_13, to_var_str(iter_80_2[1], iter_80_1, nil, true) .. "-" .. to_var_str(iter_80_2[2], iter_80_1))
		else
			if_set(arg_80_1, "txt_stat" .. var_80_13, to_var_str(iter_80_2, iter_80_1))
			SpriteCache:resetSprite(arg_80_1:getChildByName("icon_type" .. var_80_13), "img/cm_icon_stat_" .. string.gsub(iter_80_1, "_rate", "") .. ".png")
		end
	end
end

function CraftMassPopup.refreshItemList(arg_81_0)
end

function CraftMassPopup.updatePopup(arg_82_0)
	if not arg_82_0.vars or not get_cocos_refid(arg_82_0.vars.wnd) then
		return 
	end
	
	if_set_visible(arg_82_0.vars.wnd, "n_no_data", table.empty(arg_82_0.vars.items))
	
	for iter_82_0, iter_82_1 in pairs(arg_82_0.vars.items) do
		local var_82_0 = arg_82_0.vars.wnd:getChildByName("n_item" .. iter_82_0)
		
		if not get_cocos_refid(var_82_0) then
			break
		end
		
		var_82_0:removeAllChildren()
		
		local var_82_1 = load_control("wnd/equip_craft_result10_item.csb")
		local var_82_2 = UIUtil:getRewardIcon("equip", iter_82_1.code, {
			tooltip_delay = 130,
			parent = var_82_1:getChildByName("bg_item"),
			equip = iter_82_1.item
		})
		
		if iter_82_1.item:checkSell() then
			if_set_visible(var_82_1, "n_select", iter_82_1.selected)
		else
			if_set_visible(var_82_1, "n_select", false)
			if_set_visible(var_82_2, "locked", false)
			if_set_cascade_color(var_82_1, "icon_locked", false)
			if_set_visible(var_82_1, "icon_locked", true)
			
			for iter_82_2, iter_82_3 in pairs(var_82_1:getChildren()) do
				if_set_opacity(iter_82_3, nil, arg_82_0.vars.sellMode and 76.5 or 255)
			end
			
			if_set_opacity(var_82_1, "icon_locked", 255)
		end
		
		local var_82_3 = var_82_1:getChildByName("btn_select")
		
		if get_cocos_refid(var_82_3) then
			var_82_3.item = iter_82_1.item
		end
		
		arg_82_0:_setItemStats(var_82_1, iter_82_1.item)
		var_82_0:addChild(var_82_1)
	end
	
	for iter_82_4 = table.count(arg_82_0.vars.items) + 1, 10 do
		local var_82_4 = arg_82_0.vars.wnd:getChildByName("n_item" .. iter_82_4)
		
		if not get_cocos_refid(var_82_4) then
			break
		end
		
		var_82_4:removeAllChildren()
	end
	
	if_set_visible(arg_82_0.vars.wnd, "n_btn_normal", not arg_82_0.vars.sellMode and not arg_82_0.vars.rewardMode)
	if_set_visible(arg_82_0.vars.wnd, "n_btn_box_open", not arg_82_0.vars.sellMode and arg_82_0.vars.rewardMode)
	if_set_visible(arg_82_0.vars.wnd, "n_btn_organize", arg_82_0.vars.sellMode)
end

function CraftMassPopup.toggleSellMode(arg_83_0, arg_83_1)
	if arg_83_1 ~= nil then
		arg_83_0.vars.sellMode = arg_83_1
	else
		arg_83_0.vars.sellMode = not arg_83_0.vars.sellMode
	end
	
	for iter_83_0, iter_83_1 in pairs(arg_83_0.vars.items) do
		iter_83_1.item.selected = false
	end
	
	if_set_visible(arg_83_0.vars.wnd, "txt_disc", not arg_83_0.vars.sellMode)
	if_set_visible(arg_83_0.vars.wnd, "txt_selected", arg_83_0.vars.sellMode)
	
	local var_83_0 = table.count(arg_83_0.vars.selectedItems) or 0
	
	if_set(arg_83_0.vars.wnd, "txt_selected", T("ui_extraction_select_inventory", {
		count = var_83_0
	}))
	
	arg_83_0.vars.selectedItems = {}
	
	arg_83_0:updatePopup()
	arg_83_0:updateButtons()
end

function CraftMassPopup.selectItem(arg_84_0, arg_84_1, arg_84_2)
	if not arg_84_1 or not arg_84_2 or not arg_84_0.vars.sellMode or not arg_84_2:checkSell() then
		return 
	end
	
	arg_84_2.selected = not arg_84_2.selected
	
	if_set_visible(arg_84_1, "n_select", arg_84_2.selected)
	
	if Account:isUnlockExtract() and arg_84_2.selected then
		if_set_visible(arg_84_1, "icon_dont", not arg_84_2:isExtractable())
	else
		if_set_visible(arg_84_1, "icon_dont", false)
	end
	
	if arg_84_2.selected then
		table.insert(arg_84_0.vars.selectedItems, arg_84_2)
	else
		for iter_84_0, iter_84_1 in pairs(arg_84_0.vars.selectedItems) do
			if arg_84_2:getUID() == iter_84_1:getUID() then
				table.remove(arg_84_0.vars.selectedItems, iter_84_0)
			end
		end
	end
	
	local var_84_0 = table.count(arg_84_0.vars.selectedItems) or 0
	
	if_set(arg_84_0.vars.wnd, "txt_selected", T("ui_extraction_select_inventory", {
		count = var_84_0
	}))
	arg_84_0:updateButtons()
end

function CraftMassPopup.updateButtons(arg_85_0)
	if not arg_85_0.vars then
		return 
	end
	
	if table.empty(arg_85_0.vars.selectedItems) then
		if_set_opacity(arg_85_0.vars.wnd, "btn_lock", 76.5)
		if_set_opacity(arg_85_0.vars.wnd, "btn_sell", 76.5)
		if_set_opacity(arg_85_0.vars.wnd, "btn_extract", 76.5)
	else
		if_set_opacity(arg_85_0.vars.wnd, "btn_lock", 255)
		if_set_opacity(arg_85_0.vars.wnd, "btn_sell", 255)
		if_set_opacity(arg_85_0.vars.wnd, "btn_extract", 255)
	end
	
	for iter_85_0, iter_85_1 in pairs(arg_85_0.vars.selectedItems) do
		if not iter_85_1:isExtractable() then
			if_set_opacity(arg_85_0.vars.wnd, "btn_extract", 76.5)
			
			break
		end
	end
	
	if not Account:isUnlockExtract() then
		if_set_visible(arg_85_0.vars.wnd, "btn_extract", false)
	end
end

function CraftMassPopup.removeSellItems(arg_86_0, arg_86_1)
	local var_86_0 = arg_86_1 or arg_86_0.vars.selectedItems or {}
	
	for iter_86_0 = 1, #var_86_0 do
		local var_86_1 = var_86_0[iter_86_0]
		
		if not var_86_1 then
			break
		end
		
		for iter_86_1, iter_86_2 in pairs(arg_86_0.vars.items) do
			if iter_86_2.item:getUID() == var_86_1:getUID() then
				table.remove(arg_86_0.vars.items, iter_86_1)
				
				break
			end
		end
	end
end

function CraftMassPopup.req_sellItems(arg_87_0)
	if not arg_87_0.vars or not get_cocos_refid(arg_87_0.vars.wnd) or not arg_87_0.vars.sellMode or table.empty(arg_87_0.vars.selectedItems) then
		return 
	end
	
	local var_87_0 = 0
	local var_87_1 = {}
	
	for iter_87_0, iter_87_1 in pairs(arg_87_0.vars.selectedItems) do
		if iter_87_1.isEquip then
			var_87_0 = var_87_0 + calcEquipSellPrice(iter_87_1)
			
			table.push(var_87_1, iter_87_1:getUID())
		end
	end
	
	local var_87_2 = var_87_0 + PetSkill:getLobbyAddCalcValue(SKILL_CONDITION.EQUIP_SELL_GOLD_UP, var_87_0)
	
	GlobalGetSellDialog(var_87_2, nil, var_87_1, "sanctuary_craft_mass", function()
		CraftMassPopup:removeSellItems()
		CraftMassPopup:afterOrganizeItems()
	end)
end

function CraftMassPopup.req_extractItems(arg_89_0)
	local var_89_0 = {}
	local var_89_1 = false
	
	for iter_89_0, iter_89_1 in pairs(arg_89_0.vars.selectedItems) do
		if iter_89_1.isEquip and iter_89_1:isExtractable() then
			table.insert(var_89_0, iter_89_1)
		else
			var_89_1 = true
		end
	end
	
	if table.empty(var_89_0) then
		if var_89_1 then
			balloon_message_with_sound("msg_extraction_level_error")
		end
		
		return 
	end
	
	Inventory:extractUtil(var_89_0, "equip_craft_mass", function()
		CraftMassPopup:removeSellItems(var_89_0)
		CraftMassPopup:afterOrganizeItems()
	end)
end

function CraftMassPopup.req_lockItems(arg_91_0)
	if not arg_91_0.vars or table.empty(arg_91_0.vars.selectedItems) then
		return 
	end
	
	local var_91_0 = {}
	
	for iter_91_0, iter_91_1 in pairs(arg_91_0.vars.selectedItems) do
		if iter_91_1.isEquip and not iter_91_1.lock then
			table.insert(var_91_0, iter_91_1:getUID())
		end
	end
	
	if table.empty(var_91_0) then
		return 
	end
	
	query("lock_equip_mass", {
		equips = array_to_json(var_91_0)
	})
end

function CraftMassPopup.res_lockItems(arg_92_0, arg_92_1)
	local var_92_0 = arg_92_1.equips or {}
	
	for iter_92_0, iter_92_1 in pairs(var_92_0) do
		Account:getEquip(iter_92_1).lock = true
	end
	
	balloon_message_with_sound("equip_lock")
	SoundEngine:play("event:/ui/unit_detail/btn_lock")
	arg_92_0:afterOrganizeItems()
end

function CraftMassPopup.afterOrganizeItems(arg_93_0)
	if not arg_93_0.vars then
		return 
	end
	
	local var_93_0 = table.count(arg_93_0.vars.items) or 0
	
	CraftMassPopup:toggleSellMode(var_93_0 > 0)
	if_set(arg_93_0.vars.wnd, "txt_selected", T("ui_extraction_select_inventory", {
		count = 0
	}))
end

function CraftMassPopup.closeCraftMassPopup(arg_94_0)
	if not arg_94_0.vars or not get_cocos_refid(arg_94_0.vars.wnd) then
		return 
	end
	
	BackButtonManager:pop("equip_craft_result")
	arg_94_0.vars.wnd:removeFromParent()
	
	arg_94_0.vars = {}
end

function SanctuaryCraft.playCraft(arg_95_0, arg_95_1)
	set_high_fps_tick(10000)
	Account:addEquip(arg_95_1.equip)
	
	local var_95_0 = Account:getEquip(arg_95_1.equip.id)
	
	arg_95_0.vars.result_equip = var_95_0
	
	local var_95_1 = DB("equip_item", arg_95_1.equip.code, "type")
	
	ConditionContentsManager:dispatch("equip.craft", {
		equiptype = var_95_1,
		code = arg_95_1.equip.code
	})
	
	for iter_95_0, iter_95_1 in pairs(arg_95_1.items) do
		Account:setItemCount(iter_95_0, iter_95_1)
	end
	
	Account:updateCurrencies(arg_95_1)
	arg_95_0:updateCurrencies(arg_95_1.items)
	Account:updateEquipMileage(arg_95_1.mileages)
	arg_95_0:updateEquipMileage()
	TopBarNew:topbarUpdate(true)
	
	arg_95_0.vars.modal_dlg = load_dlg("equip_craft_result", true, "wnd", function()
		SanctuaryCraft:closeResultDlg()
	end)
	arg_95_0.vars.modal_dlg.sub_wnd = load_dlg("item_detail_sub", true, "wnd")
	
	arg_95_0.vars.modal_dlg.sub_wnd:setAnchorPoint(0.5, 0.5)
	arg_95_0.vars.modal_dlg.sub_wnd:setPosition(0, 0)
	arg_95_0.vars.modal_dlg:getChildByName("n_pos_detail"):addChild(arg_95_0.vars.modal_dlg.sub_wnd)
	arg_95_0:updateTargetitemInfo(arg_95_0.vars.modal_dlg.sub_wnd, arg_95_0.vars.cur_item.code)
	SceneManager:getRunningNativeScene():addChild(arg_95_0.vars.modal_dlg)
	ItemTooltip:updateItemFrame(arg_95_0.vars.modal_dlg, var_95_0)
	ItemTooltip:updateItemInformation({
		detail = true,
		wnd = arg_95_0.vars.modal_dlg.sub_wnd,
		equip = var_95_0
	})
	
	local var_95_2 = arg_95_0.vars.modal_dlg.sub_wnd:getChildByName("txt_set_info")
	
	if get_cocos_refid(var_95_2) then
		local var_95_3 = var_95_2:getStringNumLines()
		
		if var_95_3 and var_95_3 >= 4 then
			local var_95_4 = arg_95_0.vars.modal_dlg:getChildByName("cm_tooltipbox")
			local var_95_5 = arg_95_0.vars.modal_dlg:getChildByName("block")
			local var_95_6 = arg_95_0.vars.modal_dlg:getChildByName("n_btn")
			local var_95_7 = arg_95_0.vars.modal_dlg:getChildByName("frame_grade")
			
			if get_cocos_refid(var_95_4) and get_cocos_refid(var_95_5) and get_cocos_refid(var_95_6) and get_cocos_refid(var_95_7) then
				local var_95_8 = var_95_4:getContentSize()
				local var_95_9 = var_95_5:getContentSize()
				local var_95_10 = var_95_7:getContentSize()
				
				var_95_4:setContentSize({
					width = var_95_8.width,
					height = var_95_8.height + 20
				})
				var_95_5:setContentSize({
					width = var_95_9.width,
					height = var_95_9.height + 20
				})
				var_95_7:setContentSize({
					width = var_95_10.width,
					height = var_95_10.height + 20
				})
				
				local var_95_11 = var_95_6:getPositionY()
				
				var_95_6:setPositionY(var_95_11 - 20)
			end
		end
	end
	
	LuaEventDispatcher:addIfNotEventListener("update.equip.lock", LISTENER(SanctuaryCraft.updateEquipLock, arg_95_0), "craft.equip.result.popup")
	
	local var_95_12, var_95_13 = arg_95_0.vars.modal_dlg.sub_wnd:getChildByName("bg_item"):getPosition()
	local var_95_14 = arg_95_0.vars.modal_dlg:getChildByName("bg_item")
	local var_95_15 = arg_95_0.vars.modal_dlg:getChildByName("n_etc")
	local var_95_16 = arg_95_0.vars.modal_dlg:getChildByName("n_stats")
	local var_95_17 = arg_95_0.vars.modal_dlg:getChildByName("n_names")
	local var_95_18 = arg_95_0.vars.modal_dlg:getChildByName("n_btn")
	
	if_set(arg_95_0.vars.modal_dlg, "txt", T("ui_equip_craft_result_title"))
	var_95_14:setPosition(150, 317)
	var_95_14:setOpacity(0)
	var_95_15:setOpacity(0)
	var_95_16:setOpacity(0)
	var_95_18:setOpacity(0)
	var_95_17:setVisible(false)
	
	local var_95_19 = 2000
	local var_95_20 = 300
	local var_95_21 = 200
	local var_95_22 = var_95_19 + var_95_21
	local var_95_23 = 200
	
	UIAction:Add(SEQ(DELAY(var_95_19), FADE_IN(var_95_21), MOVE_TO(var_95_20, var_95_12, var_95_13)), var_95_14, "block")
	UIAction:Add(SEQ(DELAY(var_95_22), FADE_IN(var_95_23)), var_95_15, "block")
	UIAction:Add(SEQ(DELAY(var_95_22), FADE_IN(var_95_23)), var_95_16, "block")
	UIAction:Add(SEQ(DELAY(var_95_22), FADE_IN(var_95_23)), var_95_18, "block")
	UIAction:Add(SEQ(DELAY(var_95_22 + var_95_20), FADE_IN(var_95_23)), var_95_17, "block")
	EffectManager:Play({
		pivot_x = 629,
		fn = "ui_itembuild_b.cfx",
		pivot_y = 365,
		pivot_z = 99998,
		layer = SanctuaryCraft.vars.modal_dlg:getChildByName("n_eff_back")
	})
	EffectManager:Play({
		scaleY = 1.1,
		pivot_x = 629,
		fn = "ui_itembuild_f.cfx",
		pivot_y = 390,
		pivot_z = 99998,
		layer = SanctuaryCraft.vars.modal_dlg:getChildByName("n_eff_front")
	})
	UIAction:Add(SEQ(DELAY(var_95_22 + var_95_20), CALL(arg_95_0.playResultStatEffect, arg_95_0)), arg_95_0, "block")
	
	for iter_95_2, iter_95_3 in pairs(arg_95_0.ScrollViewItems) do
		arg_95_0:updateScrollViewItem(iter_95_3.control, iter_95_3.item)
	end
	
	if_set_visible(arg_95_0.vars.modal_dlg, "btn_extract", Account:isUnlockExtract())
	
	if not Account:isUnlockExtract() then
		local var_95_24 = arg_95_0.vars.modal_dlg:getChildByName("n_btn")
		
		if not var_95_24.originPosY then
			var_95_24.originPosY = var_95_24:getPositionY()
		end
		
		var_95_24:setPositionY(var_95_24.originPosY - 57)
	else
		if_set_opacity(arg_95_0.vars.modal_dlg, "btn_extract", var_95_0:isExtractable() and 255 or 76.5)
	end
end

function SanctuaryCraft.playResultStatEffect(arg_97_0)
	local var_97_0 = CACHE:getEffect("itemupgrade_statup")
	local var_97_1 = arg_97_0.vars.modal_dlg.sub_wnd:getChildByName("txt_main_stat")
	local var_97_2, var_97_3 = var_97_1:getPosition()
	
	var_97_0:setScaleY(2)
	var_97_0:setPosition(var_97_2 - 20, var_97_3)
	var_97_0:setLocalZOrder(2000)
	var_97_1:getParent():addChild(var_97_0)
	UIAction:AddSync(SEQ(DMOTION("animation"), REMOVE()), var_97_0)
	
	for iter_97_0 = 1, 4 do
		local var_97_4 = arg_97_0.vars.modal_dlg.sub_wnd:getChildByName("txt_sub_stat" .. iter_97_0)
		
		if var_97_4:isVisible() then
			local var_97_5, var_97_6 = var_97_4:getPosition()
			local var_97_7 = CACHE:getEffect("itemupgrade_statup")
			
			var_97_7:setScaleX(0.5)
			var_97_7:setPosition(var_97_5, var_97_6)
			var_97_7:setLocalZOrder(2000)
			var_97_4:getParent():addChild(var_97_7)
			UIAction:AddSync(SEQ(DMOTION("animation"), REMOVE()), var_97_7)
		end
	end
end

function SanctuaryCraft.LockUnLock_resultItem(arg_98_0, arg_98_1)
	if not arg_98_0.vars.modal_dlg or not get_cocos_refid(arg_98_0.vars.modal_dlg) or not arg_98_0.vars.result_equip then
		return 
	end
	
	if arg_98_1 == "btn_lock" then
		query("lock_equip", {
			equip = arg_98_0.vars.result_equip.id
		})
	elseif arg_98_1 == "btn_lock_done" then
		query("unlock_equip", {
			equip = arg_98_0.vars.result_equip.id
		})
	end
end

function SanctuaryCraft.updateEquipLock(arg_99_0, arg_99_1)
	if not arg_99_0.vars or not arg_99_0.vars.modal_dlg or not get_cocos_refid(arg_99_0.vars.modal_dlg) or not arg_99_0.vars.result_equip then
		return 
	end
	
	local var_99_0 = arg_99_0.vars.modal_dlg
	
	if_set_visible(var_99_0, "btn_lock", not arg_99_1)
	if_set_visible(var_99_0, "btn_lock_done", arg_99_1)
	if_set_visible(var_99_0, "locked", arg_99_1)
end

function SanctuaryCraft.sellResultItem(arg_100_0)
	if not arg_100_0.vars.modal_dlg or not get_cocos_refid(arg_100_0.vars.modal_dlg) or not arg_100_0.vars.result_equip then
		return 
	end
	
	if arg_100_0.vars.result_equip.lock then
		balloon_message_with_sound("equip_sell_locked")
		
		return 
	end
	
	local var_100_0 = calcEquipSellPrice(arg_100_0.vars.result_equip)
	local var_100_1 = var_100_0 + PetSkill:getLobbyAddCalcValue(SKILL_CONDITION.EQUIP_SELL_GOLD_UP, var_100_0)
	local var_100_2 = {}
	
	table.push(var_100_2, arg_100_0.vars.result_equip.id)
	GlobalGetSellDialog(var_100_1, nil, var_100_2, "craft_result")
end

function SanctuaryCraft.extractResultItem(arg_101_0)
	if not arg_101_0.vars.modal_dlg or not get_cocos_refid(arg_101_0.vars.modal_dlg) or not arg_101_0.vars.result_equip then
		return 
	end
	
	if arg_101_0.vars.result_equip.lock then
		balloon_message_with_sound("equip_extract_locked")
		
		return 
	end
	
	if not arg_101_0.vars.result_equip:isExtractable() then
		balloon_message_with_sound("msg_extraction_level_error")
		
		return 
	end
	
	Inventory:extractUtil({
		arg_101_0.vars.result_equip
	}, "craftItemPopup")
end

function SanctuaryCraft.closeResultDlg(arg_102_0)
	if not arg_102_0.vars or not arg_102_0.vars.modal_dlg then
		return 
	end
	
	BackButtonManager:pop("equip_craft_result")
	UIAction:Add(SEQ(FADE_OUT(150), REMOVE()), arg_102_0.vars.modal_dlg, "block")
	
	arg_102_0.vars.modal_dlg = nil
	
	TutorialGuide:procGuide("system_070")
end

function SanctuaryCraft.close(arg_103_0)
	local var_103_0 = arg_103_0.vars.wnd
	local var_103_1 = var_103_0:getChildByName("LEFT")
	local var_103_2 = var_103_0:getChildByName("RIGHT")
	local var_103_3 = var_103_0:getChildByName("CENTER")
	
	UIAction:Add(RLOG(MOVE_TO(200, VIEW_BASE_LEFT + -500, 0)), var_103_1, "block")
	UIAction:Add(RLOG(MOVE_TO(200, 500, 0)), var_103_2, "block")
	UIAction:Add(RLOG(MOVE_TO(200, 0, -700)), var_103_3, "block")
	UIAction:Add(SEQ(DELAY(260), REMOVE()), var_103_0, "block")
end

function SanctuaryCraft.show(arg_104_0, arg_104_1)
	arg_104_0.vars = {}
	
	local var_104_0 = load_dlg("equip_craft", true, "wnd")
	
	arg_104_0.vars.wnd = var_104_0
	
	if arg_104_1 then
		arg_104_1:addChild(var_104_0)
	end
	
	if_set_visible(var_104_0, "n_set_tooltip", false)
	arg_104_0:initScrollView(arg_104_0.vars.wnd:getChildByName("scrollview"), 680, 150)
	SanctuaryCraftCategories:init(arg_104_0.vars.wnd:getChildByName("scrollview_sets"))
	arg_104_0:loadDB()
	arg_104_0:selectSet(1)
	arg_104_0:selectCategory("weapon")
	arg_104_0:updateItems()
	arg_104_0:onSelectScrollViewItem(1, arg_104_0.ScrollViewItems[1], nil, true)
	
	if SceneManager:getCurrentSceneName() == "equip_craft" then
		TopBarNew:create(T("system_009_title"), arg_104_0.vars.wnd, function()
			arg_104_0:onPushBackButton()
			BackButtonManager:pop("TopBarNew." .. T("system_009_title"))
		end)
	else
		if_set_visible(arg_104_0.vars.wnd, "background")
	end
	
	local var_104_1 = var_104_0:getChildByName("LEFT")
	local var_104_2 = var_104_0:getChildByName("RIGHT")
	local var_104_3 = var_104_0:getChildByName("CENTER")
	
	var_104_1:setPositionX(-300 + VIEW_BASE_LEFT)
	var_104_2:setPositionX(300 - VIEW_BASE_LEFT)
	var_104_3:setPositionY(-700)
	
	local var_104_4 = NOTCH_LEFT_WIDTH > 0 and NOTCH_LEFT_WIDTH or NOTCH_WIDTH
	local var_104_5 = DEBUG.ORIENTAION_TEST or getenv("device.orientation") == "landscape_left"
	local var_104_6 = var_104_5 and 0 or  / 2
	local var_104_7 = not var_104_5 and 0 or  / 2
	
	UIAction:Add(LOG(MOVE_TO(250, VIEW_BASE_LEFT + var_104_6, 0)), var_104_1, "block")
	UIAction:Add(LOG(MOVE_TO(250, 0 - VIEW_BASE_LEFT - var_104_7, 0)), var_104_2, "block")
	UIAction:Add(LOG(MOVE_TO(250, 0, 0)), var_104_3, "block")
	TutorialGuide:procGuide("system_070")
	GrowthGuideNavigator:proc()
	
	return var_104_0
end

function SanctuaryCraft.onPushBackButton(arg_106_0)
	print("onPushBackButton????????????????????????????????")
	
	if SceneManager:getCurrentSceneName() == "equip_craft" then
		SceneManager:popScene()
	else
		SanctuaryMain:setMode("Main")
	end
end

function SanctuaryCraft.selectSet(arg_107_0, arg_107_1)
	if arg_107_0.vars.set_index == arg_107_1 then
		return 
	end
	
	local var_107_0 = SanctuaryCraftCategories:select(arg_107_1)
	
	arg_107_0.vars.set_index = arg_107_1
	
	for iter_107_0 = 1, 99 do
		local var_107_1 = arg_107_0.vars.wnd:getChildByName("set" .. iter_107_0)
		
		if not var_107_1 then
			break
		end
		
		if iter_107_0 == arg_107_1 then
			if_set_opacity(var_107_1, "bg", 255)
		else
			if_set_opacity(var_107_1, "bg", 0)
		end
	end
	
	local var_107_2 = arg_107_0.vars.wnd:getChildByName("n_set_icons")
	
	var_107_2:removeAllChildren()
	if_set(arg_107_0.vars.wnd, "txt_cat_title", T(var_107_0.category))
	if_set(arg_107_0.vars.wnd, "monster_disc", T(var_107_0.mileage_txt))
	if_set_sprite(arg_107_0.vars.wnd, "icon_monster", "img/" .. var_107_0.icon .. ".png")
	arg_107_0:updateEquipMileage()
	arg_107_0:setCraftEpic(false, true)
	
	local var_107_3 = arg_107_0.vars.items[arg_107_0.vars.set_index]
	
	if not var_107_3[1] then
		return 
	end
	
	arg_107_0.vars.set_infos = {}
	
	local var_107_4 = var_107_3[1].set_fx
	
	for iter_107_1 = 1, 999 do
		local var_107_5 = DB("item_set_rate", string.format("%s_%02d", var_107_4, iter_107_1), "set_id")
		
		if not var_107_5 then
			break
		end
		
		table.push(arg_107_0.vars.set_infos, var_107_5)
	end
	
	local var_107_6 = table.count(arg_107_0.vars.set_infos)
	
	for iter_107_2, iter_107_3 in pairs(arg_107_0.vars.set_infos) do
		local var_107_7 = SpriteCache:getSprite(EQUIP:getSetItemIconPath(iter_107_3))
		
		var_107_7:setPositionX((var_107_6 - iter_107_2) * -40)
		var_107_2:addChild(var_107_7)
	end
	
	return true
end

function SanctuaryCraft.selectCategory(arg_108_0, arg_108_1)
	if arg_108_0.vars.category == arg_108_1 then
		return 
	end
	
	arg_108_0.vars.category = arg_108_1
	
	local var_108_0 = arg_108_0.vars.wnd:findChildByName("n_sub_tabs")
	local var_108_1 = var_108_0:getChildByName("n_selected")
	local var_108_2 = var_108_0:getChildByName("n_tab_" .. arg_108_1)
	
	var_108_1:setPositionX(var_108_2:getPositionX())
	
	return true
end

function SanctuaryCraft.getScrollViewItem(arg_109_0, arg_109_1)
	arg_109_1 = arg_109_0:updateRequireCounts(arg_109_1)
	arg_109_1.control = load_dlg("equip_craft_bar", true, "wnd")
	
	ItemTooltip:updateItemInformation({
		no_resize_name = true,
		no_tooltip = true,
		no_resize = true,
		detail = true,
		wnd = arg_109_1.control,
		code = arg_109_1.code,
		txt_name = arg_109_1.control:getChildByName("txt_name")
	})
	if_set_visible(arg_109_1.control, "txt_type", false)
	if_set(arg_109_1.control:getChildByName("btn_go"), "label", comma_value(arg_109_1.price))
	if_set(arg_109_1.control:getChildByName("btn_go_10"), "label", comma_value(arg_109_1.price_10))
	
	arg_109_1.control.item = arg_109_1
	arg_109_1.control.guide_tag = string.sub(arg_109_1.code or "", 1, 4)
	
	arg_109_0:updateScrollViewItem(arg_109_1.control, arg_109_1)
	
	return arg_109_1.control
end

function SanctuaryCraft.checkCraftErrCode(arg_110_0, arg_110_1, arg_110_2)
	local var_110_0 = arg_110_2 or 1
	local var_110_1 = to_n(arg_110_1.count1) * var_110_0
	local var_110_2 = to_n(arg_110_1.price) * var_110_0
	
	if arg_110_0.vars.craft_epic and var_110_0 > 1 then
		return "epic"
	end
	
	if var_110_1 > Account:getItemCount(arg_110_1.material1) then
		return "res1"
	end
	
	if arg_110_1.material2 and Account:getItemCount(arg_110_1.material2) < to_n(arg_110_1.count2) * var_110_0 then
		return "res2"
	end
	
	if var_110_2 > Account:getCurrency("gold") then
		return "gold"
	end
	
	return nil
end

function SanctuaryCraft.updateRequireCounts(arg_111_0, arg_111_1)
	local var_111_0 = SanctuaryMain:GetLevels("Craft")[3]
	local var_111_1 = DB("sanctuary_upgrade", "craft_2_" .. var_111_0, "value_1")
	
	arg_111_1.count1 = math.floor(arg_111_1.o_count1 * var_111_1 + 0.5)
	
	if arg_111_1.material2 then
		arg_111_1.count2 = math.floor(arg_111_1.o_count2 * var_111_1 + 0.5)
	end
	
	arg_111_1.count1_10 = arg_111_1.count1 * var_0_0
	
	local var_111_2 = SanctuaryMain:GetLevels("Craft")[1]
	local var_111_3 = DB("sanctuary_upgrade", "craft_0_" .. var_111_2, "value_1") or 1
	
	arg_111_1.price = math.floor(arg_111_1.o_price * var_111_3 + 0.5)
	arg_111_1.price_10 = arg_111_1.price * var_0_0
	
	return arg_111_1
end

function SanctuaryCraft.updateScrollViewItem(arg_112_0, arg_112_1, arg_112_2)
	local var_112_0 = arg_112_1:getChildByName("n_res1")
	local var_112_1 = arg_112_1:getChildByName("n_res2")
	local var_112_2 = UIUtil:getRewardIcon(arg_112_2.count1, arg_112_2.material1, {
		show_count = true,
		parent = var_112_1
	})
	
	if arg_112_2.material2 then
		local var_112_3 = UIUtil:getRewardIcon(arg_112_2.count2, arg_112_2.material2, {
			show_count = true,
			parent = var_112_0
		})
	end
	
	local var_112_4 = arg_112_0:checkCraftErrCode(arg_112_2)
	local var_112_5 = cc.c3b(120, 120, 120)
	local var_112_6 = false
	local var_112_7 = arg_112_1:getChildByName("btn_go")
	
	if Account:getItemCount(arg_112_2.material1) < to_n(arg_112_2.count1) then
		var_112_6 = true
		
		var_112_1:setColor(var_112_5)
	end
	
	if arg_112_2.material2 and Account:getItemCount(arg_112_2.material2) < to_n(arg_112_2.count2) then
		var_112_6 = true
		
		var_112_0:setColor(var_112_5)
	end
	
	if Account:getCurrency("gold") < arg_112_2.price then
		if_set_color(var_112_7, "label", cc.c3b(255, 0, 0))
	end
	
	local var_112_8 = arg_112_1:getChildByName("txt_need")
	
	if_set_visible(arg_112_1, "n_lack", var_112_6)
	
	if var_112_6 then
		local var_112_9 = arg_112_1:getChildByName("n_lack")
		
		if_set_width_from(var_112_9, "lack_bg", "txt", {
			max = 100,
			ratio = 1.4
		})
		if_set_visible(var_112_8, nil, false)
	else
		if_set_visible(var_112_8, nil, true)
	end
	
	UIUtil:changeButtonState(arg_112_1:getChildByName("btn_go"), not var_112_4, true)
	
	if var_112_4 then
		if_set_opacity(arg_112_1, "bg_item", 76.5)
	else
		if_set_opacity(arg_112_1, "bg_item", 255)
	end
	
	local var_112_10 = var_112_7:getChildByName("epic_eff")
	
	if arg_112_0.vars.craft_epic and not get_cocos_refid(var_112_10) then
		local var_112_11 = var_112_7:getContentSize()
		
		var_112_10 = EffectManager:Play({
			fn = "ui_epic_equip_craft_eff.cfx",
			layer = var_112_7,
			x = var_112_11.width / 2 - 1,
			y = var_112_11.height / 2 + 2
		})
		
		var_112_10:setName("epic_eff")
	elseif not arg_112_0.vars.craft_epic and get_cocos_refid(var_112_10) then
		var_112_10:removeFromParent()
	end
	
	UIUserData:call(var_112_7:getChildByName("txt_go"), "RICH_LABEL(true)")
	if_set(var_112_7, "txt_go", T("ui_equip_craft_1"))
	
	local var_112_12 = arg_112_0:checkCraftErrCode(arg_112_2, var_0_0)
	
	UIUtil:changeButtonState(arg_112_1:getChildByName("btn_go_10"), not var_112_12, true)
	
	local var_112_13 = arg_112_1:getChildByName("btn_go_10")
	
	if Account:getCurrency("gold") < arg_112_2.price_10 then
		if_set_color(var_112_13, "label", cc.c3b(255, 0, 0))
	end
	
	if_set(var_112_13, "txt_go", T("ui_equip_craft_10"))
	
	return arg_112_2.control
end

function SanctuaryCraft.loadDB(arg_113_0)
	if not arg_113_0.vars.items then
		arg_113_0.vars.items = {}
		
		for iter_113_0 = 1, 99 do
			if not DB("item_craft", tostring(iter_113_0) .. "_1", "id") then
				break
			end
			
			arg_113_0.vars.items[iter_113_0] = {}
			
			for iter_113_1 = 1, 99 do
				if not DB("item_craft", tostring(iter_113_0) .. "_" .. iter_113_1, "id") then
					break
				end
				
				for iter_113_2 = 1, 6 do
					local var_113_0 = {}
					local var_113_1 = iter_113_0 .. "_" .. iter_113_1
					
					var_113_0.code, var_113_0.material1, var_113_0.material2, var_113_0.o_count1, var_113_0.o_count2, var_113_0.o_price, var_113_0.set_fx = DB("item_craft", var_113_1, {
						"item" .. iter_113_2,
						"material" .. iter_113_2,
						"material" .. iter_113_2 .. "_2",
						"count" .. iter_113_2,
						"count" .. iter_113_2 .. "_2",
						"price" .. iter_113_2,
						"set_id"
					})
					
					if var_113_0.code then
						var_113_0.idx = #arg_113_0.vars.items[iter_113_0] + 1
						var_113_0.craft_key = var_113_1
						var_113_0.row = iter_113_1
						var_113_0.col = iter_113_2
						var_113_0.o_price = var_113_0.o_price or 5000
						
						table.push(arg_113_0.vars.items[iter_113_0], var_113_0)
					end
				end
			end
		end
	end
end

function SanctuaryCraft.updateCurrencies(arg_114_0, arg_114_1)
	if not arg_114_0.vars.id_to_index then
		return 
	end
	
	local var_114_0 = arg_114_0.vars.wnd:findChildByName("mate_item")
	
	for iter_114_0, iter_114_1 in pairs(arg_114_1) do
		local var_114_1 = arg_114_0.vars.id_to_index[iter_114_0]
		local var_114_2 = var_114_0:getChildByName("txt_count_item" .. var_114_1)
		local var_114_3 = arg_114_0.vars.last_values[iter_114_0] or 0
		
		UIAction:Add(INC_NUMBER(500, iter_114_1, nil, var_114_3), var_114_2, iter_114_0 .. "_inc")
		
		arg_114_0.vars.last_values[iter_114_0] = iter_114_1
		
		if_set_opacity(var_114_2, nil, iter_114_1 > 0 and 255 or 76.5)
		if_set_opacity(var_114_0, "material_item" .. var_114_1, iter_114_1 > 0 and 255 or 76.5)
	end
end

function SanctuaryCraft.setCurrencies(arg_115_0, arg_115_1)
	if not arg_115_0.vars.last_values then
		arg_115_0.vars.last_values = {}
		arg_115_0.vars.id_to_index = {}
	end
	
	local var_115_0 = arg_115_0.vars.wnd:findChildByName("mate_item")
	
	for iter_115_0, iter_115_1 in pairs(arg_115_1) do
		local var_115_1 = "txt_count_item" .. iter_115_0
		local var_115_2 = "material_item" .. iter_115_0
		local var_115_3 = var_115_0:getChildByName(var_115_2)
		local var_115_4 = Account:getItemCount(iter_115_1)
		
		UIUtil:getRewardIcon(0, iter_115_1, {
			show_count = false,
			parent = var_115_3
		})
		if_set(var_115_0, var_115_1, comma_value(var_115_4))
		if_set_opacity(var_115_3, nil, var_115_4 > 0 and 255 or 76.5)
		if_set_opacity(var_115_0, var_115_1, var_115_4 > 0 and 255 or 76.5)
		
		arg_115_0.vars.last_values[iter_115_1] = var_115_4
		arg_115_0.vars.id_to_index[iter_115_1] = iter_115_0
	end
	
	local var_115_5 = #arg_115_1
	
	for iter_115_2 = 1, 6 do
		local var_115_6 = true
		
		if var_115_5 < iter_115_2 then
			var_115_6 = false
		end
		
		if_set_visible(var_115_0, "txt_count_item" .. iter_115_2, var_115_6)
		if_set_visible(var_115_0, "material_item" .. iter_115_2, var_115_6)
	end
end

function SanctuaryCraft.updateEquipMileage(arg_116_0)
	local var_116_0 = arg_116_0:getMileageType()
	
	if not var_116_0 then
		return 
	end
	
	local var_116_1 = Account:getEquipMileage(var_116_0)
	local var_116_2 = GAME_CONTENT_VARIABLE.epic_equip_craft
	
	if_set(arg_116_0.vars.wnd, "t_percent", var_116_1 % var_116_2 .. "/" .. var_116_2)
	if_set_percent(arg_116_0.vars.wnd, "progress_bar", var_116_1 % var_116_2 / var_116_2)
	
	local var_116_3 = arg_116_0.vars.wnd:getChildByName("n_legendary")
	local var_116_4 = var_116_3:getChildByName("btn_legendary")
	local var_116_5 = arg_116_0:getEpicCraftCount()
	local var_116_6 = var_116_5 > 0
	
	if var_116_6 then
		local var_116_7 = T("ui_equipcraft_epic_btn_count_1", {
			count = var_116_5
		})
		local var_116_8 = var_116_3:getChildByName("btn_cancel")
		
		if_set(var_116_4, "t_count", var_116_7)
		if_set(var_116_8, "t_count", var_116_7)
	else
		arg_116_0:setCraftEpic(false)
	end
	
	if_set_visible(var_116_4, "t_count", var_116_6)
	if_set_opacity(var_116_4, nil, var_116_6 and 255 or 76.5)
	
	local var_116_9 = var_116_4:getChildByName("t_legendary")
	
	if get_cocos_refid(var_116_9) then
		local var_116_10 = var_116_6 and 49 or 40
		
		var_116_9:setPositionY(var_116_10)
	end
end

function SanctuaryCraft.updateItems(arg_117_0)
	local var_117_0 = arg_117_0.vars.items[arg_117_0.vars.set_index]
	local var_117_1 = {}
	local var_117_2 = {}
	
	for iter_117_0, iter_117_1 in pairs(var_117_0) do
		if arg_117_0.vars.category == "all" or DB("equip_item", iter_117_1.code, "type") == arg_117_0.vars.category then
			if not arg_117_0.vars.craft_epic or DB("equip_item", iter_117_1.code, "tier") == 6 then
				arg_117_0:updateRequireCounts(iter_117_1)
				table.push(var_117_1, iter_117_1)
			end
			
			if iter_117_1.material1 and not table.find(var_117_2, iter_117_1.material1) then
				table.push(var_117_2, iter_117_1.material1)
			end
		end
	end
	
	table.sort(var_117_1, function(arg_118_0, arg_118_1)
		local var_118_0 = arg_117_0:checkCraftErrCode(arg_118_0)
		local var_118_1 = arg_117_0:checkCraftErrCode(arg_118_1)
		
		if not var_118_0 and var_118_1 then
			return true
		end
		
		if var_118_0 and not var_118_1 then
			return false
		end
		
		return arg_118_0.idx < arg_118_1.idx
	end)
	arg_117_0:createScrollViewItems(var_117_1)
	arg_117_0:setCurrencies(var_117_2)
	TopBarNew:setCurrencies({
		"gold",
		"stone"
	})
	GrowthGuideNavigator:proc()
	arg_117_0:jumpToPercent(0)
end

function SanctuaryCraft.onUpdateUpgrade(arg_119_0)
	if not arg_119_0.vars then
		return 
	end
	
	SanctuaryCraftCategories:update()
	arg_119_0:updateItems()
end

function SanctuaryCraft.updateTargetitemInfo(arg_120_0, arg_120_1, arg_120_2, arg_120_3)
	ItemTooltip:updateItemInformation({
		detail = true,
		no_resize = true,
		wnd = arg_120_1,
		code = arg_120_2,
		set_fx = arg_120_3
	})
end

function SanctuaryCraft.onSelectScrollViewItem(arg_121_0, arg_121_1, arg_121_2, arg_121_3, arg_121_4)
	do return  end
	
	if not arg_121_4 then
		SoundEngine:play("event:/ui/ok")
	end
	
	local var_121_0 = arg_121_0.vars.wnd:getChildByName("n_item")
	local var_121_1 = arg_121_2.item
	
	arg_121_0.vars.cur_item = var_121_1
end

function SanctuaryCraft.showSetInfo(arg_122_0, arg_122_1)
	UIUtil:showObtainableSetTooltip(arg_122_0.vars.wnd, arg_122_0.vars.set_infos, arg_122_1)
end
