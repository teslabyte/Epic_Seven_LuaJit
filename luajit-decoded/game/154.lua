GetItemPopup = GetItemPopup or {}

function HANDLER.get_item_popup(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_bg" then
		GetItemPopup:close()
	elseif arg_1_1 == "btn_sell" then
		GetItemPopup:sellResultItem()
	elseif arg_1_1 == "btn_lock" or arg_1_1 == "btn_lock_done" then
		GetItemPopup:toggle_lockItem(arg_1_1)
	elseif arg_1_1 == "btn_extract" then
		GetItemPopup:extractResultItem()
	end
end

function GetItemPopup.close(arg_2_0, arg_2_1)
	BackButtonManager:pop({
		id = "get_item_popup",
		dlg = arg_2_0.dlg
	})
	UIAction:Add(SEQ(LOG(FADE_OUT(250)), REMOVE()), arg_2_0.dlg, "block")
	
	if arg_2_1 and arg_2_1.caller == "sell_equips" then
		if arg_2_0.vars.isArtifact and arg_2_1.total_powder > 0 then
			balloon_message_with_sound("equip_sell_gold2", {
				price = comma_value(arg_2_1.total_price),
				price2 = comma_value(arg_2_1.total_powder)
			})
		else
			balloon_message_with_sound("equip_sell_gold", {
				price = comma_value(arg_2_1.total_price)
			})
		end
	end
	
	arg_2_0.vars = {}
end

function GetItemPopup.show(arg_3_0, arg_3_1)
	arg_3_0.vars = {}
	arg_3_0.vars.item = arg_3_1
	arg_3_0.dlg = load_dlg("get_item_popup", true, "wnd", function()
		arg_3_0:close()
	end)
	
	arg_3_0.dlg:setOpacity(0)
	UIAction:Add(LOG(FADE_IN(250)), arg_3_0.dlg, "block")
	SceneManager:getRunningPopupScene():addChild(arg_3_0.dlg)
	arg_3_0.dlg:bringToFront()
	
	local var_3_0 = EQUIP:createByInfo(arg_3_1)
	
	if not var_3_0 then
		return 
	end
	
	local var_3_1 = var_3_0:isArtifact()
	
	arg_3_0.vars.isArtifact = var_3_1
	
	if_set_visible(arg_3_0.dlg, "n_get_item", not var_3_1)
	if_set_visible(arg_3_0.dlg, "n_btn_item", not var_3_1)
	if_set_visible(arg_3_0.dlg, "n_get_arti", var_3_1)
	if_set_visible(arg_3_0.dlg, "n_btn_arti", var_3_1)
	if_set_visible(arg_3_0.dlg, "btn_extract", false)
	
	local var_3_2 = var_3_0:isEquip() and not var_3_0:isArtifact()
	local var_3_3 = ItemTooltip:getItemTooltip({
		code = arg_3_1.code,
		equip = var_3_0,
		scale = var_3_1 and 0.9 or 1,
		no_desc = var_3_2
	})
	
	if not get_cocos_refid(var_3_3) then
		return 
	end
	
	local var_3_4 = var_3_3:getContentSize()
	
	var_3_3:setPosition(-(var_3_4.width * 0.5) + 30, (DESIGN_HEIGHT - var_3_4.height) * 0.5 - 30)
	
	arg_3_0.vars.n_btn = arg_3_0.dlg:getChildByName("n_btn_arti")
	
	if not var_3_1 then
		arg_3_0.vars.n_btn = arg_3_0.dlg:getChildByName("n_btn_item")
	end
	
	if not arg_3_0.vars.isArtifact and var_3_0.isEquip then
		local var_3_5 = arg_3_0.vars.n_btn
		local var_3_6 = var_3_4.height * -0.46 + 300
		
		if_set_visible(var_3_5, "btn_extract", Account:isUnlockExtract())
		
		if not Account:isUnlockExtract() then
			var_3_5:setPositionY(var_3_6 - 57)
		else
			var_3_5:setPositionY(var_3_6)
			if_set_opacity(arg_3_0.dlg, "btn_extract", var_3_0:isExtractable() and 255 or 76.5)
		end
	end
	
	local var_3_7 = arg_3_0.dlg:findChildByName(var_3_1 and "n_artifact_tooltip" or "n_item_tooltip")
	
	if not get_cocos_refid(var_3_7) then
		return 
	end
	
	var_3_7:addChild(var_3_3)
	
	local var_3_8 = EffectManager:Play({
		pivot_x = 0,
		fn = "ui_itembuild2_b.cfx",
		layer = var_3_7,
		pivot_y = DESIGN_HEIGHT * 0.5
	})
	
	if not get_cocos_refid(var_3_8) then
		return 
	end
	
	var_3_8:setLocalZOrder(var_3_3:getLocalZOrder() - 1)
	var_3_8:setScale(var_3_1 and 1.5 or 1)
	LuaEventDispatcher:addIfNotEventListener("update.equip.lock", LISTENER(GetItemPopup.updateEquipLock, arg_3_0), "shop.equip.popup")
end

function GetItemPopup.extractResultItem(arg_5_0)
	if not arg_5_0.vars or not arg_5_0.vars.item or not get_cocos_refid(arg_5_0.dlg) or arg_5_0.vars.isArtifact then
		return 
	end
	
	if arg_5_0.vars.item.lock then
		balloon_message_with_sound("equip_extract_locked")
		
		return 
	end
	
	if not arg_5_0.vars.item:isExtractable() then
		balloon_message_with_sound("msg_extraction_level_error")
		
		return 
	end
	
	Inventory:extractUtil({
		arg_5_0.vars.item
	}, "getItemPopup", function()
		GetItemPopup:close()
	end)
end

function GetItemPopup.sellResultItem(arg_7_0)
	if not arg_7_0.vars or not arg_7_0.vars.item or not get_cocos_refid(arg_7_0.dlg) then
		return 
	end
	
	if arg_7_0.vars.item.lock then
		balloon_message_with_sound("equip_sell_locked")
		
		return 
	end
	
	if arg_7_0.vars.item:isForceLock() then
		balloon_message_with_sound("err_cannot_sell_equip")
		
		return 
	end
	
	local var_7_0 = 0
	local var_7_1 = 0
	
	if arg_7_0.vars.isArtifact then
		var_7_1 = calcArtifactSellPowder(arg_7_0.vars.item)
	end
	
	local var_7_2 = calcEquipSellPrice(arg_7_0.vars.item)
	local var_7_3 = var_7_2 + PetSkill:getLobbyAddCalcValue(SKILL_CONDITION.EQUIP_SELL_GOLD_UP, var_7_2)
	local var_7_4 = {}
	
	table.push(var_7_4, arg_7_0.vars.item.id)
	GlobalGetSellDialog(var_7_3, var_7_1, var_7_4, "get_item_popup"):bringToFront()
end

function GetItemPopup.toggle_lockItem(arg_8_0, arg_8_1)
	if not arg_8_0.vars or not arg_8_0.vars.item then
		return 
	end
	
	if arg_8_1 == "btn_lock" then
		query("lock_equip", {
			equip = arg_8_0.vars.item.id
		})
	elseif arg_8_1 == "btn_lock_done" then
		query("unlock_equip", {
			equip = arg_8_0.vars.item.id
		})
	end
end

function GetItemPopup.updateEquipLock(arg_9_0, arg_9_1)
	if not arg_9_0.vars or not arg_9_0.dlg or not get_cocos_refid(arg_9_0.dlg) or not arg_9_0.vars.n_btn or not arg_9_0.vars.item then
		return 
	end
	
	if_set_visible(arg_9_0.vars.n_btn, "btn_lock", not arg_9_1)
	if_set_visible(arg_9_0.vars.n_btn, "btn_lock_done", arg_9_1)
	if_set_visible(arg_9_0.dlg, "locked", arg_9_1)
end

function GetItemPopup.testShow(arg_10_0, arg_10_1)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_10_0 = {
		{
			count = 1,
			exp = 0,
			grade = 3,
			enhance = 0,
			seed = 25906,
			dup_pt = 0,
			enhance_rate = 1,
			id = 3251037,
			set_fx = "set_def",
			ct = 1576125309,
			code = "ecg1w",
			opts = {
				{
					"cri",
					0.02
				},
				{
					"att_rate",
					0.03
				}
			},
			op = {
				{
					"att",
					21
				},
				{
					"cri",
					0.02
				},
				{
					"att_rate",
					0.03
				}
			},
			stats = {
				{
					"att",
					21
				}
			},
			db = {
				get_xp = 200,
				name = "ecg1w_name",
				tier = 1,
				type = "weapon",
				grade_min = 1,
				main_stat = "cra1_wepo_m",
				sub_stat = "cra1_wepo_s",
				sub_stat_count = 4,
				xp = 100,
				item_level = 12,
				icon = "icon_eq_weapon_ore001",
				price = 350,
				grade_max = 1
			},
			random = {
				X1 = 939545,
				name = "equip",
				cnt = 1,
				X2 = 68159
			}
		},
		{
			grade = 5,
			code = "eih6w",
			set_fx = "set_speed",
			equip = {
				count = 1,
				exp = 0,
				grade = 5,
				enhance = 0,
				seed = 44446,
				dup_pt = 0,
				enhance_rate = 1,
				id = 3252350,
				set_fx = "set_speed",
				ct = 1576140215,
				code = "eih6w",
				opts = {
					{
						"max_hp_rate",
						0.09
					},
					{
						"att_rate",
						0.09
					},
					{
						"speed",
						5
					},
					{
						"cri",
						0.06
					}
				},
				op = {
					{
						"att",
						103
					},
					{
						"max_hp_rate",
						0.09
					},
					{
						"att_rate",
						0.09
					},
					{
						"speed",
						5
					},
					{
						"cri",
						0.06
					}
				},
				stats = {
					{
						"att",
						103
					}
				},
				db = {
					get_xp = 800,
					name = "eih6w_name",
					main_stat = "imh_wepo_m",
					type = "weapon",
					tier = 7,
					grade_min = 5,
					sub_stat = "imh_wepo_s2",
					sub_stat_count = 4,
					unique_type = "y",
					xp = 400,
					item_level = 88,
					icon = "icon_eq_weapon_insect006",
					price = 7500,
					grade_max = 5
				},
				random = {
					X1 = 316029,
					name = "equip",
					cnt = 1,
					X2 = 798043
				}
			}
		},
		{
			count = 1,
			exp = 0,
			grade = 5,
			enhance = 0,
			seed = 0,
			dup_pt = 0,
			enhance_rate = 1,
			id = 3252436,
			code = "efa08",
			ct = 1576149957,
			opts = {},
			op = {
				{
					"att",
					21
				},
				{
					"max_hp",
					32
				}
			},
			stats = {
				{
					"att",
					21
				},
				{
					"max_hp",
					32
				}
			},
			db = {
				get_xp = 900,
				name = "efa08_name",
				sub_stat_count = 0,
				type = "artifact",
				role = "assassin",
				artifact_grade = 5,
				tier = 5,
				main_stat = "art5_atk7_m",
				grade_min = 5,
				price = 2500,
				xp = 450,
				icon = "icon_art0040",
				artifact_skill = "sk_efa08",
				grade_max = 5
			},
			random = {
				X1 = 727595,
				name = "equip",
				cnt = 1,
				X2 = 798405
			}
		}
	}
	
	arg_10_0:show(var_10_0[arg_10_1 or 1])
end
