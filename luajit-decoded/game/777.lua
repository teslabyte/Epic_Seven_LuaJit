SPLStorySystem = {}

function SPLStorySystem.init(arg_1_0, arg_1_1)
	arg_1_0.vars = {}
	arg_1_0.vars.layer = arg_1_1
	arg_1_0.vars.play_queue = {}
	
	local function var_1_0()
		local var_2_0 = load_dlg("guide_talk", true, "wnd"):getChildByName("n_talk")
		local var_2_1 = var_2_0:getChildByName("arrow_t_0")
		
		if get_cocos_refid(var_2_1) then
			var_2_1:setRotation(90)
			var_2_1:setPosition(-5, -70)
		end
		
		return var_2_0:clone()
	end
	
	local function var_1_1()
		local var_3_0 = load_dlg("dungeon_heritage_talk_balloon", true, "wnd")
		local var_3_1 = var_3_0:getChildByName("n_ballon_l")
		local var_3_2 = var_3_0:getChildByName("n_ballon_r")
		
		return var_3_1:clone(), var_3_2:clone()
	end
	
	arg_1_0.vars.story_pref = var_1_0()
	arg_1_0.vars.speech_pref_l, arg_1_0.vars.speech_pref_r = var_1_1()
	
	arg_1_0.vars.layer:addChild(arg_1_0.vars.story_pref)
	arg_1_0.vars.layer:addChild(arg_1_0.vars.speech_pref_l)
	arg_1_0.vars.layer:addChild(arg_1_0.vars.speech_pref_r)
	if_set_visible(arg_1_0.vars.story_pref, nil, false)
	if_set_visible(arg_1_0.vars.speech_pref_l, nil, false)
	if_set_visible(arg_1_0.vars.speech_pref_r, nil, false)
end

function SPLStorySystem.playEpicStory(arg_4_0, arg_4_1, arg_4_2)
	SPLEventSystem:pause()
	
	arg_4_2 = arg_4_2 or {}
	
	function arg_4_2.on_finish()
		SPLSystem:setVisible(true)
		SPLEventSystem:resume()
	end
	
	play_story(arg_4_1, arg_4_2)
	SPLSystem:setVisible(false)
end

function SPLStorySystem.playSpeech(arg_6_0, arg_6_1)
	if not arg_6_0.vars then
		return 
	end
	
	local function var_6_0(arg_7_0)
		local var_7_0 = arg_7_0:getTargetObject()
		
		if var_7_0 and var_7_0:isModel() then
			local var_7_1 = (arg_7_0:isReflect() == "y" and arg_6_0.vars.speech_pref_l or arg_6_0.vars.speech_pref_r):clone()
			
			if_set(var_7_1, "txt_disc", T(arg_7_0:getText()))
			if_set_visible(var_7_1, nil, true)
			
			local var_7_2 = var_7_0:getUID()
			local var_7_3, var_7_4 = arg_7_0:getOffset()
			local var_7_5 = SPLObjectRenderer:addObjectUI(var_7_2, var_7_1, {
				offset_x = var_7_3,
				offset_y = var_7_4
			})
			
			if var_7_5 then
				var_7_5:setAdjustScale(0)
				
				return SEQ(LINEAR_CALL(200, var_7_5, "setAdjustScale", 0, 1), DELAY(arg_7_0:getDelay()), LINEAR_CALL(200, var_7_5, "setAdjustScale", 1, 0), CALL(function()
					SPLObjectRenderer:removeObjectUI(var_7_2)
				end))
			end
		end
		
		return NONE()
	end
	
	local var_6_1 = {}
	
	for iter_6_0 = 1, 99 do
		local var_6_2 = SPLSpeechData(arg_6_1, iter_6_0)
		
		if not var_6_2:getStoryID() then
			break
		end
		
		table.insert(var_6_1, var_6_0(var_6_2))
	end
	
	SPLEventSystem:pause()
	
	local var_6_3 = SEQ(table.unpack(var_6_1))
	local var_6_4 = CALL(function()
		SPLEventSystem:resume()
	end)
	
	UIAction:Add(SEQ(var_6_3, var_6_4), arg_6_0.vars.layer, "block")
end

function SPLStorySystem.playStory(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0.vars then
		return 
	end
	
	local var_10_0 = ccui.Button:create()
	
	var_10_0:setTouchEnabled(true)
	var_10_0:ignoreContentAdaptWithSize(false)
	var_10_0:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	var_10_0:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	var_10_0:setLocalZOrder(1)
	var_10_0:addTouchEventListener(function(arg_11_0, arg_11_1)
		if arg_11_1 ~= 2 then
			return 
		end
		
		if UIAction:Find("block") then
			return 
		end
		
		arg_10_0:procStory()
	end)
	
	arg_10_0.vars.story_btn = var_10_0
	
	arg_10_0.vars.layer:addChild(var_10_0)
	
	arg_10_0.vars.cur_story = arg_10_1
	arg_10_0.vars.play_queue = {}
	
	for iter_10_0 = 1, 99 do
		local var_10_1 = SPLStoryData(arg_10_1, iter_10_0)
		
		if not var_10_1:getStoryID() then
			break
		end
		
		table.insert(arg_10_0.vars.play_queue, var_10_1)
	end
	
	SPLEventSystem:pause()
	arg_10_0:procStory()
end

local function var_0_0(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_1 then
		return 0, 0
	end
	
	local var_12_0 = {}
	
	var_12_0.alignment, var_12_0.x, var_12_0.y = unpack(string.split(arg_12_1, ","))
	var_12_0.alignment = string.trim(var_12_0.alignment)
	var_12_0.x = var_12_0.x or 0
	var_12_0.y = var_12_0.y or 0
	
	local var_12_1 = {
		left = function()
			local var_13_0 = math.min(VIEW_BASE_LEFT + var_12_0.x, VIEW_BASE_RIGHT - arg_12_2.width)
			local var_13_1 = math.min(var_12_0.y, VIEW_HEIGHT - arg_12_2.height)
			
			return var_13_0, var_13_1
		end,
		right = function()
			local var_14_0 = math.max(VIEW_BASE_LEFT, VIEW_BASE_RIGHT - arg_12_2.width - var_12_0.x)
			local var_14_1 = math.min(var_12_0.y, VIEW_HEIGHT - arg_12_2.height)
			
			return var_14_0, var_14_1
		end,
		center = function()
			local var_15_0 = {
				x = 640 - arg_12_2.width * 0.5,
				y = 360 - arg_12_2.height * 0.5
			}
			local var_15_1 = math.max(VIEW_BASE_LEFT, math.min(var_15_0.x + var_12_0.x, VIEW_BASE_RIGHT - arg_12_2.width))
			local var_15_2 = math.min(var_15_0.y + var_12_0.y, VIEW_HEIGHT - arg_12_2.height)
			
			return var_15_1, var_15_2
		end
	}
	
	if not var_12_1[var_12_0.alignment] then
		Log.e("Error invalid talkbox_l: " .. arg_12_0 .. ", " .. var_12_0.alignment)
		
		return 0, 0
	end
	
	return var_12_1[var_12_0.alignment]()
end

function SPLStorySystem.makeStoryDlg(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.vars.story_pref:clone()
	
	if not get_cocos_refid(var_16_0) then
		return 
	end
	
	local var_16_1 = var_16_0:getChildByName("txt_disc")
	
	if not get_cocos_refid(var_16_1) then
		return 
	end
	
	local var_16_2 = var_16_0:getChildByName("box_bg")
	
	if not get_cocos_refid(var_16_2) then
		return 
	end
	
	local var_16_3 = var_16_0:getChildByName("n_talk_box")
	
	if not get_cocos_refid(var_16_3) then
		return 
	end
	
	local var_16_4 = var_16_0:getChildByName("cm_talk_title")
	
	if not get_cocos_refid(var_16_4) then
		return 
	end
	
	local var_16_5 = T(arg_16_1:getText())
	
	var_16_0:setName(var_16_0:getName() .. "_clone")
	if_set(var_16_0, "talk_name", T(arg_16_1:getName()))
	if_set_sprite(var_16_0, "talk_face", "face/" .. arg_16_1:getIcon() .. "_s.png")
	UIUserData:call(var_16_4, string.format("AUTOSIZE_WIDTH(../talk_name, 1, 135, 250, 1000)"))
	
	local var_16_6 = var_16_1:getContentSize()
	
	if_set(var_16_1, nil, string.gsub(var_16_5, "%\\n", "\n"))
	
	local var_16_7 = var_16_1:getContentSize()
	
	if getUserLanguage() ~= "ja" or not string.find(var_16_5, "\n") then
		local var_16_8 = VIEW_WIDTH * 0.78
		local var_16_9 = 100
		
		if var_16_8 < var_16_7.width then
			local var_16_10 = var_16_1:getLineHeight()
			local var_16_11 = math.ceil(var_16_7.width / var_16_8)
			local var_16_12 = var_16_7.width / var_16_11 + var_16_9
			
			var_16_1:setTextAreaSize({
				width = var_16_12,
				height = var_16_10 * var_16_11
			})
			var_16_1:setTextAreaSize({
				width = var_16_12,
				height = var_16_10 * var_16_1:getStringNumLines()
			})
			
			var_16_7 = var_16_1:getContentSize()
		end
	end
	
	var_16_2:setContentSize(var_16_7.width + 80, var_16_7.height + 100)
	
	local var_16_13 = var_16_1:getContentSize()
	local var_16_14 = {
		x = var_16_13.width - var_16_6.width,
		y = var_16_13.height - var_16_6.height
	}
	local var_16_15 = var_16_0:getContentSize()
	
	var_16_15.width = var_16_15.width + var_16_14.x
	var_16_15.height = var_16_15.height + var_16_14.y
	
	var_16_3:setPositionY(var_16_3:getPositionY() + var_16_14.y * 0.5)
	var_16_0:setPosition(var_0_0(arg_16_1.db.id, arg_16_1.db.talkbox_l, var_16_15))
	
	return var_16_0
end

function SPLStorySystem.procStory(arg_17_0)
	if not arg_17_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_17_0.vars.story_dlg) then
		UIAction:Add(SEQ(SPAWN(FADE_OUT(200), COLOR(200, 128, 128, 128)), REMOVE()), arg_17_0.vars.story_dlg, "block")
		
		arg_17_0.vars.story_dlg = nil
		
		SoundEngine:play("event:/ui/story_next")
	end
	
	if table.empty(arg_17_0.vars.play_queue) then
		arg_17_0:onFinishStory()
		
		return 
	end
	
	local var_17_0 = table.remove(arg_17_0.vars.play_queue, 1)
	local var_17_1 = arg_17_0:makeStoryDlg(var_17_0)
	
	arg_17_0.vars.story_dlg = var_17_1
	
	arg_17_0.vars.layer:addChild(var_17_1)
	if_set_opacity(var_17_1, nil, 0)
	if_set_color(var_17_1, nil, cc.c3b(128, 128, 128))
	UIAction:Add(SPAWN(DELAY(var_17_0:getDelay()), FADE_IN(200), COLOR(200, 255, 255, 255)), var_17_1, "block")
end

function SPLStorySystem.onFinishStory(arg_18_0)
	if not arg_18_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_18_0.vars.story_btn) then
		arg_18_0.vars.story_btn:removeFromParent()
		
		arg_18_0.vars.story_btn = nil
	end
	
	arg_18_0.vars.cur_story = nil
	
	SPLEventSystem:resume()
end

function SPLStorySystem.close(arg_19_0)
	if not arg_19_0.vars then
		return 
	end
	
	if get_cocos_refid(arg_19_0.vars.story_btn) then
		arg_19_0.vars.story_btn:removeFromParent()
		
		arg_19_0.vars.story_btn = nil
	end
	
	arg_19_0.vars = nil
end
