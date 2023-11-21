LotaRegistrationUI = {}

function HANDLER.clan_heritage_registration(arg_1_0, arg_1_1)
	if string.starts(arg_1_1, "btn_remove") then
		LotaRegistrationUI:select(arg_1_0.idx)
	end
	
	if arg_1_1 == "btn_confirm" or arg_1_1 == "btn_pay" then
		LotaRegistrationUI:confirm()
	end
	
	if arg_1_1 == "btn_reset" then
		LotaRegistrationUI:reset()
	end
	
	if arg_1_1 == "btn_info" then
		LotaRegistrationUI:openInfoPopup()
	end
end

function HANDLER.clan_heritage_registration_confirm(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_close" or arg_2_1 == "btn_cancel" then
		LotaRegistrationUI:closePopup()
	end
	
	if arg_2_1 == "btn_confirm" then
		LotaRegistrationUI:requestRegistration()
	end
	
	if arg_2_1 == "btn_free" or arg_2_1 == "btn_pay" then
		LotaRegistrationUI:requestUnregistration()
	end
end

function HANDLER.clan_heritage_registration_info(arg_3_0, arg_3_1)
	if arg_3_1 == "btn_close" then
		LotaRegistrationUI:closePopup()
	end
end

function LotaRegistrationUI.updateHeroRegistrationCount(arg_4_0)
	local var_4_0 = #LotaUserData:getRegistrationList()
	
	if_set(arg_4_0.vars.dlg, "t_hero_count", T("ui_clanheritage_hero_regi", {
		number = var_4_0
	}))
end

function LotaRegistrationUI.buildHeroBelt(arg_5_0)
	arg_5_0.vars.unit_dock = HeroBelt:create()
	
	local var_5_0 = arg_5_0.vars.unit_dock:getWindow()
	
	arg_5_0.vars.dlg:getChildByName("n_unit_list"):addChild(var_5_0)
	
	local var_5_1 = arg_5_0.vars.dlg:getChildByName("n_sorting_f")
	
	HeroBelt:changeSorterParent(var_5_1, true)
	arg_5_0.vars.unit_dock:setEventHandler(arg_5_0.onHeroListEvent, arg_5_0)
	HeroBelt:resetData(Account.units, "LotaRegistrationBelt", nil, true)
	HeroBelt:showSortButton(true)
	HeroBelt:showAddInvenButton(false)
	
	for iter_5_0, iter_5_1 in pairs(arg_5_0.vars.register_list) do
		if iter_5_1.uid then
			local var_5_2 = Account:getUnit(iter_5_1.uid)
			
			HeroBelt:popItem(var_5_2)
		end
	end
	
	resetPosForNotch(var_5_0:getChildByName("RIGHT"), nil, {
		origin_x = DESIGN_WIDTH
	})
	HeroBelt:scrollToFirstUnit(0)
	arg_5_0:updateHeroRegistrationCount()
end

function LotaRegistrationUI.onHeroListEvent(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_1 == "select" then
		arg_6_0:onSelectUnit(arg_6_2, arg_6_3)
	elseif arg_6_1 == "change" and HeroBelt:isScrolling() then
		vibrate(VIBRATION_TYPE.Select)
	end
end

function LotaRegistrationUI.isAvailableEnter(arg_7_0)
	return TutorialGuide:isClearedTutorial("tuto_heritage_register") or TutorialGuide:isPlayingTutorial("tuto_heritage_register")
end

function LotaRegistrationUI.sendWarningMessage(arg_8_0)
	balloon_message_with_sound("msg_clanheritage_need_tutorial")
end

function LotaRegistrationUI.open(arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_0:isAvailableEnter() then
		arg_9_0:sendWarningMessage()
		
		return false
	end
	
	arg_9_0.vars = {}
	arg_9_0.vars.layer = arg_9_1
	arg_9_0.vars.dlg = LotaUtil:getUIDlg("clan_heritage_registration")
	
	arg_9_0.vars.dlg:setLocalZOrder(1000001)
	
	arg_9_0.vars.register_list = arg_9_2.register_list
	arg_9_0.vars.close_callback = arg_9_2.close_callback
	arg_9_0.vars.mode = nil
	
	TopBarNew:createFromPopup(T("ui_clanheritage_regist_title"), arg_9_0.vars.dlg, function()
		LotaRegistrationUI:onButtonClose()
	end)
	TopBarNew:setCurrencies({
		"clanheritage",
		"clanheritagecoin"
	})
	TopBarNew:checkhelpbuttonID("heritageregistration")
	TopBarNew:setDisableTopRight()
	arg_9_0:buildUI()
	arg_9_0:updateUI()
	arg_9_1:addChild(arg_9_0.vars.dlg)
	TutorialGuide:procGuide("tuto_heritage_register")
	
	return true
end

function LotaRegistrationUI.onButtonClose(arg_11_0)
	if arg_11_0.vars and get_cocos_refid(arg_11_0.vars.dlg) then
		arg_11_0.vars.dlg:removeFromParent()
		BackButtonManager:pop("battle_ready")
		TopBarNew:pop()
		
		if arg_11_0.vars.close_callback then
			arg_11_0.vars.close_callback()
		end
		
		arg_11_0.vars = nil
	end
end

function LotaRegistrationUI.confirmPutOut(arg_12_0)
	local var_12_0 = 0
	
	for iter_12_0 = #arg_12_0.vars.register_list, 1, -1 do
		local var_12_1 = arg_12_0.vars.register_list[iter_12_0]
		
		if var_12_1.select then
			var_12_0 = var_12_0 + 1
			
			if var_12_1.uid then
				local var_12_2 = Account:getUnit(var_12_1.uid)
				
				HeroBelt:revertPoppedItem(var_12_2)
			end
			
			table.remove(arg_12_0.vars.register_list, iter_12_0)
		end
	end
	
	local var_12_3 = #arg_12_0.vars.register_list
	
	for iter_12_1 = 1, var_12_3 do
		arg_12_0.vars.register_list[iter_12_1].idx = iter_12_1
	end
	
	for iter_12_2 = 1, var_12_0 do
		table.insert(arg_12_0.vars.register_list, {
			idx = var_12_3 + iter_12_2
		})
	end
end

function LotaRegistrationUI.confirmPutIn(arg_13_0)
	local var_13_0 = {}
	
	for iter_13_0, iter_13_1 in pairs(arg_13_0.vars.register_list) do
		if iter_13_1.select then
			table.insert(var_13_0, iter_13_1)
			
			iter_13_1.select = false
		end
	end
end

function LotaRegistrationUI.getUIDList(arg_14_0)
	local var_14_0 = {}
	
	for iter_14_0, iter_14_1 in pairs(arg_14_0.vars.register_list) do
		if iter_14_1.uid then
			if arg_14_0.vars.mode == "putout" and not iter_14_1.select then
				table.insert(var_14_0, iter_14_1.uid)
			elseif arg_14_0.vars.mode == "putin" then
				table.insert(var_14_0, iter_14_1.uid)
			end
		end
	end
	
	return var_14_0
end

function LotaRegistrationUI.confirm(arg_15_0)
	if table.count(arg_15_0:getSelectList(arg_15_0.vars.register_list)) == 0 then
		balloon_message_with_sound("need_token")
	else
		if arg_15_0.vars.mode == "putout" and not arg_15_0:isCostEnough() then
			return 
		end
		
		if arg_15_0.vars.mode == "putout" and arg_15_0:isPay() then
			balloon_message_with_sound("msg_clanheritage_hero_deregist_max")
			
			return 
		end
		
		LotaRegistrationUI:createConfirmUI(arg_15_0.vars.register_list)
		BackButtonManager:push({
			check_id = "lota_regi_popup",
			back_func = function()
				LotaRegistrationUI:closePopup()
			end
		})
	end
end

function LotaRegistrationUI.reset(arg_17_0)
	for iter_17_0, iter_17_1 in pairs(arg_17_0.vars.register_list) do
		local var_17_0 = iter_17_1.uid
		
		if iter_17_1.select and arg_17_0.vars.mode == "putin" then
			local var_17_1 = Account:getUnit(var_17_0)
			
			if var_17_1 then
				HeroBelt:revertPoppedItem(var_17_1)
			end
			
			var_17_0 = nil
		end
		
		arg_17_0.vars.register_list[iter_17_0] = {
			select = false,
			uid = var_17_0,
			idx = iter_17_0
		}
	end
	
	arg_17_0.vars.mode = nil
	
	arg_17_0:updateUI()
	arg_17_0.vars.listview:setDataSource(arg_17_0.vars.register_list)
end

function LotaRegistrationUI.updateSelectedCount(arg_18_0)
	return 25
end

function LotaRegistrationUI.updateStorageUnitInven(arg_19_0)
	local var_19_0 = 0
	
	for iter_19_0, iter_19_1 in pairs(arg_19_0.vars.register_list) do
		if iter_19_1.uid then
			var_19_0 = var_19_0 + 1
		end
	end
	
	return var_19_0
end

function LotaRegistrationUI.addSlotPutIn(arg_20_0, arg_20_1)
	local var_20_0 = 0
	
	for iter_20_0, iter_20_1 in pairs(arg_20_0.vars.register_list) do
		if iter_20_1.uid then
			local var_20_1 = Account:getUnit(iter_20_1.uid)
			
			if var_20_1 then
				if var_20_1.db.code == arg_20_1.db.code then
					balloon_message_with_sound("msg_clanheritage_same_hero")
					
					return 
				end
				
				if arg_20_1.db.set_group and var_20_1.db.set_group == arg_20_1.db.set_group then
					balloon_message_with_sound("msg_clanheritage_same_hero")
					
					return 
				end
			end
		end
		
		if not iter_20_1.uid then
			var_20_0 = iter_20_0
			
			break
		end
	end
	
	if var_20_0 < 1 then
		return 
	end
	
	local var_20_2 = arg_20_0.vars.mode ~= "putin"
	
	arg_20_0.vars.mode = "putin"
	
	HeroBelt:popItem(arg_20_1)
	SoundEngine:play("event:/ui/upgrade/slot_in")
	
	arg_20_0.vars.register_list[var_20_0].uid = arg_20_1:getUID()
	arg_20_0.vars.register_list[var_20_0].select = true
	
	arg_20_0.vars.listview:setDataSource(arg_20_0.vars.register_list)
	arg_20_0:updateSelectedCount()
	
	local var_20_3 = arg_20_0:updateStorageUnitInven()
	
	if var_20_2 then
		local var_20_4 = arg_20_0.vars.listview:getInnerContainerSize()
		local var_20_5 = arg_20_0.vars.listview:getContentSize()
		
		var_20_4.height = var_20_4.height - var_20_5.height
		
		local var_20_6 = var_20_4.height / 87.39999999999999
		local var_20_7 = math.floor(var_20_4.width / 253.64999999999998)
		local var_20_8 = 100 / var_20_6
		local var_20_9 = math.floor((var_20_3 - 1) / var_20_7)
		
		arg_20_0.vars.listview:jumpToPercentVertical(math.min(var_20_9 * var_20_8, 100))
	end
	
	arg_20_0:updateUI()
end

function LotaRegistrationUI.onSelectUnit(arg_21_0, arg_21_1)
	if arg_21_0.vars.mode == nil or arg_21_0.vars.mode == "putin" then
		arg_21_0:addSlotPutIn(arg_21_1)
	end
end

function LotaRegistrationUI.select(arg_22_0, arg_22_1)
	arg_22_1 = to_n(arg_22_1)
	
	if arg_22_1 < 1 then
		return 
	end
	
	if arg_22_0.vars.mode == nil or arg_22_0.vars.mode == "putout" then
		local var_22_0 = arg_22_0.vars.register_list[arg_22_1]
		
		if not var_22_0 or not var_22_0.uid then
			return 
		end
		
		local var_22_1 = not var_22_0.select
		local var_22_2 = 1
		
		if not var_22_1 then
			var_22_2 = -1
		end
		
		if arg_22_0:isPay(var_22_2, true) then
			balloon_message_with_sound("msg_clanheritage_hero_deregist_max")
			
			return 
		end
		
		var_22_0.select = not var_22_0.select
		arg_22_0.vars.mode = "putout"
	else
		local var_22_3 = arg_22_0.vars.register_list[arg_22_1]
		
		if not var_22_3 or not var_22_3.uid then
			return 
		end
		
		if var_22_3.select == false then
			return 
		end
		
		local var_22_4 = Account:getUnit(var_22_3.uid)
		
		if not var_22_4 then
			return 
		end
		
		var_22_3.select = false
		var_22_3.uid = nil
		
		arg_22_0:patchListView(arg_22_1)
		HeroBelt:revertPoppedItem(var_22_4)
	end
	
	local var_22_5
	
	for iter_22_0, iter_22_1 in pairs(arg_22_0.vars.register_list) do
		if iter_22_1.select then
			var_22_5 = true
			
			break
		end
	end
	
	if not var_22_5 then
		arg_22_0.vars.mode = nil
	end
	
	arg_22_0:updateUI()
	arg_22_0.vars.listview:setDataSource(arg_22_0.vars.register_list)
end

function LotaRegistrationUI.listViewItemUpdate(arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_1:findChildByName("btn_remove")
	
	if get_cocos_refid(var_23_0) then
		var_23_0:setName("btn_remove:" .. arg_23_2.idx)
		
		var_23_0.idx = arg_23_2.idx
	end
	
	local var_23_1 = arg_23_1:getChildByName("made_unit_bar")
	
	if_set_visible(var_23_1, nil, arg_23_2.uid ~= nil)
	
	if not arg_23_2.uid then
		return arg_23_2.idx
	end
	
	local var_23_2 = Account:getUnit(arg_23_2.uid)
	
	if not var_23_2 then
		Log.e("WARN! NOT UNIT! EXIST UID! BUG!")
		
		return arg_23_2.idx
	end
	
	if not var_23_1 then
		local var_23_3 = UIUtil:updateUnitBar("LotaRegistration", var_23_2)
		
		var_23_3:setName("made_unit_bar")
		arg_23_1:findChildByName("n_unit_bar"):addChild(var_23_3)
		
		var_23_1 = var_23_3
	else
		UIUtil:updateUnitBar("LotaRegistration", var_23_2, {
			force_update = true,
			wnd = var_23_1
		})
	end
	
	var_23_1:setColor(cc.c3b(255, 255, 255))
	
	local var_23_4 = var_23_1:findChildByName("effect_do")
	
	if get_cocos_refid(var_23_4) then
		var_23_4:removeFromParent()
	end
	
	if arg_23_2.select == true then
		EffectManager:Play({
			scale = 1.35,
			fn = "hero_up_slotglow_nomal.cfx",
			y = 44,
			x = 187,
			layer = var_23_1
		}):setName("effect_do")
	elseif arg_23_0.vars.mode == "putin" then
		var_23_1:setColor(cc.c3b(80, 80, 80))
	end
	
	return arg_23_2.idx
end

function LotaRegistrationUI.getRegisterUnitCount(arg_24_0)
	local var_24_0 = 0
	
	for iter_24_0, iter_24_1 in pairs(arg_24_0.vars.register_list) do
		if iter_24_1.uid ~= nil then
			var_24_0 = var_24_0 + 1
		end
	end
	
	return var_24_0
end

function LotaRegistrationUI.patchListView(arg_25_0, arg_25_1)
	for iter_25_0 = arg_25_1 + 1, #arg_25_0.vars.register_list do
		local var_25_0 = arg_25_0.vars.register_list[iter_25_0]
		
		if var_25_0.uid ~= nil then
			arg_25_0.vars.register_list[iter_25_0 - 1].uid = var_25_0.uid
			arg_25_0.vars.register_list[iter_25_0 - 1].select = var_25_0.select
		end
		
		arg_25_0.vars.register_list[iter_25_0].select = false
		arg_25_0.vars.register_list[iter_25_0].uid = nil
	end
end

function LotaRegistrationUI.buildListView(arg_26_0)
	local var_26_0 = {}
	
	for iter_26_0, iter_26_1 in pairs(arg_26_0.vars.register_list) do
		var_26_0[iter_26_0] = {
			select = false,
			uid = iter_26_1,
			idx = iter_26_0
		}
	end
	
	local var_26_1 = LotaUserData:getMaxHeroCount()
	local var_26_2 = table.count(var_26_0)
	local var_26_3 = var_26_1 - var_26_2
	
	if var_26_3 > 0 then
		for iter_26_2 = 1, var_26_3 do
			table.insert(var_26_0, {
				idx = var_26_2 + iter_26_2
			})
		end
	end
	
	arg_26_0.vars.register_list = var_26_0
	
	local var_26_4 = arg_26_0.vars.dlg:getChildByName("listview")
	
	arg_26_0.vars.listview = ItemListView_v2:bindControl(var_26_4)
	
	local var_26_5 = {
		onUpdate = function(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
			return arg_26_0:listViewItemUpdate(arg_27_1, arg_27_3)
		end
	}
	local var_26_6 = load_control("wnd/unit_storage_item.csb")
	
	var_26_6:setScale(0.95)
	var_26_6:setContentSize({
		width = var_26_6:getContentSize().width * 0.95,
		height = var_26_6:getContentSize().height * 0.95
	})
	arg_26_0.vars.listview:setRenderer(var_26_6, var_26_5)
	arg_26_0.vars.listview:removeAllChildren()
	arg_26_0.vars.listview:setDataSource(arg_26_0.vars.register_list)
	arg_26_0.vars.listview:jumpToTop()
end

function LotaRegistrationUI.buildUI(arg_28_0)
	arg_28_0:buildListView()
	arg_28_0:buildHeroBelt()
end

function LotaRegistrationUI.updateUI(arg_29_0)
	arg_29_0:updateHeroRegistrationCount()
	
	local var_29_0 = arg_29_0.vars.dlg:findChildByName("n_left")
	local var_29_1 = arg_29_0.vars.dlg:findChildByName("n_right")
	local var_29_2 = arg_29_0.vars.dlg:findChildByName("n_bottom")
	local var_29_3 = arg_29_0.vars.dlg:findChildByName("n_center")
	local var_29_4 = arg_29_0:getRegisterUnitCount()
	local var_29_5 = table.count(arg_29_0:getSelectList(arg_29_0.vars.register_list))
	local var_29_6 = LotaUserData:getMaxHeroCount()
	local var_29_7 = LotaUserData:getUnregisterCount()
	local var_29_8 = LotaUserData:getLimitFreeUnRegistrationCount()
	
	if arg_29_0.vars.mode == "putout" then
		if var_29_8 <= var_29_7 then
			if_set(var_29_0, "t_count_hero", T("ui_clanheritage_hero_deregist_free", {
				number = 0,
				number1 = var_29_8
			}))
			
			local var_29_9 = cc.c3b(255, 32, 12)
			
			if_set_color(var_29_0, "t_count_hero", var_29_9)
		else
			local var_29_10 = var_29_8 - (var_29_7 + var_29_5)
			local var_29_11 = math.max(var_29_10, 0)
			
			if_set(var_29_0, "t_count_hero", T("ui_clanheritage_hero_deregist_free", {
				number = var_29_11,
				number1 = var_29_8
			}))
			
			local var_29_12 = cc.c3b(255, 255, 255)
			
			if var_29_8 < var_29_7 + var_29_5 then
				var_29_12 = cc.c3b(255, 32, 12)
			end
			
			if_set_color(var_29_0, "t_count_hero", var_29_12)
		end
	else
		local var_29_13 = {
			number = var_29_4,
			number1 = var_29_6
		}
		
		if_set(var_29_0, "t_count_hero", T("ui_clanheritage_hero_regist_number", var_29_13))
	end
	
	local var_29_14 = "ui_clanheritage_hero_regist_desc"
	
	if arg_29_0.vars.mode == "putout" then
		var_29_14 = "ui_clanheritage_hero_deregist_desc"
	end
	
	if_set(var_29_2, "label_info", T(var_29_14))
	
	local var_29_15 = "ui_clanheritage_hero_regist_wait"
	
	if arg_29_0.vars.mode == "putin" then
		var_29_15 = "ui_clanheritage_hero_regist_ing"
	elseif arg_29_0.vars.mode == "putout" then
		var_29_15 = "ui_clanheritage_hero_deregist_ing"
	end
	
	if_set(var_29_3, "t_action", T(var_29_15))
	if_set_visible(var_29_3, "n_no_data", arg_29_0.vars.mode == nil)
	
	local var_29_16 = var_29_3:findChildByName("n_action")
	
	if_set_visible(var_29_16, nil, arg_29_0.vars.mode ~= nil)
	
	if arg_29_0.vars.mode ~= nil then
		if_set_visible(var_29_16, "arrow_r", arg_29_0.vars.mode == "putout")
		if_set_visible(var_29_16, "arrow_l", arg_29_0.vars.mode == "putin")
		
		local var_29_17 = "ui_clanheritage_hero_regist_ing_desc"
		
		if arg_29_0.vars.mode == "putout" then
			var_29_17 = "ui_clanheritage_hero_deregist_ing_desc"
		end
		
		if_set(var_29_16, "t_disc_choose", T(var_29_17))
	end
	
	local var_29_18 = "btn_clanheritage_regist_confirm"
	
	if arg_29_0.vars.mode == "putout" then
		var_29_18 = "btn_clanheritage_deregist"
	end
	
	local var_29_19 = var_29_2:findChildByName("btn_reset")
	local var_29_20 = var_29_2:findChildByName("btn_confirm")
	local var_29_21 = false
	
	if arg_29_0.vars.mode == "putout" and var_29_8 < var_29_5 + var_29_7 then
		var_29_21 = true
		
		if_set_visible(var_29_20, nil, false)
		
		local var_29_22 = var_29_2:findChildByName("btn_pay")
		
		arg_29_0:setupBtnPay(var_29_22, var_29_5)
		
		local var_29_23
		
		for iter_29_0, iter_29_1 in pairs(var_29_22:getChildren()) do
			if iter_29_1:getName() == "label" then
				var_29_23 = iter_29_1
				
				break
			end
		end
		
		if_set(var_29_23, nil, T(var_29_18))
	else
		if_set(var_29_20, "label", T(var_29_18))
	end
	
	if_set_visible(var_29_20, nil, arg_29_0.vars.mode ~= nil and not var_29_21)
	if_set_visible(var_29_2, "btn_pay", var_29_21)
	if_set_visible(var_29_19, nil, arg_29_0.vars.mode ~= nil)
end

function LotaRegistrationUI.isPay(arg_30_0, arg_30_1, arg_30_2)
	if arg_30_0.vars.mode ~= "putout" and not arg_30_2 then
		return false
	end
	
	arg_30_1 = arg_30_1 or 0
	
	local var_30_0 = LotaUserData:getUnregisterCount()
	local var_30_1 = table.count(arg_30_0:getSelectList(arg_30_0.vars.register_list))
	
	return LotaUserData:getLimitFreeUnRegistrationCount() < var_30_0 + var_30_1 + arg_30_1
end

function LotaRegistrationUI.getPaymentCount(arg_31_0, arg_31_1)
	local var_31_0 = LotaUserData:getUnregisterCount()
	local var_31_1 = LotaUserData:getLimitFreeUnRegistrationCount()
	local var_31_2 = LotaUserData:getUnregisterCost()
	local var_31_3 = arg_31_1
	
	if var_31_0 < var_31_1 then
		var_31_3 = var_31_3 - (var_31_1 - var_31_0)
	end
	
	return var_31_3 * var_31_2
end

function LotaRegistrationUI.getPaymentToken(arg_32_0)
	return (LotaUserData:getUnregisterCostToken())
end

function LotaRegistrationUI.onConfirm(arg_33_0)
	local var_33_0 = "add"
	
	if arg_33_0.vars.mode == "putout" then
		var_33_0 = "dec"
	end
	
	LotaNetworkSystem:sendQuery("lota_confirm_registration", {
		list = json.encode(arg_33_0:getUIDList()),
		mode = var_33_0
	})
end

function LotaRegistrationUI.getSelectList(arg_34_0, arg_34_1)
	local var_34_0 = {}
	
	for iter_34_0, iter_34_1 in pairs(arg_34_1) do
		if iter_34_1.select then
			table.insert(var_34_0, iter_34_1.uid)
		end
	end
	
	return var_34_0
end

function LotaRegistrationUI.setupBtnPay(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0:getPaymentCount(arg_35_2)
	local var_35_1 = LotaUserData:getUnregisterCostToken()
	
	if_set_sprite(arg_35_1, "Sprite_41", "item/" .. DB("item_token", var_35_1, "icon") .. ".png")
	
	local var_35_2 = arg_35_1:findChildByName("Image_21")
	
	if_set(var_35_2, "label", var_35_0)
end

function LotaRegistrationUI.createConfirmUI(arg_36_0, arg_36_1)
	local var_36_0 = LotaUtil:getUIDlg("clan_heritage_registration_confirm", false)
	local var_36_1 = LotaSystem:getUIPopupLayer()
	local var_36_2 = ccui.Button:create()
	
	var_36_2:setName("_btn_blocker")
	var_36_2:setAnchorPoint(0.5, 0.5)
	var_36_2:ignoreContentAdaptWithSize(false)
	var_36_2:setContentSize(VIEW_WIDTH * 2, VIEW_HEIGHT * 2)
	var_36_2:setLocalZOrder(-99999)
	var_36_0:addChild(var_36_2)
	var_36_0:setLocalZOrder(1000001)
	onCreateNode(var_36_2)
	
	local var_36_3 = arg_36_0:getSelectList(arg_36_1)
	local var_36_4 = table.count(var_36_3)
	local var_36_5 = var_36_0:findChildByName("ScrollView_hero")
	
	var_36_5:setClippingEnabled(true)
	if_set_visible(var_36_5, nil, true)
	
	local var_36_6 = 92
	local var_36_7 = 92
	local var_36_8 = math.ceil(var_36_4 / 5)
	local var_36_9 = var_36_5:getContentSize()
	local var_36_10 = 28
	
	var_36_9.width = var_36_6 * 5 + var_36_10
	
	var_36_5:setContentSize(var_36_9)
	
	var_36_9.height = math.max(var_36_7 * var_36_8, var_36_9.height)
	
	var_36_5:setInnerContainerSize(var_36_9)
	
	local var_36_11, var_36_12 = var_36_5:getPosition()
	
	var_36_5:setPosition(var_36_11 + var_36_10 / 2, var_36_12)
	
	if var_36_8 <= 2 then
		var_36_5:setScrollBarEnabled(false)
	else
		var_36_5:setScrollBarEnabled(true)
	end
	
	local function var_36_13(arg_37_0)
		local var_37_0 = math.floor((arg_37_0 - 1) / 5)
		local var_37_1 = (arg_37_0 - 1) % 5
		local var_37_2 = var_37_0 + 1
		
		if var_36_8 == 1 then
			local var_37_3 = var_37_2 - 1
		end
		
		local var_37_4 = var_36_9.height - var_36_7 * 0.5 - var_37_0 * var_36_7
		local var_37_5 = var_36_4 - var_37_0 * 5
		local var_37_6 = 0
		
		if var_37_5 < 5 then
			var_37_6 = (5 - var_37_5) * var_36_6 * 0.5
		end
		
		return var_37_1 * var_36_6 + var_36_6 / 2 + var_37_6, var_37_4
	end
	
	for iter_36_0 = 1, var_36_4 do
		local var_36_14 = Account:getUnit(var_36_3[iter_36_0])
		local var_36_15 = var_36_14:getSkinCode() or var_36_14.db.code
		local var_36_16 = var_36_14:getLv()
		local var_36_17 = var_36_14:getGrade()
		local var_36_18 = var_36_14:getZodiacGrade() or 0
		
		if var_36_14:isGrowthBoostRegistered() then
			local var_36_19 = var_36_14:clone()
			
			GrowthBoost:apply(var_36_19)
			
			var_36_16 = var_36_19:getLv()
			var_36_17 = var_36_19:getGrade()
			var_36_18 = var_36_19:getZodiacGrade() or 0
		end
		
		local var_36_20 = UIUtil:getRewardIcon(nil, var_36_15, {
			no_popup = true,
			role = true,
			no_db_grade = true,
			lv = var_36_16,
			grade = var_36_17,
			zodiac = var_36_18
		})
		
		if not LotaUserData:isUsableUnit(var_36_14, true) or LotaUserData:isUnregisteredCurrentDay(var_36_14.db.code) then
			if_set_visible(var_36_20, "n_state_mask", true)
			if_set_visible(var_36_20, "n_state", true)
			if_set_visible(var_36_20, "role", false)
		end
		
		local var_36_21, var_36_22 = var_36_13(iter_36_0)
		
		var_36_20:setPosition(var_36_21, var_36_22)
		var_36_5:addChild(var_36_20)
	end
	
	if_set_visible(var_36_0, "n_registration_btn", arg_36_0.vars.mode == "putin")
	if_set_visible(var_36_0, "n_unregistration_btn", arg_36_0.vars.mode == "putout")
	
	local var_36_23 = var_36_0:findChildByName("n_unregistration_btn")
	
	if arg_36_0.vars.mode == "putout" then
		local var_36_24 = LotaUserData:getUnregisterCount()
		local var_36_25 = var_36_4
		local var_36_26 = LotaUserData:getLimitFreeUnRegistrationCount() < var_36_24 + var_36_25
		local var_36_27 = var_36_23:findChildByName("btn_pay")
		
		if_set_visible(var_36_23, "btn_free", not var_36_26)
		if_set_visible(var_36_27, nil, var_36_26)
		if_set(var_36_0, "txt_title", T("ui_clanheritage_hero_deregist_popup_title"))
		
		if var_36_26 then
			LotaRegistrationUI:setupBtnPay(var_36_27, var_36_25)
			
			local var_36_28 = arg_36_0:getPaymentCount(var_36_25)
			
			upgradeLabelToRichLabel(var_36_0, "t_disc")
			if_set(var_36_0, "t_disc", T("ui_clanheritage_hero_deregist_popup_desc2", {
				value = var_36_28
			}))
		else
			if_set(var_36_0, "t_disc", T("ui_clanheritage_hero_deregist_popup_desc"))
		end
	end
	
	if arg_36_0.vars.mode == "putin" then
		if_set(var_36_0, "txt_title", T("ui_clanheritage_hero_regist_popup_title"))
		if_set(var_36_0, "t_disc", T("ui_clanheritage_hero_regist_popup_desc"))
	end
	
	var_36_1:addChild(var_36_0)
	
	arg_36_0.vars.registration_popup = var_36_0
end

function LotaRegistrationUI.closePopup(arg_38_0)
	if get_cocos_refid(arg_38_0.vars.registration_popup) then
		arg_38_0.vars.registration_popup:removeFromParent()
		BackButtonManager:pop("lota_regi_popup")
	end
end

function LotaRegistrationUI.requestRegistration(arg_39_0)
	if arg_39_0.vars.mode ~= "putin" then
		Log.e("ILLEGAL ATTEMPT REGISTRION")
		
		return 
	end
	
	arg_39_0:onConfirm()
end

function LotaRegistrationUI.isLayerExist(arg_40_0)
	return arg_40_0.vars and arg_40_0.vars.layer and get_cocos_refid(arg_40_0.vars.layer)
end

function LotaRegistrationUI.isRegiExist(arg_41_0)
	return arg_41_0.vars and arg_41_0.vars.registration_popup and get_cocos_refid(arg_41_0.vars.registration_popup)
end

function LotaRegistrationUI.openInfoPopup(arg_42_0)
	local var_42_0 = LotaUtil:getUIDlg("clan_heritage_registration_info")
	local var_42_1 = LotaSystem:getUIPopupLayer()
	
	var_42_0:setLocalZOrder(1000001)
	var_42_1:addChild(var_42_0)
	
	if not arg_42_0.vars then
		arg_42_0.vars = {}
	end
	
	arg_42_0.vars.registration_popup = var_42_0
	
	BackButtonManager:push({
		check_id = "lota_regi_popup",
		back_func = function()
			LotaRegistrationUI:closePopup()
		end
	})
end

function LotaRegistrationUI.isCostEnough(arg_44_0)
	local var_44_0 = LotaUserData:getUnregisterCount()
	local var_44_1 = LotaUserData:getLimitFreeUnRegistrationCount()
	local var_44_2 = LotaUserData:getUnregisterCostToken()
	local var_44_3 = LotaUserData:getUnregisterCost()
	local var_44_4 = table.count(arg_44_0:getSelectList(arg_44_0.vars.register_list))
	
	if var_44_0 < var_44_1 then
		var_44_4 = var_44_4 - (var_44_1 - var_44_0)
	end
	
	local var_44_5 = Account:isCurrencyType(var_44_2)
	
	if var_44_3 * var_44_4 > Account:getCurrency(var_44_5) then
		balloon_message_with_sound("ui_clanheritage_hero_deregist_lack_token")
		
		return false
	end
	
	return true
end

function LotaRegistrationUI.requestUnregistration(arg_45_0)
	if arg_45_0.vars.mode ~= "putout" then
		Log.e("ILLEGAL ATTEMPT UNREGISTRION")
		
		return 
	end
	
	if not arg_45_0:isCostEnough() then
		return 
	end
	
	arg_45_0:onConfirm()
end

function LotaRegistrationUI.onReceiveRegistration(arg_46_0, arg_46_1)
	local var_46_0
	
	if arg_46_0.vars.mode == "putout" then
		arg_46_0:confirmPutOut()
		
		var_46_0 = "ui_clanheritage_unregist_popup_desc"
	elseif arg_46_0.vars.mode == "putin" then
		arg_46_0:confirmPutIn()
		
		var_46_0 = "ui_clanheritage_regist_popup_desc"
	end
	
	arg_46_0:closePopup()
	Dialog:msgBox(T(var_46_0), {
		title = T("ui_clanheritage_hero_regist_popup_title")
	})
	
	arg_46_0.vars.mode = nil
	
	arg_46_0.vars.listview:setDataSource(arg_46_0.vars.register_list)
	HeroBelt:update()
	arg_46_0:updateUI()
end
