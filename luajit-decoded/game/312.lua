function GachaUnit._set_fake_rate(arg_1_0, arg_1_1)
	arg_1_0.vars.test_fake_set_rate = arg_1_1
end

function GachaUnit._dev_special(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = Account:getGachaShopInfo().gacha_special.current
	
	if var_2_0 then
		if arg_2_2 then
			var_2_0.ceiling_character = arg_2_2
		end
		
		var_2_0.portrait_data = arg_2_1
		var_2_0.portraits[var_2_0.ceiling_character] = arg_2_1
		
		arg_2_0:enterGachaSpecial(var_2_0)
	end
end

function GachaUnit._dev_gacha(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = {}
	
	if string.starts(arg_3_1, "e") then
		local var_3_1 = DB("equip_item", arg_3_1, {
			"artifact_grade"
		})
		
		table.push(var_3_0, {
			exp = 0,
			id = 0,
			gacha_type = "equip",
			code = arg_3_1,
			g = var_3_1
		})
	else
		local var_3_2 = DB("character", arg_3_1, {
			"grade"
		})
		
		table.push(var_3_0, {
			exp = 0,
			id = 0,
			gacha_type = "character",
			code = arg_3_1,
			g = var_3_2
		})
	end
	
	if arg_3_3 then
		arg_3_0.vars.test_fake_mode = true
	else
		arg_3_0.vars.test_fake_mode = nil
	end
	
	local var_3_3 = {}
	
	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		iter_3_1.add_temp_inventory = false
		
		if not arg_3_2 then
			iter_3_1.new = true
			var_3_3[iter_3_1.code] = true
		end
	end
	
	arg_3_4 = arg_3_4 or 0
	
	Action:Add(SEQ(DELAY(arg_3_4), CALL(arg_3_0.seqIntroBookTouchWait, arg_3_0, var_3_0, var_3_3)), arg_3_0.vars.gacha_layer)
end

function GachaUnit._dev_pickup(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = Account:getGachaShopInfo().pickup[arg_4_1]
	
	if var_4_0 then
		var_4_0[arg_4_2] = arg_4_3
		
		if arg_4_2 == "title_data" or arg_4_2 == "right_data" then
			arg_4_0:enterGachaPickup(arg_4_1, var_4_0)
		elseif arg_4_2 == "banner_data" then
			arg_4_0:_dev_pickupbanner(arg_4_1, var_4_0)
		end
	end
end

function GachaUnit._dev_substoryui(arg_5_0, arg_5_1, arg_5_2)
	Account:getGachaShopInfo().gacha_substory[arg_5_1] = arg_5_2
	
	arg_5_0:enterGachaSubstory()
end

function GachaUnit._dev_storyui(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_0.vars.gacha_story_ui[arg_6_1]
	
	if not var_6_0 then
		Log.e("_dev_storyui ID NOT FOUND: " .. arg_6_1)
		
		return 
	end
	
	if tostring(arg_6_2) == "bi" then
		var_6_0.bi_img = arg_6_3
		var_6_0.bi_data = arg_6_4
	elseif to_n(arg_6_2) >= 1 and to_n(arg_6_2) <= 4 then
		var_6_0["char" .. arg_6_2 .. "_id"] = arg_6_3
		var_6_0["char" .. arg_6_2 .. "_data"] = arg_6_4
	else
		Log.e("_dev_storyui NO NOT FOUND: " .. arg_6_2)
		
		return 
	end
	
	arg_6_0:enterGachaStory(arg_6_1)
end

function GachaUnit._dev_storybanner(arg_7_0, arg_7_1, arg_7_2)
	if not arg_7_1 or not arg_7_2 then
		return 
	end
	
	local var_7_0 = arg_7_0.vars.ui_right_menu_wnd:getChildByName("scrollview"):getChildByName("n_banner:" .. arg_7_1)
	
	if get_cocos_refid(var_7_0) then
		local var_7_1 = var_7_0:getChildByName("n_bi")
		
		if get_cocos_refid(var_7_1) then
			arg_7_0:setDataUI(var_7_1, arg_7_2)
		end
	end
end

function GachaUnit._dev_customgroup(arg_8_0, arg_8_1)
	if not arg_8_1 then
		return 
	end
	
	if not arg_8_1.pd then
		return 
	end
	
	arg_8_0:updateGachaCustomGroupSelected(arg_8_1)
end

function GachaUnit._dev_customspecial(arg_9_0, arg_9_1)
	if not arg_9_1 then
		return 
	end
	
	if not arg_9_1.pd then
		return 
	end
	
	arg_9_0:updateGachaCustomSpecialSelected(arg_9_1)
end

function GachaUnit._dev_pickupbanner(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_1 or not arg_10_2 then
		return 
	end
	
	local var_10_0 = arg_10_0.vars.ui_right_menu_wnd:getChildByName("scrollview")
	local var_10_1 = DB("gacha_ui", arg_10_2.id, {
		"limit"
	})
	local var_10_2 = var_10_0:getChildByName("n_banner:" .. arg_10_1)
	
	if get_cocos_refid(var_10_2) then
		local var_10_3 = string.split(arg_10_2.banner_data, ";")
		
		if var_10_1 then
			var_10_2:getChildByName("n_gacha_title_limited"):setAnchorPoint(0, 0)
			var_10_2:getChildByName("n_gacha_title_limited"):setPosition(var_10_3[2], var_10_3[3])
		else
			var_10_2:getChildByName("n_gacha_title"):setAnchorPoint(0, 0)
			var_10_2:getChildByName("n_gacha_title"):setPosition(var_10_3[2], var_10_3[3])
		end
	end
end

function GachaUnit._dev_set_fake(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if arg_11_3 then
		arg_11_0.vars.test_fake_mode = "not_use_fake"
	else
		arg_11_0.vars.test_fake_mode = true
	end
	
	arg_11_0.vars.test_fake_grade = arg_11_1
	arg_11_0.vars.test_fake_moonlight = arg_11_2 or false
end

function GachaUnit._dev_summon_unit(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	if arg_12_1 == "gacha_moonlight" then
		arg_12_0:enterGachaMoonlight()
		
		arg_12_0.vars.last_buy_item = "gacha_moonlight"
	else
		arg_12_0:enterGachaRare()
		
		arg_12_0.vars.last_buy_item = "gacha_rare_1"
	end
	
	if arg_12_3 == nil then
		arg_12_3 = true
	end
	
	local var_12_0 = {
		{
			ct = 1592982766,
			exp = 840,
			gacha_type = "character",
			opt = 1,
			id = 13935515,
			st = 0,
			code = arg_12_2 or "c5016",
			g = arg_12_4 or 5,
			new = arg_12_3
		}
	}
	local var_12_1 = {}
	
	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		if iter_12_1.gacha_type == "character" then
			if iter_12_1.new then
				var_12_1[iter_12_1.code] = true
			end
		elseif iter_12_1.gacha_type == "equip" and iter_12_1.new then
			var_12_1[iter_12_1.code] = true
		end
	end
	
	arg_12_5 = to_n(arg_12_5)
	
	Action:Add(SEQ(DELAY(arg_12_5), CALL(arg_12_0.seqIntroBookTouchWait, arg_12_0, var_12_0, var_12_1)), arg_12_0.vars.gacha_layer)
end

function GachaUnit._dev_summon(arg_13_0, arg_13_1, arg_13_2)
	arg_13_1 = arg_13_1 and true
	
	arg_13_0:enterGachaRare()
	
	local var_13_0 = {
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "503f",
			g = 3,
			id = 3984218,
			code = "ef319",
			gacha_type = "equip",
			op = {
				{
					"att",
					4
				},
				{
					"max_hp",
					58
				}
			}
		},
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "33c8",
			g = 3,
			id = 3984219,
			code = "ef308",
			gacha_type = "equip",
			op = {
				{
					"att",
					9
				},
				{
					"max_hp",
					36
				}
			}
		},
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "326a",
			g = 3,
			id = 3984220,
			code = "ef316",
			gacha_type = "equip",
			op = {
				{
					"att",
					16
				},
				{
					"max_hp",
					14
				}
			}
		},
		{
			st = 0,
			gacha_type = "character",
			opt = 1,
			exp = 840,
			g = 5,
			id = 13935514,
			code = "c2012",
			ct = 1592982766,
			new = arg_13_1
		},
		{
			st = 0,
			gacha_type = "character",
			opt = 1,
			exp = 840,
			g = 4,
			id = 13935514,
			code = "c2062",
			ct = 1592982766,
			new = arg_13_1
		},
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "79cd",
			g = 3,
			id = 3984222,
			code = "ef312",
			gacha_type = "equip",
			op = {
				{
					"att",
					4
				},
				{
					"max_hp",
					58
				}
			}
		},
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "44b8",
			g = 3,
			id = 3984223,
			code = "ef301",
			gacha_type = "equip",
			op = {
				{
					"att",
					14
				},
				{
					"max_hp",
					21
				}
			}
		},
		{
			st = 0,
			gacha_type = "character",
			opt = 1,
			exp = 840,
			g = 5,
			id = 13935515,
			code = "c5016",
			ct = 1592982766,
			new = arg_13_1
		},
		{
			st = 0,
			gacha_type = "character",
			opt = 1,
			exp = 840,
			g = 5,
			id = 13935516,
			code = "c1087",
			ct = 1592982766,
			new = arg_13_1
		},
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "7702",
			g = 3,
			id = 3984224,
			code = "ef303",
			gacha_type = "equip",
			op = {
				{
					"att",
					14
				},
				{
					"max_hp",
					21
				}
			}
		}
	}
	local var_13_1 = {}
	
	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		if iter_13_1.gacha_type == "character" then
			if iter_13_1.new then
				var_13_1[iter_13_1.code] = true
			end
		elseif iter_13_1.gacha_type == "equip" and iter_13_1.new then
			var_13_1[iter_13_1.code] = true
		end
	end
	
	arg_13_2 = to_n(arg_13_2)
	
	Action:Add(SEQ(DELAY(arg_13_2), CALL(arg_13_0.seqIntroBookTouchWait, arg_13_0, var_13_0, var_13_1)), arg_13_0.vars.gacha_layer)
end

function GachaUnit._dev_test_fake(arg_14_0)
	local var_14_0 = {
		{
			st = 0,
			gacha_type = "character",
			opt = 1,
			exp = 840,
			g = 3,
			id = 13935515,
			code = "c3094",
			ct = 1592982766,
			new = new
		},
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "503f",
			g = 3,
			id = 3984218,
			code = "ef319",
			gacha_type = "equip",
			op = {
				{
					"att",
					4
				},
				{
					"max_hp",
					58
				}
			}
		},
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "33c8",
			g = 3,
			id = 3984219,
			code = "ef308",
			gacha_type = "equip",
			op = {
				{
					"att",
					9
				},
				{
					"max_hp",
					36
				}
			}
		},
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "326a",
			g = 3,
			id = 3984220,
			code = "ef316",
			gacha_type = "equip",
			op = {
				{
					"att",
					16
				},
				{
					"max_hp",
					14
				}
			}
		},
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "34d0",
			g = 3,
			id = 3984221,
			code = "ef317",
			gacha_type = "equip",
			op = {
				{
					"att",
					16
				},
				{
					"max_hp",
					14
				}
			}
		},
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "79cd",
			g = 3,
			id = 3984222,
			code = "ef312",
			gacha_type = "equip",
			op = {
				{
					"att",
					4
				},
				{
					"max_hp",
					58
				}
			}
		},
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "44b8",
			g = 3,
			id = 3984223,
			code = "ef301",
			gacha_type = "equip",
			op = {
				{
					"att",
					14
				},
				{
					"max_hp",
					21
				}
			}
		},
		{
			st = 0,
			gacha_type = "character",
			opt = 1,
			exp = 840,
			g = 3,
			id = 13935514,
			code = "c3094",
			ct = 1592982766,
			new = new
		},
		{
			st = 0,
			gacha_type = "character",
			opt = 1,
			exp = 840,
			g = 5,
			id = 13935516,
			code = "c1038",
			ct = 1592982766,
			new = new
		},
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "7702",
			g = 3,
			id = 3984224,
			code = "ef303",
			gacha_type = "equip",
			op = {
				{
					"att",
					14
				},
				{
					"max_hp",
					21
				}
			}
		}
	}
	
	arg_14_0.vars.gacha_results = var_14_0
	
	local var_14_1 = {}
	
	for iter_14_0, iter_14_1 in pairs(var_14_0) do
		if iter_14_1.gacha_type == "character" then
			if iter_14_1.new then
				var_14_1[iter_14_1.code] = true
			end
		elseif iter_14_1.gacha_type == "equip" and iter_14_1.new then
			var_14_1[iter_14_1.code] = true
		end
	end
	
	local var_14_2 = to_n(0)
	
	Action:Add(SEQ(DELAY(var_14_2), CALL(arg_14_0.seqIntroBookTouchWait, arg_14_0, var_14_0, var_14_1)), arg_14_0.vars.gacha_layer)
	arg_14_0:createFakeEffectList()
end

function GachaUnit._dev_summon2(arg_15_0, arg_15_1, arg_15_2)
	arg_15_1 = arg_15_1 and true
	
	arg_15_0:enterGachaRare()
	
	local var_15_0 = {
		{
			st = 0,
			gacha_type = "character",
			opt = 1,
			exp = 840,
			g = 4,
			id = 13935514,
			code = "c2062",
			ct = 1592982766,
			new = arg_15_1
		}
	}
	local var_15_1 = {}
	
	for iter_15_0, iter_15_1 in pairs(var_15_0) do
		if iter_15_1.gacha_type == "character" then
			if iter_15_1.new then
				var_15_1[iter_15_1.code] = true
			end
		elseif iter_15_1.gacha_type == "equip" and iter_15_1.new then
			var_15_1[iter_15_1.code] = true
		end
	end
	
	arg_15_2 = to_n(arg_15_2)
	
	Action:Add(SEQ(DELAY(arg_15_2), CALL(arg_15_0.seqIntroBookTouchWait, arg_15_0, var_15_0, var_15_1)), arg_15_0.vars.gacha_layer)
end

function GachaUnit._dev_summon3(arg_16_0, arg_16_1, arg_16_2)
	arg_16_1 = arg_16_1 and true
	
	arg_16_0:enterGachaRare()
	
	local var_16_0 = {
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "503f",
			g = 3,
			id = 3984218,
			code = "ef319",
			gacha_type = "equip",
			op = {
				{
					"att",
					4
				},
				{
					"max_hp",
					58
				}
			}
		},
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "33c8",
			g = 3,
			id = 3984219,
			code = "ef308",
			gacha_type = "equip",
			op = {
				{
					"att",
					9
				},
				{
					"max_hp",
					36
				}
			}
		},
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "326a",
			g = 3,
			id = 3984220,
			code = "ef316",
			gacha_type = "equip",
			op = {
				{
					"att",
					16
				},
				{
					"max_hp",
					14
				}
			}
		},
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "34d0",
			g = 3,
			id = 3984221,
			code = "ef317",
			gacha_type = "equip",
			op = {
				{
					"att",
					16
				},
				{
					"max_hp",
					14
				}
			}
		},
		{
			st = 0,
			gacha_type = "character",
			opt = 1,
			exp = 840,
			g = 3,
			id = 13935514,
			code = "c3041",
			ct = 1592982766,
			new = arg_16_1
		},
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "79cd",
			g = 3,
			id = 3984222,
			code = "ef312",
			gacha_type = "equip",
			op = {
				{
					"att",
					4
				},
				{
					"max_hp",
					58
				}
			}
		},
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "44b8",
			g = 3,
			id = 3984223,
			code = "ef301",
			gacha_type = "equip",
			op = {
				{
					"att",
					14
				},
				{
					"max_hp",
					21
				}
			}
		},
		{
			st = 0,
			gacha_type = "character",
			opt = 1,
			exp = 840,
			g = 3,
			id = 13935515,
			code = "c3041",
			ct = 1592982766,
			new = arg_16_1
		},
		{
			st = 0,
			gacha_type = "character",
			opt = 1,
			exp = 840,
			g = 3,
			id = 13935516,
			code = "c3041",
			ct = 1592982766,
			new = arg_16_1
		},
		{
			new = false,
			ct = 1592982766,
			mg = 111,
			s = "7702",
			g = 3,
			id = 3984224,
			code = "ef303",
			gacha_type = "equip",
			op = {
				{
					"att",
					14
				},
				{
					"max_hp",
					21
				}
			}
		}
	}
	local var_16_1 = {}
	
	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		if iter_16_1.gacha_type == "character" then
			if iter_16_1.new then
				var_16_1[iter_16_1.code] = true
			end
		elseif iter_16_1.gacha_type == "equip" and iter_16_1.new then
			var_16_1[iter_16_1.code] = true
		end
	end
	
	arg_16_2 = to_n(arg_16_2)
	
	Action:Add(SEQ(DELAY(arg_16_2), CALL(arg_16_0.seqIntroBookTouchWait, arg_16_0, var_16_0, var_16_1)), arg_16_0.vars.gacha_layer)
end
