TutorialBattle = {}
TutorialDeprecate = {}
TOTURIALCOUNT = {}
TOTURIALCOUNT.FIRST_GAME_ENTER = 0
TOTURIALCOUNT.START_TOT001 = 1
TOTURIALCOUNT.START_EVENT_01_CINEMA = 2
TOTURIALCOUNT.START_INTRO_STORY_D = 3
TOTURIALCOUNT.END_INTRO_STORY_D = 4
TOTURIALCOUNT.NEED_START_STORY_CH01_001 = 5
TOTURIALCOUNT.FIRST_ENTER_LOBBY = 6
TOTURIALCOUNT.END_ALL = 7

function MsgHandler.tutorial(arg_1_0)
	Action:RemoveAll()
	
	local var_1_0 = Team:makeTeamData(TutorialBattle:getTutorialUnits(arg_1_0.step))
	local var_1_1 = BattleLogic:makeLogic(arg_1_0.battle, var_1_0, {
		mode = "tutorial"
	})
	
	SceneManager:nextScene("battle", {
		logic = var_1_1
	})
end

function startGame()
	print("startGame")
	
	if not VARS.GAME_STARTED and reload_fontdata then
		reload_fontdata()
	end
	
	print("isPatchCompleteRequired : ", SAVE:isPatchCompleteRequired())
	print("getTutorialCounter : ", SAVE:getTutorialCounter())
	print("patch status : ", getenv("patch.status"))
	print("is_enable_minimal : ", is_enable_minimal())
	print("startGame", SAVE:isPatchCompleteRequired(), getenv("patch.status"), is_enable_minimal(), VARS.SWITCH_TO_DATA)
	
	if Stove.enable then
		Stove:googlePlayGamesAccountLink()
	end
	
	VARS.GAME_STARTED = true
	
	if SAVE:isPatchCompleteRequired() and getenv("patch.status") == "complete" and is_enable_minimal() then
		set_enable_minimal(false)
		
		if purge_cache_db then
			purge_cache_db()
		end
		
		reload_db()
		reload_master_sound()
	end
	
	if SAVE:isPatchCompleteRequired() and getenv("patch.status") == "complete" and is_enable_minimal() then
		TutorialGuide:resetGuideData()
		cc.UserDefault:getInstance():setStringForKey("startable.status", "hidden")
	end
	
	if PLATFORM == "win32" and not PRODUCTION_MODE then
		Account:procAccountInfo()
	elseif is_enable_minimal() then
		Account:procMinimalAccountInfo()
	else
		Account:procAccountInfo()
	end
	
	if SAVE:get("equip_maxUid0") == nil then
		local var_2_0 = Account:getMaxUidEquip()
		
		for iter_2_0 = 0, 6 do
			SAVE:set("equip_maxUid" .. iter_2_0, tostring(var_2_0))
		end
		
		SAVE:set("equip_artifactMaxUid", tostring(Account:getMaxUidArtifact()))
	end
	
	if SAVE:get("inventory.special_item_list") == nil then
		local var_2_1 = {}
		
		for iter_2_1, iter_2_2 in pairs(Account.items) do
			if DB("item_material", iter_2_1, "ma_type") == "special" then
				var_2_1[iter_2_1] = iter_2_2
			end
		end
		
		local var_2_2 = json.encode(var_2_1)
		
		SAVE:set("inventory.special_item_list", var_2_2)
	end
	
	if SAVE:get("inventory.gradejump_item_list") == nil then
		local var_2_3 = {}
		
		for iter_2_3, iter_2_4 in pairs(Account.items) do
			if DB("item_material", iter_2_3, "ma_type") == ".gradejump" then
				var_2_3[iter_2_3] = iter_2_4
			end
		end
		
		local var_2_4 = json.encode(var_2_3)
		
		SAVE:set("inventory.gradejump_item_list", var_2_4)
	end
	
	if not SAVE:isTutorialFinished() then
		TutorialBattle:startTutorial()
		
		return 
	end
	
	if getenv("patch.status") == "downloading" then
		SceneManager:nextScene("patch")
		
		return 
	end
	
	if DEBUG.ENABLE_CONTINUE_BATTLE and getenv("patch.updated") then
		removeSavedBattleInfo()
	end
	
	if DEBUG.ENABLE_CONTINUE_BATTLE and not getenv("patch.updated") then
		local var_2_5 = SAVE:get("game.restore_battle_data")
		local var_2_6 = get_restore_battle()
		
		if Battle:isSupportSaveFormat(var_2_5) and var_2_6 then
			if not DEBUG.REMOVE_SAVE then
				Dialog:msgBox(T("tutorial_msg_continue"), {
					yesno = true,
					handler = function()
						re_enter(var_2_6)
					end,
					cancel_handler = function()
						removeSavedBattleInfo()
						SceneManager:nextScene("lobby")
					end
				})
				
				return 
			else
				removeSavedBattleInfo()
			end
		end
		
		SceneManager:nextScene("lobby")
	else
		SceneManager:nextScene("lobby")
	end
end

function TutorialBattle._getUnits(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = SLOW_DB_ALL("level_monstergroup_npcteam", arg_5_1)
	local var_5_1 = {}
	local var_5_2, var_5_3, var_5_4, var_5_5
	
	if var_5_0 then
		var_5_2 = {
			var_5_0.front1,
			var_5_0.front2,
			var_5_0.back1,
			var_5_0.back2,
			var_5_0.sinsu
		}
		var_5_3 = {
			var_5_0.power_f1,
			var_5_0.power_f2,
			var_5_0.power_b1,
			var_5_0.power_b2,
			var_5_0.power_sinsu
		}
		var_5_4 = {
			var_5_0.level_f1,
			var_5_0.level_f2,
			var_5_0.level_b1,
			var_5_0.level_b2,
			var_5_0.level_sinsu
		}
		var_5_5 = {
			var_5_0.grade_f1,
			var_5_0.grade_f2,
			var_5_0.grade_b1,
			var_5_0.grade_b2,
			var_5_0.grade_sinsu
		}
		
		for iter_5_0 = 1, 5 do
			if var_5_2[iter_5_0] then
				if var_5_2[iter_5_0] == "main_character" then
					var_5_1[iter_5_0] = arg_5_2
				else
					var_5_1[iter_5_0] = UNIT:create({
						code = var_5_2[iter_5_0],
						g = var_5_5[iter_5_0] or var_5_0.add_gr,
						lv = var_5_4[iter_5_0] or var_5_0.add_lv,
						p = var_5_3[iter_5_0] or var_5_0.add_power
					})
				end
			end
		end
	end
	
	return var_5_1
end

function TutorialBattle.getTutorialUnits(arg_6_0, arg_6_1)
	local var_6_0 = {
		nil,
		"lms_tot001",
		"lms_tot002",
		nil,
		"lms_tot003"
	}
	local var_6_1 = SAVE:getTutorialCounter()
	
	return arg_6_0:_getUnits(var_6_0[arg_6_1 + 1])
end

function TutorialBattle.getStoryUnits(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0:_getUnits(arg_7_1, arg_7_2)
	
	for iter_7_0, iter_7_1 in pairs(var_7_0) do
		if iter_7_1 ~= arg_7_2 then
			iter_7_1.guest = true
		end
	end
	
	return var_7_0
end

function TutorialBattle.startTutorial(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1 or to_n(SAVE:getTutorialCounter())
	
	print("TutorialBattle:startTutorial counter", var_8_0)
	PatchGauge:show()
	arg_8_0:createDownloadNode()
	
	if get_cocos_refid(arg_8_0.e03_node) then
		print(arg_8_0.e03_node:getReferenceCount())
	end
	
	local function var_8_1()
		return true
	end
	
	if SAVE:isPatchCompleteRequired() and (getenv("patch.status") == "downloading" or getenv("patch.status") == "panding") then
		SceneManager:nextScene("patch")
		
		return 
	end
	
	if var_8_0 <= 5 and ResourceCollect.enable then
		for iter_8_0 in cc.FileUtils:getInstance():dumpReadedFiles():gmatch("[^\r\n]+") do
			ResourceCollect:add("file@", iter_8_0)
		end
	end
	
	if var_8_0 == TOTURIALCOUNT.FIRST_GAME_ENTER then
		local var_8_2 = getenv("app.id", "")
		
		print("app.id : ", var_8_2)
		
		if not string.find(var_8_2, "stove") and not string.find(var_8_2, "zlong") then
			print("ResourceCollect.enable = true")
			
			ResourceCollect.enable = true
		end
		
		SAVE:incTutorialCounter()
		arg_8_0:startTutorial()
	elseif var_8_0 == TOTURIALCOUNT.START_EVENT_01_CINEMA then
		local function var_8_3()
			SAVE:incTutorialCounter()
			arg_8_0:startTutorial()
		end
		
		story_action_on_action_scene(nil, "intro_story_c", {
			play_on_intro = true,
			on_clear = var_8_3,
			isBGMContinue = var_8_1
		})
	elseif var_8_0 == TOTURIALCOUNT.START_INTRO_STORY_D and SceneManager:getPrevSceneName() ~= "cinema" then
		local function var_8_4()
			SAVE:incTutorialCounter()
			arg_8_0:startTutorial()
		end
		
		local var_8_5
		local var_8_6 = SceneManager:getCurrentSceneName() == "story_action" and true or false
		
		if var_8_6 then
			play_story("intro_story_d", {
				play_on_intro = true,
				do_not_play = var_8_6,
				on_clear = var_8_4,
				isBGMContinue = var_8_1
			})
		else
			story_action_on_action_scene(nil, "intro_story_d", {
				play_on_intro = true,
				do_not_play = var_8_6,
				on_clear = var_8_4,
				isBGMContinue = var_8_1
			})
		end
		
		if cc.UserDefault:getInstance():getBoolForKey("tune.new_start", false) and not cc.UserDefault:getInstance():getBoolForKey("tune.v_tutorial_n1", false) then
			cc.UserDefault:getInstance():setBoolForKey("tune.v_tutorial_n1", true)
		end
	elseif var_8_0 == TOTURIALCOUNT.END_INTRO_STORY_D then
		PatchGauge:hide()
		
		if cc.UserDefault:getInstance():getBoolForKey("tune.new_start", false) and not cc.UserDefault:getInstance():getBoolForKey("tune.v_tutorial_n2", false) then
			cc.UserDefault:getInstance():setBoolForKey("tune.v_tutorial_n2", true)
		end
		
		SAVE:incTutorialCounter()
		
		if getenv("patch.status") == "complete" then
			arg_8_0:startTutorial()
		else
			startGame()
		end
	elseif var_8_0 == TOTURIALCOUNT.NEED_START_STORY_CH01_001 then
		SoundEngine:playBGM("event:/bgm/default")
		ResourceCollect:dump()
		ResourceCollect:send()
		SceneManager:nextScene("cinema", {
			story = "CH01_001",
			on_clear = function()
				print("error END ")
			end
		})
		
		ResourceCollect.enable = false
	else
		SceneManager:nextScene("blank")
		
		if var_8_0 == TOTURIALCOUNT.START_INTRO_STORY_D or var_8_0 == TOTURIALCOUNT.END_INTRO_STORY_D then
			var_8_0 = 1
			
			SAVE:saveTutorialCount(TOTURIALCOUNT.START_INTRO_STORY_D)
		end
		
		query("tutorial", {
			step = var_8_0
		})
	end
end

function TutorialBattle.onClearTutorialBattle(arg_13_0)
	SAVE:incTutorialCounter()
	
	if SAVE:isTutorialFinished() then
		SceneManager:nextScene("lobby")
		
		return 
	end
	
	startGame()
end

function TutorialBattle.createDownloadNode(arg_14_0)
	if not get_cocos_refid(arg_14_0.e03_node) then
		arg_14_0.e03_node = download_file("cinema/event_03.mp4")
		
		if get_cocos_refid(arg_14_0.e03_node) then
			arg_14_0.e03_node:retain()
		end
	end
	
	if not get_cocos_refid(arg_14_0.mov2_node) then
		arg_14_0.mov2_node = download_file("cinema/mov2_8_10_1.mp4")
		
		if get_cocos_refid(arg_14_0.mov2_node) then
			arg_14_0.mov2_node:retain()
		end
	end
end

function TutorialBattle.removeDownloadNode(arg_15_0)
	if get_cocos_refid(arg_15_0.e03_node) then
		arg_15_0.e03_node:release()
		
		arg_15_0.e03_node = nil
	end
	
	if get_cocos_refid(arg_15_0.mov2_node) then
		arg_15_0.mov2_node:release()
		
		arg_15_0.mov2_node = nil
	end
end

function TutorialDeprecate.setGuide(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6)
	if not get_cocos_refid(arg_16_3) then
		arg_16_3 = SceneManager:getRunningNativeScene()
	end
	
	local var_16_0
	
	if type(arg_16_1) == "string" then
		arg_16_1 = arg_16_3:getChildByName(arg_16_1)
	end
	
	if type(arg_16_1) == "userdata" then
		var_16_0 = arg_16_1:convertToWorldSpace({
			y = 0,
			x = VIEW_BASE_LEFT
		})
	end
	
	if arg_16_1 == nil then
		Log.e("tutorial error")
		
		return 
	end
	
	local var_16_1 = arg_16_4 or arg_16_1:getContentSize()
	local var_16_2 = arg_16_6
	
	arg_16_0.guide_info = {
		control = arg_16_1
	}
	arg_16_0.guide_info.wnd = cc.CSLoader:createNode("wnd/guide.csb")
	
	arg_16_0.guide_info.wnd:setLocalZOrder(999999999)
	arg_16_0.guide_info.wnd:setAnchorPoint(0.5, 0.5)
	
	local var_16_3 = arg_16_0.guide_info.wnd:getChildByName("n_guide")
	local var_16_4 = arg_16_0.guide_info.wnd:getChildByName("n_pos")
	local var_16_5 = arg_16_0.guide_info.wnd:getChildByName("bg")
	local var_16_6 = arg_16_0.guide_info.wnd:getChildByName("n_chat")
	
	var_16_6:setScale(0)
	var_16_3:setOpacity(0)
	UIAction:Add(OPACITY(300, 0, 0.5), var_16_3, "block")
	UIAction:Add(SEQ(LOG(SCALE(150, 0, 1.2)), RLOG(SCALE(100, 1.2, 1))), var_16_6, "block")
	var_16_3:setScaleX(var_16_1.width / 50 * arg_16_1:getScaleX())
	var_16_3:setScaleY(var_16_1.height / 50 * arg_16_1:getScaleY())
	
	local var_16_7
	local var_16_8
	
	if type(arg_16_5) == "function" then
		var_16_7, var_16_8 = arg_16_5()
	elseif type(arg_16_5) == "table" then
		var_16_7 = arg_16_5.x or 0
		var_16_8 = arg_16_5.y or 0
	elseif var_16_0 then
		var_16_7 = var_16_0.x + var_16_1.width / 2 * arg_16_1:getScaleX()
		var_16_8 = var_16_0.y + var_16_1.height / 2 * arg_16_1:getScaleY()
	else
		Log.e("상황체크 필요", "tutorial.lua, x,y")
	end
	
	if var_16_2 then
		var_16_3:setRotation(var_16_2)
	end
	
	var_16_4:setPosition(var_16_7, var_16_8 - arg_16_3:getPositionY())
	
	if var_16_7 > DESIGN_WIDTH / 2 then
		var_16_5:setScaleX(-1)
		arg_16_0.guide_info.wnd:getChildByName("txt"):setScaleX(-0.8)
	end
	
	arg_16_3:addChild(arg_16_0.guide_info.wnd)
end

function TutorialDeprecate.makeGuideData(arg_17_0)
	local var_17_0 = {
		[UNLOCK_ID.TUTORIAL002] = {
			{
				scene = "battle",
				message = "touch_object_button",
				target = function()
					return Battle.logic:getRoomObject("tot00300_3").model
				end,
				size = {
					width = 160,
					height = 400
				},
				pos = function()
					local var_19_0, var_19_1 = Battle.logic:getRoomObject("tot00300_3").model:getPosition()
					
					return BattleLayout:convertToScreenX(var_19_0) + 20, var_19_1 + 130
				end
			},
			{
				scene = "battle",
				delay = 0,
				help_id = "battle_sinsu"
			}
		},
		[UNLOCK_ID.TUTORIAL003] = {
			{
				scene = "battle",
				message = "touch_summon_button",
				target = "sinsu_face"
			}
		},
		[UNLOCK_ID.MAZE_PORTAL] = {
			{
				scene = "battle",
				delay = 0,
				help_id = "mazeportal"
			}
		},
		[UNLOCK_ID.COLLECTION_BOOK] = {
			{
				scene = "collection",
				delay = 0,
				help_id = UNLOCK_ID.COLLECTION_BOOK
			}
		},
		[UNLOCK_ID.FRIEND] = {
			{
				scene = "friend",
				delay = 50,
				help_id = UNLOCK_ID.FRIEND
			}
		},
		[UNLOCK_ID.SUPPORT] = {
			{
				scene = "unit_ui",
				delay = 300,
				mode = function()
					return UnitMain:getMode() == "Support"
				end,
				help_id = UNLOCK_ID.SUPPORT
			}
		},
		[UNLOCK_ID.TUTORIAL_LOBBY] = {
			{
				scene = "lobby",
				message = "touch_worldmap_button",
				target = "btn_map",
				delay = 500
			},
			{
				scene = "worldmap_scene",
				message = "touch_summon_button",
				target = "btn_start",
				delay = 200
			},
			{
				scene = "worldmap_scene",
				delay = 0,
				help_id = UNLOCK_ID.TUTORIAL_LOBBY
			}
		},
		[UNLOCK_ID.DESTINY] = {
			{
				scene = "lobby",
				message = "touch_char_reward_sys_button",
				target = "btn_rel",
				delay = 1000
			},
			{
				scene = "lobby",
				message = "touch_summon_button",
				delay = 1000,
				target = "btn_get_on",
				tuto_end = true
			}
		},
		[UNLOCK_ID.CLAN] = {
			{
				scene = "clan",
				delay = 0,
				help_id = UNLOCK_ID.CLAN
			}
		},
		[UNLOCK_ID.CLAN_MAIN] = {
			{
				scene = "clan",
				delay = 0,
				help_id = UNLOCK_ID.CLAN_MAIN
			}
		},
		[UNLOCK_ID.CHAOS_1] = {
			{
				scene = "battle",
				message = "",
				target = function()
					return Battle.logic:getRoomObject(Battle.vars.tutorial_temp.target_id).model
				end,
				size = {
					width = 160,
					height = 160
				},
				pos = function()
					local var_22_0, var_22_1 = Battle.logic:getRoomObject(Battle.vars.tutorial_temp.target_id).model:getPosition()
					
					return BattleLayout:convertToScreenX(var_22_0), var_22_1
				end
			},
			{
				scene = "battle",
				delay = 0,
				help_id = "orbis_gate"
			}
		},
		[UNLOCK_ID.CHAOS_2] = {
			{
				scene = "battle",
				message = "",
				tuto_end = true,
				target = function()
					return Battle.logic:getRoomObject(Battle.vars.tutorial_temp.target_id).model
				end,
				size = {
					width = 160,
					height = 160
				},
				pos = function()
					local var_24_0, var_24_1 = Battle.logic:getRoomObject(Battle.vars.tutorial_temp.target_id).model:getPosition()
					
					return BattleLayout:convertToScreenX(var_24_0), var_24_1
				end
			}
		}
	}
	
	for iter_17_0 = 1, 9999 do
		local var_17_1 = {}
		
		var_17_1.id, var_17_1.type, var_17_1.scene, var_17_1.target, var_17_1.target_touch, var_17_1.target_scale, var_17_1.target_rotation, var_17_1.delay, var_17_1.npc_icon, var_17_1.npc_name, var_17_1.message, var_17_1.talkbox_l, var_17_1.eff, var_17_1.sound, var_17_1.talk_image, var_17_1.s_title, var_17_1.s_image, var_17_1.s_text, var_17_1.item_id, var_17_1.item_value, var_17_1.item_title, var_17_1.item_text, var_17_1.skip_btn, var_17_1.mode, var_17_1.proc, var_17_1.skip_if = DBN("tutorial_guide", iter_17_0, {
			"id",
			"type",
			"scene",
			"target",
			"target_touch",
			"target_scale",
			"target_rotation",
			"delay",
			"npc_icon",
			"npc_name",
			"message",
			"talkbox_l",
			"eff",
			"sound",
			"talk_image",
			"s_title",
			"s_image",
			"s_text",
			"item_id",
			"item_value",
			"item_title",
			"item_text",
			"skip_btn",
			"mode",
			"proc",
			"skip_if"
		})
		
		if not var_17_1.id then
			break
		end
		
		local var_17_2 = string.sub(var_17_1.id, 1, -4)
		
		if tonumber(string.sub(var_17_1.id, -2, -1)) == 1 then
			var_17_0[var_17_2] = {}
		end
		
		if var_17_1.target and string.starts(var_17_1.target, "*") then
			var_17_1.target = FUNCTION_MAP[string.sub(var_17_1.target, 2, -1)]
		end
		
		if var_17_1.proc and string.starts(var_17_1.proc, "*") then
			var_17_1.proc = FUNCTION_MAP[string.sub(var_17_1.proc, 2, -1)]
		end
		
		if var_17_1.mode and string.starts(var_17_1.mode, "*") then
			var_17_1.mode = FUNCTION_MAP[string.sub(var_17_1.mode, 2, -1)]
		end
		
		if var_17_1.skip_if and string.starts(var_17_1.skip_if, "*") then
			var_17_1.skip_if = FUNCTION_MAP[string.sub(var_17_1.skip_if, 2, -1)]
		end
		
		table.push(var_17_0[var_17_2], var_17_1)
	end
	
	return var_17_0
end

function TutorialDeprecate.showHelp2(arg_25_0, arg_25_1, arg_25_2)
	if type(arg_25_1) == "string" then
		arg_25_1 = {
			help_id = arg_25_1
		}
	end
	
	if arg_25_2 == nil then
		arg_25_2 = SceneManager:getRunningNativeScene()
	end
	
	local var_25_0 = arg_25_2:getChildByName("guide_help")
	
	if not var_25_0 then
		var_25_0 = load_dlg("guide_help", true, "wnd")
		
		local var_25_1 = load_dlg("help_content", true, "wnd")
		
		var_25_1:setAnchorPoint(0.5, 0.5)
		var_25_1:setPosition(0, 0)
		var_25_0:getChildByName("n_content"):addChild(var_25_1)
		var_25_0:setLocalZOrder(999999)
		var_25_0:setOpacity(0)
		arg_25_2:addChild(var_25_0)
		UIAction:Add(SEQ(DELAY(arg_25_1.delay or 200), LOG(SPAWN(SCALE(200, 0, 1), FADE_IN(200)))), var_25_0, "block")
	end
	
	arg_25_0:setupHelpWindow2(var_25_0, arg_25_1.help_id)
end

function TutorialDeprecate.showHelp(arg_26_0, arg_26_1, arg_26_2)
	if type(arg_26_1) == "string" then
		arg_26_1 = {
			help_id = arg_26_1
		}
	end
	
	if arg_26_2 == nil then
		arg_26_2 = SceneManager:getRunningNativeScene()
	end
	
	print(arg_26_1.help_id, DB("tutorial_help", arg_26_1.help_id, "id"))
	
	if DB("tutorial_help", arg_26_1.help_id, "id") then
		return arg_26_0:showHelp2(arg_26_1, arg_26_2)
	end
	
	local var_26_0 = load_dlg("help", true, "wnd")
	
	var_26_0:setLocalZOrder(999999)
	var_26_0:setOpacity(0)
	arg_26_2:addChild(var_26_0)
	UIAction:Add(SEQ(DELAY(arg_26_1.delay or 500), LOG(SPAWN(SCALE(300, 0, 1), FADE_IN(300)))), var_26_0, "block")
	arg_26_0:setupHelpWindow(var_26_0, arg_26_1.help_id)
	
	arg_26_0.help_dlg = var_26_0
end

function TutorialDeprecate.closeHelpWindow(arg_27_0)
	if arg_27_0.help_dlg and get_cocos_refid(arg_27_0.help_dlg) then
		arg_27_0.help_dlg:removeFromParent()
	end
	
	arg_27_0.help_dlg = nil
	
	arg_27_0:saveTutorial()
	arg_27_0:procGuide()
end

function TutorialDeprecate.closeHelpWindow2(arg_28_0, arg_28_1)
	arg_28_1:removeFromParent()
	arg_28_0:saveTutorial()
	arg_28_0:procGuide()
end

function TutorialDeprecate.prevHelpWindow(arg_29_0)
	arg_29_0:setupHelpWindow(arg_29_0.help_dlg, arg_29_0.help_id, arg_29_0.help_step - 1)
end

function TutorialDeprecate.nextHelpWindow(arg_30_0)
	arg_30_0:setupHelpWindow(arg_30_0.help_dlg, arg_30_0.help_id, arg_30_0.help_step + 1)
end

function TutorialDeprecate.setupHelpWindow2(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = SLOW_DB_ALL("tutorial_help", arg_31_2)
	
	HelpGuide:SetupHelpPage(arg_31_1, var_31_0, cc.c3b(200, 180, 160), cc.c3b(55, 20, 10))
end

function TutorialDeprecate.setupHelpWindow(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	arg_32_3 = arg_32_3 or 1
	
	local var_32_0 = cc.Sprite:create(string.format("tutorial/%s_%02d.png", arg_32_2, arg_32_3))
	
	if not var_32_0 then
		return 
	end
	
	if var_32_0 then
		var_32_0:setName("img")
		
		local var_32_1 = arg_32_1:getChildByName("img")
		
		if var_32_1 then
			var_32_1:removeFromParent()
		end
		
		arg_32_1:getChildByName("n_content"):addChild(var_32_0)
	end
	
	if_set_visible(arg_32_1, "n_btn_prev", arg_32_3 > 1)
	
	local var_32_2 = cc.FileUtils:getInstance():isFileExist(string.format("tutorial/%s_%02d.png", arg_32_2, arg_32_3 + 1))
	
	if_set_visible(arg_32_1, "n_btn_next", var_32_2)
	if_set_visible(arg_32_1, "n_btn_close", not var_32_2)
	
	arg_32_0.help_id = arg_32_2
	arg_32_0.help_step = arg_32_3
end

function HANDLER.help(arg_33_0, arg_33_1)
	if arg_33_1 == "btn_ok" or arg_33_1 == "btn_close" then
		TutorialDeprecate:closeHelpWindow()
	end
	
	if arg_33_1 == "btn_next" then
		TutorialDeprecate:nextHelpWindow()
	end
	
	if arg_33_1 == "btn_prev" then
		TutorialDeprecate:prevHelpWindow()
	end
end

function HANDLER.guide_help(arg_34_0, arg_34_1)
	if arg_34_1 == "btn_ok" or arg_34_1 == "btn_close" then
		TutorialDeprecate:closeHelpWindow2(getParentWindow(arg_34_0))
	end
end
