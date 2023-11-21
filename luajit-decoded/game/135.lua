SubstoryRumble = {}

function HANDLER.dungeon_rumble(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_start" then
		if SubstoryManager:checkEndEvent() then
			balloon_message_with_sound("end_sub_story_event")
		else
			SceneManager:nextScene("rumble")
		end
	elseif arg_1_1 == "btn_hero" then
		SubstoryRumble:onButtonHero()
	elseif arg_1_1 == "btn_achieve" then
		SubstoryAchievePopup:show(SubstoryRumble:getLayer(), {
			callback_update = function()
				SubstoryRumble:updateAchieveNoti()
			end
		})
	end
end

function SubstoryRumble.show(arg_3_0, arg_3_1)
	if arg_3_0.vars and get_cocos_refid(arg_3_0.vars.wnd) then
		return 
	end
	
	arg_3_1 = arg_3_1 or {}
	arg_3_0.vars = {}
	arg_3_0.vars.wnd = load_dlg("dungeon_rumble", true, "wnd")
	arg_3_0.vars.layer = arg_3_1.parent_layer or SceneManager:getRunningNativeScene()
	
	arg_3_0.vars.layer:addChild(arg_3_0.vars.wnd)
	TopBarNew:createFromPopup(T("rumble_title"), arg_3_0.vars.wnd, function()
		arg_3_0:close()
	end, nil, "rumble")
	
	local var_3_0 = {
		"crystal",
		"gold"
	}
	
	TopBarNew:setCurrencies(var_3_0)
	arg_3_0:initData()
	arg_3_0:initUI()
	if_set_sprite(arg_3_0.vars.wnd, "n_bg", UIUtil:getIllustPath("story/bg/", arg_3_0:getConfig("rumble_main_bg")))
	arg_3_0:updateHeroNoti()
	arg_3_0:updateAchieveNoti()
	SoundEngine:playBGM("event:/bgm/fmf2023_Battle2_Loop")
	TutorialGuide:procGuide("rumble_start")
end

function SubstoryRumble.getLayer(arg_5_0)
	return arg_5_0.vars and arg_5_0.vars.layer
end

function SubstoryRumble.initData(arg_6_0)
	if not arg_6_0.vars then
		return 
	end
	
	arg_6_0.vars.info = Account:getSubStoryRumble()
	arg_6_0.vars.config = {}
	
	for iter_6_0 = 1, 99 do
		local var_6_0, var_6_1 = DBN("rumble_config", iter_6_0, {
			"key",
			"value"
		})
		
		if not var_6_0 then
			break
		end
		
		arg_6_0.vars.config[var_6_0] = var_6_1
	end
	
	arg_6_0.vars.schedule = RumbleUtil:getRumbleSchedule()
end

function SubstoryRumble.getConfig(arg_7_0, arg_7_1)
	if not arg_7_0.vars or not arg_7_0.vars.config then
		return 
	end
	
	return arg_7_0.vars.config[arg_7_1]
end

function SubstoryRumble.initUI(arg_8_0)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.wnd) then
		return 
	end
	
	local var_8_0 = arg_8_0.vars.info
	local var_8_1 = var_8_0 and var_8_0.max_stage_count > 0
	
	if var_8_1 then
		local var_8_2 = arg_8_0.vars.wnd:getChildByName("n_record")
		
		if var_8_0.unit_list then
			local var_8_3 = json.decode(var_8_0.unit_list) or {}
			
			table.sort(var_8_3, RumbleUtil.sortLineUp)
			
			for iter_8_0, iter_8_1 in ipairs(var_8_3) do
				local var_8_4 = var_8_2:getChildByName("n_unit" .. iter_8_0)
				
				if not get_cocos_refid(var_8_4) then
					break
				end
				
				local var_8_5 = RumbleUtil:getHeroIcon(iter_8_1.c, {
					show_info = true,
					devote = RumbleUtil:getDevoteGrade(iter_8_1.c, iter_8_1.d)
				})
				
				if var_8_5 then
					var_8_4:addChild(var_8_5)
				end
			end
		end
		
		if_set(var_8_2, "txt_result", T("rumble_enter_records_highestrecord_count", {
			count = to_n(var_8_0.max_stage_count)
		}))
		if_set(var_8_2, "txt_point", to_n(var_8_0.clear_count))
	end
	
	if_set_visible(arg_8_0.vars.wnd, "n_record", var_8_1)
	if_set_visible(arg_8_0.vars.wnd, "n_info", not var_8_1)
	
	local var_8_6 = arg_8_0.vars.wnd:getChildByName("n_reward")
	
	if get_cocos_refid(var_8_6) then
		for iter_8_2 = 1, 3 do
			local var_8_7 = var_8_6:getChildByName("n_" .. iter_8_2)
			local var_8_8 = arg_8_0:getConfig("rumble_core_reward_id_" .. iter_8_2)
			
			if not var_8_8 or not get_cocos_refid(var_8_7) then
				break
			end
			
			if string.starts(var_8_8, "e") then
				local var_8_9 = string.split(var_8_8, ",") or {}
				local var_8_10 = var_8_9[1]
				
				if var_8_10 then
					UIUtil:getRewardIcon(1, var_8_10, {
						zero = true,
						parent = var_8_7,
						grade = to_n(var_8_9[2]),
						set_fx = var_8_9[3]
					})
				end
			else
				UIUtil:getRewardIcon(1, var_8_8, {
					zero = true,
					parent = var_8_7
				})
			end
		end
	end
	
	local var_8_11 = SubstoryManager:getInfo() or {}
	local var_8_12, var_8_13, var_8_14 = SubstoryManager:getEventTimeInfo()
	
	if_set_opacity(arg_8_0.vars.wnd, "btn_start", SubstoryManager:checkEndEvent() and 76.5 or 255)
	if_set_visible(arg_8_0.vars.wnd, "btn_achieve", var_8_11.achieve_flag and var_8_11.achieve_flag == "y" and var_8_12 == SUBSTORY_CONSTANTS.STATE_OPEN)
end

function SubstoryRumble.updateHeroNoti(arg_9_0)
	if not arg_9_0.vars then
		return 
	end
	
	local var_9_0 = SAVE:get("rumble.hero_noti")
	
	if_set_visible(arg_9_0.vars.wnd, "n_hero_noti", arg_9_0.vars.schedule ~= var_9_0)
end

function SubstoryRumble.updateAchieveNoti(arg_10_0)
	if not arg_10_0.vars or not get_cocos_refid(arg_10_0.vars.wnd) then
		return 
	end
	
	local var_10_0 = arg_10_0.vars.wnd:getChildByName("btn_achieve")
	local var_10_1 = SubstoryUIUtil:isAchieveNotifier()
	
	if_set_visible(var_10_0, "n_noti", var_10_1)
end

function SubstoryRumble.onButtonHero(arg_11_0)
	if not arg_11_0.vars then
		return 
	end
	
	RumbleCollection:show()
	SAVE:set("rumble.hero_noti", arg_11_0.vars.schedule)
	if_set_visible(arg_11_0.vars.wnd, "n_hero_noti", false)
end

function SubstoryRumble.close(arg_12_0)
	if not arg_12_0.vars or not get_cocos_refid(arg_12_0.vars.wnd) then
		return 
	end
	
	TopBarNew:pop()
	BackButtonManager:pop("dungeon_rumble")
	arg_12_0.vars.wnd:removeFromParent()
	
	arg_12_0.vars = nil
end
