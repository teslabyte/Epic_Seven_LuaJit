LotaNetworkSystem = {}
DEBUG.ROTA_NETWORK_MOCKING = nil

function fog_test()
	DEBUG.ROTA_NETWORK_MOCKING = true
	
	LotaNetworkSystem:sendQuery("lota_lobby")
end

LotaNetworkSystem.MockupServer = {
	_legacy_uid = 1,
	_cur_floor = 1,
	_discover_objects = {},
	lota_shop = function()
		return {
			shop_item_list = {
				{
					export_id = "dakman12_62279",
					name = "c1123_name",
					substory_schedule = "vrimaa",
					type = "c1123",
					value = 1,
					desc = "item_category_character",
					limit_count = 1,
					story = "y",
					category = "vrimaa",
					token = "ma_vrimaa1",
					limit_period = "40days",
					shop_type = "story",
					id = "story_vrimaa1_1",
					price = 2500,
					sort = 1
				},
				{
					export_id = "dakman12_62279",
					name = "efh15_name",
					substory_schedule = "vrimaa",
					type = "efh15",
					value = 1,
					limit_count = 1,
					story = "y",
					desc = "item_category_artifact",
					token = "ma_vrimaa1",
					limit_period = "40days",
					shop_type = "story",
					id = "story_vrimaa1_2",
					category = "vrimaa",
					price = 1200,
					sort = 2,
					data = {
						g = 5,
						op = {
							{
								"att",
								9
							},
							{
								"max_hp",
								76
							}
						}
					}
				},
				{
					export_id = "dakman12_62279",
					name = "ma_raingar_es_name",
					bulk_purchase = "y",
					type = "ma_raingar_es",
					desc = "item_category_essence1",
					category = "vrimaa",
					limit_count = 6,
					story = "y",
					price = 170,
					sort = 3,
					substory_schedule = "vrimaa",
					value = 1,
					image = "shop_product_ma_raingar_es_b",
					token = "ma_vrimaa1",
					limit_period = "40days",
					shop_type = "story",
					id = "story_vrimaa1_3"
				},
				{
					export_id = "dakman12_62279",
					name = "ns_story_v1066a_4",
					substory_schedule = "vrimaa",
					type = "to_mura",
					value = 1,
					image = "shop_product_mura_b",
					limit_count = 1,
					story = "y",
					desc = "item_category_forest",
					token = "ma_vrimaa1",
					limit_period = "40days",
					shop_type = "story",
					id = "story_vrimaa1_4",
					category = "vrimaa",
					price = 190,
					sort = 4
				},
				{
					export_id = "dakman12_62279",
					name = "ns_story_v1066a_5",
					substory_schedule = "vrimaa",
					type = "m8042",
					value = 1,
					desc = "item_category_machar",
					limit_count = 1,
					story = "y",
					category = "vrimaa",
					token = "ma_vrimaa1",
					limit_period = "40days",
					shop_type = "story",
					id = "story_vrimaa1_5",
					price = 250,
					sort = 5
				},
				{
					export_id = "dakman12_62279",
					name = "ma_runefire3_shop_name",
					bulk_purchase = "y",
					type = "ma_runefire3",
					desc = "item_category_stone",
					category = "vrimaa",
					limit_count = 3,
					story = "y",
					price = 130,
					sort = 6,
					substory_schedule = "vrimaa",
					value = 1,
					image = "shop_product_ma_runefire3_b",
					token = "ma_vrimaa1",
					limit_period = "40days",
					shop_type = "story",
					id = "story_vrimaa1_6"
				},
				{
					export_id = "dakman12_62279",
					name = "ma_runefire2_shop_name",
					bulk_purchase = "y",
					type = "ma_runefire2",
					desc = "item_category_stone",
					category = "vrimaa",
					limit_count = 4,
					story = "y",
					price = 70,
					sort = 7,
					substory_schedule = "vrimaa",
					value = 3,
					image = "shop_product_ma_runefire2_b",
					token = "ma_vrimaa1",
					limit_period = "40days",
					shop_type = "story",
					id = "story_vrimaa1_7"
				},
				{
					export_id = "dakman12_62279",
					name = "ma_runefire1_shop_name",
					bulk_purchase = "y",
					type = "ma_runefire1",
					desc = "item_category_stone",
					category = "vrimaa",
					limit_count = 5,
					story = "y",
					price = 40,
					sort = 8,
					substory_schedule = "vrimaa",
					value = 10,
					image = "shop_product_ma_runefire1_b",
					token = "ma_vrimaa1",
					limit_period = "40days",
					shop_type = "story",
					id = "story_vrimaa1_8"
				},
				{
					export_id = "dakman12_62279",
					name = "ns_story_v1066a_9",
					bulk_purchase = "y",
					type = "to_ticketrare",
					desc = "item_category_ticket",
					category = "vrimaa",
					limit_count = 3,
					story = "y",
					price = 60,
					sort = 9,
					substory_schedule = "vrimaa",
					value = 5,
					image = "shop_goods_ticket_rare_b",
					token = "ma_vrimaa1",
					limit_period = "40days",
					shop_type = "story",
					id = "story_vrimaa1_9"
				},
				{
					export_id = "dakman12_62279",
					name = "ns_story_v1066a_10",
					substory_schedule = "vrimaa",
					type = "ma_est4f",
					value = 1,
					image = "shop_product_est4f_b",
					limit_count = 1,
					story = "y",
					desc = "item_category_ehstone",
					token = "ma_vrimaa1",
					limit_period = "40days",
					shop_type = "story",
					id = "story_vrimaa1_10",
					category = "vrimaa",
					price = 150,
					sort = 10
				},
				{
					export_id = "dakman12_62279",
					name = "ma_guer_select_001_name",
					bulk_purchase = "y",
					type = "ma_guer_select_001",
					desc = "item_category_selectbox",
					category = "vrimaa",
					limit_count = 4,
					story = "y",
					price = 150,
					sort = 11,
					substory_schedule = "vrimaa",
					value = 1,
					image = "shop_icon_sb_stone_g4",
					token = "ma_vrimaa1",
					limit_period = "40days",
					shop_type = "story",
					id = "story_vrimaa1_11"
				},
				{
					export_id = "dakman12_62279",
					name = "ma_sub_inti_fire_name",
					bulk_purchase = "y",
					type = "ma_sub_inti_fire",
					desc = "item_category_intimacy",
					category = "vrimaa",
					limit_count = 10,
					story = "y",
					price = 100,
					sort = 12,
					substory_schedule = "vrimaa",
					value = 1,
					image = "shop_product_ma_sub_inti_fire",
					token = "ma_vrimaa1",
					limit_period = "40days",
					shop_type = "story",
					id = "story_vrimaa1_12"
				},
				{
					export_id = "dakman12_62279",
					name = "ns_story_v1066a_12",
					bulk_purchase = "y",
					type = "to_gold",
					value = 2500,
					image = "shop_product_gold_b",
					substory_schedule = "vrimaa",
					story = "y",
					category = "vrimaa",
					token = "ma_vrimaa1",
					desc = "item_category_gold",
					shop_type = "story",
					id = "story_vrimaa1_13",
					price = 15,
					sort = 13
				}
			}
		}
	end,
	lota_interaction_object = function(arg_3_0, arg_3_1)
		if arg_3_1.target_tile_id then
			local var_3_0 = LotaTileMapSystem:getBossRoomPositionByIdx(1)
			
			print("req.tile_id?", arg_3_1.tile_id)
			
			return {
				tile_id = tostring(arg_3_1.tile_id),
				object_info = {
					object = "starting_point_1",
					season_id = "heritage002",
					user_id = 12623108,
					floor = 1,
					use_count = 1,
					tile_id = tostring(arg_3_1.tile_id),
					object_info = {
						use_users = {}
					}
				},
				member_move_data = {
					{
						exp = 10000,
						tm = os.time() * 10000,
						tiles = {
							tostring(var_3_0:getTileId())
						},
						id = AccountData.id
					}
				}
			}
		end
		
		local var_3_1 = true
		
		if var_3_1 then
			return {
				tile_id = tostring(arg_3_1.tile_id),
				object_info = {
					object = "floating_tile_start_1",
					season_id = "heritage002",
					user_id = 12623108,
					floor = 4,
					use_count = 1,
					tile_id = tostring(arg_3_1.tile_id),
					object_info = {
						use_users = {}
					}
				},
				member_move_data = {
					{
						exp = 10000,
						tm = os.time() * 10000,
						tiles = {
							"463"
						},
						id = AccountData.id
					}
				}
			}
		end
		
		return {
			action_point = 98,
			res = "ok",
			exp = 450,
			tile_id = tostring(arg_3_1.tile_id),
			artifact_effects = {},
			object_info = {
				object = "quest_1",
				season_id = "heritage002",
				user_id = 12623108,
				floor = 1,
				use_count = 1,
				tile_id = 115,
				object_info = {
					max_use = 1,
					event = {
						event_id = "loa01_e0004",
						complete = false
					}
				}
			}
		}
	end,
	lota_interaction_object_old = function(arg_4_0, arg_4_1)
		local var_4_0 = {}
		local var_4_1 = LotaObjectSystem:getObject(arg_4_1.tile_id)
		local var_4_2 = table.clone(var_4_1.inst)
		
		var_4_0.tile_id = var_4_1:getTileId()
		var_4_0.res = "ok"
		
		if var_4_1:getTypeDetail() == "legacy" then
			if not arg_4_0._legacies then
				arg_4_0._legacies = {
					"legacy_8_3",
					"legacy_8_4",
					"legacy_8_2"
				}
			end
			
			local var_4_3 = table.clone(arg_4_0._legacies)
			
			var_4_0.artifact_select_pool = var_4_3
			var_4_0.active = false
			arg_4_0._legacies_pool = var_4_3
		end
		
		if var_4_1:getTypeDetail() == "production" then
			var_4_0.exp = LotaUserData:getExp() + 5000
			var_4_0.action_point = 20
		end
		
		if var_4_1:getTypeDetail() == "watchtower" then
			local var_4_4 = var_4_1:getTileId()
			local var_4_5 = LotaTileMapSystem:getTileById(var_4_4)
			
			var_4_0.objects = arg_4_0:GetObjects({
				tile_ids = {
					var_4_4
				}
			}, 5)
			var_4_0.discover = {
				length = 5,
				pos = var_4_5:getPos()
			}
		end
		
		if var_4_1:getTypeDetail() == "goddess" then
			local var_4_6 = LotaUserData:getRegistration()
			local var_4_7 = json.decode(arg_4_1.uid_list)
			local var_4_8 = LotaUserData:getActionPoint()
			
			for iter_4_0, iter_4_1 in pairs(var_4_7) do
				iter_4_1 = tostring(iter_4_1)
				
				if var_4_6[iter_4_1] then
					var_4_6[iter_4_1] = "not_use"
				end
			end
			
			var_4_0.user_registration_data = var_4_6
			var_4_2.use_users[tostring(AccountData.id)] = true
		end
		
		if var_4_1:getTypeDetail() == "treasure_box" then
			var_4_0.job_levels = {
				mat = 100
			}
			var_4_0.rewards = {
				new_units = {
					{
						exp = 0,
						code = "c1033",
						grade = 3
					},
					{
						exp = 0,
						code = "c1034",
						grade = 3
					}
				},
				new_items = {
					{
						c = 300,
						code = "ma_runefire1"
					}
				}
			}
			var_4_0.exp = 100002
		end
		
		var_4_2.use_count = var_4_2.use_count or 0
		var_4_2.use_count = var_4_2.use_count + 1
		var_4_0.artifact_effects = {
			object_use_add_exp = 23
		}
		var_4_0.object_info = var_4_2
		
		return var_4_0
	end,
	lota_refresh_start_legacy_pool = function()
		return {
			start_legacy_refresh_count = 1,
			artifact_select_pool = {
				"start_legacy_1_03",
				"start_legacy_1_04",
				"start_legacy_1_05"
			}
		}
	end,
	lota_clear_coop_battle = function(arg_6_0, arg_6_1)
		local var_6_0 = table.clone(LotaBattleDataInterface)
		
		var_6_0.room.tile_id = "244"
		var_6_0.room.battle_id = "1_244"
		var_6_0.room.state = LotaRewardStateEnum.CLEAR
		;({})["1_244"] = var_6_0
		
		return {
			exp = 352102,
			object_info = {},
			artifact_effects = {
				battle_win_add_exp = 30
			},
			battle_data = var_6_0
		}
	end,
	lota_clear_event_battle = function(arg_7_0, arg_7_1)
		return {
			exp = 352102,
			action_point = 40,
			object_info = {}
		}
	end,
	lota_clear_battle = function(arg_8_0, arg_8_1)
		return {
			exp = 352102,
			object_info = {},
			artifact_effects = {
				battle_win_add_exp = 30,
				battle_win_bonus_token = 1
			}
		}
	end,
	lota_show_coop_detail = function(arg_9_0, arg_9_1)
		return {
			res = "ok",
			expedition_info = {
				battle_id = "1_637",
				hp_rate = -100000,
				dead = true,
				start_tm = 1638784284,
				last_hp = -1741767,
				tile_id = 637,
				object_id = "heritage002_b_1",
				expire_tm = 1638870684,
				max_hp = 3600000,
				boss_info = {
					max_hp = 3600000,
					character_id = "nasuzmel_d_b_her001"
				}
			},
			expedition_users = {
				{
					last_attack_tm = 1638784284,
					name = "Karisha",
					border_code = "ma_border62",
					user_id = 12623108,
					max_score = 0,
					leader_code = "c1111",
					count = 4,
					total_score = 5341767
				}
			}
		}
	end,
	lota_show_coop_detail_old = function(arg_10_0, arg_10_1)
		local var_10_0 = table.clone(LotaBattleDataInterface)
		
		var_10_0.room.state = LotaRewardStateEnum.CLEAR
		var_10_0.room.tile_id = "244"
		var_10_0.room.battle_id = "1_244"
		var_10_0.room.last_hp = 5000
		var_10_0.room.boss_info.max_hp = 10000
		
		return {
			object = "heritage002_m_2_3",
			battle_data = var_10_0,
			user_list = {
				{
					damage = 100,
					name = "하루가카1",
					enter_count = 10,
					leader_code = "c1101",
					uid = 1
				},
				{
					damage = 101,
					name = "하루가카2",
					enter_count = 10,
					leader_code = "c1102",
					uid = 2
				},
				{
					damage = 102,
					name = "하루가카3",
					enter_count = 10,
					leader_code = "c1103",
					uid = 3
				},
				{
					damage = 103,
					name = "하루가카4",
					enter_count = 10,
					leader_code = "c1104",
					uid = 4
				},
				{
					damage = 104,
					name = "하루가카5",
					enter_count = 10,
					leader_code = "c1105",
					uid = 5
				},
				[tostring(AccountData.id)] = {
					damage = 105,
					name = "MEME",
					enter_count = 10,
					leader_code = "c1002",
					uid = AccountData.id
				}
			}
		}
	end,
	lota_battle_sync = function(arg_11_0, arg_11_1)
		local var_11_0 = "elite_monster"
		local var_11_1 = "boss_monster"
		
		if var_11_0 == "boss_monster" then
			local var_11_2 = LotaUtil:getBossInfo("heritage002_b_1")
			
			return {
				res = "ok",
				expedition_info = {
					boss_info = {
						character_id = var_11_2.character_id,
						max_hp = var_11_2.max_hp
					},
					last_hp = var_11_2.max_hp * 0.5
				},
				user_info = {
					[24242] = {
						total_score = 10000,
						leader_code = "c1002",
						count = 10,
						name = "ffdd270"
					}
				}
			}
		elseif var_11_0 == "elite_monster" then
			return {
				res = "ok",
				expedition_info = {
					last_hp = 1,
					boss_info = {
						character_id = "undeadcm_d_s",
						max_hp = 500000
					}
				},
				user_info = {
					[24242] = {
						total_score = 10000,
						leader_code = "c1002",
						count = 10,
						name = "ffdd270"
					}
				}
			}
		elseif var_11_0 == "not_exist_battle" then
			return {
				no_info_reason = "true"
			}
		end
		
		return {
			no_info_reason = "true"
		}
	end,
	_gen_list = function(arg_12_0, arg_12_1)
		local var_12_0 = {}
		
		for iter_12_0, iter_12_1 in pairs(arg_12_1) do
			local var_12_1 = Account:serverTimeDayLocalDetail()
			
			var_12_0[tostring(iter_12_1)] = tostring(var_12_1)
		end
		
		return var_12_0
	end,
	lota_confirm_registration = function(arg_13_0, arg_13_1)
		return {
			res = "ok",
			list = arg_13_0:_gen_list(json.decode(arg_13_1.list)),
			currency = {
				to_crystal = 500
			}
		}
	end,
	lota_get_history = function()
		return {
			logs = {}
		}
	end,
	lota_test_start_battle = function(arg_15_0, arg_15_1)
		return {
			state = 0,
			battle_id = arg_15_1.tile_id,
			tile_id = arg_15_1.tile_id
		}
	end,
	lota_test_start_coop_battle = function(arg_16_0, arg_16_1)
		table.print(arg_16_1)
		
		return {
			hp_rate = 90000,
			state = 0,
			battle_id = arg_16_1.tile_id,
			tile_id = arg_16_1.tile_id
		}
	end,
	lota_exit_boss_room = function(arg_17_0, arg_17_1)
		return {
			move_data = {
				id = AccountData.id,
				tiles = {
					tostring(1)
				}
			}
		}
	end,
	lota_jump_boss_room = function(arg_18_0, arg_18_1)
		local var_18_0 = LotaTileMapSystem:getBossRoomPositionByIdx(1)
		
		return {
			move_data = {
				id = AccountData.id,
				tiles = {
					tostring(var_18_0:getTileId())
				}
			}
		}
	end,
	lota_event_select = function(arg_19_0, arg_19_1)
		local var_19_0 = {
			action_point = 22,
			res = "ok",
			exp = 60,
			is_penalty_proc = false,
			tile_id = "290"
		}
		
		if not arg_19_1.select_id then
			var_19_0.close = true
		end
		
		return var_19_0
	end,
	lota_test_clear_battle = function(arg_20_0, arg_20_1)
		return {
			battle_id = arg_20_1.battle_id,
			state = LotaRewardStateEnum.CLEAR
		}
	end,
	lota_test_get_reward = function(arg_21_0, arg_21_1)
		local var_21_0 = arg_21_1.battle_id
		local var_21_1 = "reward_1"
		local var_21_2 = {}
		
		for iter_21_0 = 1, 40 do
			local var_21_3 = DB("clan_heritage_reward_data", var_21_1 .. "_" .. iter_21_0, "id")
			
			if not var_21_3 then
				break
			end
			
			table.insert(var_21_2, var_21_3)
		end
		
		local var_21_4 = var_21_2[math.random(1, table.count(var_21_2))]
		local var_21_5 = {}
		
		for iter_21_1 = 1, 40 do
			local var_21_6, var_21_7, var_21_8, var_21_9 = DB("clan_heritage_reward_data", var_21_4, {
				"item_id_" .. iter_21_1,
				"item_count_" .. iter_21_1,
				"grade_rate_" .. iter_21_1,
				"set_rate_" .. iter_21_1
			})
			
			if not var_21_6 then
				break
			end
			
			if string.starts(var_21_6, "e") then
				table.insert(var_21_5, {
					equip = EQUIP:createByInfo({
						grade = 5,
						code = var_21_6
					})
				})
			else
				table.insert(var_21_5, {
					item = {
						code = var_21_6,
						diff = var_21_7
					}
				})
			end
		end
		
		return {
			rewards = var_21_5,
			battle_id = var_21_0
		}
	end,
	GetObjects = function(arg_22_0, arg_22_1, arg_22_2)
		local var_22_0 = {}
		
		arg_22_2 = arg_22_2 or LotaWhiteboard:get("map_sight_cell")
		
		for iter_22_0, iter_22_1 in pairs(arg_22_1.tile_ids) do
			local var_22_1 = iter_22_1
			local var_22_2 = LotaTileMapSystem:getTileById(var_22_1)
			local var_22_3 = LotaUtil:getDiscoverRange(var_22_2:getPos(), arg_22_2)
			
			for iter_22_2, iter_22_3 in pairs(var_22_3) do
				local var_22_4 = LotaObjectSystem:debug_getFindObject(iter_22_3)
				
				if var_22_4 and not arg_22_0._discover_objects[var_22_1] and not LotaObjectSystem:getObject(var_22_1) then
					table.insert(var_22_0, var_22_4)
					
					arg_22_0._discover_objects[var_22_1] = true
				end
			end
		end
		
		return var_22_0
	end,
	MoveTo = function(arg_23_0, arg_23_1)
		local var_23_0 = arg_23_0:GetObjects(arg_23_1)
		local var_23_1 = LotaUserData:getActionPoint() - #arg_23_1.tile_ids
		
		return {
			movable_id = arg_23_1.movable_id,
			tile_ids = arg_23_1.tile_ids,
			objects = var_23_0,
			action_point = var_23_1
		}
	end,
	JumpTo = function(arg_24_0, arg_24_1)
		local var_24_0 = arg_24_0:GetObjects({
			tile_ids = {
				arg_24_1.tile_id
			}
		})
		
		return {
			movable_id = arg_24_1.movable_id,
			tile_id = arg_24_1.tile_id,
			objects = var_24_0
		}
	end,
	lota_ranking_board = function(arg_25_0, arg_25_1)
		return {
			ranker = {
				floor_1_clan = "42",
				floor_1_tm = 146120000
			},
			clans = {
				["42"] = {
					name = "푸치마스",
					level = 12,
					emblem = GAME_STATIC_VARIABLE.emblem_default_id,
					emblem_bg = GAME_STATIC_VARIABLE.emblem_bg_default_id
				}
			}
		}
	end,
	lota_ranking_board_detail = function(arg_26_0, arg_26_1)
		return {
			rank_list = {
				{
					score = 3600,
					rank = 1,
					clan_info = {
						name = "푸치마스",
						clan_id = "42",
						level = 12,
						emblem = GAME_STATIC_VARIABLE.emblem_default_id,
						emblem_bg = GAME_STATIC_VARIABLE.emblem_bg_default_id
					}
				},
				{
					score = 3630,
					rank = 2,
					clan_info = {
						name = "하루차",
						clan_id = "43",
						level = 5,
						emblem = GAME_STATIC_VARIABLE.emblem_default_id,
						emblem_bg = GAME_STATIC_VARIABLE.emblem_bg_default_id
					}
				},
				{
					score = 4112,
					rank = 3,
					clan_info = {
						name = "쿄코씨",
						clan_id = "42",
						level = 10,
						emblem = GAME_STATIC_VARIABLE.emblem_default_id,
						emblem_bg = GAME_STATIC_VARIABLE.emblem_bg_default_id
					}
				},
				{
					score = 514217722,
					rank = 4,
					clan_info = {
						name = "쿄오코상",
						clan_id = "42",
						level = 10,
						emblem = GAME_STATIC_VARIABLE.emblem_default_id,
						emblem_bg = GAME_STATIC_VARIABLE.emblem_bg_default_id
					}
				}
			}
		}
	end,
	lota_move_sync = function(arg_27_0, arg_27_1)
		local var_27_0 = table.clone(LotaBattleSlotDataInterface.inst)
		
		var_27_0.floor = 2
		var_27_0.tile_id = 497
		var_27_0.slot_tm_1 = os.time() - 0
		var_27_0.slot_user_1 = AccountData.id
		var_27_0.slot_tm_2 = os.time()
		var_27_0.slot_user_2 = true
		var_27_0.slot_tm_3 = os.time() - 1
		var_27_0.slot_user_3 = true
		
		return {
			res = "ok",
			action_point = 32,
			update_objects = {
				clan = {
					{
						floor = 2,
						object = "boss_portal",
						use_count = 0,
						tile_id = 525,
						object_info = {}
					}
				},
				user = {}
			},
			slot_list = {
				var_27_0
			},
			user_battle_data = {
				{
					room = {
						battle_id = "2:525",
						clan_id = 300017,
						start_tm = 1639100673,
						tile_id = 525,
						last_hp = -1666248,
						season_id = "heritage002",
						hp_rate = -300000,
						dead = true,
						expire_tm = 1639187073,
						object_id = "heritage002_e_6_5",
						max_hp = 660000
					}
				}
			},
			last_update_tm = os.time() * 10000,
			box_list = {
				"1:592:guildbox_1r"
			},
			member_move_data = {
				{
					exp = 10,
					tm = os.time() * 10000,
					tiles = json.decode(arg_27_1.tile_ids or "{}"),
					id = AccountData.id
				}
			},
			artifact_effects = {},
			ping_status = {
				memo_1 = "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW.",
				ping_4 = -1,
				memo_3 = "WAKE UP!",
				ping_3 = 130,
				ping_5 = -1,
				ping_2 = -1,
				ping_6 = -1,
				ping_1 = 83
			},
			dead_boss_status = {
				boss_dead_count = 0,
				keeper_dead_count = 4
			}
		}
	end,
	lota_move_sync_old = function(arg_28_0, arg_28_1)
		do return {
			clan_explore_point = 0,
			last_update_tm = os.time() * 10000,
			member_move_data = {},
			_debug_object_infos = {
				["105"] = {
					find = true,
					id = "105",
					use_count = 0,
					object = "sculp_5",
					use_users = {}
				}
			}
		} end
		
		if false then
			return {
				clan_explore_point = 0,
				last_update_tm = os.time() * 10000,
				member_move_data = {},
				_debug_battle_infos = {
					["1_9"] = {
						battle_id = "1_9",
						tile_id = 9,
						state = LotaRewardStateEnum.CLEAR
					}
				}
			}
		end
		
		if false then
			return {
				clan_explore_point = 0,
				last_update_tm = os.time() * 10000,
				member_move_data = {},
				_debug_elite_dead_infos = {
					["9"] = true
				}
			}
		end
		
		if false then
			return {
				clan_explore_point = 0,
				last_update_tm = os.time() * 10000,
				member_move_data = {},
				_debug_object_infos = {
					["8"] = 3
				}
			}
		end
		
		if false then
			local var_28_0 = LotaUserData:getActionPoint()
			local var_28_1 = json.decode(arg_28_1.tile_ids)
			
			return {
				last_update_tm = os.time() * 10000,
				member_move_data = {
					{
						id = arg_28_1.movable_id,
						tiles = var_28_1,
						exp = LotaUserData:getExp() + #var_28_1 * 500
					}
				}
			}
		end
		
		if false then
			return {
				clan_explore_point = 0,
				last_update_tm = os.time() * 10000,
				member_move_data = {},
				_debug_keeper_dead_data = {
					["1"] = 4
				}
			}
		end
		
		if not arg_28_1.movable_id then
			return {
				member_move_data = {},
				last_update_tm = os.time() * 10000
			}
		end
		
		local var_28_2 = LotaUserData:getActionPoint()
		local var_28_3 = json.decode(arg_28_1.tile_ids)
		
		return {
			clan_explore_point = 7,
			member_move_data = {
				{
					id = arg_28_1.movable_id,
					tiles = var_28_3,
					exp = LotaUserData:getExp() + #var_28_3 * 5
				}
			},
			last_update_tm = os.time() * 10000,
			action_point = var_28_2 - #var_28_3,
			artifact_effects = {
				move_tile_add_exp = 30
			}
		}
	end,
	lota_cheat_warp = function(arg_29_0, arg_29_1)
		LotaNetworkSystem:sendQuery("lota_move_sync", {
			movable_id = AccountData.id,
			tile_ids = json.encode({
				arg_29_1.tile_id
			})
		})
		
		return {}
	end,
	lota_confirm_legacy_select = function(arg_30_0, arg_30_1)
		if arg_30_1.clear then
			arg_30_0._legacies = {}
			
			local var_30_0 = table.clone(LotaUserData.vars.info.artifact_items)
			
			return {
				artifact_items = var_30_0
			}
		end
		
		local var_30_1 = arg_30_1.select_confirm_legacy_idx
		local var_30_2 = arg_30_1.select_replace_inventory_idx
		
		if LotaUserData:isArtifactInventoryFull() and not var_30_2 then
			return {
				reason = "REPLACED IDX NOT PRESENT",
				res = ""
			}
		end
		
		var_30_2 = var_30_2 or LotaUserData:getArtifactInventoryCount() + 1
		
		local var_30_3 = table.clone(LotaUserData.vars.info.artifact_items)
		
		var_30_3[var_30_2] = {
			id = "box_add_item_1"
		}
		
		return {
			artifact_items = var_30_3
		}
	end,
	lota_get_reward_ranking_board = function(arg_31_0, arg_31_1)
		return {
			floor_reward_step = 2
		}
	end,
	lota_select_start_pos = function(arg_32_0, arg_32_1)
		local var_32_0 = arg_32_1.tile_id
		local var_32_1 = LotaTileMapSystem:getRandomStartPositionByTileId(var_32_0)
		local var_32_2 = arg_32_0:GetObjects({
			tile_ids = {
				var_32_1:getTileId()
			}
		})
		
		return {
			tile_id = var_32_1:getTileId(),
			objects = var_32_2
		}
	end,
	lota_edit_notice = function(arg_33_0, arg_33_1)
		local var_33_0 = table.clone(LotaClanInfoInterface)
		
		var_33_0.notice_msg = arg_33_1.msg
		
		return {
			lota_clan_info = var_33_0
		}
	end,
	lota_enter = function(arg_34_0, arg_34_1)
		local var_34_0 = {}
		local var_34_1 = arg_34_0:_gen_list(var_34_0)
		local var_34_2 = table.clone(LotaClanInfoInterface)
		local var_34_3 = 1
		
		for iter_34_0, iter_34_1 in pairs(var_34_1) do
			if var_34_3 > 3 then
				break
			end
			
			var_34_1[iter_34_0] = "not_use"
			var_34_3 = var_34_3 + 1
		end
		
		var_34_2.floor_enter_count = {
			[1] = 1,
			[2] = 1
		}
		
		return {
			ranker_info = {
				floor_2_clan = 397,
				floor_1_clan = 397,
				floor_1_tm = os.time() * 1000,
				floor_2_tm = os.time() * 1000
			},
			lota_clan_info = var_34_2,
			lota_user_info = {
				user_floor = 1,
				floor_reward_step = 1,
				explore_exp = 10,
				action_point = 5,
				user_battle_data = {
					["1_729"] = {
						battle_id = "1_729",
						tile_id = "729",
						state = 0
					}
				},
				artifact_items = {
					{
						id = "start_legacy_1_02"
					},
					{
						id = "legacy_1_2"
					}
				},
				job_levels = {},
				user_registration_data = var_34_1
			},
			schedule_info = {
				heritage003 = {
					world_id = "heritage_shandra",
					id = "heritage003",
					start_time = os.time() - 14400,
					end_time = os.time() + 216000
				}
			}
		}
	end,
	lota_lobby = function(arg_35_0, arg_35_1)
		local var_35_0 = table.clone(LotaBattleSlotDataInterface.inst)
		
		var_35_0.floor = 2
		var_35_0.tile_id = 497
		var_35_0.slot_tm_1 = os.time() - 0
		var_35_0.slot_user_1 = AccountData.id
		var_35_0.slot_tm_2 = os.time()
		var_35_0.slot_user_2 = true
		var_35_0.slot_tm_3 = os.time() - 1
		var_35_0.slot_user_3 = true
		
		local var_35_1 = 3
		local var_35_2 = {}
		local var_35_3 = Account:getUnits()
		
		for iter_35_0, iter_35_1 in pairs(var_35_3) do
			if var_35_1 <= table.count(var_35_2) then
				break
			end
			
			var_35_2[tostring(iter_35_1:getUID())] = "not_use"
		end
		
		local var_35_4 = Account:serverTimeDayLocalDetail()
		local var_35_5 = tostring(tonumber(var_35_4) - 1)
		
		return {
			first_enter = false,
			tile_id = 131,
			fog = "0",
			action_point = 33,
			view = "0",
			res = "ok",
			ping_status = {
				memo_1 = "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW",
				ping_4 = -1,
				memo_3 = "WAKE UP!",
				ping_3 = 341,
				ping_5 = -1,
				ping_2 = -1,
				ping_6 = -1,
				ping_1 = 298
			},
			slot_list = {
				var_35_0
			},
			dead_boss_info = {
				season_id = "heritage002",
				floor = 1,
				boss_dead_count = 0,
				clan_id = 300017,
				keeper_dead_count = 4
			},
			user_battle_data = {},
			user_register = {
				clan_id = 300017,
				season_id = "heritage002",
				unregister_count = 0,
				user_id = AccountData.id,
				user_registration_data = var_35_2,
				user_unregister_data = {
					c2006 = var_35_4,
					c5071 = var_35_4
				}
			},
			box_list = {},
			floor_objects = {
				clan = {
					[298] = {
						object_id = "floating_tile_start_1",
						tile_id = "298"
					},
					[43] = {
						object_id = "starting_point_1",
						tile_id = "43"
					},
					[243] = {
						object_id = "starting_point_1",
						tile_id = "243"
					},
					[341] = {
						object_id = "floating_tile_dest_1",
						tile_id = "341"
					},
					[821] = {
						object_id = "heritage001_b_4",
						tile_id = "821"
					}
				},
				user = {}
			},
			user_default = {
				user_floor = 1,
				season_id = "heritage002",
				last_recharge_ap_tm = 1637895078,
				dir = 1,
				explore_exp = 0,
				pos = 1455,
				clan_id = 300017,
				action_point = 33,
				user_id = AccountData.id
			},
			update_objects = {
				clan = {},
				user = {}
			},
			schedule_info = {
				heritage002 = {
					id = "heritage002",
					world_id = "heritage_shandra2",
					start_time = os.time() - 100,
					end_time = os.time() + 10000000
				}
			},
			clan_base = {
				season_id = "heritage002",
				start_day_id = 1619805600,
				clan_id = 300017,
				end_day_id = 1654020000,
				map_config = {
					world_key = "heritage_shandra2",
					seed = "69f",
					floor_config = {
						[2] = {
							tile_count = "1045",
							map_id = "heritage_shandra2_02"
						},
						[4] = {
							tile_count = "1514",
							map_id = "heritage_shandra2_04"
						},
						{
							tile_count = "649",
							map_id = "heritage_shandra2_01"
						},
						[3] = {
							tile_count = "1080",
							map_id = "heritage_shandra2_03"
						}
					}
				}
			},
			user_artifact_doc = {
				season_id = "heritage002",
				clan_id = 300017,
				user_id = AccountData.id,
				artifact_items = {
					["1"] = {
						id = "enhance_ranger_2",
						use_count = 2
					}
				}
			},
			members = {
				{
					floor = 1,
					dir = 1,
					name = "Karisha",
					exp = 0,
					leader_code = "c1111",
					tile_id = 299,
					id = AccountData.id
				},
				{
					id = 12623107,
					floor = 1,
					dir = 1,
					name = "Friend",
					exp = 0,
					leader_code = "c1112",
					tile_id = 43
				}
			},
			update_objects = {
				clan = {},
				user = {}
			}
		}
	end,
	lota_next_floor = function(arg_36_0, arg_36_1)
		local var_36_0 = arg_36_0:lota_lobby()
		
		arg_36_0._cur_floor = 2
		
		return var_36_0
	end,
	lota_clan_status = function(arg_37_0, arg_37_1)
		return {
			user_data_hash = {
				["1234"] = {
					ap = 50,
					exp = 2421,
					id = "1234",
					user_info = {
						leader_code = "c2022",
						name = "하루카타",
						border_code = "ma_border1",
						level = 32
					},
					job_levels = {
						knight = 6,
						warrior = 15
					}
				},
				["1235"] = {
					exp = 242421,
					ap = 50,
					id = "1235",
					user_info = {
						leader_code = "c2021",
						name = "하루카코",
						border_code = "ma_border1",
						level = 21
					}
				}
			}
		}
	end,
	lota_role_enhancement = function(arg_38_0, arg_38_1)
		local var_38_0 = arg_38_1.role
		local var_38_1 = LotaRoleEnhancementUI:getLevelupRequirePoint()
		local var_38_2 = table.clone(LotaUserData:getJobLevels())
		
		var_38_2[var_38_0] = var_38_2[var_38_0] or 1
		var_38_2[var_38_0] = var_38_2[var_38_0] + 1
		var_38_2.mat = var_38_2.mat or 0
		var_38_2.mat = var_38_2.mat - var_38_1
		
		return {
			job_levels = var_38_2
		}
	end,
	lota_set_ping = function(arg_39_0, arg_39_1)
		local var_39_0 = arg_39_1.tile_id
		local var_39_1 = arg_39_1.ping_number or 2
		
		return {
			ping_status = {
				["ping_" .. tostring(var_39_1)] = var_39_0,
				["memo_" .. tostring(var_39_1)] = arg_39_1.msg
			}
		}
	end,
	lota_monster_detail = function(arg_40_0, arg_40_1)
		local var_40_0 = arg_40_1.battle_id
		
		return {
			battle_id = var_40_0
		}
	end
}

local function var_0_0(arg_41_0)
	for iter_41_0, iter_41_1 in pairs(arg_41_0.objects) do
		local var_41_0 = iter_41_1
		local var_41_1 = var_41_0.id
		local var_41_2 = LotaTileMapSystem:getTileById(var_41_1)
		
		if var_41_2 then
			LotaObjectSystem:addObject(var_41_2, var_41_0)
			LotaMinimapRenderer:updateSprite(var_41_2)
		end
	end
end

function merge_member_move_data(arg_42_0)
	if not arg_42_0 or table.empty(arg_42_0) then
		return {}
	end
	
	local var_42_0 = {}
	
	for iter_42_0, iter_42_1 in pairs(arg_42_0 or {}) do
		local var_42_1 = iter_42_1.id
		
		if not var_42_0[var_42_1] then
			var_42_0[var_42_1] = {}
		end
		
		table.insert(var_42_0[var_42_1], iter_42_1)
	end
	
	local var_42_2 = {}
	
	for iter_42_2, iter_42_3 in pairs(var_42_0) do
		table.sort(iter_42_3, function(arg_43_0, arg_43_1)
			return tonumber(arg_43_0.tm) < tonumber(arg_43_1.tm)
		end)
		
		local var_42_3 = {}
		local var_42_4 = {}
		local var_42_5
		
		for iter_42_4, iter_42_5 in pairs(iter_42_3) do
			for iter_42_6 = 1, table.count(iter_42_5.tiles) do
				local var_42_6 = iter_42_5.tiles[iter_42_6]
				
				table.insert(var_42_3, var_42_6)
			end
			
			table.insert(var_42_4, {
				tm = iter_42_5.tm,
				tile_index = #var_42_3 - table.count(iter_42_5.tiles) + 1
			})
			
			if var_42_5 then
				var_42_5 = math.max(var_42_5, to_n(iter_42_5.exp))
			else
				var_42_5 = to_n(iter_42_5.exp)
			end
		end
		
		table.insert(var_42_2, {
			tiles = var_42_3,
			res_tm_list = var_42_4,
			id = iter_42_2,
			exp = var_42_5
		})
	end
	
	return var_42_2
end

LotaNetworkSystem.QueryProc = {
	MoveTo = function(arg_44_0)
		MTV:setTbl(arg_44_0, "MoveTo Response")
		
		if arg_44_0.objects then
			var_0_0(arg_44_0)
		end
		
		LotaSystem:updateActionPoint(arg_44_0)
		LotaSystem:procMovePath(arg_44_0)
	end,
	lota_get_reward_list = function(arg_45_0)
		LotaEnterUI:receiveSyncData(arg_45_0)
	end,
	lota_move_sync = function(arg_46_0)
		arg_46_0 = arg_46_0 or {}
		
		if arg_46_0._req_next_day then
			LotaUserData:updateRegistration(arg_46_0.user_registration_data)
			Dialog:msgBox("[WIP-TEXT] 다음 날이 되었어요!\n이제 유닛들의 사용불가가 초기화되었어요!\n토큰이 늘었어요!\n신난다!", {
				title = "[안내]"
			})
		end
		
		local var_46_0 = merge_member_move_data(arg_46_0.member_move_data)
		
		for iter_46_0, iter_46_1 in pairs(var_46_0) do
			LotaSystem:procMovePath(iter_46_1)
		end
		
		LotaSystem:updateExplorePoint(arg_46_0.clan_explore_point)
		
		if arg_46_0.dead_boss_status then
			local var_46_1 = LotaClanInfo:isAvailableBossBattle(LotaUserData:getFloor())
			
			LotaClanInfo:updateKeeperDeadCount(arg_46_0.dead_boss_status.keeper_dead_count)
			LotaClanInfo:updateBossDeadCount(arg_46_0.dead_boss_status.boss_dead_count)
			
			if LotaSystem:isAvailableExecuteEffect() and not LotaSystem:procBossAppearEffect() then
				LotaSystem:procBossDeadEffect()
			end
			
			if var_46_1 ~= LotaClanInfo:isAvailableBossBattle(LotaUserData:getFloor()) then
				LotaObjectSystem:updateObjectRenderStatusByType("portal")
			end
		end
		
		if arg_46_0.user_battle_data then
			local var_46_2 = {}
			
			for iter_46_2, iter_46_3 in pairs(arg_46_0.user_battle_data) do
				table.insert(var_46_2, iter_46_3.room)
			end
			
			LotaSystem:updateObjectRewardState(var_46_2)
		end
		
		LotaMovableSystem:updateMovablesExp(arg_46_0.exp_list or {})
		LotaSystem:updateObjectStatus(arg_46_0.update_objects)
		LotaBoxSystem:updateBoxList(arg_46_0.box_list)
		LotaBattleSlotSystem:updateBattleSlots(arg_46_0.slot_list)
		LotaNetworkSystem:updateLastTm(arg_46_0.last_update_tm)
		LotaNetworkSystem:updateExpLastTm(arg_46_0.last_update_tm)
		
		if ContentDisable:byAlias("clan_heritage") then
			Dialog:msgBox(T("content_disable"), {
				handler = function()
					SceneManager:nextScene("lobby")
				end
			})
		end
	end,
	JumpTo = function(arg_48_0)
		if arg_48_0.objects then
			var_0_0(arg_48_0)
		end
		
		local var_48_0 = LotaTileMapSystem:getPosById(arg_48_0.tile_id)
		
		LotaMovableSystem:setPosById(var_48_0.x, var_48_0.y, arg_48_0.movable_id)
	end,
	UpdateMapInfos = function(arg_49_0)
	end,
	lota_interaction_object = function(arg_50_0)
		if arg_50_0.objects then
			var_0_0(arg_50_0)
		end
		
		LotaObjectSystem:onResponseObject(arg_50_0.tile_id, arg_50_0)
	end,
	lota_confirm_legacy_select = function(arg_51_0)
		if arg_51_0.artifact_items then
			LotaUserData:confirmArtifactSelect(arg_51_0.artifact_items)
		end
		
		LotaLegacySelectUI:onConfirmArtifactSelect()
		LotaUIMainLayer:updateUI()
	end,
	lota_refresh_start_legacy_pool = function(arg_52_0)
		LotaUserData:clearSelectArtifacts()
		LotaUserData:updateStartLegacyRefreshCount(arg_52_0.start_legacy_refresh_count)
		LotaUserData:updateSelectArtifacts(arg_52_0.artifact_select_pool)
		LotaLegacySelectUI:updateSelectableArtifacts(LotaUserData:getSelectableArtifacts())
	end,
	lota_cheat_set_arti = function(arg_53_0)
		if arg_53_0.artifact_items then
			LotaUserData:confirmArtifactSelect(arg_53_0.artifact_items)
		end
	end,
	lota_select_start_pos = function(arg_54_0)
		local var_54_0 = arg_54_0.tile_id
		
		if arg_54_0.objects then
			var_0_0(arg_54_0)
		end
		
		LotaSystem:onConfirmStartPoint(var_54_0)
	end,
	enter_boss_room = function(arg_55_0)
		if arg_55_0.type == "boss_monster" then
			LotaBossReadyUI:open(SceneManager:getRunningNativeScene(), arg_55_0)
		else
			arg_55_0.elite_room = true
			arg_55_0.object_id = LotaObjectSystem:getObject(arg_55_0.tile_id):getDBId()
			
			LotaBattleReady:show(arg_55_0)
		end
	end,
	lota_get_box_reward = function(arg_56_0)
		if DEBUG.ROTA_NETWORK_MOCKING then
			Dialog:msgRewards(T("[DEBUG] !작업중!"), {
				title = T("[DEBUG] 열심히 만들고 있습니다"),
				rewards = arg_56_0.rewards
			})
		else
			local var_56_0 = arg_56_0.object_id
			local var_56_1, var_56_2 = DB("clan_heritage_object_data", var_56_0, {
				"reward_title",
				"reward_desc"
			})
			local var_56_3 = var_56_1
			local var_56_4 = var_56_2
			local var_56_5, var_56_6 = LotaUtil:makeMsgRewardsParam(arg_56_0, var_56_3, var_56_4, true)
			local var_56_7 = Dialog:msgRewards(var_56_5.desc, var_56_5)
			
			if_set(var_56_7, "txt_title", var_56_6.title)
		end
		
		if arg_56_0.battle_data then
			LotaBattleDataSystem:updateReward(arg_56_0.battle_data)
		end
		
		if arg_56_0.box_list then
			LotaBoxSystem:updateBoxList(arg_56_0.box_list)
		end
		
		LotaReminderUI:onResponse(arg_56_0)
		LotaUIMainLayer:updateSetVisibleNoti()
		LotaEnterUI:updateUI()
	end,
	lota_start_event_battle = function(arg_57_0)
		local var_57_0 = BattleLogic:makeLogic(arg_57_0.battle, arg_57_0.team, {})
		
		LotaSystem:prepareBeforeBattleStart()
		PreLoad:beforeEnterBattle(var_57_0)
		SceneManager:nextScene("battle", {
			logic = var_57_0
		})
	end,
	lota_start_battle = function(arg_58_0)
		local var_58_0 = BattleLogic:makeLogic(arg_58_0.battle, arg_58_0.team, {
			started_data = started_data,
			user_device = user_device,
			monster_device = monster_device,
			automaton_ally_info = automaton_ally_info
		})
		
		LotaSystem:prepareBeforeBattleStart()
		PreLoad:beforeEnterBattle(var_58_0)
		SceneManager:nextScene("battle", {
			logic = var_58_0,
			expedition_users = arg_58_0.user_info,
			coop_sync_time = arg_58_0.coop_sync_time
		})
	end,
	lota_clear_battle = function(arg_59_0)
		local var_59_0 = arg_59_0.object_info
		local var_59_1 = tostring(var_59_0.tile_id)
		
		if var_59_1 then
			local var_59_2 = {
				hit = true,
				tile_id = var_59_1
			}
			local var_59_3 = LotaObjectSystem:getObject(var_59_1)
			local var_59_4 = arg_59_0.object_info
			local var_59_5 = var_59_4 and var_59_4.object_info.max_use or -9999
			
			if var_59_3 and (not var_59_4 or var_59_5 - var_59_4.use_count <= 0) then
				var_59_2.db_id = var_59_3:getDBId()
				var_59_2.request_create = true
				var_59_2.is_dead = true
				var_59_2.force_active = true
			end
			
			LotaOverSceneDataSystem:append("object_renderer", var_59_2)
			LotaObjectRenderer:updateObject(var_59_1)
		end
		
		LotaNetworkSystem:applyClearResponse(arg_59_0)
		ClearResult:show(Battle.logic, arg_59_0)
	end,
	lota_clear_event_battle = function(arg_60_0)
		arg_60_0.event_battle = true
		
		LotaNetworkSystem:applyClearResponse(arg_60_0)
		ClearResult:show(Battle.logic, arg_60_0)
		
		if arg_60_0.select_id then
			local var_60_0 = DB("clan_heritage_event_select", arg_60_0.select_id, "event_story_after")
			
			print("event_story_after?????", var_60_0)
			
			if var_60_0 then
				start_new_story(nil, var_60_0)
			end
		end
	end,
	lota_lose_battle = function(arg_61_0)
		ClearResult:show(Battle.logic, {
			lose = true,
			is_lota = true,
			map_id = Battle.logic.map.enter
		})
	end,
	lota_lose_event_battle = function(arg_62_0)
		ClearResult:show(Battle.logic, {
			lose = true,
			is_lota = true,
			map_id = Battle.logic.map.enter
		})
	end,
	lota_start_coop_battle = function(arg_63_0)
		if arg_63_0.cant_enter_reason then
			LotaBattleReady:closeByAlreadyDead()
			
			return 
		end
		
		local var_63_0 = BattleLogic:makeLogic(arg_63_0.battle, arg_63_0.team, {
			started_data = started_data,
			user_device = user_device,
			monster_device = monster_device,
			automaton_ally_info = automaton_ally_info
		})
		
		LotaSystem:prepareBeforeBattleStart()
		PreLoad:beforeEnterBattle(var_63_0)
		SceneManager:nextScene("battle", {
			logic = var_63_0,
			expedition_users = arg_63_0.expedition_users,
			coop_sync_time = arg_63_0.coop_sync_time
		})
	end,
	lota_clear_coop_battle = function(arg_64_0)
		local var_64_0 = table.clone(arg_64_0.expedition_info)
		local var_64_1
		
		for iter_64_0, iter_64_1 in pairs(arg_64_0.expedition_users) do
			if tostring(iter_64_1.user_id) == tostring(AccountData.id) then
				var_64_1 = iter_64_1
				
				break
			end
		end
		
		local var_64_2 = {
			room = var_64_0,
			user = var_64_1
		}
		
		LotaBattleDataSystem:updateReward(var_64_2)
		
		local var_64_3 = LotaUtil:createBattleData(var_64_2)
		local var_64_4 = var_64_3:isBossDead()
		local var_64_5 = var_64_3:getBattleId()
		local var_64_6 = LotaBattleDataSystem:battleIdToTileId(var_64_5)
		
		if var_64_6 then
			local var_64_7 = tostring(var_64_6)
			local var_64_8 = {
				tile_id = var_64_7,
				is_dead = var_64_4
			}
			local var_64_9 = LotaObjectSystem:getObject(var_64_7)
			
			if not arg_64_0.object_info and var_64_9 then
				var_64_8.db_id = var_64_9:getDBId()
				var_64_8.request_create = true
				var_64_8.force_active = true
			end
			
			LotaOverSceneDataSystem:append("object_renderer", var_64_8)
		end
		
		if arg_64_0.keeper_dead_data then
			LotaClanInfo:updateKeeperDeadCount(arg_64_0.keeper_dead_data)
		end
		
		if arg_64_0.boss_dead_data then
			LotaClanInfo:updateBossDeadCount(arg_64_0.boss_dead_data)
		end
		
		LotaUserData:updateRegistration(arg_64_0.user_registration_data)
		
		arg_64_0.is_lota = true
		arg_64_0.is_lota_with_coop = true
		
		if arg_64_0.exp then
			arg_64_0.items = arg_64_0.items or {}
			
			LotaUtil:addExpToRewards(arg_64_0.exp, arg_64_0.items, true, arg_64_0.artifact_effects, "result")
			
			local var_64_10 = LotaUserData:getUserLevel()
			local var_64_11 = LotaUtil:getUserLevel(tonumber(arg_64_0.exp))
			
			if var_64_10 ~= var_64_11 then
				LotaOverSceneDataSystem:append("battle.level_up", {
					prv_lv = var_64_10,
					new_lv = var_64_11
				})
			end
		end
		
		Battle:responseExpedition(arg_64_0)
		ClearResult:show(Battle.logic, arg_64_0)
	end,
	lota_show_coop_detail = function(arg_65_0)
		local var_65_0 = table.clone(arg_65_0.expedition_info)
		local var_65_1
		
		for iter_65_0, iter_65_1 in pairs(arg_65_0.expedition_users) do
			if tostring(iter_65_1.user_id) == tostring(AccountData.id) then
				var_65_1 = iter_65_1
				
				break
			end
		end
		
		local var_65_2 = {
			room = var_65_0,
			user = var_65_1
		}
		
		LotaBattleDataSystem:updateReward(var_65_2)
		LotaReminderUI:onShowCoopDetail(arg_65_0)
	end,
	lota_event_select = function(arg_66_0)
		LotaEventSystem:onResponseEventResultData(arg_66_0)
	end,
	lota_battle_sync = function(arg_67_0)
		if SceneManager:getCurrentSceneName() == "battle" then
			Battle:responseExpedition(arg_67_0)
			Battle:updateExpeditionSyncDirty()
		elseif LotaBattleReady:isActive() or LotaBattleReady:isWaitResponse() then
			LotaBattleReady:responseSync(arg_67_0)
			LotaNetworkSystem:updateLastSyncResponseTime()
		elseif LotaBossReadyUI:isActive() or LotaBossReadyUI:isWaitResponse() then
			LotaBossReadyUI:responseSync(arg_67_0)
			LotaNetworkSystem:updateLastSyncResponseTime()
		end
	end,
	lota_enter = function(arg_68_0)
		if arg_68_0.update_currency then
			Account:updateCurrencies(arg_68_0.update_currency)
		end
		
		SceneManager:nextScene("lota_lobby", arg_68_0)
	end,
	lota_lobby = function(arg_69_0)
		UIAction:Remove("loop_cmd")
		TransitionScreen:show({
			on_show_before = function(arg_70_0)
				return EffectManager:Play({
					fn = "eff_anc_floor.cfx",
					pivot_z = 99998,
					layer = arg_70_0,
					pivot_x = VIEW_WIDTH / 2,
					pivot_y = VIEW_HEIGHT / 2 + HEIGHT_MARGIN / 2
				}), 250
			end,
			on_hide_before = function(arg_71_0)
				return nil, 0
			end,
			on_show = function()
				SceneManager:nextScene("lota", arg_69_0)
			end
		})
	end,
	lota_remove_cache = function(arg_73_0)
		SceneManager:nextScene("lobby")
	end,
	lota_cheat_fog = function(arg_74_0)
		SceneManager:nextScene("lobby")
	end,
	lota_cheat_warp = function(arg_75_0)
		LotaNetworkSystem:sendQuery("lota_move_sync")
	end,
	lota_jump_boss_room = function(arg_76_0)
		LotaSystem:procJumpTo(arg_76_0.move_data)
	end,
	lota_next_floor = function(arg_77_0)
		LotaSystem:showCurtain()
		LotaSystem:onNextFloor()
		LotaOverSceneDataSystem:append("lota_next_floor", {})
		LotaNetworkSystem:sendQuery("lota_lobby")
		SceneManager:resetSceneFlow()
	end,
	lota_edit_notice = function(arg_78_0)
		LotaEnterUI:updateNoticeMsg(arg_78_0)
		balloon_message_with_sound("ui_clan_heritage_order_modify")
		LotaNotiPopupUI:closeNoticePopup()
	end,
	lota_exit_boss_room = function(arg_79_0)
		LotaSystem:procJumpTo(arg_79_0.move_data)
	end,
	lota_monster_detail = function(arg_80_0)
		local var_80_0
		
		if not arg_80_0.expedition_info then
			var_80_0 = string.split(arg_80_0.battle_id, ":")[2]
		else
			var_80_0 = arg_80_0.expedition_info.tile_id
			arg_80_0.expedition_info.invitee = arg_80_0.expedition_users or {}
			
			LotaBattleDataSystem:updateRoomInfo(arg_80_0.expedition_info)
		end
		
		local var_80_1 = LotaObjectSystem:getObject(var_80_0)
		
		LotaInteractiveUI:openDetailTooltip(var_80_1)
	end,
	lota_confirm_registration = function(arg_81_0)
		if MTV then
			MTV:setTbl(arg_81_0.list)
		end
		
		if arg_81_0.currency then
			Account:updateCurrencies(arg_81_0.currency)
			TopBarNew:topbarUpdate(true)
		end
		
		LotaUserData:onConfirmRegistration(arg_81_0.user_register)
		LotaRegistrationUI:onReceiveRegistration()
		LotaUIMainLayer:updateHeroButton()
	end,
	lota_set_ping = function(arg_82_0)
		if arg_82_0.fail_reason then
			balloon_message_with_sound("msg_clanheritage_memo_max")
			
			return 
		end
		
		if LotaMemoInputView:isRequestRemoved() then
			balloon_message_with_sound("msg_clanheritage_memo_delete")
		else
			balloon_message_with_sound("msg_clanheritage_memo_complete")
		end
	end,
	lota_update_ping = function(arg_83_0)
	end,
	lota_update_room = function(arg_84_0)
		if arg_84_0.room_info then
			LotaSystem:updateObjectRewardState({
				arg_84_0.room_info
			})
		end
		
		if arg_84_0.box_list then
			LotaBoxSystem:updateBoxList(arg_84_0.box_list)
			LotaUIMainLayer:updateSetVisibleNoti()
		end
	end,
	lota_update_object = function(arg_85_0)
		if arg_85_0.room_info then
			LotaSystem:updateObjectRewardState({
				arg_85_0.room_info
			})
		end
		
		if arg_85_0.box_list then
			LotaBoxSystem:updateBoxList(arg_85_0.box_list)
			LotaUIMainLayer:updateSetVisibleNoti()
		end
		
		LotaSystem:updateObjectStatus(arg_85_0.update_objects)
		LotaBattleSlotSystem:updateBattleSlots(arg_85_0.slot_list)
		LotaMovableSystem:updateMovablesExp(arg_85_0.exp_list or {})
		LotaNetworkSystem:updateExpLastTm(arg_85_0.exp_tm)
		LotaMovableSystem:drawMovableArea(nil, true)
		
		if LotaSystem:isAvailableExecuteEffect() then
			LotaSystem:procBossDeadEffect()
		end
	end,
	lota_get_member = function(arg_86_0)
		if arg_86_0.members and type(arg_86_0.members) == "table" then
			for iter_86_0, iter_86_1 in pairs(arg_86_0.members) do
				LotaMovableSystem:updateMovableInfo(iter_86_1)
			end
		end
	end,
	lota_get_history = function(arg_87_0)
		LotaReminderUI:onResponseLogs(arg_87_0.logs)
	end,
	lota_cheat_registeration_reset = function(arg_88_0)
		LotaUserData:updateRegistration(arg_88_0.list)
		balloon_message_with_sound("!REGISTRATION RESET 성공!")
	end,
	lota_role_enhancement = function(arg_89_0)
		LotaRoleEnhancementUI:onResponse()
	end,
	lota_ranking_board = function(arg_90_0)
		LotaEnterUI:updateRankerInfo(arg_90_0.ranker)
		LotaRankingBoardUI:open(SceneManager:getRunningNativeScene(), arg_90_0)
	end,
	lota_get_reward_ranking_board = function(arg_91_0)
		LotaRankingBoardUI:onResponseRewards(arg_91_0)
	end,
	lota_ranking_board_detail = function(arg_92_0)
		LotaRankingBoardUI:onResponseBoardDetail(arg_92_0)
	end,
	lota_shop = function(arg_93_0)
		LotaEnterUI:hide()
		LotaShopUI:open(arg_93_0.shop_item_list)
	end,
	lota_clan_status = function(arg_94_0)
		LotaClanStatusUI:init(SceneManager:getRunningNativeScene(), arg_94_0)
	end,
	lota_cheat_set_role = function(arg_95_0)
	end,
	lota_cheat_set_job_levels = function(arg_96_0)
	end,
	lota_cheat_recharge_token = function(arg_97_0)
	end,
	lota_cheat_set_token = function(arg_98_0)
	end,
	lota_cheat_next_day = function(arg_99_0)
		Dialog:msgBox("다음 날이 되었습니다. 모든 기사단원에게 다음 날이 되었으니 게임 로비로 나가서 다시 게임에 재진입해달라고 말해주세요.")
	end,
	lota_cheat_remove_user_data = function(arg_100_0)
		SceneManager:nextScene("lobby")
	end,
	lota_cheat_remove_clan_data = function(arg_101_0)
		SceneManager:nextScene("lobby")
	end,
	lota_cheat_complete_object = function(arg_102_0)
		LotaNetworkSystem:updateDebugInfos(arg_102_0)
	end,
	lota_cheat_recharge_token_day = function()
		SceneManager:nextScene("lobby")
	end,
	lota_cheat_set_floor = function(arg_104_0)
		SceneManager:nextScene("lobby")
	end,
	lota_debug_add_history = function(arg_105_0)
	end
}

function MsgHandler.lota_enter(arg_106_0)
	LotaNetworkSystem:receiveQuery("lota_enter", arg_106_0)
end

function ErrHandler.lota_enter(arg_107_0, arg_107_1, arg_107_2)
	LotaNetworkSystem:handleError(arg_107_0, arg_107_1, arg_107_2)
end

function MsgHandler.lota_lobby(arg_108_0)
	LotaNetworkSystem:receiveQuery("lota_lobby", arg_108_0)
end

function ErrHandler.lota_lobby(arg_109_0, arg_109_1, arg_109_2)
	LotaNetworkSystem:handleError(arg_109_0, arg_109_1, arg_109_2)
end

function MsgHandler.lota_edit_notice(arg_110_0)
	LotaNetworkSystem:receiveQuery("lota_edit_notice", arg_110_0)
end

function ErrHandler.lota_edit_notice(arg_111_0, arg_111_1, arg_111_2)
	LotaNetworkSystem:handleError(arg_111_0, arg_111_1, arg_111_2)
end

function MsgHandler.lota_next_floor(arg_112_0)
	LotaNetworkSystem:receiveQuery("lota_next_floor", arg_112_0)
end

function ErrHandler.lota_next_floor(arg_113_0, arg_113_1, arg_113_2)
	LotaNetworkSystem:handleError(arg_113_0, arg_113_1, arg_113_2)
end

function MsgHandler.lota_move_sync(arg_114_0)
	LotaNetworkSystem:receiveQuery("lota_move_sync", arg_114_0)
end

function ErrHandler.lota_move_sync(arg_115_0, arg_115_1, arg_115_2)
	LotaNetworkSystem:handleError(arg_115_0, arg_115_1, arg_115_2)
end

function MsgHandler.lota_select_start_pos(arg_116_0)
	LotaNetworkSystem:receiveQuery("lota_select_start_pos", arg_116_0)
end

function ErrHandler.lota_select_start_pos(arg_117_0, arg_117_1, arg_117_2)
	LotaNetworkSystem:handleError(arg_117_0, arg_117_1, arg_117_2)
end

function MsgHandler.lota_remove_cache(arg_118_0)
	LotaNetworkSystem:receiveQuery("lota_remove_cache", arg_118_0)
end

function ErrHandler.lota_remove_cache(arg_119_0, arg_119_1, arg_119_2)
	LotaNetworkSystem:handleError(arg_119_0, arg_119_1, arg_119_2)
end

function MsgHandler.lota_interaction_object(arg_120_0)
	LotaNetworkSystem:receiveQuery("lota_interaction_object", arg_120_0)
end

function ErrHandler.lota_interaction_object(arg_121_0, arg_121_1, arg_121_2)
	LotaNetworkSystem:handleError(arg_121_0, arg_121_1, arg_121_2)
end

function MsgHandler.lota_confirm_legacy_select(arg_122_0)
	LotaNetworkSystem:receiveQuery("lota_confirm_legacy_select", arg_122_0)
end

function ErrHandler.lota_confirm_legacy_select(arg_123_0, arg_123_1, arg_123_2)
	LotaNetworkSystem:handleError(arg_123_0, arg_123_1, arg_123_2)
end

function MsgHandler.lota_monster_detail(arg_124_0)
	LotaNetworkSystem:receiveQuery("lota_monster_detail", arg_124_0)
end

function ErrHandler.lota_monster_detail(arg_125_0, arg_125_1, arg_125_2)
	LotaNetworkSystem:handleError(arg_125_0, arg_125_1, arg_125_2)
end

function MsgHandler.lota_refresh_start_legacy_pool(arg_126_0)
	LotaNetworkSystem:receiveQuery("lota_refresh_start_legacy_pool", arg_126_0)
end

function ErrHandler.lota_refresh_start_legacy_pool(arg_127_0, arg_127_1, arg_127_2)
	LotaNetworkSystem:handleError(arg_127_0, arg_127_1, arg_127_2)
end

function MsgHandler.lota_set_ping(arg_128_0)
	LotaNetworkSystem:receiveQuery("lota_set_ping", arg_128_0)
end

function ErrHandler.lota_set_ping(arg_129_0, arg_129_1, arg_129_2)
	LotaNetworkSystem:handleError(arg_129_0, arg_129_1, arg_129_2)
end

function MsgHandler.lota_show_coop_detail(arg_130_0)
	LotaNetworkSystem:receiveQuery("lota_show_coop_detail", arg_130_0)
end

function ErrHandler.lota_show_coop_detail(arg_131_0, arg_131_1, arg_131_2)
	LotaNetworkSystem:handleError(arg_131_0, arg_131_1, arg_131_2)
end

function MsgHandler.lota_get_history(arg_132_0)
	LotaNetworkSystem:receiveQuery("lota_get_history", arg_132_0)
end

function ErrHandler.lota_get_history(arg_133_0, arg_133_1, arg_133_2)
	LotaNetworkSystem:handleError(arg_133_0, arg_133_1, arg_133_2)
end

function MsgHandler.lota_event_select(arg_134_0)
	LotaNetworkSystem:receiveQuery("lota_event_select", arg_134_0)
end

function ErrHandler.lota_event_select(arg_135_0, arg_135_1, arg_135_2)
	LotaNetworkSystem:handleError(arg_135_0, arg_135_1, arg_135_2)
end

function MsgHandler.lota_ranking_board(arg_136_0)
	LotaNetworkSystem:receiveQuery("lota_ranking_board", arg_136_0)
end

function ErrHandler.lota_ranking_board(arg_137_0, arg_137_1, arg_137_2)
	LotaNetworkSystem:handleError(arg_137_0, arg_137_1, arg_137_2)
end

function MsgHandler.lota_ranking_board_detail(arg_138_0)
	LotaNetworkSystem:receiveQuery("lota_ranking_board_detail", arg_138_0)
end

function ErrHandler.lota_ranking_board_detail(arg_139_0, arg_139_1, arg_139_2)
	LotaNetworkSystem:handleError(arg_139_0, arg_139_1, arg_139_2)
end

function MsgHandler.lota_get_reward_ranking_board(arg_140_0)
	LotaNetworkSystem:receiveQuery("lota_get_reward_ranking_board", arg_140_0)
end

function ErrHandler.lota_get_reward_ranking_board(arg_141_0, arg_141_1, arg_141_2)
	LotaNetworkSystem:handleError(arg_141_0, arg_141_1, arg_141_2)
end

function MsgHandler.lota_clan_status(arg_142_0)
	LotaNetworkSystem:receiveQuery("lota_clan_status", arg_142_0)
end

function ErrHandler.lota_clan_status(arg_143_0, arg_143_1, arg_143_2)
	LotaNetworkSystem:handleError(arg_143_0, arg_143_1, arg_143_2)
end

function MsgHandler.lota_shop(arg_144_0)
	LotaNetworkSystem:receiveQuery("lota_shop", arg_144_0)
end

function ErrHandler.lota_shop(arg_145_0, arg_145_1, arg_145_2)
	LotaNetworkSystem:handleError(arg_145_0, arg_145_1, arg_145_2)
end

function MsgHandler.lota_confirm_registration(arg_146_0)
	LotaNetworkSystem:receiveQuery("lota_confirm_registration", arg_146_0)
end

function ErrHandler.lota_confirm_registration(arg_147_0, arg_147_1, arg_147_2)
	LotaNetworkSystem:handleError(arg_147_0, arg_147_1, arg_147_2)
end

function MsgHandler.lota_role_enhancement(arg_148_0)
	LotaNetworkSystem:receiveQuery("lota_role_enhancement", arg_148_0)
end

function ErrHandler.lota_role_enhancement(arg_149_0, arg_149_1, arg_149_2)
	LotaNetworkSystem:handleError(arg_149_0, arg_149_1, arg_149_2)
end

function MsgHandler.lota_start_battle(arg_150_0)
	LotaNetworkSystem:receiveQuery("lota_start_battle", arg_150_0)
end

function ErrHandler.lota_start_battle(arg_151_0, arg_151_1, arg_151_2)
	LotaNetworkSystem:handleError(arg_151_0, arg_151_1, arg_151_2)
end

function MsgHandler.lota_lose_battle(arg_152_0)
	LotaNetworkSystem:receiveQuery("lota_lose_battle", arg_152_0)
end

function ErrHandler.lota_lose_battle(arg_153_0, arg_153_1, arg_153_2)
	LotaNetworkSystem:handleError(arg_153_0, arg_153_1, arg_153_2)
end

function MsgHandler.lota_clear_battle(arg_154_0)
	LotaNetworkSystem:receiveQuery("lota_clear_battle", arg_154_0)
end

function ErrHandler.lota_clear_battle(arg_155_0, arg_155_1, arg_155_2)
	LotaNetworkSystem:handleError(arg_155_0, arg_155_1, arg_155_2)
end

function MsgHandler.lota_start_coop_battle(arg_156_0)
	LotaNetworkSystem:receiveQuery("lota_start_coop_battle", arg_156_0)
end

function ErrHandler.lota_start_coop_battle(arg_157_0, arg_157_1, arg_157_2)
	LotaNetworkSystem:handleError(arg_157_0, arg_157_1, arg_157_2)
end

function MsgHandler.lota_clear_coop_battle(arg_158_0)
	LotaNetworkSystem:receiveQuery("lota_clear_coop_battle", arg_158_0)
end

function ErrHandler.lota_clear_coop_battle(arg_159_0, arg_159_1, arg_159_2)
	LotaNetworkSystem:handleError(arg_159_0, arg_159_1, arg_159_2)
end

function MsgHandler.lota_battle_sync(arg_160_0)
	LotaNetworkSystem:receiveQuery("lota_battle_sync", arg_160_0)
end

function ErrHandler.lota_battle_sync(arg_161_0, arg_161_1, arg_161_2)
	LotaNetworkSystem:handleError(arg_161_0, arg_161_1, arg_161_2)
end

function MsgHandler.lota_start_event_battle(arg_162_0)
	LotaNetworkSystem:receiveQuery("lota_start_event_battle", arg_162_0)
end

function ErrHandler.lota_start_event_battle(arg_163_0, arg_163_1, arg_163_2)
	LotaNetworkSystem:handleError(arg_163_0, arg_163_1, arg_163_2)
end

function MsgHandler.lota_lose_event_battle(arg_164_0)
	LotaNetworkSystem:receiveQuery("lota_lose_event_battle", arg_164_0)
end

function ErrHandler.lota_lose_event_battle(arg_165_0, arg_165_1, arg_165_2)
	LotaNetworkSystem:handleError(arg_165_0, arg_165_1, arg_165_2)
end

function MsgHandler.lota_clear_event_battle(arg_166_0)
	LotaNetworkSystem:receiveQuery("lota_clear_event_battle", arg_166_0)
end

function ErrHandler.lota_clear_event_battle(arg_167_0, arg_167_1, arg_167_2)
	LotaNetworkSystem:handleError(arg_167_0, arg_167_1, arg_167_2)
end

function MsgHandler.lota_get_box_reward(arg_168_0)
	LotaNetworkSystem:receiveQuery("lota_get_box_reward", arg_168_0)
end

function ErrHandler.lota_get_box_reward(arg_169_0, arg_169_1, arg_169_2)
	LotaNetworkSystem:handleError(arg_169_0, arg_169_1, arg_169_2)
end

function MsgHandler.lota_get_reward_list(arg_170_0)
	LotaNetworkSystem:receiveQuery("lota_get_reward_list", arg_170_0)
end

function ErrHandler.lota_get_reward_list(arg_171_0, arg_171_1, arg_171_2)
	LotaNetworkSystem:handleError(arg_171_0, arg_171_1, arg_171_2)
end

function MsgHandler.lota_update_ping(arg_172_0)
	LotaNetworkSystem:receiveQuery("lota_update_ping", arg_172_0)
end

function MsgHandler.lota_update_object(arg_173_0)
	LotaNetworkSystem:receiveQuery("lota_update_object", arg_173_0)
end

function MsgHandler.lota_get_member(arg_174_0)
	LotaNetworkSystem:receiveQuery("lota_get_member", arg_174_0)
end

function MsgHandler.lota_update_room(arg_175_0)
	LotaNetworkSystem:receiveQuery("lota_update_room", arg_175_0)
end

function MsgHandler.lota_jump_boss_room(arg_176_0)
	LotaNetworkSystem:receiveQuery("lota_jump_boss_room", arg_176_0)
end

function MsgHandler.lota_exit_boss_room(arg_177_0)
	LotaNetworkSystem:receiveQuery("lota_exit_boss_room", arg_177_0)
end

function MsgHandler.lota_test_start_battle(arg_178_0)
	LotaNetworkSystem:receiveQuery("lota_test_start_battle", arg_178_0)
end

function MsgHandler.lota_debug_add_history(arg_179_0)
	LotaNetworkSystem:receiveQuery("lota_debug_add_history", arg_179_0)
end

function MsgHandler.lota_test_start_coop_battle(arg_180_0)
	LotaNetworkSystem:receiveQuery("lota_test_start_coop_battle", arg_180_0)
end

function MsgHandler.lota_test_clear_battle(arg_181_0)
	LotaNetworkSystem:receiveQuery("lota_test_clear_battle", arg_181_0)
end

function MsgHandler.lota_cheat_fog(arg_182_0)
	LotaNetworkSystem:receiveQuery("lota_cheat_fog", arg_182_0)
end

function MsgHandler.lota_cheat_warp(arg_183_0)
	LotaNetworkSystem:receiveQuery("lota_cheat_warp", arg_183_0)
end

function MsgHandler.lota_cheat_recharge_token(arg_184_0)
	LotaNetworkSystem:receiveQuery("lota_cheat_recharge_token", arg_184_0)
end

function MsgHandler.lota_cheat_set_token(arg_185_0)
	LotaNetworkSystem:receiveQuery("lota_cheat_set_token", arg_185_0)
end

function MsgHandler.lota_cheat_set_role(arg_186_0)
	LotaNetworkSystem:receiveQuery("lota_cheat_set_role", arg_186_0)
end

function MsgHandler.lota_cheat_set_job_levels(arg_187_0)
	LotaNetworkSystem:receiveQuery("lota_cheat_set_job_levels", arg_187_0)
end

function MsgHandler.lota_cheat_set_arti(arg_188_0)
	LotaNetworkSystem:receiveQuery("lota_cheat_set_arti", arg_188_0)
end

function MsgHandler.lota_cheat_next_day(arg_189_0)
	LotaNetworkSystem:receiveQuery("lota_cheat_next_day", arg_189_0)
end

function MsgHandler.lota_cheat_registeration_reset(arg_190_0)
	LotaNetworkSystem:receiveQuery("lota_cheat_registeration_reset", arg_190_0)
end

function MsgHandler.lota_cheat_recharge_token_day(arg_191_0)
	LotaNetworkSystem:receiveQuery("lota_cheat_recharge_token_day", arg_191_0)
end

function MsgHandler.lota_cheat_complete_object(arg_192_0)
	LotaNetworkSystem:receiveQuery("lota_cheat_complete_object", arg_192_0)
end

function MsgHandler.lota_cheat_set_floor(arg_193_0)
	LotaNetworkSystem:receiveQuery("lota_cheat_set_floor", arg_193_0)
end

function MsgHandler.lota_cheat_remove_user_data(arg_194_0)
	LotaNetworkSystem:receiveQuery("lota_cheat_remove_user_data", arg_194_0)
end

function MsgHandler.lota_cheat_remove_clan_data(arg_195_0)
	LotaNetworkSystem:receiveQuery("lota_cheat_remove_clan_data", arg_195_0)
end

function LotaNetworkSystem.handleError(arg_196_0, arg_196_1, arg_196_2, arg_196_3)
	local var_196_0
	
	if arg_196_2 == "tx_err" or arg_196_2 == "max_usage" then
		var_196_0 = T("heritage_server_error_desc")
	elseif arg_196_2 == "no_clan_id" then
		var_196_0 = T("ui_clan_heritage_forced_secession")
	elseif arg_196_2 == "invalid_season_info" then
		var_196_0 = T("msg_clangeritage_contents_off")
	elseif arg_196_2 == "msg_clan_lota_server_busy" then
		var_196_0 = T("error_try_again")
	elseif arg_196_2 == "not_enough_remain_count" then
		var_196_0 = T("msg_clan_heritage_normal_warning")
	elseif arg_196_2 == "no_user_data" then
		var_196_0 = T("msg_clanheritage_rank_error")
	else
		var_196_0 = T(arg_196_1 .. "." .. arg_196_2)
	end
	
	if arg_196_2 == "msg_clan_lota_server_busy" and arg_196_1 ~= "lota_set_ping" then
		arg_196_0:onNetworkRetry(var_196_0)
	else
		Dialog:msgBox(var_196_0, {
			handler = function()
				if arg_196_2 == "not_enough_remain_count" then
					LotaBattleReady:close()
				end
				
				if arg_196_2 == "tx_err" or arg_196_2 == "no_clan_id" or arg_196_2 == "invalid_season_info" or arg_196_2 == "max_usage" then
					SceneManager:nextScene("lobby")
				end
			end
		})
	end
end

function LotaNetworkSystem.refreshRetryCount(arg_198_0)
	arg_198_0.retry_count = 0
	arg_198_0.err_dialog = nil
end

function LotaNetworkSystem.onNetworkRetry(arg_199_0, arg_199_1)
	if not arg_199_0.retry_count then
		arg_199_0:refreshRetryCount()
	end
	
	local var_199_0 = 4000
	local var_199_1 = 2000
	
	arg_199_0.retry_count = arg_199_0.retry_count + 1
	
	if arg_199_0.retry_count < 3 then
		local var_199_2 = T("game_connect_try")
		
		local function var_199_3()
			arg_199_0:sendQuery("lota_lobby")
		end
		
		local var_199_4 = load_dlg("msgbox", true, "wnd")
		
		arg_199_0.err_dialog = Dialog:msgBox(arg_199_1, {
			text = arg_199_1,
			dlg = var_199_4,
			handler = var_199_3
		})
		
		if_set(var_199_4, "txt_tab", T("tab_to_retry"))
		if_set_visible(var_199_4, "btn_yes", false)
		if_set_visible(var_199_4, "txt_yes", false)
		if_set_visible(var_199_4, "btn_cancel", false)
		if_set_visible(var_199_4, "txt_cancel", false)
		if_set_visible(var_199_4, "btn_ok", false)
		if_set_visible(var_199_4, "txt_ok", true)
		if_set_visible(var_199_4, "n_buttons", true)
		if_set_visible(var_199_4, "n_cost_buttons", false)
		
		arg_199_0.err_dialog_end_tm = systick() + var_199_0 + (arg_199_0.retry_count - 1) * var_199_1
		
		local function var_199_5(arg_201_0)
			if not arg_201_0.err_dialog then
				return 
			end
			
			local var_201_0 = arg_201_0.err_dialog_end_tm - systick()
			local var_201_1 = math.floor(var_201_0 / 1000)
			
			if_set(arg_201_0.err_dialog, "txt_warning", tostring(var_201_1))
			if_set_visible(arg_201_0.err_dialog, "txt_warning", var_201_1 > 0)
			if_set_visible(arg_201_0.err_dialog, "btn_ok", var_201_1 <= 0)
			if_set_visible(arg_201_0.err_dialog, "btn_default", var_201_1 <= 0)
		end
		
		var_199_5(arg_199_0)
		Scheduler:addSlow(arg_199_0.err_dialog, var_199_5, arg_199_0)
	else
		Dialog:msgBox(arg_199_1)
		arg_199_0:refreshRetryCount()
	end
end

function LotaNetworkSystem.init(arg_202_0, arg_202_1)
	arg_202_0.vars = {}
	arg_202_0.vars._debug_queue = {}
	arg_202_0.vars.event_listener_obj = arg_202_1
	arg_202_0.vars.wait_queue = {}
	arg_202_0.vars.last_update_tm = os.time() * 10000
	arg_202_0.vars.proc_move_syncing = false
	
	arg_202_0:resumeSync()
end

function LotaNetworkSystem.isProcMoveSyncing(arg_203_0)
	return arg_203_0.vars and arg_203_0.vars.proc_move_syncing
end

function LotaNetworkSystem.addWaitQueue(arg_204_0, arg_204_1)
	if arg_204_0.vars then
		table.insert(arg_204_0.vars.wait_queue, arg_204_1)
	end
end

function LotaNetworkSystem.applyClearResponse(arg_205_0, arg_205_1)
	LotaUserData:updateRegistration(arg_205_1.user_registration_data)
	
	arg_205_1.is_lota = true
	
	if not table.empty(arg_205_1.rewards) then
		local var_205_0 = Account:addReward(arg_205_1.rewards, {
			enter = arg_205_1.map
		})
		
		arg_205_1.equip = arg_205_1.rewards.new_equips or {}
		arg_205_1.character = arg_205_1.rewards.new_units or {}
		
		local var_205_1 = {}
		
		for iter_205_0, iter_205_1 in pairs(arg_205_1.rewards.new_items or {}) do
			table.insert(var_205_1, {
				code = iter_205_1.code,
				count = iter_205_1.diff
			})
		end
		
		arg_205_1.items = var_205_1
		
		if var_205_0 then
			arg_205_1.tokens = {}
			
			for iter_205_2, iter_205_3 in pairs(var_205_0.currencies_diff or {}) do
				if iter_205_2 ~= "stamina" then
					table.insert(arg_205_1.tokens, {
						t = "token",
						code = iter_205_2,
						count = iter_205_3
					})
				end
			end
		end
	end
	
	if arg_205_1.exp then
		arg_205_1.items = arg_205_1.items or {}
		
		LotaUtil:addExpToRewards(arg_205_1.exp, arg_205_1.items, true, arg_205_1.artifact_effects, "result")
		
		local var_205_2 = LotaUserData:getUserLevel()
		local var_205_3 = LotaUtil:getUserLevel(tonumber(arg_205_1.exp))
		
		if var_205_2 ~= var_205_3 then
			LotaOverSceneDataSystem:append("battle.level_up", {
				prv_lv = var_205_2,
				new_lv = var_205_3
			})
		end
	end
	
	if arg_205_1.action_point then
		if not arg_205_1.tokens then
			arg_205_1.tokens = {}
		end
		
		local var_205_4, var_205_5 = LotaUtil:getPrvAndNewLv(arg_205_1.exp)
		
		LotaUtil:addActionPointToRewards(arg_205_1.action_point, var_205_4, var_205_5, arg_205_1.tokens, true)
	end
	
	local var_205_6 = arg_205_1.artifact_effects
	
	if LotaUserData:getRolePointDiffValue() > 0 then
		arg_205_1.items = arg_205_1.items or {}
		
		LotaUtil:addRolePointToRewards(arg_205_1.items, nil, tonumber(arg_205_1.exp), true)
		
		if var_205_6 and to_n(var_205_6.use_event_add_roleup_point) > 0 then
			for iter_205_4, iter_205_5 in pairs(arg_205_1.items) do
				if iter_205_5.code == "ma_heritage_job" then
					iter_205_5.lota_arti_bonus = to_n(var_205_6.use_event_add_roleup_point)
				end
			end
		end
	end
	
	if var_205_6 and var_205_6.battle_win_bonus_token then
		if not arg_205_1.tokens then
			arg_205_1.tokens = {}
		end
		
		LotaUtil:addActionPointToRewardsByCount(arg_205_1.tokens, 1, true)
		
		for iter_205_6, iter_205_7 in pairs(arg_205_1.tokens) do
			if iter_205_7.code == "clanheritage" then
				iter_205_7.lota_arti_bonus = 1
			end
		end
	end
end

function LotaNetworkSystem.sendMoveTo(arg_206_0, arg_206_1)
	LotaMovableSystem:moveTo(arg_206_1.x, arg_206_1.y)
end

function LotaNetworkSystem.procMoveTo(arg_207_0, arg_207_1)
	if not LotaMovableSystem:isMovable(arg_207_1.x, arg_207_1.y) then
		balloon_message_with_sound("msg_clanheritage_token_lack")
		
		return false
	end
	
	if arg_207_0:isProcMoveSyncing() then
		arg_207_0:addWaitQueue(arg_207_1)
	else
		arg_207_0:sendMoveTo(arg_207_1)
	end
	
	return true
end

function LotaNetworkSystem.isMoveSyncAvailable(arg_208_0)
	local var_208_0 = not LotaBattleReady:isActive() or not LotaBattleReady:isCoop()
	
	if not LotaSystem:isPopupEmpty() then
		var_208_0 = false
	end
	
	return var_208_0
end

function LotaNetworkSystem.isCurrentSleepMode(arg_209_0)
	return arg_209_0.vars.sleep_mode
end

function LotaNetworkSystem.update(arg_210_0)
	if not arg_210_0.vars or not get_cocos_refid(arg_210_0.vars.event_listener_obj) then
		return 
	end
	
	if not arg_210_0.vars.proc_move_syncing then
		local var_210_0 = SceneManager:getRunningScene()
		local var_210_1 = os.time()
		local var_210_2 = tonumber(getenv("allow.lota_move_sync_interval") or 10)
		local var_210_3 = arg_210_0.vars.last_move_sync_recv_tm or 0
		local var_210_4 = arg_210_0:isMoveSyncAvailable()
		
		if var_210_0.getTouchEventTime and var_210_4 then
			if var_210_1 - var_210_0:getTouchEventTime() > 30 then
				var_210_4 = false
				arg_210_0.vars.sleep_mode = true
				
				LotaSystem:procInputWaitMode()
			else
				arg_210_0.vars.sleep_mode = false
			end
		end
		
		if var_210_4 then
			if table.empty(arg_210_0.vars.wait_queue) then
				if var_210_2 <= var_210_1 - var_210_3 then
					arg_210_0:sendQuery("lota_move_sync")
				else
					arg_210_0:procVolatileAPI()
				end
			else
				local var_210_5 = arg_210_0.vars.wait_queue[#arg_210_0.vars.wait_queue]
				
				table.remove(arg_210_0.vars.wait_queue)
				arg_210_0:sendMoveTo(var_210_5)
			end
		end
	end
	
	if not arg_210_0.vars.proc_battle_syncing and LotaBattleReady:isActive() and LotaBattleReady:isCoop() and not LotaBattleReady:isOpenHeroInfo() and not LotaBattleReady:isOpenRegistration() and arg_210_0.vars.last_update_sync_tm and arg_210_0.vars.last_update_recv_tm then
		local var_210_6 = os.time()
		local var_210_7 = 5
		local var_210_8 = var_210_6 - SceneManager:getRunningScene():getTouchEventTime()
		
		if var_210_7 < var_210_6 - arg_210_0.vars.last_update_recv_tm and not (var_210_8 > 30) then
			local var_210_9 = LotaBattleReady:getTileId()
			
			arg_210_0:sendQuery("lota_battle_sync", {
				tile_id = var_210_9,
				battle_id = LotaUtil:getBattleId(var_210_9)
			})
		end
	end
end

function LotaNetworkSystem.updateLastSyncResponseTime(arg_211_0)
	arg_211_0.vars.last_update_sync_tm = uitick()
	arg_211_0.vars.last_update_recv_tm = os.time()
	arg_211_0.vars.proc_battle_syncing = false
end

function LotaNetworkSystem.updateExpLastTm(arg_212_0, arg_212_1)
	arg_212_0.vars.last_update_exp_tm = tonumber(arg_212_1)
end

function LotaNetworkSystem.updateLastTm(arg_213_0, arg_213_1)
	arg_213_0.vars.last_update_tm = tonumber(arg_213_1)
	
	if not arg_213_0.vars.last_update_tm then
		arg_213_0.vars.last_update_tm = os.time() * 10000
	end
	
	arg_213_0.vars.proc_move_syncing = false
	arg_213_0.vars.last_move_sync_recv_tm = os.time()
end

function LotaNetworkSystem.debug_getMockingResponse(arg_214_0, arg_214_1, arg_214_2)
	if LotaNetworkSystem.MockupServer[arg_214_1] then
		arg_214_2 = LotaNetworkSystem.MockupServer[arg_214_1](LotaNetworkSystem.MockupServer, arg_214_2)
		
		return arg_214_2
	end
	
	return arg_214_2
end

function LotaNetworkSystem.commonProcBeforeQueryProc(arg_215_0, arg_215_1)
	if arg_215_1.object_info then
		local var_215_0 = LotaObjectSystem:getObject(tostring(arg_215_1.object_info.tile_id))
		
		if not var_215_0 then
			if LotaObjectSystem.vars then
				print("[ERROR] OBJECT SYSTEM EXIST BUT NOT HAVE OBJECT. INFO WAS NOT NIL. CHK.")
			end
		else
			var_215_0:updateInfo(arg_215_1.object_info)
		end
	end
	
	if arg_215_1.job_levels then
		LotaUserData:updateJobLevels(arg_215_1.job_levels)
	end
end

function LotaNetworkSystem.commonProcAfterQueryProc(arg_216_0, arg_216_1)
	if arg_216_1 and arg_216_1.user_default and LotaSystem:isActive() and LotaUserData:isActive() and arg_216_0:isIgnoreAllContentsQueryAndReceive() then
		local var_216_0 = arg_216_1.user_default.user_floor
		local var_216_1 = LotaUserData:getFloor()
		
		if tostring(var_216_0) ~= tostring(var_216_1) then
			return 
		end
	end
	
	if arg_216_1.action_point then
		LotaUserData:updateActionPoint(arg_216_1.action_point)
		TopBarNew:topbarUpdate(true)
	end
	
	if arg_216_1.ping_status then
		LotaPingSystem:updatePingStatus(arg_216_1.ping_status)
	end
	
	if arg_216_1.artifact_effects and not table.empty(arg_216_1.artifact_effects) then
		local var_216_2 = false
		local var_216_3
		local var_216_4 = false
		
		if arg_216_1.object_info then
			local var_216_5 = arg_216_1.object_info.object
			local var_216_6 = DB("clan_heritage_object_data", var_216_5, "type_2")
			
			var_216_4 = ({
				treasure_box = true,
				production = true,
				sanctuary = true
			})[var_216_6]
		end
		
		local var_216_7 = var_216_4
		local var_216_8 = false
		local var_216_9 = {
			exp = 0,
			items = {}
		}
		
		for iter_216_0, iter_216_1 in pairs(arg_216_1.artifact_effects) do
			if iter_216_0 == "move_tile_add_exp" then
				LotaMovableSystem:addEffectAfterMoveEnd(iter_216_0, iter_216_1)
				
				var_216_9.exp = var_216_9.exp + iter_216_1
				var_216_7 = true
			elseif iter_216_0 == "use_treasure_box_add_item" then
				table.insert(var_216_9.items, iter_216_1)
				
				var_216_8 = true
			elseif iter_216_0 == "object_use_add_exp" then
				var_216_9.exp = var_216_9.exp + iter_216_1
				var_216_8 = true
			elseif iter_216_0 == "object_use_exp" then
				var_216_9.exp = var_216_9.exp + iter_216_1
				var_216_8 = true
			end
		end
		
		if not var_216_7 then
			if var_216_8 then
				local var_216_10 = {
					additional_exp = var_216_9.exp
				}
				
				if LotaMovableSystem:getPlayerMovable() then
					LotaMovableRenderer:addEffectToWaitQueue(LotaMovableSystem:getPlayerMovable(), var_216_10)
				end
			end
			
			if false then
			end
		elseif var_216_4 then
			LotaObjectSystem:addLastArtifactEffects(arg_216_1.object_info.id, var_216_9)
		end
		
		LotaUserData:useArtifactEffects(arg_216_1.artifact_effects)
		LotaUIMainLayer:updateUI()
	end
	
	LotaMovableRenderer:procEffectsOnWaitQueue()
	LotaUserData:clearRolePointDiffValue()
end

function LotaNetworkSystem.isFloorUncondAPI(arg_217_0, arg_217_1)
	local var_217_0 = {
		"lota_get_member"
	}
	
	return table.isInclude(var_217_0, arg_217_1 or "")
end

function LotaNetworkSystem.isUncondAPI(arg_218_0, arg_218_1)
	local var_218_0 = {
		"lota_get_member"
	}
	
	return table.isInclude(var_218_0, arg_218_1 or "")
end

function LotaNetworkSystem.getVolatileParams(arg_219_0, arg_219_1, arg_219_2)
	return ({
		lota_update_ping = {
			floor = LotaUserData:getFloor()
		},
		lota_update_object = {
			floor = LotaUserData:getFloor(),
			exp_tm = arg_219_0.vars.last_update_exp_tm,
			battle_id = arg_219_2 and arg_219_2.battle_id,
			req_box = arg_219_2 and arg_219_2.dead
		},
		lota_get_member = {
			targets = json.encode(arg_219_2 and arg_219_2.targets or {})
		},
		lota_update_room = {
			battle_id = arg_219_2 and arg_219_2.battle_id,
			req_box = arg_219_2 and arg_219_2.dead
		}
	})[arg_219_1] or {}
end

function LotaNetworkSystem.clearMoveSyncRelated(arg_220_0)
	if not arg_220_0.vars then
		return 
	end
	
	if not arg_220_0.vars.volatile_api_send_tm then
		arg_220_0.vars.volatile_api_send_tm = {}
	end
	
	if not arg_220_0.vars.volatile_api_list then
		arg_220_0.vars.volatile_api_list = {}
	end
	
	local var_220_0 = {
		"lota_get_member"
	}
	local var_220_1 = table.clone(arg_220_0.vars.volatile_api_list)
	
	for iter_220_0, iter_220_1 in pairs(var_220_1) do
		if not table.isInclude(var_220_0, iter_220_0) then
			arg_220_0.vars.volatile_api_send_tm[iter_220_0] = systick()
			arg_220_0.vars.volatile_api_list[iter_220_0] = {}
		end
	end
end

function LotaNetworkSystem.procVolatileAPI(arg_221_0)
	if not arg_221_0.vars then
		return 
	end
	
	if not arg_221_0.vars.volatile_api_send_tm then
		arg_221_0.vars.volatile_api_send_tm = {}
	end
	
	if not arg_221_0.vars.volatile_api_list then
		arg_221_0.vars.volatile_api_list = {}
	end
	
	if arg_221_0:isProcMoveSyncing() then
		return 
	end
	
	if NetWaiting:isWaiting() then
		return 
	end
	
	if table.empty(arg_221_0.vars.volatile_api_list) then
		return 
	end
	
	if not arg_221_0:isMoveSyncAvailable() then
		return 
	end
	
	if arg_221_0:isCurrentSleepMode() then
		return 
	end
	
	if SceneManager:getCurrentSceneName() ~= "lota" then
		arg_221_0.vars.volatile_api_list = {}
	end
	
	local var_221_0 = tonumber(getenv("allow.lota_minimum_sync_delay") or 500)
	local var_221_1 = {}
	local var_221_2 = arg_221_0.vars.volatile_api_list.lota_get_member
	
	if var_221_2 and table.count(var_221_2) > 0 then
		local var_221_3 = arg_221_0.vars.volatile_api_send_tm.lota_get_member or 0
		
		if var_221_0 >= systick() - var_221_3 then
			return 
		end
		
		local var_221_4 = {}
		local var_221_5 = {}
		
		for iter_221_0, iter_221_1 in pairs(var_221_2) do
			local var_221_6 = iter_221_1.targets
			
			table.add(var_221_5, var_221_6)
		end
		
		for iter_221_2, iter_221_3 in pairs(var_221_5) do
			if not table.isInclude(var_221_4, iter_221_3) then
				table.insert(var_221_4, iter_221_3)
			end
		end
		
		var_221_1.targets = var_221_4
		
		arg_221_0:sendQuery("lota_get_member", arg_221_0:getVolatileParams("lota_get_member", var_221_1))
		
		arg_221_0.vars.volatile_api_send_tm.lota_get_member = systick()
		arg_221_0.vars.volatile_api_list.lota_get_member = {}
		
		return 
	end
	
	local var_221_7 = {}
	local var_221_8
	
	for iter_221_4, iter_221_5 in pairs(arg_221_0.vars.volatile_api_list) do
		if table.count(iter_221_5) > 0 then
			arg_221_0.vars.volatile_api_send_tm[iter_221_4] = arg_221_0.vars.volatile_api_send_tm[iter_221_4] or systick()
			
			local var_221_9 = arg_221_0.vars.volatile_api_send_tm[iter_221_4]
			
			if not var_221_8 or var_221_9 < var_221_8 then
				var_221_8 = var_221_9
			end
			
			table.insert(var_221_7, {
				iter_221_4,
				iter_221_5
			})
		end
	end
	
	local var_221_10 = table.count(var_221_7)
	
	if var_221_10 > 0 then
		if var_221_10 == 1 then
			local var_221_11 = var_221_7[1]
			local var_221_12 = arg_221_0.vars.volatile_api_send_tm[var_221_11[1]] or 0
			
			if var_221_0 >= systick() - var_221_12 then
				return 
			end
			
			arg_221_0:sendQuery(var_221_11[1], arg_221_0:getVolatileParams(var_221_11[1], var_221_11[2]))
		else
			if var_221_0 >= systick() - var_221_8 then
				return 
			end
			
			arg_221_0:sendQuery("lota_move_sync")
		end
		
		arg_221_0:clearMoveSyncRelated()
	end
end

function LotaNetworkSystem.receiveVolatileMsg(arg_222_0, arg_222_1)
	if not arg_222_0.vars then
		return 
	end
	
	if not arg_222_0.vars.volatile_api_send_tm then
		arg_222_0.vars.volatile_api_send_tm = {}
	end
	
	if not arg_222_0.vars.volatile_api_list then
		arg_222_0.vars.volatile_api_list = {}
	end
	
	local var_222_0 = arg_222_1.type
	local var_222_1 = SceneManager:getCurrentSceneName()
	local var_222_2 = arg_222_0:isMoveSyncAvailable()
	local var_222_3 = arg_222_0:isCurrentSleepMode()
	local var_222_4 = arg_222_1.opts or {}
	local var_222_5 = arg_222_1.user and arg_222_1.user.id == AccountData.id
	
	if var_222_1 == "lota" then
		if var_222_5 then
			return 
		end
		
		local var_222_6 = tonumber(arg_222_1.floor)
		
		if var_222_4.battle_id or var_222_4.dead then
			var_222_6 = nil
		end
		
		if var_222_6 and var_222_6 ~= LotaUserData:getFloor() and not arg_222_0:isFloorUncondAPI(arg_222_1.api) then
			return 
		end
		
		if var_222_2 and not var_222_3 or arg_222_0:isUncondAPI(arg_222_1.api) then
			if var_222_0 == "heritage_need_update" then
				local var_222_7 = arg_222_1.user
				
				if var_222_7 then
					var_222_4.targets = {
						var_222_7.id
					}
				end
				
				local var_222_8 = arg_222_0.vars.volatile_api_send_tm[arg_222_1.api] or 0
				local var_222_9 = tonumber(getenv("allow.lota_minimum_sync_delay") or 500)
				
				if not NetWaiting:isWaiting() and var_222_9 < systick() - var_222_8 then
					arg_222_0:sendQuery(arg_222_1.api, arg_222_0:getVolatileParams(arg_222_1.api, var_222_4))
					
					arg_222_0.vars.volatile_api_send_tm[arg_222_1.api] = systick()
				else
					local var_222_10 = arg_222_0.vars.volatile_api_list[arg_222_1.api] or {}
					
					table.insert(var_222_10, var_222_4)
					
					arg_222_0.vars.volatile_api_list[arg_222_1.api] = var_222_10
				end
			elseif var_222_0 == "heritage_move" then
				local var_222_11 = merge_member_move_data({
					arg_222_1.move_data
				})
				
				for iter_222_0, iter_222_1 in pairs(var_222_11) do
					LotaSystem:procMovePath(iter_222_1)
				end
			end
		else
			arg_222_0.vars.last_move_sync_recv_tm = 0
		end
	elseif var_222_1 == "battle" and arg_222_1.api == "lota_battle_sync" then
	end
end

function LotaNetworkSystem.receiveQuery(arg_223_0, arg_223_1, arg_223_2)
	if arg_223_0._ignore_all_contents_query_and_receive and not arg_223_0:checkAcceptQueryAndReceive(arg_223_1) then
		return 
	end
	
	if not arg_223_0.QueryProc[arg_223_1] then
		error("NOT EXIST QUERY PROC FOR " .. arg_223_1)
		
		return 
	end
	
	if DEBUG.ROTA_NETWORK_MOCKING or not MsgHandler[arg_223_1] then
		arg_223_2 = arg_223_0:debug_getMockingResponse(arg_223_1, arg_223_2)
	end
	
	if arg_223_2.content_switch then
		ContentDisable:resetContentSwitchMain(arg_223_2.content_switch)
		
		if ContentDisable:byAlias("clan_heritage") then
			Dialog:msgBox(T("content_disable"), {
				handler = function()
					SceneManager:nextScene("lobby")
				end
			})
			
			return 
		end
	end
	
	if SceneManager:getCurrentSceneName() == "lota_lobby" and arg_223_1 == "lota_get_reward_list" then
		arg_223_0.QueryProc[arg_223_1](arg_223_2)
		
		return 
	end
	
	arg_223_0:commonProcBeforeQueryProc(arg_223_2)
	arg_223_0.QueryProc[arg_223_1](arg_223_2)
	arg_223_0:commonProcAfterQueryProc(arg_223_2)
end

function LotaNetworkSystem.debug_pushQueue(arg_225_0, arg_225_1, arg_225_2)
	if not arg_225_0.vars._debug_queue[arg_225_1] and arg_225_1 == "lota_move_sync" then
		arg_225_0.vars._debug_queue[arg_225_1] = {
			move_list = {}
		}
	end
	
	if arg_225_1 == "lota_move_sync" then
		table.insert(arg_225_0.vars._debug_queue[arg_225_1].move_list, arg_225_2)
	end
end

function LotaNetworkSystem.updateDebugInfos(arg_226_0, arg_226_1)
	if arg_226_1._debug_battle_infos then
		LotaSystem:updateObjectRewardState(arg_226_1._debug_battle_infos)
	end
	
	if arg_226_1._debug_object_infos then
		LotaSystem:updateObjectStatus(arg_226_1._debug_object_infos)
	end
	
	if arg_226_1._debug_elite_dead_infos then
		LotaSystem:updateBossDeadStatus(arg_226_1._debug_elite_dead_infos)
	end
	
	if arg_226_1._debug_keeper_dead_data then
		LotaClanInfo:updateKeeperDeadCount(arg_226_1._debug_keeper_dead_data)
		LotaSystem:procBossAppearEffect()
	end
	
	if arg_226_1._debug_boss_dead_data then
		LotaClanInfo:updateBossDeadCount(arg_226_1._debug_boss_dead_data)
		LotaSystem:procBossDeadEffect()
	end
end

function LotaNetworkSystem.stopSync(arg_227_0)
	arg_227_0.vars.stop_move_sync = true
end

function LotaNetworkSystem.resumeSync(arg_228_0)
	arg_228_0.vars.stop_move_sync = false
end

function LotaNetworkSystem._cheatSetFixEventId(arg_229_0, arg_229_1)
	arg_229_0.vars._fix_event_id = arg_229_1
end

function LotaNetworkSystem._cheatGetFixEventId(arg_230_0)
	return arg_230_0.vars._fix_event_id
end

function LotaNetworkSystem.isIgnoreAllContentsQueryAndReceive(arg_231_0)
	return arg_231_0._ignore_all_contents_query_and_receive
end

function LotaNetworkSystem.ignoreAllContentsQueryAndReceive(arg_232_0)
	arg_232_0._ignore_all_contents_query_and_receive = true
end

function LotaNetworkSystem.acceptAllContentsQueryAndReceive(arg_233_0)
	arg_233_0._ignore_all_contents_query_and_receive = false
end

function LotaNetworkSystem.checkAcceptQueryAndReceive(arg_234_0, arg_234_1)
	if not arg_234_0._not_ignore_query_filter then
		arg_234_0._not_ignore_query_filter = {
			lota_enter = true,
			lota_ranking_board = true,
			lota_ranking_board_detail = true,
			lota_lobby = true,
			lota_shop = true
		}
	end
	
	return arg_234_0._not_ignore_query_filter[arg_234_1]
end

function LotaNetworkSystem.sendQuery(arg_235_0, arg_235_1, arg_235_2)
	if arg_235_0._ignore_all_contents_query_and_receive and not arg_235_0:checkAcceptQueryAndReceive(arg_235_1) then
		return 
	end
	
	if arg_235_1 == "lota_move_sync" then
		if arg_235_0.vars.stop_move_sync then
			return 
		end
		
		arg_235_2 = arg_235_2 or {}
		arg_235_2.last_update_tm = arg_235_0.vars.last_update_tm
		arg_235_2.exp_tm = arg_235_0.vars.last_update_exp_tm
		arg_235_0.vars.proc_move_syncing = true
		
		arg_235_0:clearMoveSyncRelated()
	end
	
	if not PRODUCTION_MODE and arg_235_1 == "lota_interaction_object" and arg_235_0:_cheatGetFixEventId() ~= nil then
		arg_235_2 = arg_235_2 or {}
		arg_235_2._event_id = arg_235_0:_cheatGetFixEventId()
	end
	
	if arg_235_1 == "lota_battle_sync" then
		arg_235_0.vars.proc_battle_syncing = true
	end
	
	if arg_235_1 == "lota_start_battle" or arg_235_1 == "lota_start_coop_battle" then
		query(arg_235_1, arg_235_2)
		
		return true
	end
	
	if DEBUG.ROTA_NETWORK_MOCKING or not MsgHandler[arg_235_1] then
		arg_235_0:receiveQuery(arg_235_1, arg_235_2)
	else
		query(arg_235_1, arg_235_2)
	end
	
	return true
end

function LotaNetworkSystem.close(arg_236_0)
	if arg_236_0.vars then
		arg_236_0.vars = nil
	end
end
