function HANDLER.equip_pack(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_bg" then
		EquipPack:next()
	elseif arg_1_1 == "btn_lock" or arg_1_1 == "btn_lock_done" then
		EquipPack:toggle_lockItem(arg_1_1)
	end
end

EquipPack = EquipPack or {}

function EquipPack.close(arg_2_0)
	BackButtonManager:pop("equip_pack")
	arg_2_0.dlg:removeFromParent()
	
	arg_2_0.dlg = nil
end

function EquipPack.show(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.equips = arg_3_1
	arg_3_0.reward_dlg_data = arg_3_2
	arg_3_0.fn_close = fn_close
	arg_3_0.equips_num = #arg_3_0.equips
	arg_3_0.equip_index = 0
	arg_3_0.dlg = load_dlg("equip_pack", true, "wnd", function()
		arg_3_0:next()
	end)
	
	SceneManager:getRunningPopupScene():addChild(arg_3_0.dlg)
	arg_3_0:next()
end

function EquipPack.update(arg_5_0, arg_5_1, arg_5_2)
	if get_cocos_refid(arg_5_0.item_node) then
		arg_5_0.item_node:removeFromParent()
		
		arg_5_0.item_node = nil
	end
	
	local var_5_0 = EQUIP:createByInfo(arg_5_1)
	
	arg_5_0.item_node = load_dlg("item_detail_sub", true, "wnd")
	
	arg_5_0.item_node:setAnchorPoint(0.5, 0.5)
	arg_5_0.item_node:setPosition(0, 0)
	ItemTooltip:updateItemFrame(arg_5_0.dlg, var_5_0)
	ItemTooltip:updateItemInformation({
		detail = true,
		no_resize = true,
		wnd = arg_5_0.item_node,
		equip = var_5_0
	})
	
	local var_5_1 = arg_5_0.item_node:getContentSize()
	local var_5_2 = EffectManager:Play({
		fn = "ui_equip_pack_eff.cfx",
		layer = arg_5_0.item_node,
		x = var_5_1.width * 0.5,
		y = var_5_1.height * 0.5
	})
	
	UIAction:Add(SEQ(DELAY(800)), arg_5_0.dlg, "block")
	var_5_2:setPositionX(var_5_2:getPositionX() - 4)
	var_5_2:setPositionY(var_5_2:getPositionY() - 5)
	
	if arg_5_0.item_node:findChildByName("txt_set_info"):getStringNumLines() > 4 then
		local var_5_3 = 15
		local var_5_4 = arg_5_0.dlg:findChildByName("cm_tooltipbox")
		
		if get_cocos_refid(var_5_4) then
			var_5_4.origin_size = var_5_4.origin_size or var_5_4:getContentSize()
			
			var_5_4:setContentSize({
				width = var_5_4.origin_size.width,
				height = var_5_4.origin_size.height + var_5_3
			})
			var_5_2:setScaleY((var_5_4.origin_size.height + var_5_3) / var_5_4.origin_size.height)
			var_5_2:setPositionY(var_5_2:getPositionY() - var_5_3 * 0.5)
		end
		
		local var_5_5 = arg_5_0.dlg:findChildByName("frame_grade")
		
		if get_cocos_refid(var_5_5) then
			var_5_5.origin_size = var_5_5.origin_size or var_5_5:getContentSize()
			
			var_5_5:setContentSize({
				width = var_5_5.origin_size.width,
				height = var_5_5.origin_size.height + var_5_3
			})
		end
	end
	
	arg_5_0.dlg:findChildByName("n_pos_detail"):addChild(arg_5_0.item_node)
	if_set(arg_5_0.dlg, "t_1_title", T("ui_equip_pack_effect_remain") .. string.format(": %d", arg_5_2))
	if_set_visible(arg_5_0.dlg, "t_1_title", arg_5_2 ~= 0)
	if_set_visible(arg_5_0.dlg, "btn_lock", true)
	if_set_visible(arg_5_0.dlg, "btn_lock_done", false)
end

function EquipPack.next(arg_6_0)
	arg_6_0.equip_index = arg_6_0.equip_index + 1
	
	if arg_6_0.equip_index <= arg_6_0.equips_num then
		arg_6_0:update(arg_6_0.equips[arg_6_0.equip_index], arg_6_0.equips_num - arg_6_0.equip_index)
		
		return 
	end
	
	arg_6_0.equip_index = nil
	
	arg_6_0:close()
	
	if arg_6_0.reward_dlg_data then
		Dialog:msgRewards(arg_6_0.reward_dlg_data.desc, arg_6_0.reward_dlg_data)
	end
end

function EquipPack.toggle_lockItem(arg_7_0, arg_7_1)
	if not get_cocos_refid(arg_7_0.dlg) or not arg_7_0.equips or not arg_7_0.equip_index or not arg_7_0.equips[arg_7_0.equip_index] then
		return 
	end
	
	if arg_7_1 == "btn_lock" then
		if_set_visible(arg_7_0.dlg, "btn_lock", false)
		if_set_visible(arg_7_0.dlg, "btn_lock_done", true)
		query("lock_equip", {
			equip = arg_7_0.equips[arg_7_0.equip_index].id
		})
	elseif arg_7_1 == "btn_lock_done" then
		if_set_visible(arg_7_0.dlg, "btn_lock", true)
		if_set_visible(arg_7_0.dlg, "btn_lock_done", false)
		query("unlock_equip", {
			equip = arg_7_0.equips[arg_7_0.equip_index].id
		})
	end
end

function EquipPack.testShow(arg_8_0)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_8_0 = {
		res = "ok",
		gold = 3077715,
		crystal = 29801,
		_qid = "3",
		randomboxes = {
			{
				code = "ecw6b",
				count = 1,
				randombox = "sp_equip_1_1_l",
				opts = {
					temp = {
						grade_rate = "grade5"
					}
				}
			},
			{
				code = "ecw6w",
				count = 1,
				randombox = "sp_equip_1_1_r",
				opts = {
					temp = {
						grade_rate = "option"
					}
				}
			},
			{
				code = "ecw6b",
				count = 1,
				randombox = "sp_equip_1_1_r",
				opts = {
					temp = {
						grade_rate = "option"
					}
				}
			},
			{
				code = "ecw6b",
				count = 1,
				randombox = "sp_equip_1_1_r",
				opts = {
					temp = {
						grade_rate = "option"
					}
				}
			},
			{
				code = "ecw6r",
				count = 1,
				randombox = "sp_equip_1_1_r",
				opts = {
					temp = {
						grade_rate = "option"
					}
				}
			}
		},
		idx = {
			"59157"
		},
		packages = {
			{
				package = "sp_equip_1_1",
				items = {
					{
						code = "sp_equip_1_1_l",
						count = 1,
						opts = {
							voucher_type = "package"
						}
					},
					{
						code = "sp_equip_1_1_r",
						count = 1,
						opts = {
							voucher_type = "package"
						}
					},
					{
						code = "sp_equip_1_1_r",
						count = 1,
						opts = {
							voucher_type = "package"
						}
					},
					{
						code = "sp_equip_1_1_r",
						count = 1,
						opts = {
							voucher_type = "package"
						}
					},
					{
						code = "sp_equip_1_1_r",
						count = 1,
						opts = {
							voucher_type = "package"
						}
					},
					{
						code = "to_crystal",
						count = 900,
						opts = {
							voucher_type = "package"
						}
					},
					{
						code = "to_gold",
						count = 75000,
						opts = {
							voucher_type = "package"
						}
					}
				}
			}
		},
		currency_time = {
			gold = 1560240344
		},
		new_equips = {
			{
				g = 5,
				code = "ecw6b",
				id = 2078020,
				s = "a03d",
				f = "set_cri",
				op = {
					{
						"def_rate",
						0.12
					},
					{
						"att_rate",
						0.08
					},
					{
						"res",
						0.05
					},
					{
						"speed",
						5
					},
					{
						"max_hp_rate",
						0.08
					}
				}
			},
			{
				g = 4,
				code = "ecw6w",
				id = 2078021,
				s = "e9b1",
				f = "set_cri",
				op = {
					{
						"att",
						60
					},
					{
						"cri_dmg",
						0.07
					},
					{
						"speed",
						2
					},
					{
						"res",
						0.06
					}
				}
			},
			{
				g = 3,
				code = "ecw6b",
				id = 2078022,
				s = "fae5",
				f = "set_cri",
				op = {
					{
						"att_rate",
						0.12
					},
					{
						"def",
						11
					},
					{
						"res",
						0.05
					}
				}
			},
			{
				g = 4,
				code = "ecw6b",
				id = 2078023,
				s = "3468",
				f = "set_cri",
				op = {
					{
						"speed",
						8
					},
					{
						"res",
						0.04
					},
					{
						"def",
						10
					},
					{
						"def_rate",
						0.07
					}
				}
			},
			{
				g = 3,
				code = "ecw6r",
				id = 2078024,
				s = "16c3",
				f = "set_cri",
				op = {
					{
						"def",
						24
					},
					{
						"cri_dmg",
						0.04
					},
					{
						"cri",
						0.03
					}
				}
			}
		}
	}
	
	arg_8_0:show(var_8_0.new_equips)
end
