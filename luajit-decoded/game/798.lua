RumbleUnitAct = ClassDef()

function RumbleUnitAct.constructor(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_3 = arg_1_3 or {}
	arg_1_2 = arg_1_2 or {}
	arg_1_0.target = arg_1_1
	arg_1_0.TOTAL_TIME = arg_1_2.duration or 0
	arg_1_0.POWER = arg_1_2.power or 0
	arg_1_0.info = arg_1_2
	
	if not arg_1_0.target.getShadowY then
		function arg_1_0.target.getShadowY()
			if get_cocos_refid(arg_1_3.model) then
				return arg_1_3.model:getShadowY()
			else
				return 0
			end
		end
	end
	
	if not arg_1_0.target.setShadowY then
		function arg_1_0.target.setShadowY(arg_3_0, arg_3_1)
			if get_cocos_refid(arg_1_3.model) then
				return arg_1_3.model:setShadowY(arg_3_1)
			else
				return 0
			end
		end
	end
	
	if arg_1_2.style == "jump" then
		arg_1_0.Update = RumbleUnitAct.DoJumpUpdate
	else
		arg_1_0.Update = RumbleUnitAct.DoMoveUpdate
	end
end

function RumbleUnitAct.Start(arg_4_0)
	if not arg_4_0.info then
		return 
	end
	
	arg_4_0.start_x, arg_4_0.start_y = arg_4_0.target:getPosition()
	arg_4_0.start_h = arg_4_0.target:getShadowY()
	arg_4_0.start_z = arg_4_0.target:getLocalZOrder()
	arg_4_0.to_x = arg_4_0.info.x or arg_4_0.start_x
	arg_4_0.to_h = arg_4_0.info.h or arg_4_0.start_h
	arg_4_0.to_z = arg_4_0.info.z or arg_4_0.start_z
	arg_4_0.to_y = (arg_4_0.info.y or arg_4_0.start_y) + arg_4_0.to_h
end

function RumbleUnitAct.getRate(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1.elapsed_time / arg_5_0.TOTAL_TIME
	
	if var_5_0 ~= var_5_0 then
		var_5_0 = 1
	end
	
	return var_5_0
end

function RumbleUnitAct.DoJumpUpdate(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0:getRate(arg_6_1)
	local var_6_1 = math.log(1 + 4 * var_6_0, 5) / 1
	local var_6_2 = arg_6_0.start_x + (arg_6_0.to_x - arg_6_0.start_x) * var_6_1
	local var_6_3 = arg_6_0.start_y + (arg_6_0.to_y - arg_6_0.start_y) * var_6_0 + math.sin(var_6_1 * math.pi) * arg_6_0.POWER
	local var_6_4 = arg_6_0.start_h + (arg_6_0.to_h - arg_6_0.start_h) * var_6_0 + math.sin(var_6_1 * math.pi) * arg_6_0.POWER
	local var_6_5 = arg_6_0.start_z + (arg_6_0.to_z - arg_6_0.start_z) * var_6_0
	
	arg_6_0.target:setPosition(var_6_2, var_6_3)
	arg_6_0.target:setShadowY(var_6_4)
	arg_6_0.target:setLocalZOrder(var_6_5)
end

function RumbleUnitAct.DoMoveUpdate(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0:getRate(arg_7_1)
	local var_7_1 = arg_7_0.start_x + (arg_7_0.to_x - arg_7_0.start_x) * var_7_0
	local var_7_2 = arg_7_0.start_y + (arg_7_0.to_y - arg_7_0.start_y) * var_7_0
	local var_7_3 = arg_7_0.start_h + (arg_7_0.to_h - arg_7_0.start_h) * var_7_0
	local var_7_4 = arg_7_0.start_z + (arg_7_0.to_z - arg_7_0.start_z) * var_7_0
	
	arg_7_0.target:setPosition(var_7_1, var_7_2)
	arg_7_0.target:setShadowY(var_7_3)
	arg_7_0.target:setLocalZOrder(var_7_4)
end

function RumbleUnitAct.Finish(arg_8_0, arg_8_1, arg_8_2)
	arg_8_1.elapsed_time = arg_8_0.TOTAL_TIME
	
	arg_8_0:Update(arg_8_1, arg_8_2)
end

RumbleUnitAnim = {
	rs_c1028_1 = {
		anim_opts = {
			end_time = 1000,
			start_time = 0
		},
		hit_info = {
			{
				500,
				"hit_new_blunt_normal"
			}
		}
	},
	rs_c1028_2 = {
		start_anim = "skill2",
		anim_opts = {
			end_time = 2850,
			start_time = 0
		},
		hit_info = {
			{
				700,
				"hit_new_blunt_normal"
			},
			{
				1155,
				"hit_new_blunt_normal"
			},
			{
				1452,
				"hit_new_blunt_normal"
			},
			{
				1650,
				"hit_new_blunt_normal"
			},
			{
				1848,
				"hit_new_blunt_normal"
			},
			{
				2112,
				"hit_new_blunt_normal"
			},
			{
				2409,
				"hit_new_blunt_normal"
			}
		}
	},
	rs_c3035_1 = {
		hit_info = {
			{
				429,
				"hit_new_slash_normal"
			}
		},
		eff_info = {
			{
				429,
				"Attach_Self",
				"spear3_skill_04_dark"
			}
		}
	},
	rs_c1036_1 = {
		hit_info = {
			{
				380,
				"hit_new_slash_normal"
			}
		}
	},
	rs_c1036_2 = {
		start_anim = "skill2",
		eff_delay = 1000
	},
	rs_c3052_1 = {
		hit_info = {
			{
				366,
				"hit_new_blunt_normal"
			}
		},
		eff_info = {
			{
				380,
				"Attach_Self",
				"staff_skill_01_pati",
				{
					y = 130
				}
			}
		}
	},
	rs_c3052_2 = {
		eff_delay = 1056,
		start_anim = "skill2",
		eff_info = {
			{
				1056,
				"Unit_Target",
				"stse_del_buff",
				{
					bone = "target"
				}
			}
		}
	},
	rs_c1007_1 = {
		hit_info = {
			{
				660,
				"hit_new_pierce_normal"
			},
			{
				1386,
				"hit_new_slash_normal"
			},
			{
				1486,
				"hit_new_slash_normal"
			},
			{
				1586,
				"hit_new_slash_normal"
			}
		},
		eff_info = {
			{
				0,
				"Attach_Target",
				"wildred_sk1eff_target",
				{
					bone = "target"
				}
			},
			{
				50,
				"Field_Self",
				"wildred_sk1eff_self"
			}
		}
	},
	rs_c1007_2 = {
		start_anim = "skill2",
		hit_info = {
			{
				1320,
				"hit_new_slash_normal"
			},
			{
				1485,
				"hit_new_slash_normal"
			},
			{
				1584,
				"hit_new_slash_normal"
			},
			{
				1683,
				"hit_new_slash_normal"
			},
			{
				1782,
				"hit_new_slash_normal"
			},
			{
				1881,
				"hit_new_slash_normal"
			},
			{
				2046,
				"hit_new_slash_normal"
			}
		},
		eff_info = {
			{
				0,
				"Field_Target",
				"wildred_sk2_eff",
				{
					scale = 0.5,
					x = -150,
					y = 100
				}
			}
		}
	},
	rs_c1007_3 = {
		eff_delay = 5300,
		start_anim = "skill3",
		ult = true,
		eff_info = {
			{
				0,
				"focus",
				{
					delay = 1633,
					target = "ENEMY_ALL"
				}
			},
			{
				5200,
				"focus_back",
				{
					dim = cc.c3b(0, 0, 0)
				}
			},
			{
				5300,
				"Unit_Target",
				"hit_new_blunt_normal",
				{
					target = "ENEMY_ALL",
					bone = "target"
				}
			},
			{
				5810,
				"Attach_Self",
				"wildred_swordineff"
			}
		}
	},
	rs_c3012_1 = {
		hit_info = {
			{
				0,
				"hit_new_slash_normal"
			},
			{
				300,
				"hit_new_slash_normal"
			}
		},
		eff_info = {
			{
				297,
				"Attach_Self",
				"twohanded_add_skill_01",
				{
					y = -17
				}
			}
		}
	},
	rs_c3012_2 = {
		start_anim = "skill2",
		hit_info = {
			{
				231,
				"hit_new_slash_normal"
			}
		},
		eff_info = {
			{
				231,
				"Attach_Self",
				"twohanded_add_skill_03",
				{
					x = -20,
					y = 3
				}
			}
		}
	},
	rs_c1062_1 = {
		hit_info = {
			{
				400,
				"hit_new_blunt_normal"
			}
		}
	},
	rs_c1062_2 = {
		eff_delay = 1600,
		start_anim = "skill2",
		eff_info = {
			{
				900,
				"Unit_Target",
				"angelica_skill_02_target",
				{
					target = "ALLY_CIRCLE"
				}
			}
		}
	},
	rs_c3084_1 = {
		hit_info = {
			{
				792,
				"hit_new_blunt_normal"
			},
			{
				992,
				"hit_new_blunt_normal"
			},
			{
				1192,
				"hit_new_blunt_normal"
			},
			{
				1392,
				"hit_new_blunt_normal"
			}
		}
	},
	rs_c3051_1 = {
		hit_info = {
			{
				366,
				"hit_new_blunt_normal"
			}
		},
		eff_info = {
			{
				0,
				"Attach_Self",
				"staff3_skill_01_fire"
			},
			{
				380,
				"Attach_Self",
				"staff_skill_01_pati",
				{
					y = 140
				}
			}
		}
	},
	rs_c1040_1 = {
		hit_info = {
			{
				1933,
				"hit_new_blunt_normal"
			}
		},
		eff_info = {
			{
				1400,
				"Field_Target",
				"serilla_skill_01_target",
				{
					bone = "target"
				}
			}
		}
	},
	rs_c1040_2 = {
		start_anim = "skill2",
		anim_opts = {
			end_time = 1200,
			start_time = 0
		},
		hit_info = {
			{
				850,
				"hit_new_blunt_normal"
			}
		},
		eff_info = {
			{
				800,
				"Field_Target",
				"serilla_skill_02_target"
			}
		}
	},
	rs_c1011_1 = {
		hit_info = {
			{
				66,
				"hit_new_slash_normal"
			},
			{
				633,
				"hit_new_slash_normal"
			}
		},
		eff_info = {
			{
				0,
				"Attach_Self",
				"karin_sk1_eff"
			}
		}
	},
	rs_c1011_2 = {
		eff_delay = 433,
		start_anim = "skill2",
		hit_info = {
			{
				133,
				"hit_new_slash_normal"
			},
			{
				433,
				"hit_new_slash_normal"
			},
			{
				533,
				"hit_new_slash_normal"
			},
			{
				633,
				"hit_new_slash_normal"
			}
		},
		eff_info = {
			{
				0,
				"Attach_Self",
				"karin_sk2_eff"
			}
		}
	},
	rs_c1030_1 = {
		hit_info = {
			{
				2500,
				"hit_new_blunt_mult_normal",
				0.4
			},
			{
				2600,
				"hit_new_blunt_mult_normal",
				0.4
			},
			{
				2700,
				"hit_new_blunt_normal",
				0.7
			}
		},
		eff_info = {
			{
				1800,
				"Field_Target",
				"yuna_skill_01_doldol"
			},
			{
				2400,
				"Field_Target",
				"yuna_skill_01_boom4",
				{
					x = -150,
					y = 100
				}
			},
			{
				2400,
				"Field_Target",
				"yuna_skill_01_boom1",
				{
					x = 100,
					y = 50
				}
			},
			{
				2400,
				"Field_Target",
				"yuna_skill_01_boom3",
				{
					x = -50,
					y = 10
				}
			},
			{
				2400,
				"Field_Target",
				"yuna_skill_01_boom1",
				{
					x = -150,
					y = -80
				}
			},
			{
				2400,
				"Field_Target",
				"yuna_skill_01_boom2",
				{
					x = 70,
					y = -50
				}
			}
		}
	},
	rs_c1030_2 = {
		eff_delay = 3966,
		start_anim = "skill2",
		eff_info = {
			{
				1500,
				"Field_Self",
				"yuna_skill_02_sate",
				{
					y = 300
				}
			},
			{
				3466,
				"Field_Target",
				"yuna_skill_02_buff",
				{
					target = "ALLY_ALL"
				}
			}
		}
	},
	rs_c1030_3 = {
		eff_delay = 13100,
		start_anim = "b_idle",
		ult = true,
		eff_info = {
			{
				0,
				"focus",
				{
					delay = 200,
					target = "ENEMY_ALL"
				}
			},
			{
				13000,
				"focus_back",
				{
					dim = cc.c3b(255, 255, 255)
				}
			},
			{
				13100,
				"Unit_Target",
				"hit_new_blunt_normal",
				{
					target = "ENEMY_ALL",
					bone = "target"
				}
			}
		}
	},
	rs_c1020_1 = {
		hit_info = {
			{
				986,
				"hit_new_pierce_normal"
			},
			{
				1986,
				"hit_new_pierce_normal"
			},
			{
				2144,
				"hit_new_pierce_normal"
			}
		}
	},
	rs_c1020_2 = {
		start_anim = "skill2",
		hit_info = {
			{
				1122,
				"hit_new_blunt_mult_normal"
			},
			{
				1322,
				"hit_new_blunt_mult_normal"
			},
			{
				2310,
				"hit_new_blunt_mult_normal"
			},
			{
				2510,
				"hit_new_blunt_mult_normal"
			}
		}
	},
	rs_c3113_1 = {
		hit_info = {
			{
				980,
				"hit_new_blunt_normal"
			}
		},
		eff_info = {
			{
				0,
				"Attach_Target",
				"lucy_sk1",
				{
					x = -30,
					y = -10
				}
			}
		}
	},
	rs_c3113_2 = {
		start_anim = "skill2",
		hit_info = {
			{
				1016,
				"hit_new_blunt_normal"
			},
			{
				1166,
				"hit_new_blunt_normal"
			},
			{
				1366,
				"hit_new_blunt_normal"
			}
		},
		eff_info = {
			{
				0,
				"Field_Target",
				"lucy_sk2",
				{
					y = 50
				}
			}
		}
	},
	rs_c1021_1 = {
		hit_info = {
			{
				200,
				"hit_new_slash_normal"
			},
			{
				400,
				"hit_new_slash_normal"
			},
			{
				700,
				"hit_new_slash_normal"
			}
		}
	},
	rs_c1021_2 = {
		start_anim = "skill2",
		hit_info = {
			{
				1300,
				"hit_new_blunt_normal"
			},
			{
				1530,
				"hit_new_blunt_normal"
			},
			{
				2025,
				"hit_new_blunt_normal"
			},
			{
				2190,
				"hit_new_blunt_normal"
			},
			{
				2355,
				"hit_new_blunt_normal"
			}
		},
		eff_info = {
			{
				0,
				"Attach_Self",
				"dingo_eff_sk2_self"
			},
			{
				232,
				"jump",
				{
					rate = 0.5,
					duration = 725,
					h = 70,
					power = 100
				}
			},
			{
				990,
				"move",
				{
					h = 0,
					rate = 1
				}
			},
			{
				1200,
				"Field_Target",
				"dingo_eff_sk2_exp"
			},
			{
				1333,
				"anim",
				"jump_back"
			},
			{
				1333,
				"position"
			},
			{
				1583,
				"jump",
				{
					rate = 0,
					duration = 550,
					h = 0
				}
			}
		}
	},
	rs_c1037_1 = {
		hit_info = {
			{
				1485,
				"hit_new_blunt_normal"
			}
		},
		eff_info = {
			{
				0,
				"Attach_Self",
				"nixid_eff_sk1"
			}
		}
	},
	rs_c1037_2 = {
		eff_delay = 2200,
		start_anim = "skill2",
		eff_info = {
			{
				0,
				"Attach_Self",
				"nixid_eff_sk2"
			},
			{
				1833,
				"Unit_Target",
				"nixid_eff_sk2_buff",
				{
					target = "ALLY_CIRCLE"
				}
			}
		}
	},
	rs_c1004_1 = {
		hit_info = {
			{
				466,
				"hit_new_pierce_normal"
			}
		},
		eff_info = {
			{
				0,
				"Field_Self",
				"silk_skill_01"
			}
		}
	},
	rs_c1004_2 = {
		start_anim = "skill2",
		hit_info = {
			{
				1000,
				"hit_new_pierce_normal"
			},
			{
				1100,
				"hit_new_pierce_normal"
			},
			{
				1200,
				"hit_new_pierce_normal"
			}
		},
		eff_info = {
			{
				0,
				"Field_Self",
				"elf_eff_sk2_f"
			},
			{
				0,
				"Field_Self",
				"elf_eff_sk2_b",
				{
					z = -3
				}
			}
		}
	},
	rs_c2022_1 = {
		start_anim = "skill1_1",
		hit_info = {
			{
				1600,
				"hit_new_pierce_normal"
			}
		},
		eff_info = {
			{
				1600,
				"Attach_Target",
				"ruell_skill_01_hit_light",
				{
					x = -10,
					y = 80
				}
			}
		}
	},
	rs_c2022_2 = {
		eff_delay = 1350,
		start_anim = "skill2",
		eff_info = {
			{
				1350,
				"Field_Target",
				"hit_light_heal_01",
				{
					target = "ALLY_CIRCLE"
				}
			}
		}
	},
	rs_c2022_3 = {
		eff_delay = 5400,
		start_anim = "skill3_1",
		ult = true,
		eff_info = {
			{
				0,
				"focus",
				{
					delay = 1533,
					target = "ENEMY_ALL"
				}
			},
			{
				0,
				"Attach_Self",
				"ruell_m_skill_03_01"
			},
			{
				5133,
				"focus_back",
				{
					dim = cc.c3b(255, 255, 255)
				}
			},
			{
				5400,
				"Attach_Target",
				"hit_light_heal_01",
				{
					target = "ALLY_ALL"
				}
			}
		}
	},
	rs_c1106_1 = {
		shadow_x = 235,
		offset_x = -60,
		anim_opts = {
			end_time = 1600,
			start_time = 970
		},
		hit_info = {
			{
				297
			},
			{
				397
			},
			{
				497
			}
		},
		eff_info = {
			{
				297,
				"Attach_Self",
				"senya_skill_01"
			}
		}
	},
	rs_c1106_2 = {
		eff_delay = 3800,
		start_anim = "skill2",
		anim_opts = {
			duration = 4000
		},
		eff_info = {
			{
				0,
				"Attach_Self",
				"senya_skill_02",
				{
					scale = 0.6,
					action = {
						{
							delay = 3400
						},
						{
							fade_out = 400
						}
					}
				}
			}
		}
	},
	rs_c1106_3 = {
		eff_delay = 4650,
		start_anim = "b_idle",
		ult = true,
		eff_info = {
			{
				0,
				"focus",
				{
					delay = 300,
					target = "ENEMY_ALL"
				}
			},
			{
				4500,
				"focus_back",
				{
					dim = cc.c3b(255, 255, 255)
				}
			},
			{
				4650,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target"
				}
			},
			{
				4800,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target"
				}
			},
			{
				4950,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target"
				}
			},
			{
				5100,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target"
				}
			},
			{
				5250,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target"
				}
			}
		}
	},
	rs_c1003_1 = {
		hit_info = {
			{
				233,
				"hit_new_slash_normal"
			},
			{
				700,
				"hit_new_slash_normal"
			}
		}
	},
	rs_c1003_2 = {
		eff_delay = 1766,
		start_anim = "skill2",
		eff_info = {
			{
				1366,
				"Attach_Self",
				"valkyrie_sk2",
				{
					bone = "target"
				}
			}
		}
	},
	rs_c3124_1 = {
		hit_info = {
			{
				288,
				"hit_new_slash_normal"
			}
		},
		eff_info = {
			{
				0,
				"Attach_Self",
				"winten_fire_skill_01",
				{
					x = 25,
					y = 5
				}
			}
		}
	},
	rs_c3124_2 = {
		eff_delay = 2100,
		start_anim = "skill2",
		eff_info = {
			{
				0,
				"Attach_Self",
				"winten_light_skill_02"
			}
		}
	},
	rs_c3125_1 = {
		hit_info = {
			{
				288,
				"hit_new_slash_normal"
			}
		},
		eff_info = {
			{
				0,
				"Attach_Self",
				"winten_fire_skill_01",
				{
					y = 5
				}
			}
		}
	},
	rs_c3125_2 = {
		eff_delay = 2100,
		start_anim = "skill2",
		eff_info = {
			{
				0,
				"Attach_Self",
				"winten_dark_skill_02"
			}
		}
	},
	rs_c1112_1 = {
		hit_info = {
			{
				1266,
				"hit_new_blunt_normal"
			}
		},
		eff_info = {
			{
				0,
				"Unit_Self",
				"politis_skeff_sk1_self",
				{
					bone = "shadow"
				}
			},
			{
				0,
				"Unit_Target",
				"politis_skeff_sk1_target",
				{
					bone = "target"
				}
			}
		}
	},
	rs_c1112_2 = {
		start_anim = "skill2",
		hit_info = {
			{
				3100,
				"hit_new_blunt_normal"
			},
			{
				3300,
				"hit_new_blunt_normal"
			},
			{
				3400,
				"hit_new_blunt_normal"
			},
			{
				3500,
				"hit_new_blunt_normal"
			},
			{
				3600,
				"hit_new_blunt_normal"
			},
			{
				3750,
				"hit_new_blunt_normal"
			}
		},
		eff_info = {
			{
				0,
				"Unit_Self",
				"politis_skeff_sk2_self",
				{
					bone = "shadow",
					x = -73,
					action = {
						{
							delay = 1400
						},
						{
							move_to = {
								time = 800,
								x = -300,
								y = 0
							}
						},
						{
							delay = 800
						},
						{
							fade_out = 200
						}
					}
				}
			},
			{
				3000,
				"Unit_Target",
				"politis_skeff_sk2_target",
				{
					bone = "shadow",
					x = -200,
					scale = 0.5,
					y = -150
				}
			},
			{
				3200,
				"Unit_Target",
				"politis_skeff_sk2_target",
				{
					bone = "shadow",
					scale = 0.55
				}
			},
			{
				3300,
				"Unit_Target",
				"politis_skeff_sk2_target",
				{
					bone = "shadow",
					x = -500,
					scale = 0.4
				}
			},
			{
				3400,
				"Unit_Target",
				"politis_skeff_sk2_target",
				{
					bone = "shadow",
					x = 500,
					scale = 0.6,
					y = -80
				}
			},
			{
				3500,
				"Unit_Target",
				"politis_skeff_sk2_target",
				{
					bone = "shadow",
					x = 200,
					scale = 0.45,
					y = 50
				}
			},
			{
				3650,
				"Unit_Target",
				"politis_skeff_sk2_target",
				{
					bone = "shadow",
					x = 400,
					scale = 0.35,
					y = -20
				}
			}
		}
	},
	rs_c1112_3 = {
		eff_delay = 5816,
		ult = true,
		eff_info = {
			{
				0,
				"focus",
				{
					delay = 666,
					target = "ENEMY_ALL"
				}
			},
			{
				300,
				"Attach_Self",
				"politis_skeff_sk3_1",
				{
					scale = 0.5
				}
			},
			{
				5666,
				"focus_back",
				{
					dim = cc.c3b(255, 255, 255)
				}
			},
			{
				5816,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target"
				}
			},
			{
				5966,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target"
				}
			},
			{
				6116,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target"
				}
			},
			{
				6266,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target"
				}
			}
		}
	},
	rs_c3102_1 = {
		hit_info = {
			{
				800,
				"hit_new_pierce_normal",
				0.7
			},
			{
				1000,
				"hit_new_pierce_normal",
				0.8
			}
		},
		eff_info = {
			{
				0,
				"Unit_Self",
				"eff_cyborg_sk1",
				{
					bone = "shadow"
				}
			}
		}
	},
	rs_c3102_2 = {
		eff_delay = 1666,
		start_anim = "skill2",
		eff_info = {
			{
				0,
				"Unit_Self",
				"eff_cyborg_sk4_self",
				{
					bone = "shadow"
				}
			},
			{
				0,
				"Unit_Self",
				"eff_cyborg_sk4_target",
				{
					bone = "shadow"
				}
			},
			{
				0,
				"Unit_Target",
				"eff_cyborg_sk4_target",
				{
					target = "ALLY_NEAR_HIGHEST_ATK",
					bone = "shadow"
				}
			}
		}
	},
	rs_c3105_1 = {
		hit_info = {
			{
				800,
				"hit_new_pierce_normal",
				0.7
			},
			{
				1000,
				"hit_new_pierce_normal",
				0.8
			}
		},
		eff_info = {
			{
				0,
				"Unit_Self",
				"eff_cyborg_sk2",
				{
					bone = "shadow"
				}
			}
		}
	},
	rs_c1085_1 = {
		hit_info = {
			{
				1000
			}
		}
	},
	rs_c1085_2 = {
		start_anim = "skill2",
		hit_info = {
			{
				2000
			}
		}
	},
	rs_c1087_1 = {
		anim_opts = {
			end_time = 2230,
			start_time = 700
		},
		hit_info = {
			{
				934,
				"hit_new_blunt_normal"
			},
			{
				1700,
				"hit_new_pierce_normal"
			}
		}
	},
	rs_c1087_2 = {
		eff_delay = 1267,
		start_anim = "skill2",
		eff_info = {
			{
				867,
				"Unit_Target",
				"furious_skill_02_target",
				{
					target = "ALLY_CIRCLE"
				}
			}
		}
	},
	rs_c2110_1 = {
		hit_info = {
			{
				1065,
				"hit_new_pierce_normal",
				0.5
			},
			{
				1298,
				"hit_new_pierce_normal",
				0.5
			}
		},
		eff_info = {
			{
				0,
				"Attach_Self",
				"flan_m_skill_01"
			}
		}
	},
	rs_c2110_2 = {
		eff_delay = 2397,
		start_anim = "skill2",
		eff_info = {
			{
				0,
				"Field_Self",
				"flan_m_skill_02_self"
			},
			{
				1332,
				"Field_Target",
				"flan_m_skill_02_target",
				{
					scale = 0.7,
					target = "ALLY_NEAR"
				}
			}
		}
	},
	rs_c2110_3 = {
		eff_delay = 5321,
		start_anim = "skill3_1",
		ult = true,
		eff_info = {
			{
				0,
				"Attach_Self",
				"flan_m_skill_03-1"
			},
			{
				0,
				"focus",
				{
					delay = 300,
					target = "ENEMY_ALL"
				}
			},
			{
				5221,
				"focus_back",
				{
					dim = cc.c3b(0, 0, 0)
				}
			},
			{
				5321,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target"
				}
			},
			{
				5421,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target"
				}
			},
			{
				5521,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target"
				}
			}
		}
	},
	rs_c2109_1 = {
		hit_info = {
			{
				1033,
				"hit_new_blunt_normal",
				0.7
			},
			{
				1233,
				"hit_new_blunt_normal",
				0.7
			},
			{
				1630,
				"hit_new_blunt_normal",
				0.7
			}
		}
	},
	rs_c2109_2 = {
		start_anim = "skill2",
		anim_opts = {
			duration = 2000
		},
		hit_info = {
			{
				966,
				"hit_new_blunt_mult_normal",
				0.6
			},
			{
				1132,
				"hit_new_blunt_mult_normal",
				0.6
			},
			{
				1298,
				"hit_new_blunt_mult_normal",
				0.6
			},
			{
				1464,
				"hit_new_blunt_mult_normal",
				0.6
			},
			{
				1630,
				"hit_new_blunt_mult_normal",
				0.6
			},
			{
				1796,
				"hit_new_blunt_mult_normal",
				0.6
			},
			{
				1962,
				"hit_new_blunt_mult_normal",
				0.6
			}
		},
		eff_info = {
			{
				800,
				"Field_Target",
				"landy_sk02_target_eff",
				{
					x = -80,
					y = -15
				}
			}
		}
	},
	rs_c2109_3 = {
		eff_delay = 7367,
		start_anim = "skill3",
		ult = true,
		eff_info = {
			{
				0,
				"focus",
				{
					delay = 533,
					target = "ENEMY_ALL"
				}
			},
			{
				7167,
				"focus_back",
				{
					dim = cc.c3b(0, 0, 0)
				}
			},
			{
				7167,
				"Screen_Center",
				"landy_m_skeff_sk3_final"
			},
			{
				7367,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target",
					scale = 1.6
				}
			},
			{
				7467,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target",
					scale = 1.2
				}
			},
			{
				7567,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target",
					scale = 1.6
				}
			},
			{
				7667,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target",
					scale = 1.7
				}
			},
			{
				7767,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target",
					scale = 1.6
				}
			},
			{
				7867,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target",
					scale = 1.2
				}
			},
			{
				7967,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target",
					scale = 1.6
				}
			},
			{
				8067,
				"Unit_Target",
				"hit_new_blunt_mult_normal",
				{
					target = "ENEMY_ALL",
					bone = "target",
					scale = 1.6
				}
			}
		}
	},
	rs_c5089_1 = {
		hit_info = {
			{
				1200,
				"hit_new_blunt_normal"
			}
		},
		eff_info = {
			{
				0,
				"Attach_Self",
				"lilias_a01_skeff_sk1_self"
			},
			{
				0,
				"Attach_Target",
				"lilias_a01_skeff_sk1_target",
				{
					scale = 0.7,
					y = 80
				}
			},
			{
				0,
				"Field_Target",
				"lilias_a01_skeff_sk1_dog",
				{
					x = -350
				}
			}
		}
	},
	rs_c5089_2 = {
		eff_delay = 2166,
		start_anim = "skill2",
		eff_info = {
			{
				0,
				"Field_Self",
				"lilias_skeff_sk2"
			}
		}
	},
	rs_c5089_3 = {
		start_anim = "skill3",
		ult = true,
		hit_info = {
			{
				5150,
				"hit_new_blunt_mult_normal"
			},
			{
				5250,
				"hit_new_blunt_mult_normal"
			},
			{
				5350,
				"hit_new_blunt_mult_normal"
			},
			{
				5450,
				"hit_new_blunt_mult_normal"
			},
			{
				5550,
				"hit_new_blunt_mult_normal"
			},
			{
				6750,
				"hit_new_blunt_mult_normal"
			}
		},
		eff_info = {
			{
				0,
				"focus",
				{
					delay = 600
				}
			},
			{
				200,
				"anim",
				"skill3_1"
			},
			{
				5001,
				"focus_back",
				{
					dim = cc.c3b(0, 0, 0)
				}
			},
			{
				5001,
				"Screen_Center",
				"lilias_a01_skeff_sk3_final"
			}
		}
	},
	rs_c1119_1 = {
		hit_info = {
			{
				900,
				"hit_new_slash_normal",
				0.8
			},
			{
				1033,
				"hit_new_slash_normal",
				0.8
			},
			{
				1267,
				"hit_new_slash_normal",
				0.8
			}
		},
		eff_info = {
			{
				433,
				"Field_Self",
				"zahhak_skill01_dust"
			},
			{
				533,
				"Attach_Self",
				"zahhak_skill01_light"
			},
			{
				867,
				"Attach_Self",
				"zahhak_skill01_self"
			}
		}
	},
	rs_c1119_2 = {
		eff_delay = 1233,
		start_anim = "skill2",
		eff_info = {
			{
				1100,
				"Attach_Target",
				"zahhak_skill_02_target"
			}
		}
	},
	rs_c1119_3 = {
		start_anim = "b_idle",
		ult = true,
		hit_info = {
			{
				5687,
				"hit_new_blunt_mult_normal"
			},
			{
				5837,
				"hit_new_blunt_mult_normal"
			},
			{
				5937,
				"hit_new_blunt_mult_normal"
			},
			{
				6087,
				"hit_new_blunt_mult_normal"
			}
		},
		eff_info = {
			{
				0,
				"focus",
				{
					delay = 366
				}
			},
			{
				200,
				"anim",
				"skill3_1"
			},
			{
				5437,
				"focus_back",
				{
					dim = cc.c3b(0, 0, 0)
				}
			}
		}
	},
	rs_c3134_1 = {
		hit_info = {
			{
				1033,
				"hit_new_slash_normal"
			},
			{
				1133,
				"hit_new_slash_normal"
			}
		},
		eff_info = {
			{
				0,
				"Unit_Self",
				"blade_light_sk1eff_b",
				{
					bone = "shadow"
				}
			},
			{
				0,
				"Attach_Self",
				"blade_light_sk1eff_f",
				{
					bone = "shadow"
				}
			}
		}
	},
	rs_c3134_2 = {
		eff_delay = 1533,
		start_anim = "skill2",
		hit_info = {
			{
				1099,
				"hit_new_slash_normal"
			},
			{
				1199,
				"hit_new_slash_normal"
			},
			{
				1533,
				"hit_new_slash_normal"
			},
			{
				1633,
				"hit_new_slash_normal"
			},
			{
				1733,
				"hit_new_slash_normal"
			},
			{
				1833,
				"hit_new_slash_normal"
			},
			{
				1933,
				"hit_new_slash_normal"
			}
		},
		eff_info = {
			{
				0,
				"Unit_Self",
				"blade_light_sk2_dust"
			},
			{
				0,
				"Attach_Self",
				"blade_light_sk2_self"
			},
			{
				533,
				"warp",
				{
					x = -30
				}
			},
			{
				1933,
				"warp"
			}
		}
	},
	rs_c3135_1 = {
		hit_info = {
			{
				1033,
				"hit_new_slash_normal"
			},
			{
				1133,
				"hit_new_slash_normal"
			}
		},
		eff_info = {
			{
				0,
				"Unit_Self",
				"blade_light_sk1eff_b",
				{
					bone = "shadow"
				}
			},
			{
				0,
				"Attach_Self",
				"blade_light_sk1eff_f",
				{
					bone = "shadow"
				}
			}
		}
	},
	bowman_1 = {
		hit_info = {
			{
				1300,
				"hit_new_pierce_normal",
				0.4
			}
		}
	},
	bowman_2 = {
		start_anim = "skill2",
		eff_delay = 1000
	},
	swordman_1 = {
		hit_info = {
			{
				400,
				"hit_new_slash_normal"
			}
		}
	},
	swordman_2 = {
		start_anim = "skill2",
		hit_info = {
			{
				733,
				"hit_new_slash_normal"
			}
		},
		eff_info = {
			{
				0,
				"Attach_Self",
				"swordman_skill_02_self"
			},
			{
				0,
				"Unit_Self",
				"swordman_skill_02_remain"
			}
		}
	},
	spearman_1 = {
		hit_info = {
			{
				400,
				"hit_new_pierce_normal"
			}
		}
	},
	spearman_2 = {
		start_anim = "skill2",
		hit_info = {
			{
				800,
				"hit_new_pierce_normal"
			}
		},
		eff_info = {
			{
				0,
				"Attach_Self",
				"spearman_skill_02",
				{
					y = 130
				}
			}
		}
	},
	mouse_1 = {
		hit_info = {
			{
				133,
				"hit_new_pierce_normal"
			}
		}
	},
	mouse_2 = {
		start_anim = "skill2",
		hit_info = {
			{
				467,
				"hit_new_pierce_normal",
				0.5
			},
			{
				734,
				"hit_new_pierce_normal",
				0.5
			},
			{
				1000,
				"hit_new_pierce_normal",
				0.5
			},
			{
				1267,
				"hit_new_pierce_normal",
				0.5
			},
			{
				1400,
				"hit_new_pierce_normal",
				0.5
			}
		}
	},
	rs_wizard_f_n_1 = {
		hit_info = {
			{
				1300,
				"hit_new_blunt_normal",
				0.8
			}
		},
		eff_info = {
			{
				1133,
				"Attach_Target",
				"wizard_fire_sk01_target_eff",
				{
					scale = 0.7
				}
			}
		}
	},
	rs_wizard_f_n_2 = {
		start_anim = "skill2",
		hit_info = {
			{
				1133,
				"hit_new_blunt_normal",
				0.8
			}
		},
		eff_info = {
			{
				1133,
				"Attach_Target",
				"wizard_fire_sk02_target_eff"
			}
		}
	},
	rs_wizard_i_n_1 = {
		hit_info = {
			{
				1300,
				"hit_new_blunt_normal",
				0.8
			}
		},
		eff_info = {
			{
				1133,
				"Attach_Target",
				"wizard_ice_sk01_target_eff",
				{
					scale = 0.7
				}
			}
		}
	},
	rs_wizard_i_n_2 = {
		start_anim = "skill2",
		hit_info = {
			{
				1133,
				"hit_new_blunt_normal",
				0.8
			}
		},
		eff_info = {
			{
				1133,
				"Attach_Target",
				"wizard_ice_sk02_target_eff"
			}
		}
	},
	rs_wizard_w_n_1 = {
		hit_info = {
			{
				1300,
				"hit_new_blunt_normal",
				0.8
			}
		},
		eff_info = {
			{
				1133,
				"Attach_Target",
				"wizard_wind_sk01_target_eff",
				{
					scale = 0.7
				}
			}
		}
	},
	rs_wizard_w_n_2 = {
		start_anim = "skill2",
		hit_info = {
			{
				1133,
				"hit_new_blunt_normal",
				0.8
			}
		},
		eff_info = {
			{
				1133,
				"Attach_Target",
				"wizard_wind_sk02_target_eff"
			}
		}
	},
	rs_wizard_l_n_1 = {
		hit_info = {
			{
				1300,
				"hit_new_blunt_normal",
				0.8
			}
		},
		eff_info = {
			{
				1133,
				"Attach_Target",
				"wizard_light_sk01_target_eff",
				{
					scale = 0.7
				}
			}
		}
	},
	rs_wizard_l_n_2 = {
		start_anim = "skill2",
		hit_info = {
			{
				1133,
				"hit_new_blunt_normal",
				0.8
			}
		},
		eff_info = {
			{
				1133,
				"Attach_Target",
				"wizard_light_sk02_target_eff"
			}
		}
	}
}
RumbleUnitAnim.rs_bowman_f_n_1 = RumbleUnitAnim.bowman_1
RumbleUnitAnim.rs_bowman_f_n_2 = RumbleUnitAnim.bowman_2
RumbleUnitAnim.rs_bowman_i_n_1 = RumbleUnitAnim.bowman_1
RumbleUnitAnim.rs_bowman_i_n_2 = RumbleUnitAnim.bowman_2
RumbleUnitAnim.rs_bowman_w_n_1 = RumbleUnitAnim.bowman_1
RumbleUnitAnim.rs_bowman_w_n_2 = RumbleUnitAnim.bowman_2
RumbleUnitAnim.rs_bowman_l_n_1 = RumbleUnitAnim.bowman_1
RumbleUnitAnim.rs_bowman_l_n_2 = RumbleUnitAnim.bowman_2
RumbleUnitAnim.rs_bowman_d_n_1 = RumbleUnitAnim.bowman_1
RumbleUnitAnim.rs_bowman_d_n_2 = RumbleUnitAnim.bowman_2
RumbleUnitAnim.rs_swordman_f_n_1 = RumbleUnitAnim.swordman_1
RumbleUnitAnim.rs_swordman_f_n_2 = RumbleUnitAnim.swordman_2
RumbleUnitAnim.rs_swordman_i_n_1 = RumbleUnitAnim.swordman_1
RumbleUnitAnim.rs_swordman_i_n_2 = RumbleUnitAnim.swordman_2
RumbleUnitAnim.rs_swordman_w_n_1 = RumbleUnitAnim.swordman_1
RumbleUnitAnim.rs_swordman_w_n_2 = RumbleUnitAnim.swordman_2
RumbleUnitAnim.rs_swordman_l_n_1 = RumbleUnitAnim.swordman_1
RumbleUnitAnim.rs_swordman_l_n_2 = RumbleUnitAnim.swordman_2
RumbleUnitAnim.rs_swordman_d_n_1 = RumbleUnitAnim.swordman_1
RumbleUnitAnim.rs_swordman_d_n_2 = RumbleUnitAnim.swordman_2
RumbleUnitAnim.rs_spearman_f_n_1 = RumbleUnitAnim.spearman_1
RumbleUnitAnim.rs_spearman_f_n_2 = RumbleUnitAnim.spearman_2
RumbleUnitAnim.rs_spearman_i_n_1 = RumbleUnitAnim.spearman_1
RumbleUnitAnim.rs_spearman_i_n_2 = RumbleUnitAnim.spearman_2
RumbleUnitAnim.rs_spearman_w_n_1 = RumbleUnitAnim.spearman_1
RumbleUnitAnim.rs_spearman_w_n_2 = RumbleUnitAnim.spearman_2
RumbleUnitAnim.rs_spearman_l_n_1 = RumbleUnitAnim.spearman_1
RumbleUnitAnim.rs_spearman_l_n_2 = RumbleUnitAnim.spearman_2
RumbleUnitAnim.rs_spearman_d_n_1 = RumbleUnitAnim.spearman_1
RumbleUnitAnim.rs_spearman_d_n_2 = RumbleUnitAnim.spearman_2
RumbleUnitAnim.rs_mouse_f_n_1 = RumbleUnitAnim.mouse_1
RumbleUnitAnim.rs_mouse_f_n_2 = RumbleUnitAnim.mouse_2
RumbleUnitAnim.rs_mouse_i_n_1 = RumbleUnitAnim.mouse_1
RumbleUnitAnim.rs_mouse_i_n_2 = RumbleUnitAnim.mouse_2
RumbleUnitAnim.rs_mouse_w_n_1 = RumbleUnitAnim.mouse_1
RumbleUnitAnim.rs_mouse_w_n_2 = RumbleUnitAnim.mouse_2
RumbleUnitAnim.rs_mouse_l_n_1 = RumbleUnitAnim.mouse_1
RumbleUnitAnim.rs_mouse_l_n_2 = RumbleUnitAnim.mouse_2
RumbleUnitAnim.rs_mouse_d_n_1 = RumbleUnitAnim.mouse_1
RumbleUnitAnim.rs_mouse_d_n_2 = RumbleUnitAnim.mouse_2
RumbleUnitAnim.rs_wizard_d_n_1 = RumbleUnitAnim.rs_wizard_l_n_1
RumbleUnitAnim.rs_wizard_d_n_2 = RumbleUnitAnim.rs_wizard_l_n_2
