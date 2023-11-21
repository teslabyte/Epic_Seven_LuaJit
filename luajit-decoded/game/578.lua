ContentDisable = ContentDisable or {}

function ContentDisable.init(arg_1_0)
	arg_1_0:initAliasData()
	SceneManager:setCanNext(function(arg_2_0)
		local var_2_0 = not ContentDisable:byAlias(ContentDisable:findAliasByScene(arg_2_0))
		
		if not var_2_0 then
			balloon_message(T("content_disable"))
		end
		
		return var_2_0
	end)
end

function ContentDisable.initAliasData(arg_3_0)
	arg_3_0.alias_data = {
		{
			alias = "adventure",
			scenes = {
				"worldmap_scene"
			},
			buttons = {
				"btn_map",
				"btn_scene_worldmap_scene"
			}
		},
		{
			alias = "market",
			scenes = {
				"shop"
			},
			buttons = {
				"btn_shop"
			}
		},
		{
			alias = "mail",
			scenes = {},
			buttons = {
				"btn_top_mail"
			}
		},
		{
			alias = "hero",
			scenes = {
				"unit_ui"
			},
			buttons = {
				"btn_hero",
				"btn_unit_detail",
				"btn_unit_team",
				"btn_unit_skill"
			}
		},
		{
			alias = "battle",
			scenes = {
				"DungeonList"
			},
			buttons = {
				"btn_battle",
				"btn_scene_DungeonList"
			}
		},
		{
			alias = "achievement",
			scenes = {
				"achievement"
			},
			buttons = {
				"btn_achieve",
				"btn_scene_achievement"
			}
		},
		{
			alias = "gotcha",
			scenes = {
				"gacha_unit"
			},
			buttons = {
				"btn_gacha",
				"btn_scene_gacha_unit"
			}
		},
		{
			alias = "friend",
			scenes = {},
			buttons = {
				"btn_friends"
			}
		},
		{
			alias = "collection",
			scenes = {
				"collection"
			},
			buttons = {
				"btn_dict",
				"btn_scene_collection"
			}
		},
		{
			alias = "clan",
			scenes = {
				"clan"
			},
			buttons = {
				"btn_clan",
				"btn_scene_clan"
			}
		},
		{
			alias = "subtask",
			scenes = {
				"sanctuary"
			},
			buttons = {
				"btn_sanctuary",
				"btn_scene_sanctuary"
			}
		},
		{
			alias = "heal",
			scenes = {},
			buttons = {
				"btn_heal"
			}
		},
		{
			alias = "pvp",
			scenes = {
				"pvp"
			},
			buttons = {
				"btn_gladiator",
				"btn_scene_gladiator"
			}
		},
		{
			alias = "google_pgs",
			scenes = {},
			buttons = {}
		},
		{
			alias = "package_purchase",
			scenes = {},
			buttons = {}
		},
		{
			alias = "stove",
			scenes = {},
			buttons = {}
		},
		{
			alias = "game_reset",
			scenes = {},
			buttons = {
				"btn_normal_unregister"
			}
		},
		{
			alias = "instant_debug",
			scenes = {},
			buttons = {}
		},
		{
			alias = "exception_report",
			scenes = {},
			buttons = {}
		},
		{
			alias = "chat",
			scenes = {},
			buttons = {}
		},
		{
			alias = "battle_speed",
			scenes = {},
			buttons = {}
		},
		{
			alias = "offer_wall",
			scenes = {},
			buttons = {}
		},
		{
			alias = "pet",
			scenes = {
				"pet_ui"
			},
			buttons = {
				"btn_pet"
			}
		},
		{
			alias = "clan_war",
			scenes = {
				"clan"
			},
			buttons = {
				"btn_clan_war"
			}
		},
		{
			alias = "market_crystal",
			scenes = {},
			buttons = {
				"crystal"
			}
		},
		{
			alias = "market_promotion",
			scenes = {},
			buttons = {
				"promotion"
			}
		},
		{
			alias = "market_currency",
			scenes = {},
			buttons = {
				"currency"
			}
		},
		{
			alias = "market_skin",
			scenes = {},
			buttons = {
				"skin"
			}
		},
		{
			alias = "market_herocoin",
			scenes = {},
			buttons = {
				"herocoin"
			}
		},
		{
			alias = "market_powder",
			scenes = {},
			buttons = {
				"powder"
			}
		},
		{
			alias = "market_friendship",
			scenes = {},
			buttons = {
				"friendship"
			}
		},
		{
			alias = "market_dungeon",
			scenes = {},
			buttons = {
				"dungeon"
			}
		},
		{
			alias = "market_pvp",
			scenes = {},
			buttons = {
				"pvp"
			}
		},
		{
			alias = "market_pet",
			scenes = {},
			buttons = {
				"pet"
			}
		},
		{
			alias = "market_mooncoin",
			scenes = {},
			buttons = {
				"mooncoin"
			}
		},
		{
			alias = "market_rarecoin",
			scenes = {},
			buttons = {
				"rarecoin"
			}
		},
		{
			alias = "market_miragecoin",
			scenes = {},
			buttons = {
				"miragecoin"
			}
		},
		{
			alias = "market_moon_miragecoin",
			scenes = {},
			buttons = {
				"moon_miragecoin"
			}
		},
		{
			alias = "clan_market_member",
			scenes = {},
			buttons = {
				"clanshop"
			}
		},
		{
			alias = "clan_market_master",
			scenes = {},
			buttons = {
				"clanmastershop"
			}
		},
		{
			alias = "world_arena",
			scenes = {}
		},
		{
			alias = "waitingroom",
			scenes = {
				"waitingroom"
			},
			buttons = {
				"btn_storage"
			}
		},
		{
			alias = "expedition",
			scenes = {}
		},
		{
			alias = "amazon_prime_btn",
			scenes = {},
			buttons = {
				"btn_promotion"
			}
		},
		{
			alias = "eq_arti_statistics",
			scenes = {},
			buttons = {
				"btn_equip_arti"
			}
		},
		{
			alias = "event_user_custom",
			scenes = {}
		},
		{
			alias = "amazon_prime_aos_btn",
			scenes = {},
			buttons = {
				"btn_promotion"
			}
		},
		{
			alias = "amazon_prime_ios_btn",
			scenes = {},
			buttons = {
				"btn_promotion"
			}
		},
		{
			alias = "event_ui",
			scenes = {},
			buttons = {
				"btn_Integrate"
			}
		},
		{
			alias = "clan_promote",
			scenes = {},
			buttons = {
				"btn_knights_recruitment"
			}
		}
	}
end

function ContentDisable.resetContentSwitchMain(arg_4_0, arg_4_1)
	ContentDisable:init()
	
	arg_4_0.content_disable_main = {}
	
	for iter_4_0, iter_4_1 in pairs(arg_4_1 or {}) do
		table.insert(arg_4_0.content_disable_main, {
			name = iter_4_1.content_name,
			active = iter_4_1.active,
			tag1 = iter_4_1.content_tag1,
			tag2 = iter_4_1.content_tag2,
			tag3 = iter_4_1.content_tag3,
			start_time = iter_4_1.start_time,
			end_time = iter_4_1.end_time
		})
	end
end

function ContentDisable.resetContentSwitchRta(arg_5_0, arg_5_1)
	arg_5_0.content_disable_rta = {}
	
	for iter_5_0, iter_5_1 in pairs(arg_5_1 or {}) do
		table.insert(arg_5_0.content_disable_rta, {
			name = iter_5_1.content_name,
			active = iter_5_1.active,
			tag1 = iter_5_1.content_tag1,
			tag2 = iter_5_1.content_tag2,
			tag3 = iter_5_1.content_tag3,
			start_time = iter_5_1.start_time,
			end_time = iter_5_1.end_time
		})
	end
end

function ContentDisable.findAliasByScene(arg_6_0, arg_6_1)
	local var_6_0 = ""
	
	for iter_6_0, iter_6_1 in pairs(arg_6_0.alias_data or {}) do
		for iter_6_2, iter_6_3 in pairs(iter_6_1.scenes or {}) do
			if iter_6_3 == arg_6_1 then
				var_6_0 = iter_6_1.alias
				
				break
			end
		end
		
		if var_6_0 ~= "" then
			break
		end
	end
	
	return var_6_0
end

function ContentDisable.findAliasByButton(arg_7_0, arg_7_1)
	local var_7_0 = ""
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0.alias_data or {}) do
		for iter_7_2, iter_7_3 in pairs(iter_7_1.buttons or {}) do
			if iter_7_3 == arg_7_1 then
				var_7_0 = iter_7_1.alias
				
				break
			end
		end
		
		if var_7_0 ~= "" then
			break
		end
	end
	
	return var_7_0
end

function ContentDisable.byAlias(arg_8_0, arg_8_1)
	if arg_8_1 == nil or arg_8_1 == "" then
		return false
	end
	
	local var_8_0 = os.time()
	
	local function var_8_1(arg_9_0)
		for iter_9_0, iter_9_1 in pairs(arg_9_0 or {}) do
			if iter_9_1.name == arg_8_1 then
				if iter_9_1.active == 0 then
					table.print(arg_9_0)
					
					return true
				end
				
				if iter_9_1.start_time and iter_9_1.end_time and var_8_0 >= iter_9_1.start_time and var_8_0 < iter_9_1.end_time then
					return true
				end
				
				return false
			end
		end
		
		return false
	end
	
	if var_8_1(arg_8_0.content_disable_main) then
		return true
	end
	
	if var_8_1(arg_8_0.content_disable_rta) then
		return true
	end
	
	return false
end

function ContentDisable.byButton(arg_10_0, arg_10_1)
	if arg_10_1 == nil then
		return false
	end
	
	return arg_10_0:byAlias(arg_10_0:findAliasByButton(arg_10_1))
end

function ContentDisable.checkDisableUnitByAlias(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	if not arg_11_0:byAlias(arg_11_1) then
		return false
	end
	
	local var_11_0 = not arg_11_3 and arg_11_0.content_disable_main or arg_11_0.content_disable_rta
	
	for iter_11_0, iter_11_1 in pairs(var_11_0 or {}) do
		if iter_11_1.name == arg_11_1 and iter_11_1.tag2 ~= nil and iter_11_1.tag2 ~= "" then
			local var_11_1 = string.split(iter_11_1.tag2, ",")
			
			for iter_11_2, iter_11_3 in pairs(var_11_1 or {}) do
				if iter_11_3 == arg_11_2 then
					return true
				end
			end
		end
	end
	
	return false
end
