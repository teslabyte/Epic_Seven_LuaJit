StoryReady = {}

function HANDLER.story_ready(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	if arg_1_1 == "btn_close" then
		StoryReady:hide()
	end
	
	if arg_1_1 == "btn_go" then
		StoryReady:enterStory()
	end
	
	if arg_1_1 == "btn_simple_info" then
		StoryReady:showSimpleInfo(false)
	end
end

function StoryReady.show(arg_2_0, arg_2_1)
	if arg_2_0.vars and get_cocos_refid(arg_2_0.vars.dlg) then
		return 
	end
	
	local var_2_0 = arg_2_1
	
	arg_2_0.vars = {}
	arg_2_0.vars.dlg = load_dlg("story_ready", true, "wnd")
	arg_2_0.vars.enter_id = var_2_0.enter_id
	arg_2_0.vars.cook_type = var_2_0.cook_type
	arg_2_0.vars.arcade_type = var_2_0.arcade_type
	arg_2_0.vars.repair_type = var_2_0.repair_type
	arg_2_0.vars.exorcist_type = var_2_0.exorcist_type
	
	SceneManager:getRunningNativeScene():addChild(arg_2_0.vars.dlg)
	
	local function var_2_1()
		StoryReady:hide()
	end
	
	BackButtonManager:push({
		check_id = "story_ready",
		back_func = var_2_1
	})
	arg_2_0:updateUI()
end

function StoryReady.hide(arg_4_0)
	BackButtonManager:pop("story_ready")
	
	if get_cocos_refid(arg_4_0.vars.dlg) then
		arg_4_0.vars.dlg:removeFromParent()
	end
end

function StoryReady.setPortrait(arg_5_0, arg_5_1)
	if not arg_5_1 then
		return 
	end
	
	local var_5_0 = arg_5_0.vars.dlg:getChildByName("n_portrait")
	local var_5_1 = string.split(arg_5_1, "&")
	local var_5_2 = var_5_1[1]
	local var_5_3 = var_5_1[2]
	local var_5_4, var_5_5 = DB("character", var_5_2, {
		"name",
		"face_id"
	})
	
	if var_5_4 then
		if_set(arg_5_0.vars.dlg, "txt_name", T(var_5_4))
	end
	
	if var_5_5 then
		local var_5_6, var_5_7 = UIUtil:getPortraitAni(var_5_5, {
			pin_sprite_position_y = true
		})
		
		if get_cocos_refid(var_5_6) then
			if not var_5_7 then
				var_5_6:setPositionY(var_5_6:getPositionY() + 400)
			end
			
			var_5_6:setScaleX(-1)
			var_5_0:addChild(var_5_6)
			
			if var_5_3 == "flip_x" then
				var_5_6:setScaleX(-var_5_6:getScaleX())
			end
		end
	end
end

function StoryReady.updateUI(arg_6_0)
	local var_6_0, var_6_1, var_6_2, var_6_3 = DB("level_enter", arg_6_0.vars.enter_id, {
		"name",
		"local",
		"type",
		"tag_icon"
	})
	
	arg_6_0.vars.tag_icon_name = decodeTownTagIcon(var_6_3)
	
	if_set_visible(arg_6_0.vars.dlg, "n_simple_info", false)
	
	if arg_6_0.vars.tag_icon_name then
		if_set_sprite(arg_6_0.vars.dlg, "spr_tag_icon", "map/" .. arg_6_0.vars.tag_icon_name .. ".png")
		arg_6_0:showSimpleInfo(true, 360, true)
	end
	
	if_set_visible(arg_6_0.vars.dlg, "spr_tag_icon", arg_6_0.vars.tag_icon_name and true)
	
	local var_6_4 = StoryMapUtil:getPlayStoryData(arg_6_0.vars.enter_id)
	
	if_set(arg_6_0.vars.dlg, "txt_zone", T(var_6_1))
	if_set(arg_6_0.vars.dlg, "txt_title", T(var_6_0))
	if_set(arg_6_0.vars.dlg, "sub_title", T(var_6_4.title))
	arg_6_0:setPortrait(var_6_4.enter_portrait)
	
	local var_6_5 = arg_6_0.vars.dlg:getChildByName("btn_go")
	
	if get_cocos_refid(var_6_5) then
		UIUtil:setButtonEnterInfo(var_6_5, arg_6_0.vars.enter_id)
	end
	
	if var_6_4.desc then
		if_set(arg_6_0.vars.dlg, "disc", T(var_6_4.desc))
	end
	
	local var_6_6 = {}
	local var_6_7 = UIUtil:setMsgCheckEnterMapErr(arg_6_0.vars.enter_id, var_6_6)
	
	if arg_6_0.vars.cook_type then
		if_set(arg_6_0.vars.dlg, "title", T("ui_story_ready_cook_title"))
		if_set(arg_6_0.vars.dlg:getChildByName("small_info"), "label", T("ui_story_ready_cook_desc"))
		if_set(arg_6_0.vars.dlg:getChildByName("btn_go"), "label", T("ui_story_ready_btn_cook"))
	elseif arg_6_0.vars.arcade_type or arg_6_0.vars.repair_type or arg_6_0.vars.exorcist_type then
		if_set(arg_6_0.vars.dlg, "title", T("ui_story_ready_arcade_title"))
		if_set(arg_6_0.vars.dlg:getChildByName("small_info"), "label", T("ui_story_ready_arcade_desc"))
		if_set(arg_6_0.vars.dlg:getChildByName("btn_go"), "label", T("ui_story_ready_btn_arcade"))
	end
end

function StoryReady.showSimpleInfo(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if not arg_7_0.vars.tag_icon_name then
		return 
	end
	
	if arg_7_0.vars.hide_tag_icon_text then
		return 
	elseif not DB("text", arg_7_0.vars.tag_icon_name, {
		"id"
	}) then
		arg_7_0.vars.hide_tag_icon_text = true
		
		return 
	end
	
	local var_7_0 = arg_7_0.vars.dlg:getChildByName("n_simple_info")
	
	UIAction:Remove(var_7_0)
	
	if arg_7_1 then
		var_7_0:setVisible(true)
		var_7_0:setScale(0)
		
		local var_7_1 = 1
		local var_7_2 = NONE()
		
		if arg_7_3 then
			var_7_2 = SEQ(DELAY(3000), RLOG(SCALE(80, 1, 0)), SHOW(false))
		end
		
		UIAction:Add(SEQ(DELAY(to_n(arg_7_2)), LOG(SCALE(150, 0, var_7_1 * 1.1)), DELAY(50), RLOG(SCALE(80, var_7_1 * 1.1, var_7_1)), var_7_2), var_7_0)
		if_set(arg_7_0.vars.dlg, "txt_simple_info", T(arg_7_0.vars.tag_icon_name))
	else
		UIAction:Add(SEQ(RLOG(SCALE(80, 1, 0)), SHOW(false)), var_7_0)
	end
end

function StoryReady.enterStory(arg_8_0)
	arg_8_0:hide()
	
	local var_8_0 = DB("level_enter", arg_8_0.vars.enter_id, {
		"type"
	})
	
	if WORLDMAP_MODE_LIST[var_8_0] then
		WorldMapManager:getController():saveLastTown(arg_8_0.vars.enter_id)
	end
	
	SoundEngine:stopAllMusic()
	
	if arg_8_0.vars.cook_type then
		SceneManager:nextScene("mini_cook", {
			enter_id = arg_8_0.vars.enter_id
		})
	elseif var_8_0 and var_8_0 == "repair" then
		SceneManager:nextScene("mini_repair", {
			enter_id = arg_8_0.vars.enter_id
		})
	elseif var_8_0 and var_8_0 == "arcade" then
		MiniDefenceMain:enterGame(arg_8_0.vars.enter_id)
	elseif var_8_0 and var_8_0 == "exorcist" then
		SceneManager:nextScene("mini_exorcist", {
			enter_id = arg_8_0.vars.enter_id
		})
	else
		SceneManager:nextScene("storymap", {
			enter_id = arg_8_0.vars.enter_id
		})
	end
end
