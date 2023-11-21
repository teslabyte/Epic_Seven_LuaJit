PetTransfer = {}

function HANDLER.pet_sell(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_slot" and arg_1_0.id then
		local var_1_0 = arg_1_0.id
		
		PetTransfer:removeSlot(var_1_0)
	elseif arg_1_1 == "btn_reset" then
		PetTransfer:clearSlots(false)
	elseif arg_1_1 == "btn_autofill" then
		PetTransfer:showAutoFillUI(true)
	elseif arg_1_1 == "btn_close" then
		PetTransfer:showAutoFillUI(false)
	elseif arg_1_1 == "btn_sell" then
		PetTransfer:reqTransferPets()
	end
end

function HANDLER.pet_sell_autosel_tip(arg_2_0, arg_2_1)
	if string.starts(arg_2_1, "btn_expand_") then
		local var_2_0 = string.len("btn_expand_")
		local var_2_1 = string.sub(arg_2_1, var_2_0 + 1, -1)
		
		PetTransfer:toggleFillter(var_2_1)
	end
end

function MsgHandler.sell_pet(arg_3_0)
	PetTransfer:transferPets(arg_3_0)
end

function PetTransfer.onCreate(arg_4_0, arg_4_1)
	arg_4_0.vars = {}
	arg_4_1 = arg_4_1 or {}
	arg_4_0.vars.dlg = load_dlg("pet_sell", true, "wnd")
	arg_4_0.vars.parent = PetUIBase:getBaseUI()
	
	arg_4_0.vars.parent:addChild(arg_4_0.vars.dlg)
	arg_4_0.vars.dlg:getChildByName("n_autofill_tip"):setVisible(true)
	
	arg_4_0.vars.pet_belt = PetUIBase:getPetBelt()
	
	arg_4_0:initPetTransferSlots()
	arg_4_0:initPetTransferRewards()
	arg_4_0:initListView()
	arg_4_0:updateTransferUI(true)
	
	if arg_4_1.pet then
		arg_4_0.vars.pet = arg_4_1.pet
	end
	
	arg_4_0:initAutoFillUI()
end

function PetTransfer.onEnter(arg_5_0)
	arg_5_0:eventSetting()
	arg_5_0.vars.pet_belt:setData(Account:getPets(), "Transfer")
	
	local var_5_0 = arg_5_0.vars.pet_belt:getWnd()
	
	if get_cocos_refid(var_5_0) then
		PetUIBase:clilpPetBelt(false)
		var_5_0:ejectFromParent()
		
		local var_5_1 = arg_5_0.vars.dlg:getChildByName("n_pet_belt")
		
		if get_cocos_refid(var_5_1) then
			var_5_1:addChild(var_5_0)
		end
	end
	
	if arg_5_0.vars.pet then
		arg_5_0.vars.pet_belt:scrollToItem(arg_5_0.vars.pet)
		arg_5_0.vars.pet_belt:updateControlColor(nil, arg_5_0.vars.pet, nil, true)
		
		arg_5_0.vars.pet = nil
	end
	
	arg_5_0:setRegisteredPets()
	PetTransferListView:jumpToTop()
	
	if PetHouse:isFocus() then
		PetRingMenu:hide()
	end
	
	TopBarNew:setTitleName(T("ui_pet_detail_transfer"), "infopet_9")
end

function PetTransfer.onLeave(arg_6_0)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.dlg) then
		return nil
	end
	
	PetTransferListView:reset()
	PetUIBase:clilpPetBelt(false)
	
	local var_6_0 = {
		pet = arg_6_0.vars.pet_belt:getCurrentItem()
	}
	
	arg_6_0.vars.dlg:removeFromParent()
	
	arg_6_0.vars = nil
	
	return var_6_0
end

function PetTransfer.getWnd(arg_7_0)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.dlg) then
		return nil
	end
	
	return arg_7_0.vars.dlg
end

local var_0_0 = 30

function PetTransfer.initPetTransferSlots(arg_8_0)
	if not arg_8_0.vars then
		return 
	end
	
	arg_8_0.vars.registered_count = 0
	arg_8_0.vars.pet_transfer_slots = {}
	
	for iter_8_0 = 1, var_0_0 do
		local var_8_0 = {
			id = iter_8_0,
			pet = {}
		}
		
		table.insert(arg_8_0.vars.pet_transfer_slots, var_8_0)
	end
end

function PetTransfer.initPetTransferRewards(arg_9_0)
	if not arg_9_0.vars then
		return 
	end
	
	arg_9_0.vars.transfer_reward = {}
	
	table.insert(arg_9_0.vars.transfer_reward, {
		id = "to_gold",
		prev_count = 0,
		count = 0
	})
	table.insert(arg_9_0.vars.transfer_reward, {
		id = "ma_petpoint",
		prev_count = 0,
		count = 0
	})
end

function PetTransfer.updatePetTransferRewards(arg_10_0)
	if not arg_10_0.vars or table.empty(arg_10_0.vars.pet_transfer_slots) or table.empty(arg_10_0.vars.transfer_reward) then
		return 
	end
	
	local var_10_0 = arg_10_0.vars.transfer_reward
	local var_10_1 = arg_10_0.vars.pet_transfer_slots
	
	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		iter_10_1.prev_count = iter_10_1.count
		
		local var_10_2 = 0
		
		for iter_10_2, iter_10_3 in pairs(var_10_1) do
			local var_10_3 = 0
			
			if not table.empty(iter_10_3.pet) then
				if iter_10_1.id and iter_10_1.id == "to_gold" then
					var_10_3 = iter_10_3.pet:getSellGoldPrice()
				end
				
				if iter_10_1.id and iter_10_1.id == "ma_petpoint" then
					var_10_3 = iter_10_3.pet:getSellPetPointPrice()
				end
			end
			
			var_10_2 = var_10_2 + var_10_3
		end
		
		iter_10_1.count = var_10_2
	end
end

function PetTransfer.initListView(arg_11_0)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.dlg) then
		return 
	end
	
	PetTransferListView:init(arg_11_0.vars.dlg)
end

function PetTransfer.setRegisteredPets(arg_12_0)
	if not arg_12_0.vars or table.empty(arg_12_0.vars.pet_transfer_slots) then
		return 
	end
	
	PetTransferListView:setItems(arg_12_0.vars.pet_transfer_slots)
end

function PetTransfer.updateTransferUI(arg_13_0, arg_13_1)
	if not arg_13_0.vars or not get_cocos_refid(arg_13_0.vars.dlg) then
		return 
	end
	
	local var_13_0
	local var_13_1 = arg_13_1 and 0 or arg_13_0.vars.registered_count
	
	if_set(arg_13_0.vars.dlg, "txt_count", T("ui_pet_transfer_check", {
		count = var_13_1
	}))
	
	local var_13_2 = arg_13_0.vars.transfer_reward
	
	for iter_13_0, iter_13_1 in pairs(var_13_2) do
		local var_13_3 = arg_13_0.vars.dlg:getChildByName("n_item" .. iter_13_0)
		
		if get_cocos_refid(var_13_3) then
			if not get_cocos_refid(iter_13_1.icon) then
				local var_13_4 = false
				
				if string.find(iter_13_1.id, "ma_petpoint") then
					var_13_4 = true
				end
				
				iter_13_1.icon = UIUtil:getRewardIcon(0, iter_13_1.id, {
					scale = 0.8,
					show_count = true,
					count = 0,
					use_drop_icon = var_13_4
				})
				
				var_13_3:addChild(iter_13_1.icon)
			end
			
			local var_13_5 = iter_13_1.icon:getChildByName("txt_small_count")
			
			if get_cocos_refid(var_13_5) then
				UIAction:Remove(var_13_5)
				UIAction:Add(INC_NUMBER(250, iter_13_1.count, nil, iter_13_1.prev_count), var_13_5)
			end
		end
	end
end

function PetTransfer.addPetInSlot(arg_14_0, arg_14_1)
	if arg_14_0.vars.registered_count >= var_0_0 then
		balloon_message_with_sound("pet_sell_full")
		
		return 
	end
	
	if not arg_14_1:isCanRemove() then
		local var_14_0 = arg_14_1:getUsableCodeList()
		
		Dialog:msgPetLock(var_14_0)
		
		return 
	end
	
	arg_14_0.vars.registered_count = arg_14_0.vars.registered_count + 1
	arg_14_0.vars.pet_transfer_slots[arg_14_0.vars.registered_count].pet = arg_14_1
	
	arg_14_0.vars.pet_belt:popItem(arg_14_1)
	arg_14_0:setRegisteredPets()
	arg_14_0:updatePetTransferRewards()
	arg_14_0:updateTransferUI()
end

function PetTransfer.removeSlot(arg_15_0, arg_15_1)
	if not arg_15_0.vars or not get_cocos_refid(arg_15_0.vars.dlg) or not arg_15_1 then
		return 
	end
	
	if table.empty(arg_15_0.vars.pet_transfer_slots) then
		return 
	end
	
	local var_15_0 = arg_15_0.vars.pet_transfer_slots
	local var_15_1 = var_15_0[arg_15_1]
	
	if not var_15_1 or table.empty(var_15_1.pet) then
		return 
	end
	
	arg_15_0.vars.pet_belt:stopAutoScroll()
	arg_15_0.vars.pet_belt:revertPoppedItem(var_15_1.pet)
	table.remove(var_15_0, arg_15_1)
	
	local var_15_2 = {
		pet = {}
	}
	
	table.insert(var_15_0, var_15_2)
	
	for iter_15_0, iter_15_1 in pairs(var_15_0) do
		iter_15_1.id = iter_15_0
	end
	
	arg_15_0:setRegisteredPets()
	
	arg_15_0.vars.registered_count = arg_15_0.vars.registered_count - 1
	
	arg_15_0:updatePetTransferRewards()
	arg_15_0:updateTransferUI()
end

function PetTransfer.clearSlots(arg_16_0, arg_16_1)
	if not arg_16_0.vars or not get_cocos_refid(arg_16_0.vars.dlg) then
		return 
	end
	
	if table.empty(arg_16_0.vars.pet_transfer_slots) or table.empty(arg_16_0.vars.transfer_reward) then
		return 
	end
	
	local var_16_0 = BackButtonManager:getTopInfo()
	
	if var_16_0 and var_16_0.dlg and var_16_0.dlg ~= arg_16_0.vars.dlg then
		return 
	end
	
	if arg_16_0.vars.registered_count <= 0 then
		return 
	end
	
	arg_16_0.vars.registered_count = 0
	
	local var_16_1 = arg_16_0.vars.pet_transfer_slots
	
	for iter_16_0, iter_16_1 in pairs(var_16_1) do
		iter_16_1.id = iter_16_0
		
		if not table.empty(iter_16_1.pet) then
			iter_16_1.pet = {}
		end
	end
	
	arg_16_0:setRegisteredPets()
	PetTransferListView:jumpToTop()
	arg_16_0.vars.pet_belt:stopAutoScroll()
	
	if arg_16_1 then
		arg_16_0.vars.pet_belt:clearGarbageItems()
	else
		arg_16_0.vars.pet_belt:revertPoppedItem(nil)
	end
	
	arg_16_0.vars.pet_belt:updateSort("Transfer")
	
	local var_16_2 = arg_16_0.vars.pet_belt:getCurrentItem()
	
	if var_16_2 then
		arg_16_0.vars.pet_belt:updateControlColor(nil, var_16_2, nil, true)
	end
	
	arg_16_0:updatePetTransferRewards()
	arg_16_0:updateTransferUI()
end

function PetTransfer.initAutoFillUI(arg_17_0)
	if not arg_17_0.vars or not get_cocos_refid(arg_17_0.vars.dlg) then
		return 
	end
	
	local var_17_0 = arg_17_0.vars.dlg:getChildByName("n_autofill_tip")
	
	if not get_cocos_refid(var_17_0) then
		return 
	end
	
	arg_17_0.vars.auto_fill_dlg = load_dlg("pet_sell_autosel_tip", true, "wnd")
	
	arg_17_0.vars.auto_fill_dlg:setAnchorPoint(0, 0)
	arg_17_0.vars.auto_fill_dlg:setPosition(0, 0)
	var_17_0:addChild(arg_17_0.vars.auto_fill_dlg)
	arg_17_0.vars.auto_fill_dlg:setVisible(false)
	if_set_visible(arg_17_0.vars.dlg, "btn_block", true)
	arg_17_0:initAutoFillOpts()
end

function PetTransfer.initAutoFillOpts(arg_18_0)
	if not arg_18_0.vars or not get_cocos_refid(arg_18_0.vars.dlg) or not get_cocos_refid(arg_18_0.vars.auto_fill_dlg) then
		return 
	end
	
	local var_18_0 = "pet_transfer_opts"
	local var_18_1 = SAVE:getKeep(var_18_0) and (json.decode() or {})
	
	if table.empty(var_18_1) then
		arg_18_0.vars.auto_fill_check_opts = {
			a = false,
			c = false,
			special = true,
			d = false,
			s = false,
			b = false
		}
	else
		arg_18_0.vars.auto_fill_check_opts = var_18_1
	end
	
	for iter_18_0, iter_18_1 in pairs(arg_18_0.vars.auto_fill_check_opts) do
		local var_18_2
		
		if iter_18_0 == "special" then
			var_18_2 = arg_18_0.vars.auto_fill_dlg:getChildByName("check_box_special")
		else
			var_18_2 = arg_18_0.vars.auto_fill_dlg:getChildByName("check_box_grade_" .. iter_18_0)
		end
		
		if get_cocos_refid(var_18_2) then
			var_18_2:setSelected(iter_18_1)
		end
	end
end

function PetTransfer.showAutoFillUI(arg_19_0, arg_19_1)
	if not arg_19_0.vars or not get_cocos_refid(arg_19_0.vars.dlg) or not get_cocos_refid(arg_19_0.vars.auto_fill_dlg) then
		return 
	end
	
	if_set_visible(arg_19_0.vars.dlg, "btn_close", arg_19_1)
	arg_19_0.vars.auto_fill_dlg:setVisible(arg_19_1)
	
	if arg_19_1 then
		return 
	end
	
	arg_19_0:autoFillPets()
end

function PetTransfer.toggleFillter(arg_20_0, arg_20_1)
	if not arg_20_0.vars or not get_cocos_refid(arg_20_0.vars.auto_fill_dlg) then
		return 
	end
	
	if not arg_20_1 or table.empty(arg_20_0.vars.auto_fill_check_opts) then
		return 
	end
	
	local var_20_0 = arg_20_0.vars.auto_fill_check_opts[arg_20_1]
	
	if var_20_0 == nil then
		return 
	end
	
	local var_20_1
	
	if arg_20_1 == "special" then
		var_20_1 = arg_20_0.vars.auto_fill_dlg:getChildByName("check_box_special")
	else
		var_20_1 = arg_20_0.vars.auto_fill_dlg:getChildByName("check_box_grade_" .. arg_20_1)
	end
	
	if get_cocos_refid(var_20_1) then
		var_20_1:setSelected(not var_20_0)
		
		arg_20_0.vars.auto_fill_check_opts[arg_20_1] = not var_20_0
	end
	
	local var_20_2 = "pet_transfer_opts"
	
	SAVE:setKeep(var_20_2, json.encode(arg_20_0.vars.auto_fill_check_opts))
end

function PetTransfer.autoFillPets(arg_21_0)
	if not arg_21_0.vars or table.empty(arg_21_0.vars.pet_transfer_slots) or table.empty(arg_21_0.vars.auto_fill_check_opts) then
		return 
	end
	
	arg_21_0:clearSlots(false)
	
	local var_21_0 = arg_21_0.vars.auto_fill_check_opts
	local var_21_1 = 0
	local var_21_2 = {}
	local var_21_3 = arg_21_0.vars.pet_belt:getItems()
	
	for iter_21_0, iter_21_1 in pairs(var_21_3) do
		if var_21_1 >= var_0_0 then
			break
		end
		
		if iter_21_1:getLv() <= 1 and iter_21_1:isCanRemove() then
			local var_21_4 = 0
			
			for iter_21_2 = 1, 3 do
				if not PetSkill:getValueByIdx(iter_21_1, iter_21_2) then
					break
				end
				
				local var_21_5 = iter_21_1:getSkillRank(iter_21_2)
				
				if var_21_4 < var_21_5 then
					var_21_4 = var_21_5
				end
			end
			
			local var_21_6 = true
			
			if var_21_4 == 1 then
				var_21_6 = var_21_0.d
			elseif var_21_4 == 2 then
				var_21_6 = var_21_0.c
			elseif var_21_4 == 3 then
				var_21_6 = var_21_0.b
			elseif var_21_4 == 4 then
				var_21_6 = var_21_0.a
			elseif var_21_4 == 5 then
				var_21_6 = var_21_0.s
			else
				var_21_6 = false
			end
			
			if iter_21_1:isFeature() then
				var_21_6 = var_21_6 and not var_21_0.special
			end
			
			if var_21_6 then
				var_21_1 = var_21_1 + 1
				
				table.insert(var_21_2, iter_21_1)
			end
		end
	end
	
	if var_21_1 <= 0 then
		balloon_message_with_sound("pet_batchsell_no")
		
		return 
	end
	
	for iter_21_3, iter_21_4 in pairs(arg_21_0.vars.pet_transfer_slots) do
		if var_21_2[iter_21_3] then
			iter_21_4.pet = var_21_2[iter_21_3]
		else
			break
		end
	end
	
	arg_21_0.vars.registered_count = var_21_1
	
	arg_21_0:setRegisteredPets()
	PetTransferListView:jumpToTop()
	arg_21_0.vars.pet_belt:stopAutoScroll()
	arg_21_0.vars.pet_belt:popItems(var_21_2)
	arg_21_0.vars.pet_belt:scrollToFirstItem()
	arg_21_0:updatePetTransferRewards()
	arg_21_0:updateTransferUI()
end

function PetTransfer.reqTransferPets(arg_22_0)
	if not arg_22_0.vars or table.empty(arg_22_0.vars.pet_transfer_slots) then
		return 
	end
	
	if arg_22_0.vars.registered_count <= 0 then
		balloon_message_with_sound("pet_sell_empty")
		
		return 
	end
	
	local var_22_0 = false
	local var_22_1 = {}
	
	for iter_22_0, iter_22_1 in pairs(arg_22_0.vars.pet_transfer_slots) do
		if not table.empty(iter_22_1.pet) then
			if iter_22_1.pet:isFeature() or iter_22_1.pet:getGrade() >= 4 then
				var_22_0 = true
			end
			
			table.insert(var_22_1, iter_22_1.pet:getUID())
		end
	end
	
	local var_22_2
	local var_22_3 = var_22_0 and "pet_sell_desc2" or "pet_sell_desc"
	
	Dialog:msgBox(T(var_22_3), {
		yesno = true,
		handler = function()
			if not arg_22_0.vars or not get_cocos_refid(arg_22_0.vars.dlg) then
				return 
			end
			
			query("sell_pet", {
				pets = array_to_json(var_22_1)
			})
		end
	})
end

function PetTransfer.transferPets(arg_24_0, arg_24_1)
	arg_24_1 = arg_24_1 or {}
	
	Account:addReward(arg_24_1.result)
	
	for iter_24_0, iter_24_1 in pairs(arg_24_1.sell_list) do
		Account:removePet(iter_24_1)
		
		if Account:isHousePet(iter_24_1) then
			Account:removeHousePet(iter_24_1)
		end
	end
	
	arg_24_0:clearSlots(true)
	
	if arg_24_1.total_price and arg_24_1.total_petpoint then
		arg_24_0:showRewardsPopup({
			total_price = arg_24_1.total_price,
			total_petpoint = arg_24_1.total_petpoint
		})
	end
end

function PetTransfer.showRewardsPopup(arg_25_0, arg_25_1)
	if table.empty(arg_25_1) then
		return 
	end
	
	local var_25_0 = {}
	
	if arg_25_1.total_price then
		table.insert(var_25_0, {
			code = "to_gold",
			count = arg_25_1.total_price
		})
	end
	
	if arg_25_1.total_petpoint then
		table.insert(var_25_0, {
			code = "ma_petpoint",
			count = arg_25_1.total_petpoint
		})
	end
	
	Dialog:msgRewards(T("pet_sell_popup_desc"), {
		rewards = var_25_0,
		title = T("pet_sell_popup_title")
	})
end

function PetTransfer.petBeltEventHandler(arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	if arg_26_1 == "select" then
		arg_26_0:addPetInSlot(arg_26_2)
	end
end

function PetTransfer.eventSetting(arg_27_0)
	arg_27_0.vars.pet_belt:setEventHandler(arg_27_0.petBeltEventHandler, arg_27_0)
end
