StoryLogger = {}

function StoryLogger.destroyWithViewer(arg_1_0)
	StoryLogger:destroy()
	StoryViewer:destroy()
end

function StoryLogger.init(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.vars = {}
	arg_2_0.vars.log = {}
	arg_2_0.vars.sort_uid = 0
	arg_2_0.vars.story_id = arg_2_1
end

function StoryLogger.getStoryText(arg_3_0, arg_3_1)
	local var_3_0 = ""
	
	return arg_3_1[story_text_locale_column()]
end

function StoryLogger.getStoryName(arg_4_0, arg_4_1)
	arg_4_1.text = arg_4_1.text or ""
	
	if not arg_4_1.name and not arg_4_1.talker and string.len(arg_4_1.text) ~= 0 then
		return "NARRATION"
	end
	
	local var_4_0, var_4_1 = DB("story_character", arg_4_1.name, {
		"id",
		"name"
	})
	
	if not var_4_0 then
		var_4_0, var_4_1 = DB("story_character", arg_4_1.talker, {
			"id",
			"name"
		})
	end
	
	if var_4_0 and not var_4_1 and string.len(arg_4_1.text) ~= 0 then
		return "NARRATION"
	end
	
	if arg_4_1.talker == "NARRATION" or arg_4_1.talker == "NARRATION2" or arg_4_1.talker == "LOCATION" or string.starts(arg_4_1.talker or "", "CHAPTER") then
		return arg_4_1.talker
	end
	
	if arg_4_1.movie and arg_4_1.moive ~= "" then
		return nil
	end
	
	if DB("text", var_4_1, "text") then
		var_4_1 = T(var_4_1)
	end
	
	return var_4_1
end

function StoryLogger.getStoryImage(arg_5_0, arg_5_1)
	local var_5_0 = DB("story_character", arg_5_1.name, "image") or DB("story_character", arg_5_1.talker, "image")
	
	if not var_5_0 then
		return "nothing"
	end
	
	if string.find(var_5_0, "fu") then
		var_5_0 = string.replace(var_5_0, "fu", "s")
	else
		var_5_0 = var_5_0 .. "_s"
	end
	
	return "face/" .. var_5_0
end

function StoryLogger.readCutActionBySubAction(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	if not is_using_story_v2() or not arg_6_1 or not arg_6_2 or not arg_6_3 then
		return 
	end
	
	if not arg_6_0.vars then
		Log.e("INVALID ACCESS AT STORY LOGGER. IS STORY LOGGER INIT OR INIT AFTER DESTORY?")
		StoryLogger:init()
	end
	
	local var_6_0 = (function(arg_7_0)
		local var_7_0 = DB("character", arg_7_0, "face_id")
		
		if not var_7_0 then
			var_7_0 = var_7_0 or DB("story_character", arg_7_0, "image")
			
			if not var_7_0 then
				return "nothing"
			end
		end
		
		if string.find(var_7_0, "fu") then
			var_7_0 = string.replace(var_7_0, "fu", "s")
		else
			var_7_0 = var_7_0 .. "_s"
		end
		
		return "face/" .. var_7_0
	end)(arg_6_1)
	local var_6_1 = arg_6_4 or arg_6_0.vars.sort_uid
	
	arg_6_0.vars.log[var_6_1] = {
		text = T(arg_6_2),
		name = T(arg_6_3),
		sub_id = var_6_1,
		story_id = arg_6_0.vars.story_id,
		image = var_6_0,
		sort = arg_6_0.vars.sort_uid
	}
	arg_6_0.vars.sort_uid = arg_6_0.vars.sort_uid + 1
end

function StoryLogger.readCutAction(arg_8_0, arg_8_1)
	if not is_using_story_v2() then
		return 
	end
	
	if not arg_8_0.vars then
		Log.e("INVALID ACCESS AT STORY LOGGER. IS STORY LOGGER INIT OR INIT AFTER DESTORY?")
		StoryLogger:init()
	end
	
	local function var_8_0(arg_9_0)
		arg_9_0.text = arg_9_0.text or ""
		
		if not arg_9_0.name and not arg_9_0.talker and string.len(arg_9_0.text) ~= 0 then
			return "NARRATION"
		end
		
		local var_9_0, var_9_1 = DB("story_character", arg_9_0.name, {
			"id",
			"name"
		})
		
		if not var_9_0 then
			var_9_0, var_9_1 = DB("story_character", arg_9_0.talker, {
				"id",
				"name"
			})
		end
		
		if var_9_0 and not var_9_1 and string.len(arg_9_0.text) ~= 0 then
			return "NARRATION"
		end
		
		if arg_9_0.talker == "NARRATION" or arg_9_0.talker == "NARRATION2" or arg_9_0.talker == "LOCATION" or string.starts(arg_9_0.talker or "", "CHAPTER") then
			return arg_9_0.talker
		end
		
		if arg_9_0.movie and arg_9_0.moive ~= "" then
			return nil
		end
		
		return nil
	end
	
	local var_8_1 = table.shallow_clone(arg_8_1)
	
	if not var_8_1.sub_id then
		return 
	end
	
	local var_8_2 = var_8_0(var_8_1)
	
	if not var_8_2 then
		return 
	end
	
	local var_8_3 = arg_8_0:getStoryText(var_8_1)
	
	if var_8_3 == "" or var_8_3 == nil then
		return 
	end
	
	local var_8_4 = arg_8_0:getStoryImage(var_8_1)
	local var_8_5 = sort or arg_8_0.vars.sort_uid
	
	arg_8_0.vars.log[arg_8_0.vars.sort_uid] = {
		text = var_8_3,
		name = var_8_2,
		sub_id = var_8_5,
		story_id = arg_8_0.vars.story_id,
		image = var_8_4,
		sort = arg_8_0.vars.sort_uid
	}
	arg_8_0.vars.sort_uid = arg_8_0.vars.sort_uid + 1
end

function StoryLogger.readCut(arg_10_0, arg_10_1)
	if not arg_10_0.vars then
		Log.e("INVALID ACCESS AT STORY LOGGER. IS STORY LOGGER INIT OR INIT AFTER DESTORY?")
		StoryLogger:init()
	end
	
	local var_10_0 = table.shallow_clone(arg_10_1)
	
	if not var_10_0.sub_id then
		return 
	end
	
	local var_10_1 = arg_10_0:getStoryName(var_10_0)
	
	if not var_10_1 then
		return 
	end
	
	local var_10_2 = arg_10_0:getStoryText(var_10_0)
	
	if var_10_2 == "" or var_10_2 == nil then
		return 
	end
	
	local var_10_3 = arg_10_0:getStoryImage(var_10_0)
	
	arg_10_0.vars.log[var_10_0.sub_id] = {
		text = var_10_2,
		name = var_10_1,
		balloon = var_10_0.balloon,
		sub_id = var_10_0.sub_id,
		story_id = arg_10_0.vars.story_id,
		talker = var_10_0.talker,
		image = var_10_3,
		sort = arg_10_0.vars.sort_uid
	}
	arg_10_0.vars.sort_uid = arg_10_0.vars.sort_uid + 1
end

function StoryLogger.readSelected(arg_11_0, arg_11_1)
	arg_11_0.vars.log["story_select_" .. arg_11_0.vars.sort_uid] = {
		name = "SELECT",
		story_id = "",
		balloon = "SELECT",
		image = "",
		talker = "SELECT",
		sub_id = "",
		text = arg_11_1,
		sort = arg_11_0.vars.sort_uid
	}
	arg_11_0.vars.sort_uid = arg_11_0.vars.sort_uid + 1
end

function StoryLogger.getStoryLogs(arg_12_0)
	if not arg_12_0.vars then
		return false
	end
	
	local var_12_0 = {}
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0.vars.log) do
		var_12_0[#var_12_0 + 1] = iter_12_1
	end
	
	table.sort(var_12_0, function(arg_13_0, arg_13_1)
		return arg_13_0.sort < arg_13_1.sort
	end)
	
	return var_12_0, arg_12_0.vars.story_id
end

function StoryLogger.destroy(arg_14_0)
	arg_14_0.vars = nil
end

StoryViewer = {}

function HANDLER.story_log(arg_15_0, arg_15_1)
	if arg_15_1 == "btn_close" then
		StoryViewer:close()
	end
end

function StoryViewer.isInited(arg_16_0)
	return arg_16_0.vars ~= nil
end

function StoryViewer.init(arg_17_0)
	arg_17_0.vars = {}
	arg_17_0.vars.logs = {}
	arg_17_0.vars.hash_tbl = {}
	arg_17_0.vars.sort_uid = 0
end

function StoryViewer.procNext(arg_18_0)
	local var_18_0, var_18_1 = StoryLogger:getStoryLogs()
	
	if not var_18_0 then
		return 
	end
	
	arg_18_0.vars.logs[var_18_1] = var_18_0
	arg_18_0.vars.logs[var_18_1].sort_uid = arg_18_0.vars.sort_uid
	arg_18_0.vars.sort_uid = arg_18_0.vars.sort_uid + 1
end

function StoryViewer.skipStory(arg_19_0, arg_19_1, arg_19_2)
	for iter_19_0, iter_19_1 in pairs(arg_19_1) do
		if arg_19_2 < iter_19_0 then
			for iter_19_2, iter_19_3 in pairs(iter_19_1 or {}) do
				if iter_19_3.movie or iter_19_3.illust then
					arg_19_0:procNext()
					
					return 
				end
				
				if not is_using_story_v2() then
					StoryLogger:readCut(iter_19_3)
				else
					StoryLogger:readCutAction(iter_19_3)
					
					if iter_19_3.story_action then
						local var_19_0 = STORY_ACTION_MANAGER:getTextSubActionByActionID(iter_19_3.story_action)
						
						if var_19_0 then
							for iter_19_4, iter_19_5 in pairs(var_19_0) do
								StoryLogger:readCutActionBySubAction(iter_19_5.code, iter_19_5.text, iter_19_5.name)
							end
						end
					end
				end
			end
		end
	end
	
	arg_19_0:procNext()
end

function StoryViewer.getNameNode(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = ""
	local var_20_1 = false
	
	if arg_20_2.name == "NARRATION" or arg_20_2.name == "NARRATION2" or arg_20_2.name == "LOCATION" or string.starts(arg_20_2.name or "", "CHAPTER") or arg_20_2.balloon == "caption" then
		var_20_0 = "n_narration"
	elseif arg_20_2.name == "SELECT" then
		var_20_0 = "n_selected"
	elseif arg_20_2.balloon == "mono" then
		var_20_0 = "n_monologue"
		var_20_1 = true
	else
		var_20_0 = "n_normal"
		var_20_1 = true
	end
	
	if_set_visible(arg_20_1, "n_face", var_20_1)
	
	return arg_20_1:findChildByName(var_20_0), var_20_0
end

function StoryViewer.setRendererSize(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_1:getContentSize()
	local var_21_1, var_21_2 = arg_21_0:getNameNode(arg_21_1, arg_21_2)
	local var_21_3 = var_21_1:findChildByName("txt_info")
	local var_21_4 = var_21_3:getContentSize()
	local var_21_5 = var_21_3:getStringNumLines()
	
	var_21_4.height = var_21_4.height + (var_21_5 - 2) * 24
	
	local var_21_6 = (var_21_5 - 2) * 24
	
	if var_21_6 < 0 then
		var_21_6 = 0
	end
	
	if var_21_2 == "n_narration" then
		arg_21_1:setContentSize({
			width = var_21_0.width,
			height = var_21_0.height + var_21_6
		})
		arg_21_1:findChildByName("n_narration"):setPositionY(25 - var_21_6)
	else
		var_21_3:setContentSize(var_21_4)
		arg_21_1:setContentSize({
			width = var_21_0.width,
			height = var_21_0.height + var_21_6
		})
		arg_21_1:findChildByName("n_talk"):setPositionY(20 + var_21_6)
	end
	
	arg_21_1:setPositionY(var_21_6)
end

function StoryViewer.onUpdate(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0, var_22_1 = arg_22_0:getNameNode(arg_22_1, arg_22_2)
	local var_22_2 = arg_22_1:findChildByName("face")
	
	if string.find(arg_22_2.image, "none") then
		arg_22_2.image = "nothing"
	end
	
	local var_22_3
	
	if arg_22_0.vars.hash_tbl[arg_22_2.image] ~= nil then
		var_22_3 = arg_22_0.vars.hash_tbl[arg_22_2.image]
	else
		local var_22_4 = arg_22_2.image
		
		if not string.ends(var_22_4, ".png") and not string.ends(var_22_4, ".sct") then
			var_22_4 = var_22_4 .. ".png"
		end
		
		local var_22_5 = cc.FileUtils:getInstance():fullPathForFilename(var_22_4)
		
		arg_22_0.vars.hash_tbl[arg_22_2.image] = var_22_5 ~= nil and string.len(var_22_5) ~= 0
		var_22_3 = arg_22_0.vars.hash_tbl[arg_22_2.image]
	end
	
	if var_22_3 then
		var_22_2:setScale(1)
		if_set_sprite(var_22_2, nil, arg_22_2.image)
	else
		var_22_2:setScale(1.2)
		if_set_sprite(var_22_2, nil, "img/_hero_s_bg_las.png")
	end
	
	local var_22_6 = var_22_0:findChildByName("title_bg")
	
	if get_cocos_refid(var_22_6) then
		UIUserData:call(var_22_6, string.format("AUTOSIZE_WIDTH(txt_name, 1, %d)", var_22_1 == "n_monologue" and 30 or 100))
	end
	
	local var_22_7 = var_22_0:findChildByName("txt_name")
	
	if get_cocos_refid(var_22_7) then
		UIUserData:call(var_22_7, string.format("RELATIVE_X_POS(.., 0, %d)", var_22_1 == "n_monologue" and 11 or 30))
	end
	
	local var_22_8 = arg_22_2.text
	
	if var_22_8 and arg_22_2.name == "LOCATION" then
		var_22_8 = "- " .. var_22_8
	end
	
	if_set(var_22_0, "txt_name", arg_22_2.name)
	if_set(var_22_0, "txt_info", var_22_8)
	if_set_visible(arg_22_1, "n_monologue", false)
	if_set_visible(arg_22_1, "n_normal", false)
	if_set_visible(arg_22_1, "n_narration", false)
	if_set_visible(var_22_0, nil, true)
	arg_22_0:setRendererSize(arg_22_1, arg_22_2)
end

function StoryViewer.rollbackSizeNode(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0
	local var_23_1
	
	if arg_23_3 == nil then
		var_23_0 = arg_23_1
		var_23_1 = arg_23_2
	else
		var_23_0 = arg_23_1:findChildByName(arg_23_3)
		var_23_1 = arg_23_2:findChildByName(arg_23_3)
	end
	
	var_23_0:setContentSize(var_23_1:getContentSize())
end

function StoryViewer.onSize(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	local var_24_0 = arg_24_0:getNameNode(arg_24_1, arg_24_4)
	
	if_set(var_24_0, "txt_info", arg_24_4.text)
	arg_24_0:setRendererSize(arg_24_1, arg_24_4)
	arg_24_3:setContentSize(arg_24_1:getContentSize())
	if_set(var_24_0, "txt_info", "")
	
	local var_24_1 = arg_24_0:getNameNode(arg_24_2, arg_24_4)
	
	arg_24_0:rollbackSizeNode(var_24_0, var_24_1, "txt_info")
	arg_24_0:rollbackSizeNode(arg_24_1, arg_24_2)
end

function StoryViewer.getTexts(arg_25_0)
	StoryViewer:procNext()
	
	local var_25_0 = {}
	
	for iter_25_0, iter_25_1 in pairs(arg_25_0.vars.logs) do
		var_25_0[#var_25_0 + 1] = iter_25_1
		var_25_0[#var_25_0].sort_uid = iter_25_1.sort_uid
	end
	
	table.sort(var_25_0, function(arg_26_0, arg_26_1)
		return arg_26_0.sort_uid < arg_26_1.sort_uid
	end)
	
	local var_25_1 = {}
	
	for iter_25_2 = 1, #var_25_0 do
		local var_25_2 = var_25_0[iter_25_2]
		
		var_25_1[iter_25_2] = {}
		
		for iter_25_3 = 1, #var_25_2 do
			local var_25_3 = var_25_2[iter_25_3]
			
			table.insert(var_25_1[iter_25_2], var_25_3)
		end
	end
	
	return var_25_1
end

function StoryViewer.show(arg_27_0)
	local var_27_0 = arg_27_0:getTexts()
	local var_27_1 = load_dlg("story_log", true, "wnd", function()
		StoryViewer:close()
	end)
	local var_27_2 = SceneManager:getRunningPopupScene()
	local var_27_3 = var_27_1:findChildByName("listview")
	local var_27_4 = GroupListView:bindControl(var_27_3)
	local var_27_5 = load_control("wnd/story_log_division.csb")
	local var_27_6 = {
		onUpdate = function(arg_29_0, arg_29_1, arg_29_2)
		end
	}
	local var_27_7 = load_control("wnd/story_log_txt.csb")
	local var_27_8 = {
		onUpdate = function(arg_30_0, arg_30_1, arg_30_2)
			StoryViewer:onUpdate(arg_30_1, arg_30_2)
		end,
		onSize = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
			StoryViewer:onSize(arg_31_1, arg_31_2, arg_31_3, arg_31_4)
		end
	}
	
	var_27_4:setRenderer(var_27_5, var_27_7, var_27_6, var_27_8)
	var_27_4:removeAllChildren()
	
	for iter_27_0 = 1, #var_27_0 do
		var_27_4:addGroup(iter_27_0, var_27_0[iter_27_0])
	end
	
	var_27_2:addChild(var_27_1)
	var_27_1:bringToFront()
	var_27_4:scrollToBottom()
	
	arg_27_0.vars.dlg = var_27_1
	
	STORY_ACTION_MANAGER:setAllModelAnim(true)
end

function StoryViewer.close(arg_32_0)
	if arg_32_0.vars and get_cocos_refid(arg_32_0.vars.dlg) then
		BackButtonManager:pop("story_log")
		arg_32_0.vars.dlg:removeFromParent()
		STORY_ACTION_MANAGER:setAllModelAnim(false)
	end
end

function StoryViewer.destroy(arg_33_0)
	arg_33_0:close()
	
	arg_33_0.vars = nil
end

function StoryViewer.isActive(arg_34_0)
	return arg_34_0.vars and get_cocos_refid(arg_34_0.vars.dlg)
end
