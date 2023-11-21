TOWN_PLACE_CODE = {
	alchemy_center = 3,
	village = 11,
	artifact = 6,
	coincil = 10,
	collection = 1,
	maincastle = 9,
	executive = 5,
	colosseum = 4,
	pub = 7,
	tacticslab = 8,
	community = 2
}
ABUSE_FILTER = {
	WORLD_NAME = 4,
	NAME = 1,
	CHAT = 2,
	ALL = 255
}
META_STATIC_VARIABLE, GAME_STATIC_VARIABLE, META_CONTENT_VARIABLE, GAME_CONTENT_VARIABLE = {}, {}, {}, {}

function META_STATIC_VARIABLE.getCategory(arg_1_0, arg_1_1)
	if arg_1_1 == "all" then
		arg_1_1 = nil
	end
	
	local var_1_0 = {}
	
	for iter_1_0, iter_1_1 in pairs(META_STATIC_VARIABLE) do
		if type(iter_1_1) ~= "function" and (not arg_1_1 or iter_1_1.category == arg_1_1) then
			var_1_0[iter_1_0] = iter_1_1.value
		end
	end
	
	return var_1_0
end

setmetatable(GAME_STATIC_VARIABLE, {
	__index = function(arg_2_0, arg_2_1)
		return (META_STATIC_VARIABLE[arg_2_1] or {}).value
	end,
	__call = function(arg_3_0, arg_3_1)
		return META_STATIC_VARIABLE:getCategory(arg_3_1)
	end
})
setmetatable(GAME_CONTENT_VARIABLE, {
	__index = function(arg_4_0, arg_4_1)
		return (META_CONTENT_VARIABLE[arg_4_1] or {}).value
	end
})

function init_game_static_variable()
	local function var_5_0(arg_6_0)
		if arg_6_0 == "n" or arg_6_0 == "false" then
			return false
		end
		
		if arg_6_0 == "y" or arg_6_0 == "true" then
			return true
		end
		
		return arg_6_0
	end
	
	for iter_5_0 = 1, 999 do
		local var_5_1, var_5_2, var_5_3 = DBN("minimal_system_static", iter_5_0, {
			"type",
			"key",
			"client_value"
		})
		
		if not var_5_2 then
			break
		end
		
		META_STATIC_VARIABLE[var_5_2] = {
			category = var_5_1,
			value = var_5_0(var_5_3)
		}
	end
end

function _showTextDebugMode(arg_7_0)
	font = font or "font/daum.ttf"
	
	local var_7_0 = ccui.Text:create()
	
	var_7_0:setPosition(0, DESIGN_HEIGHT - 10)
	var_7_0:setAnchorPoint(0, 1)
	var_7_0:setFontName("font/daum.ttf")
	var_7_0:setString(arg_7_0)
	var_7_0:setFontSize(22)
	var_7_0:setTextColor(cc.c3b(255, 0, 0))
	var_7_0:setColor(cc.c3b(255, 0, 0))
	var_7_0:setGlobalZOrder(1000)
	cc.Director:getInstance():getRunningScene():addChild(var_7_0)
end

function preload_db(arg_8_0)
	print("preload_db !!")
	load_env("version.ini")
	load_db("minimal_system_static", "db/minimal_system_static.db")
	
	if not PRODUCTION_MODE then
		local var_8_0 = cc.FileUtils:getInstance():getWritablePath() .. "/qares"
		
		cc.FileUtils:getInstance():addSearchPath(var_8_0, true)
		cc.FileUtils:getInstance():addLocaleFilter("qatext", "{name}_{loc}{ext}")
	end
	
	local var_8_1
	
	if not PRODUCTION_MODE and cc.FileUtils:getInstance():isFileExist("qatext/text.db") then
		load_db("text", "qatext/text.db")
		
		var_8_1 = "TEXT"
	else
		load_db("text", "text/text.db")
	end
	
	if var_8_1 then
		_showTextDebugMode(var_8_1)
	end
	
	init_game_static_variable()
end

function load_title_db()
	load_db("title_manager", "title/title_manager.db")
end

function reload_db(arg_10_0)
	print("reload_db")
	
	local var_10_0 = Account:isAlterDbRequired()
	
	print("alter_db_content : ", var_10_0)
	print("alter_db_only : ", arg_10_0)
	
	if arg_10_0 and Account:isAlterDbLoaded() then
		return 
	end
	
	print("[reload_db - DEBUGING TESTING] ", "patch.use: " .. getenv("patch.use", "false"), "patch.enc.enable: " .. getenv("patch.enc.enable", "false"))
	print("patch status : ", getenv("patch.status", ""))
	print("is_enable_minimal : ", is_enable_minimal())
	preload_db(var_10_0)
	
	if var_10_0 then
		Account:setAlterDbLoaded()
	end
	
	if false then
	end
	
	if arg_10_0 and Account:isAlterDbLoaded() then
		return 
	end
	
	verify_yuna_db_set()
	load_db("clan_heritage_tile_texture", "db/clan_heritage_tile_texture.db")
	load_db("clan_heritage_season", "db/clan_heritage_season.db")
	load_db("clan_heritage_config", "db/clan_heritage_config.db")
	load_db("clan_heritage_rank_data", "db/clan_heritage_rank_data.db")
	load_db("clan_heritage_role_stat_data", "db/clan_heritage_role_stat_data.db")
	load_db("clan_heritage_object_data", "db/clan_heritage_object_data.db")
	load_db("clan_heritage_world", "db/clan_heritage_world.db")
	load_db("clan_legacy_skill_data", "db/clan_legacy_skill_data.db")
	load_db("clan_legacy_skill_rate", "db/clan_legacy_skill_rate.db")
	load_db("clan_heritage_object_icon", "db/clan_heritage_object_icon.db")
	load_db("clan_heritage_reward_data", "db/clan_heritage_reward_data.db")
	load_db("clan_heritage_quest_summary", "db/clan_heritage_quest_summary.db")
	load_db("clan_heritage_event_group", "db/clan_heritage_event_group.db")
	load_db("clan_heritage_event_data", "db/clan_heritage_event_data.db")
	load_db("clan_heritage_event_select", "db/clan_heritage_event_select.db")
	load_db("clan_heritage_pre_reward_data", "db/clan_heritage_pre_reward_data.db")
	load_db("clan_heritage_equip_stat_data", "db/clan_heritage_equip_stat_data.db")
	load_db("clan_heritage_role_stat_data", "db/clan_heritage_role_stat_data.db")
	
	for iter_10_0 = 1, 999 do
		local var_10_1 = DBN("clan_heritage_world", iter_10_0, "map_id")
		
		if not var_10_1 then
			break
		end
		
		load_db(var_10_1, "db/" .. var_10_1 .. ".db")
	end
	
	load_db("tile_sub", "db/tile_sub.db")
	load_db("tile_sub_action", "db/tile_sub_action.db")
	load_db("tile_sub_config", "db/tile_sub_config.db")
	load_db("tile_sub_event", "db/tile_sub_event.db")
	load_db("tile_sub_mission", "db/tile_sub_mission.db")
	load_db("tile_sub_npc_text", "db/tile_sub_npc_text.db")
	load_db("tile_sub_object_data", "db/tile_sub_object_data.db")
	load_db("tile_sub_object_icon", "db/tile_sub_object_icon.db")
	load_db("tile_sub_preset", "db/tile_sub_preset.db")
	load_db("tile_sub_speech", "db/tile_sub_speech.db")
	load_db("tile_sub_tile_texture", "db/tile_sub_tile_texture.db")
	
	for iter_10_1 = 1, 999 do
		local var_10_2 = DBN("tile_sub", iter_10_1, "map_id")
		
		if not var_10_2 then
			break
		end
		
		load_db(var_10_2, "db/" .. var_10_2 .. ".db")
	end
	
	load_db("character", "db/character.db")
	load_db("character_reference", "db/character_reference.db")
	load_db("character_scale", "db/character_scale.db")
	load_db("character_guide", "db/character_guide.db")
	load_db("character_voice", "db/character_voice.db")
	load_db("character_extra_sound", "db/character_extra_sound.db")
	load_db("character_model_combine", "db/character_model_combine.db")
	load_db("char_intro", "db/char_intro.db")
	load_db("char_promotion_data", "db/char_promotion_data.db")
	load_db("char_promotion_combine", "db/char_promotion_combine.db")
	load_db("char_promotion_sell", "db/char_promotion_sell.db")
	load_db("char_memory_imprint_reward", "db/char_memory_imprint_reward.db")
	load_db("char_intro_gacha", "db/char_intro_gacha.db")
	load_db("exp", "db/exp.db")
	load_db("background", "db/background.db")
	load_db("background_flip", "db/background_flip.db")
	load_db("musicplayer_album", "db/musicplayer_album.db")
	load_db("musicplayer_song", "db/musicplayer_song.db")
	load_db("musicplayer_lock", "db/musicplayer_lock.db")
	load_db("character_ai", "db/character_ai.db")
	load_db("gacha_ui", "db/gacha_ui.db")
	load_db("gacha_ui_list", "db/gacha_ui_list.db")
	load_db("gacha_select_condition", "db/gacha_select_condition.db")
	load_db("gacha_story_ui", "db/gacha_story_ui.db")
	load_db("gacha_substory_select_list", "db/gacha_substory_select_list.db")
	load_db("gacha_intro_info", "db/gacha_intro_info.db")
	load_db("skill", "db/skill.db")
	load_db("skill_effect", "db/skill_effect.db")
	load_db("skill_ai", "db/skill_ai.db")
	load_db("skillset", "db/skillset.db")
	load_db("sklv", "db/sklv.db")
	load_db("skillact", "db/skillact.db")
	load_db("skill_upgrade", "db/skill_upgrade.db")
	load_db("skill_attack_type_group", "db/skill_attack_type_group.db")
	load_db("cs", "db/cs.db")
	load_db("cslv", "db/cslv.db")
	load_db("cs_monster_descent", "db/cs_monster_descent.db")
	load_db("character_monster_descent", "db/character_monster_descent.db")
	load_db("combat_power", "db/combat_power.db")
	load_db("skill_resist", "db/skill_resist.db")
	load_db("skill_immune", "db/skill_immune.db")
	load_db("skill_immune_group", "db/skill_immune_group.db")
	load_db("map_mission", "db/map_mission.db")
	load_db("mission_data", "db/mission_data.db")
	load_db("itemgrade", "db/itemgrade.db")
	load_db("item_equip_balance", "db/item_equip_balance.db")
	load_db("item_equip_stat_count", "db/item_equip_stat_count.db")
	load_db("item_equip_artifact_sell", "db/item_equip_artifact_sell.db")
	load_db("item_equip_grade_rate", "db/item_equip_grade_rate.db")
	load_db("item_equip_upgrade", "db/item_equip_upgrade.db")
	load_db("item_equip_upgrade_stat", "db/item_equip_upgrade_stat.db")
	load_db("item_equip_polish_price", "db/item_equip_polish_price.db")
	load_db("item_equip_reset", "db/item_equip_reset.db")
	load_db("item_token", "db/item_token.db")
	load_db("item_material", "db/item_material.db")
	load_db("item_material_intimacy", "db/item_material_intimacy.db")
	load_db("item_material_bgpack", "db/item_material_bgpack.db")
	load_db("material_flag", "db/material_flag.db")
	load_db("itemenhance", "db/itemenhance.db")
	load_db("equip_item", "db/equip_item.db")
	load_db("equip_item_undress", "db/equip_item_undress.db")
	load_db("equip_stat", "db/equip_stat.db")
	load_db("equipment_score", "db/equipment_score.db")
	load_db("item_equip_stat_revision", "db/item_equip_stat_revision.db")
	load_db("item_equip_substat_change", "db/item_equip_substat_change.db")
	load_db("item_equip_substat_change_pool", "db/item_equip_substat_change_pool.db")
	load_db("item_reward_order", "db/item_reward_order.db")
	load_db("item_ext", "db/item_ext.db")
	load_db("item_link", "db/item_link.db")
	load_db("item_info", "db/item_info.db")
	load_db("item_craft", "db/item_craft.db")
	load_db("item_craft_category", "db/item_craft_category.db")
	load_db("custom", "db/custom.db")
	load_db("story_character", "db/story_character.db")
	load_db("face", "db/face.db")
	load_db("story_action_main", "db/story_action_main.db")
	load_db("story_action_list", "db/story_action_list.db")
	load_db("story_action_text", "db/story_action_text.db")
	load_db("story_action_portrait", "db/story_action_portrait.db")
	load_db("alchemy_recipe", "db/alchemy_recipe.db")
	load_db("recipe_category", "db/recipe_category.db")
	load_db("alchemy_change_result", "db/alchemy_change_result.db")
	load_db("alchemy_change_stat", "db/alchemy_change_stat.db")
	load_db("alchemy_equip_quality", "db/alchemy_equip_quality.db")
	load_db("alchemy_equip_quality_enchant", "db/alchemy_equip_quality_enchant.db")
	load_db("item_equip_sell_enchant", "db/item_equip_sell_enchant.db")
	load_db("alc_ma_eq_rate", "db/alc_ma_eq_rate.db")
	load_db("skill_equip", "db/skill_equip.db")
	load_db("event_equip_craft", "db/event_equip_craft.db")
	load_db("event_equip_craft_data", "db/event_equip_craft_data.db")
	load_db("sanctuary_upgrade", "db/sanctuary_upgrade.db")
	load_db("sanctuary_upgrade_guide", "db/sanctuary_upgrade_guide.db")
	load_db("story_main_script_1", "db/story_main_script_1.db")
	load_db("story_sub_script_1", "db/story_sub_script_1.db")
	load_db("story_etc_script_1", "db/story_etc_script_1.db")
	load_db("story_special_script_1_1", "db/story_special_script_1_1.db")
	load_db("story_skill_act", "db/story_skill_act.db")
	
	if not PRODUCTION_MODE then
		load_db("story_dev_script_1", "db/story_dev_script_1.db")
	end
	
	load_db("acc_rank", "db/acc_rank.db")
	load_db("mail_send", "db/mail_send.db")
	load_db("item_potion", "db/item_potion.db")
	load_db("item_special", "db/item_special.db")
	load_db("item_set", "db/item_set.db")
	load_db("item_set_rate", "db/item_set_rate.db")
	load_db("item_mix", "db/item_mix.db")
	load_db("item_hide_filter", "db/item_hide_filter.db")
	load_db("skill_effectfilter", "db/skill_effectfilter.db")
	load_db("level_enter", "db/level_enter.db")
	load_db("level_enter_limit", "db/level_enter_limit.db")
	load_db("level_enter_chapters", "db/level_enter_chapters.db")
	load_db("level_enter_drops", "db/level_enter_drops.db")
	load_db("level_chapter_monsters", "db/level_chapter_monsters.db")
	load_db("level_battlemenu_genie", "db/level_battlemenu_genie.db")
	load_db("substory_bg", "db/substory_bg.db")
	load_db("level_story", "db/level_story.db")
	load_db("level_story_free", "db/level_story_free.db")
	load_db("level_stage_1_info", "db/level_stage_1_info.db")
	load_db("level_automaton", "db/level_automaton.db")
	load_db("level_automaton_device", "db/level_automaton_device.db")
	load_db("level_automaton_config", "db/level_automaton_config.db")
	load_db("level_automaton_season", "db/level_automaton_season.db")
	load_db("level_world_1_world", "db/level_world_1_world.db")
	load_db("level_world_2_continent", "db/level_world_2_continent.db")
	load_db("level_world_2_continent_slide", "db/level_world_2_continent_slide.db")
	load_db("level_world_3_chapter", "db/level_world_3_chapter.db")
	load_db("level_battlemenu", "db/level_battlemenu.db")
	load_db("level_battlemenu_hunt", "db/level_battlemenu_hunt.db")
	load_db("level_battlemenu_dungeon", "db/level_battlemenu_dungeon.db")
	load_db("quest_chapter", "db/quest_chapter.db")
	load_db("quest_episode", "db/quest_episode.db")
	load_db("ep_select", "db/ep_select.db")
	load_db("level_first_clear", "db/level_first_clear.db")
	load_db("level_abyss_reward", "db/level_abyss_reward.db")
	load_db("character_randomability", "db/character_randomability.db")
	load_db("character_intimacy_level", "db/character_intimacy_level.db")
	load_db("shop_random_list", "db/shop_random_list.db")
	load_db("randombox", "db/randombox.db")
	load_db("shop_promotion_list", "db/shop_promotion_list.db")
	load_db("shop_promotion_category", "db/shop_promotion_category.db")
	load_db("shop_promotion_list", "db/shop_promotion_list.db")
	load_db("shop_package_bonus", "db/shop_package_bonus.db")
	load_db("shop_package_data", "db/shop_package_data.db")
	load_db("level_atlas", "db/level_atlas.db")
	load_db("level_npc", "db/level_npc.db")
	load_db("level_guide_ext", "db/level_guide_ext.db")
	load_db("level_guidemarker", "db/level_guidemarker.db")
	load_db("level_difficulty", "db/level_difficulty.db")
	load_db("level_enter_change", "db/level_enter_change.db")
	load_db("level_change_location", "db/level_change_location.db")
	load_db("level_maze_link", "db/level_maze_link.db")
	load_db("level_maze_story_cleanup", "db/level_maze_story_cleanup.db")
	load_db("level_crevicehunt", "db/level_crevicehunt.db")
	load_db("level_crevicehunt_runestone", "db/level_crevicehunt_runestone.db")
	load_db("crevicehunt_season_reward", "db/crevicehunt_season_reward.db")
	load_db("crevicehunt_kill_reward_preview", "db/crevicehunt_kill_reward_preview.db")
	load_db("zodiac_sphere_2", "db/zodiac_sphere_2.db")
	load_db("zodiac_stone_2", "db/zodiac_stone_2.db")
	load_db("shop_category", "db/shop_category.db")
	load_db("shop_banner", "db/shop_banner.db")
	load_db("shop_chapter", "db/shop_chapter.db")
	load_db("shop_chapter_category", "db/shop_chapter_category.db")
	load_db("shop_chapter_force", "db/shop_chapter_force.db")
	load_db("shop_chapter_force_credit_grade", "db/shop_chapter_force_credit_grade.db")
	load_db("shop_chapter_quest", "db/shop_chapter_quest.db")
	load_db("character_skin", "db/character_skin.db")
	load_db("character_sell_type", "db/character_sell_type.db")
	load_db("character_relationship", "db/character_relationship.db")
	load_db("character_relationship_ui", "db/character_relationship_ui.db")
	load_db("character_story_list", "db/character_story_list.db")
	load_db("character_relationship_bonus", "db/character_relationship_bonus.db")
	load_db("character_profile", "db/character_profile.db")
	load_db("character_profile_unlock", "db/character_profile_unlock.db")
	load_db("level_monstergroup_npcteam", "db/level_monstergroup_npcteam.db")
	load_db("mission_data", "db/mission_data.db")
	load_db("mission_time_config", "db/mission_time_config.db")
	load_db("pvp_sa", "db/pvp_sa.db")
	load_db("pvp_penalty", "db/pvp_penalty.db")
	load_db("pvp_npcbattle", "db/pvp_npcbattle.db")
	load_db("pvp_story", "db/pvp_story.db")
	load_db("pvp_streak", "db/pvp_streak.db")
	load_db("pvp_weekly_reward", "db/pvp_weekly_reward.db")
	load_db("pvp_rta", "db/pvp_rta.db")
	load_db("pvp_rta_basic", "db/pvp_rta_basic.db")
	load_db("pvp_rta_season", "db/pvp_rta_season.db")
	load_db("pvp_rta_season_event", "db/pvp_rta_season_event.db")
	load_db("pvp_rta_emoji", "db/pvp_rta_imoji.db")
	load_db("pvp_rta_reward", "db/pvp_rta_reward.db")
	load_db("pvp_rta_fame", "db/pvp_rta_fame.db")
	load_db("pvp_rta_penalty", "db/pvp_rta_penalty.db")
	load_db("pvp_rta_draft_character", "db/pvp_rta_draft_character.db")
	load_db("pvp_rta_draft_character_stat", "db/pvp_rta_draft_character_stat.db")
	load_db("pvp_rta_draft_tier", "db/pvp_rta_draft_tier.db")
	load_db("smart_bg_static", "db/smart_bg_static.db")
	load_db("achievement", "db/achievement.db")
	load_db("achievement_point_reward", "db/achievement_point_reward.db")
	load_db("achievement_maze_reward", "db/achievement_maze_reward.db")
	load_db("faction", "db/faction.db")
	load_db("faction_level", "db/faction_level.db")
	load_db("level_battlemenu_achievement", "db/level_battlemenu_achievement.db")
	load_db("team_slot_price", "db/team_slot_price.db")
	load_db("rune_sell", "db/rune_sell.db")
	load_db("rune_table", "db/rune_table.db")
	load_db("rune_req", "db/rune_req.db")
	load_db("condition_group", "db/condition_group.db")
	load_db("subtask_mission", "db/subtask_mission.db")
	load_db("subtask_mission_category", "db/subtask_mission_category.db")
	load_db("subtask_mission_condition", "db/subtask_mission_condition.db")
	load_db("subtask_mission_skill", "db/subtask_mission_skill.db")
	load_db("tutorial_guide", "db/tutorial_guide.db")
	load_db("tutorial_menu", "db/tutorial_menu.db")
	load_db("tutorial_help", "db/tutorial_help.db")
	load_db("tutorial_notice", "db/tutorial_notice.db")
	load_db("tutorial_custom", "db/tutorial_custom.db")
	load_db("npc_balloon", "db/npc_balloon.db")
	load_db("clan_attendance", "db/clan_attendance.db")
	load_db("clan_category", "db/clan_category.db")
	load_db("clan_donate", "db/clan_donate.db")
	load_db("clan_level", "db/clan_level.db")
	load_db("clan_member_grade", "db/clan_member_grade.db")
	load_db("item_clantoken", "db/item_clantoken.db")
	load_db("clan_material", "db/clan_material.db")
	load_db("clan_history", "db/clan_history.db")
	load_db("clan_worldboss", "db/clan_worldboss.db")
	load_db("clan_worldboss_battle_grade", "db/clan_worldboss_battle_grade.db")
	load_db("clan_worldboss_npc", "db/clan_worldboss_npc.db")
	load_db("clan_worldboss_weekly_reward", "db/clan_worldboss_weekly_reward.db")
	load_db("clan_worldboss_clanrank", "db/clan_worldboss_clanrank.db")
	load_db("clan_emblem", "db/clan_emblem.db")
	load_db("clan_tag", "db/clan_tag.db")
	load_db("forest_spirit_function", "db/forest_spirit_function.db")
	load_db("balloon_msg", "db/balloon_msg.db")
	load_db("account_skill", "db/account_skill.db")
	load_db("boost_event_schedule", "db/boost_event_schedule.db")
	load_db("character_intimacy", "db/character_intimacy.db")
	load_db("character_intimacy_voice", "db/character_intimacy_voice.db")
	load_db("devotion_skill", "db/devotion_skill.db")
	load_db("devotion_skill_grade", "db/devotion_skill_grade.db")
	load_db("skill_effectexplain", "db/skill_effectexplain.db")
	load_db("morale", "db/morale.db")
	load_db("destiny_category", "db/destiny_category.db")
	load_db("destiny_mission", "db/destiny_mission.db")
	load_db("camp_utterance", "db/camp_utterance.db")
	load_db("clan_mission", "db/clan_mission.db")
	load_db("clan_mission_point_reward", "db/clan_mission_point_reward.db")
	load_db("package", "db/package.db")
	load_db("option", "db/option.db")
	load_db("substory_volleyball_character", "db/substory_volleyball_character.db")
	load_db("substory_volleyball_enter", "db/substory_volleyball_enter.db")
	load_db("substory_volleyball_config", "db/substory_volleyball_config.db")
	load_db("substory_arcade_1_stage", "db/substory_arcade_1_stage.db")
	load_db("substory_arcade_2_character", "db/substory_arcade_2_character.db")
	load_db("substory_arcade_3_monster", "db/substory_arcade_3_monster.db")
	load_db("substory_main", "db/substory_main.db")
	load_db("substory_achievement", "db/substory_achievement.db")
	load_db("substory_quest", "db/substory_quest.db")
	load_db("substory_world_sub", "db/substory_world_sub.db")
	load_db("substory_world_custom", "db/substory_world_custom.db")
	load_db("substory_descent", "db/substory_descent.db")
	load_db("substory_change_image", "db/substory_change_image.db")
	load_db("level_change_chapter", "db/level_change_chapter.db")
	load_db("story_choice", "db/story_choice.db")
	load_db("story_choice_special", "db/story_choice_special.db")
	load_db("substory_piece", "db/substory_piece.db")
	load_db("substory_piece_reward", "db/substory_piece_reward.db")
	load_db("dic_data_substory", "db/dic_data_substory.db")
	load_db("substory_album", "db/substory_album.db")
	load_db("substory_album_mission", "db/substory_album_mission.db")
	load_db("substory_album_reward", "db/substory_album_reward.db")
	load_db("substory_festival", "db/substory_festival.db")
	load_db("substory_festival_fm", "db/substory_festival_fm.db")
	load_db("substory_festival_mission", "db/substory_festival_mission.db")
	load_db("substory_festival_office", "db/substory_festival_office.db")
	load_db("substory_travel", "db/substory_travel.db")
	load_db("substory_cook", "db/substory_cook.db")
	load_db("substory_exorcist", "db/substory_exorcist.db")
	load_db("substory_custom_mission", "db/substory_custom_mission.db")
	load_db("level_substory_enter_property", "db/level_substory_enter_property.db")
	load_db("substory_system_main", "db/substory_system_main.db")
	load_db("substory_village", "db/substory_village.db")
	load_db("substory_village_sub", "db/substory_village_sub.db")
	load_db("substory_village_craft", "db/substory_village_craft.db")
	load_db("substory_village_tree_reward", "db/substory_village_tree_reward.db")
	load_db("substory_story_change", "db/substory_story_change.db")
	load_db("substory_board", "db/substory_board.db")
	load_db("substory_board_reward", "db/substory_board_reward.db")
	load_db("substory_board_talk", "db/substory_board_talk.db")
	load_db("substory_inference_1_note", "db/substory_inference_1_note.db")
	load_db("substory_inference_2_case", "db/substory_inference_2_case.db")
	load_db("substory_inference_3_clue", "db/substory_inference_3_clue.db")
	load_db("dic_ui", "db/dic_ui.db")
	load_db("dic_data", "db/dic_data.db")
	load_db("dic_data_illust", "db/dic_data_illust.db")
	load_db("dic_data_illust_special", "db/dic_data_illust_special.db")
	load_db("illust_ambient_color", "db/illust_ambient_color.db")
	load_db("dic_data_story", "db/dic_data_story.db")
	load_db("ml_theater", "db/ml_theater.db")
	load_db("ml_theater_season", "db/ml_theater_season.db")
	load_db("ml_theater_cast", "db/ml_theater_cast.db")
	load_db("ml_theater_story", "db/ml_theater_story.db")
	load_db("substory_dlc_story_ui", "db/substory_dlc_story_ui.db")
	load_db("substory_dlc_story", "db/substory_dlc_story.db")
	load_db("substory_dlc_reward", "db/substory_dlc_reward.db")
	load_db("substory_dlc_chronicle", "db/substory_dlc_chronicle.db")
	load_db("substory_burning", "db/substory_burning.db")
	load_db("substory_burning_main", "db/substory_burning_main.db")
	load_db("substory_burning_story", "db/substory_burning_story.db")
	load_db("substory_burning_chapter", "db/substory_burning_chapter.db")
	load_db("substory_burning_battle", "db/substory_burning_battle.db")
	load_db("substory_burning_shop", "db/substory_burning_shop.db")
	load_db("substory_burning_equip", "db/substory_burning_equip.db")
	load_db("reward_display_order", "db/reward_display_order.db")
	load_db("system_achievement", "db/system_achievement.db")
	load_db("system_achievement_effect", "db/system_achievement_effect.db")
	load_db("classchange_quest", "db/classchange_quest.db")
	load_db("classchange_category", "db/classchange_category.db")
	load_db("skill_tree", "db/skill_tree.db")
	load_db("skill_tree_rune", "db/skill_tree_rune.db")
	load_db("skill_tree_material", "db/skill_tree_material.db")
	load_db("condition_state", "db/condition_state.db")
	load_db("clan_war", "db/clan_war.db")
	load_db("clan_war_schedule", "db/clan_war_schedule.db")
	load_db("clan_war_object_main", "db/clan_war_object_main.db")
	load_db("clan_war_object_sub_001", "db/clan_war_object_sub_001.db")
	load_db("clan_war_calibrate", "db/clan_war_calibrate.db")
	load_db("clan_war_calibrate_war02", "db/clan_war_calibrate_war02.db")
	load_db("clan_war_object_sub_002", "db/clan_war_object_sub_002.db")
	load_db("clan_war_object_sub_003", "db/clan_war_object_sub_003.db")
	load_db("clan_war_object_sub_004", "db/clan_war_object_sub_004.db")
	load_db("clan_war_rank_grade", "db/clan_war_rank_grade.db")
	load_db("title_manager", "title/title_manager.db")
	load_db("guidequest_group", "db/guidequest_group.db")
	load_db("guidequest_mission", "db/guidequest_mission.db")
	load_db("substory_tournament", "db/substory_tournament.db")
	load_db("content_tournament", "db/content_tournament.db")
	load_db("content_piece", "db/content_piece.db")
	load_db("content_travel", "db/content_travel.db")
	load_db("substory_challenge", "db/substory_challenge.db")
	load_db("content_village", "db/content_village.db")
	load_db("content_inference", "db/content_inference.db")
	load_db("content_board", "db/content_board.db")
	load_db("content_burning", "db/content_burning.db")
	load_db("level_battlemenu_trialhall", "db/level_battlemenu_trialhall.db")
	load_db("challenge_rank", "db/challenge_rank.db")
	load_db("challenge_rank_reward", "db/challenge_rank_reward.db")
	load_db("pet_character", "db/pet_character.db")
	load_db("pet_skill", "db/pet_skill.db")
	load_db("pet_skill_per", "db/pet_skill_per.db")
	load_db("pet_exp", "db/pet_exp.db")
	load_db("pet_affection", "db/pet_affection.db")
	load_db("pet_gacha", "db/pet_gacha.db")
	load_db("pet_personality", "db/pet_personality.db")
	load_db("pet_affection_effect", "db/pet_affection_effect.db")
	load_db("pet_grade", "db/pet_grade.db")
	load_db("pet_gacha_event", "db/pet_gacha_event.db")
	load_db("achievement_honor_category", "db/achievement_honor_category.db")
	load_db("achievement_honor_reward", "db/achievement_honor_reward.db")
	load_db("character_attribute_change", "db/character_attribute_change.db")
	load_db("episode_mission", "db/episode_mission.db")
	load_db("episode_adin", "db/episode_adin.db")
	load_db("ep5_tree", "db/ep5_tree.db")
	load_db("event_mission_category", "db/event_mission_category.db")
	load_db("event_mission_day_reward", "db/event_mission_day_reward.db")
	load_db("event_mission", "db/event_mission.db")
	load_db("player_time", "db/player_time.db")
	load_db("gm_info", "db/gm_info.db")
	load_db("chat_emoji", "db/chat_emoji.db")
	load_db("lobby_type", "db/lobby_type.db")
	load_db("lobby_theme_object", "db/lobby_theme_object.db")
	load_db("lobby_theme_group", "db/lobby_theme_group.db")
	load_db("profile_config", "db/profile_config.db")
	load_db("item_material_profile", "db/item_material_profile.db")
	load_db("profile_sd_character", "db/profile_sd_character.db")
	load_db("mission_contents", "db/mission_contents.db")
	load_db("profile_spine_illust_resolution", "db/profile_spine_illust_resolution.db")
	load_db("expedition_main", "db/expedition_main.db")
	load_db("expedition_config", "db/expedition_config.db")
	load_db("expedition_supply", "db/expedition_supply.db")
	load_db("expedition_boss_group", "db/expedition_boss_group.db")
	load_db("expedition_boss_level", "db/expedition_boss_level.db")
	load_db("expedition_boss_additional_info", "db/expedition_boss_additional_info.db")
	load_db("expedition_detect", "db/expedition_detect.db")
	load_db("expedition_reward_preview", "db/expedition_reward_preview.db")
	load_db("level_guide_npc", "db/level_guide_npc.db")
	load_db("character_achievement", "db/character_achievement.db")
	load_db("moonlight_destiny_season", "db/moonlight_destiny.db")
	load_db("event_platform", "db/event_platform.db")
	load_db("hero_recommend", "db/hero_recommend.db")
	load_db("hero_recommend_tag", "db/hero_recommend_tag.db")
	load_db("hero_recommend_moonlight", "db/hero_recommend_moonlight.db")
	load_db("rumble_character", "db/rumble_character.db")
	load_db("rumble_config", "db/rumble_config.db")
	load_db("rumble_cs", "db/rumble_cs.db")
	load_db("rumble_gacha", "db/rumble_gacha.db")
	load_db("rumble_schedule", "db/rumble_schedule.db")
	load_db("rumble_stage", "db/rumble_stage.db")
	load_db("rumble_synergy", "db/rumble_synergy.db")
	load_db("rumble_skill", "db/rumble_skill.db")
	load_db("help_0_shortcut", "db/help_0_shortcut.db")
	load_db("help_0_group", "db/help_0_group.db")
	load_db("help_1_menu", "db/help_1_menu.db")
	load_db("help_2_category", "db/help_2_category.db")
	load_db("help_3_contents", "db/help_3_contents.db")
	load_db("growth_boost", "db/growth_boost.db")
	load_db("sound_bank", "db/sound_bank.db")
	load_db("unused_story_id", "db/unused_story_id.db")
	load_db("ai_simulation", "db/ai_simulation.db")
	load_db("ref_stat_id", "db/ref_stat_id.db")
	load_db("event_lobby_icon_set", "db/event_lobby_icon_set.db")
	
	if string.starts(getUserLanguage(), "zh") then
		load_db("name_sort", "text/name_sort.db")
	end
	
	load_db("abuse_filter_name", "db/abuse_filter_name.db")
	load_db("abuse_filter_chat", "db/abuse_filter_chat.db")
	init_abuse_filter()
	load_db("config_content", "db/config_content.db")
	init_game_content_variable()
end

function init_abuse_filter()
	clear_abuse_filter()
	
	for iter_11_0 = 1, 999999 do
		local var_11_0 = DBN("abuse_filter_name", iter_11_0, {
			"word"
		})
		
		if not var_11_0 then
			break
		end
		
		add_abuse_filter(var_11_0, ABUSE_FILTER.NAME)
	end
	
	for iter_11_1 = 1, 999999 do
		local var_11_1 = DBN("abuse_filter_chat", iter_11_1, {
			"word"
		})
		
		if not var_11_1 then
			break
		end
		
		add_abuse_filter(var_11_1, ABUSE_FILTER.CHAT)
	end
end

function init_game_content_variable()
	local function var_12_0(arg_13_0)
		if arg_13_0 == "n" or arg_13_0 == "false" then
			return false
		end
		
		if arg_13_0 == "y" or arg_13_0 == "true" then
			return true
		end
		
		return arg_13_0
	end
	
	for iter_12_0 = 1, 9999 do
		local var_12_1, var_12_2, var_12_3 = DBN("config_content", iter_12_0, {
			"type",
			"key",
			"client_value"
		})
		
		if not var_12_2 then
			break
		end
		
		META_CONTENT_VARIABLE[var_12_2] = {
			category = var_12_1,
			value = var_12_0(var_12_3)
		}
	end
end

function _debug_print_game_static_variable(arg_14_0)
	if arg_14_0 then
		print("SS[ " .. arg_14_0 .. " ] = " .. tostring((META_STATIC_VARIABLE[arg_14_0] or {}).value))
	else
		for iter_14_0, iter_14_1 in pairs(META_STATIC_VARIABLE) do
			if type(iter_14_1) ~= "function" then
				print("SS[ " .. tostring(iter_14_0) .. " ] = " .. tostring((iter_14_1 or {}).value))
			end
		end
	end
end

function _debug_print_game_content_variable(arg_15_0)
	if arg_15_0 then
		print("CC[ " .. arg_15_0 .. " ] = " .. tostring((META_CONTENT_VARIABLE[arg_15_0] or {}).value))
	else
		for iter_15_0, iter_15_1 in pairs(META_CONTENT_VARIABLE) do
			if type(iter_15_1) ~= "function" then
				print("CC[ " .. tostring(iter_15_0) .. " ] = " .. tostring((iter_15_1 or {}).value))
			end
		end
	end
end

function _verify_yuna_db_set(arg_16_0)
	local var_16_0
	
	if string.ends(arg_16_0, ".tsv") then
		var_16_0 = cc.FileUtils:getInstance():fullPathForFilename("db/character.db")
	else
		var_16_0 = cc.FileUtils:getInstance():fullPathForFilename("db/" .. arg_16_0)
	end
	
	local var_16_1 = Path.dirname(var_16_0) .. "../../server/res/db/"
	local var_16_2 = var_16_1 .. string.gsub(arg_16_0, ".db", ".tsv")
	local var_16_3 = 0
	local var_16_4 = io.open(var_16_2, "r")
	
	if var_16_4 then
		var_16_4:close()
		
		local function var_16_5(arg_17_0)
			if string.sub(arg_17_0, -1, -1) == "\r" then
				arg_17_0 = string.sub(arg_17_0, 1, -2)
			end
			
			return arg_17_0
		end
		
		local function var_16_6(arg_18_0, arg_18_1)
			local var_18_0 = {}
			local var_18_1 = arg_18_0
			local var_18_2 = 1
			
			while true do
				local var_18_3, var_18_4 = string.find(var_18_1, arg_18_1)
				
				if var_18_3 == nil then
					if string.len(var_18_1) > 0 then
						var_18_0[var_18_2] = var_18_1
					end
					
					return var_18_0
				end
				
				if var_18_3 == 1 then
					var_18_0[var_18_2] = nil
					var_18_2 = var_18_2 + 1
				else
					var_18_0[var_18_2] = string.sub(var_18_1, 1, var_18_3 - 1)
					var_18_2 = var_18_2 + 1
				end
				
				var_18_1 = string.sub(var_18_1, var_18_4 + 1, -1)
			end
		end
		
		local var_16_7 = {}
		
		for iter_16_0 in io.lines(var_16_2) do
			table.insert(var_16_7, var_16_5(iter_16_0))
		end
		
		local var_16_8
		local var_16_9 = {}
		
		if string.sub(var_16_7[1], 1, 9) == "YUNADBSET" then
			local var_16_10 = systick()
			local var_16_11 = var_16_7
			local var_16_12 = true
			local var_16_13 = {}
			
			for iter_16_1 = 2, #var_16_11 do
				local var_16_14 = var_16_6(var_16_11[iter_16_1], "\t")
				local var_16_15 = var_16_1 .. var_16_14[1] .. ".tsv"
				local var_16_16 = SAVE:getUserDefaultData("hs:" .. var_16_14[1], "")
				local var_16_17 = string_tomd5(io.readfile(var_16_15))
				
				if var_16_16 ~= var_16_17 then
					var_16_13[var_16_14[1]] = var_16_17
					var_16_12 = false
				end
			end
			
			print("*** proccess start : " .. arg_16_0, var_16_12 and "-> already verified" or "-> db change detected")
			
			if not var_16_12 then
				for iter_16_2 = 2, #var_16_11 do
					local var_16_18 = var_16_6(var_16_11[iter_16_2], "\t")
					local var_16_19 = var_16_1 .. var_16_18[1] .. ".tsv"
					
					print("  * " .. var_16_18[1] .. ".tsv", var_16_13[var_16_18[1]] and "change detected" or "not changed")
					
					local var_16_20 = io.lines(var_16_19)
					local var_16_21 = 0
					
					for iter_16_3 in var_16_20 do
						var_16_21 = var_16_21 + 1
						
						if var_16_21 > 1 then
							iter_16_3 = var_16_5(iter_16_3)
							
							local var_16_22 = var_16_6(iter_16_3, "\t")
							local var_16_23 = var_16_22[1]
							
							if var_16_23 and var_16_9[var_16_23] then
								print("    - " .. var_16_23)
								
								var_16_3 = var_16_3 + 1
							else
								var_16_9[var_16_23] = var_16_22
							end
						end
					end
					
					if var_16_13[var_16_18[1]] then
						SAVE:setUserDefaultData("hs:" .. var_16_18[1], var_16_3 == 0 and var_16_13[var_16_18[1]] or "yaho")
					end
				end
			end
			
			local var_16_24 = string.format("d(%d), t(%.2f)", var_16_3, (systick() - var_16_10) / 1000)
			
			print("*** proccess end : " .. var_16_24)
		end
	end
	
	return var_16_3
end

function verify_yuna_db_set()
	if PLATFORM ~= "win32" or IS_TOOL_MODE or PRODUCTION_MODE then
		return 
	end
	
	local var_19_0 = getenv("patch.use", "") == "true"
	
	if PLATFORM == "win32" and not var_19_0 then
		print("## start verify YDBS")
		
		local var_19_1 = _verify_yuna_db_set("character.db")
		local var_19_2 = _verify_yuna_db_set("skill.db")
		local var_19_3 = _verify_yuna_db_set("cs.db")
		local var_19_4 = _verify_yuna_db_set("skillset.db")
		local var_19_5 = _verify_yuna_db_set("level_enter.db")
		local var_19_6 = _verify_yuna_db_set("level_stage_2_data.db")
		local var_19_7 = _verify_yuna_db_set("level_monstergroup.tsv")
		local var_19_8 = var_19_1 + var_19_2 + var_19_3 + var_19_4 + var_19_5 + var_19_6 + var_19_7
		
		print("## duplicate : " .. var_19_8)
		print("## end verify YDBS")
		
		if var_19_8 > 0 then
			local var_19_9 = "[YUNADBSET] has Duplicated row id"
			
			__G__TRACKBACK__(var_19_9)
		end
	end
end

function _verify_resist_db(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1.eff_columns
	local var_20_1 = arg_20_1.old_columns
	local var_20_2 = arg_20_1.new_columns
	local var_20_3 = {}
	
	table.add(var_20_3, var_20_0)
	table.add(var_20_3, var_20_1)
	table.add(var_20_3, var_20_2)
	
	local var_20_4 = 0
	local var_20_5 = 0
	local var_20_6 = 0
	local var_20_7 = 0
	local var_20_8 = 0
	local var_20_9 = 0
	
	for iter_20_0 = 1, 99999 do
		local var_20_10 = DBN(arg_20_0, iter_20_0, "id")
		local var_20_11 = DBT(arg_20_0, tostring(var_20_10), var_20_3)
		
		if not var_20_10 then
			break
		end
		
		var_20_4 = var_20_4 + 1
		
		for iter_20_1, iter_20_2 in pairs(var_20_0) do
			if var_20_11[iter_20_2] then
				local var_20_12 = var_20_1[iter_20_1] or var_20_1[1]
				local var_20_13 = var_20_2[iter_20_1] or var_20_2[1]
				local var_20_14 = var_20_11[var_20_12]
				local var_20_15 = var_20_11[var_20_13]
				
				var_20_5 = var_20_5 + 1
				
				local var_20_16 = true
				
				if var_20_14 == "y" and var_20_15 and var_20_15 ~= "n" then
					print("error: - case 1 : ", string.format("%s : %s( %s ) ==> %s (%s) -> %s (%s)", arg_20_0, var_20_10, var_20_11[iter_20_2], var_20_12, var_20_14, var_20_13, var_20_15))
					
					var_20_6 = var_20_6 + 1
					var_20_16 = false
				end
				
				if (var_20_14 == "n" or not var_20_14) and var_20_15 ~= "y" then
					print("error: - case 2 : ", string.format("%s : %s( %s ) ==> %s (%s) -> %s (%s)", arg_20_0, var_20_10, var_20_11[iter_20_2], var_20_12, var_20_14, var_20_13, var_20_15))
					
					var_20_7 = var_20_7 + 1
					var_20_16 = false
				end
				
				if var_20_16 then
					var_20_8 = var_20_8 + 1
				else
					var_20_9 = var_20_9 + 1
				end
			end
		end
	end
	
	print("error: test result :", arg_20_0, string.format("total : %d, case : %d, pass : %d, fail : %d(%d/%d)", var_20_4, var_20_5, var_20_8, var_20_9, var_20_6, var_20_7))
end

function verify_resist_db()
	local var_21_0 = {
		eff_columns = {
			"sk_start_eff",
			"sk_add_eff1",
			"sk_add_eff2",
			"sk_add_eff3",
			"sk_add_eff4",
			"sk_add_eff5",
			"sk_add_eff6",
			"sk_add_eff7",
			"sk_add_eff8"
		},
		old_columns = {
			"start_res",
			"add_res1",
			"add_res2",
			"add_res3",
			"add_res4",
			"add_res5",
			"add_res6",
			"add_res7",
			"add_res8"
		},
		new_columns = {
			"sk_start_resist_ignore",
			"sk_add_resist_ignore1",
			"sk_add_resist_ignore2",
			"sk_add_resist_ignore3",
			"sk_add_resist_ignore4",
			"sk_add_resist_ignore5",
			"sk_add_resist_ignore6",
			"sk_add_resist_ignore7",
			"sk_add_resist_ignore8"
		}
	}
	
	_verify_resist_db("skill", var_21_0)
	
	local var_21_1 = {
		eff_columns = {
			"cs_eff1",
			"cs_eff2",
			"cs_eff3",
			"cs_eff4",
			"cs_eff5",
			"cs_eff6"
		},
		old_columns = {
			"cs_res"
		},
		new_columns = {
			"cs_eff_resist_ignore"
		}
	}
	
	_verify_resist_db("cs", var_21_1)
end
