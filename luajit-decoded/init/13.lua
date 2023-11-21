TitleBackground = TitleBackground or {}
BackgroundEventData = BackgroundEventData or {}

local var_0_0 = false
local var_0_1
local var_0_2
local var_0_3 = "\nattribute vec4 a_position;\nattribute vec2 a_texCoord;\nattribute vec4 a_color;\n#ifdef GL_ES\nvarying lowp vec4 v_fragmentColor;\nvarying mediump vec2 v_texCoord;\n#else\nvarying vec4 v_fragmentColor;\nvarying vec2 v_texCoord;\n#endif\nvoid main()\n{\n\tgl_Position = CC_PMatrix * a_position;\n\tv_fragmentColor = a_color;\n\tv_texCoord = a_texCoord;\n}\n\n"
local var_0_4 = "\n#ifdef GL_ES\nprecision lowp float;\n#endif\n\nvarying vec4 v_fragmentColor;\nvarying vec2 v_texCoord;\n\nvoid main()\n{\n\tvec4 tex0 = texture2D(CC_Texture0, v_texCoord);\n\tvec4 tex1 = texture2D(CC_TexAlpha, v_texCoord);\n\tgl_FragColor =  v_fragmentColor * vec4( tex0.rgb , tex0.a * tex1.a );\n}\n\n"

function adjustTitleMovieScale(arg_1_0, arg_1_1)
	local var_1_0 = arg_1_0:getContentSize()
	local var_1_1 = TITLE_WIDTH / var_1_0.width
	
	if TITLE_HEIGHT > DESIGN_HEIGHT then
		var_1_1 = var_1_1 * (TITLE_HEIGHT / DESIGN_HEIGHT)
	end
	
	local var_1_2 = arg_1_1 and arg_1_1:getScale() or 1
	
	arg_1_0:setScale(var_1_1 / var_1_2)
end

function BackgroundEventData.getUserDefaultData(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_1 == nil or arg_2_2 == nil then
		return 
	end
	
	if type(arg_2_2) == "string" then
		return cc.UserDefault:getInstance():getStringForKey(arg_2_1, arg_2_2)
	elseif type(arg_2_2) == "number" then
		return math.round(cc.UserDefault:getInstance():getFloatForKey(arg_2_1, arg_2_2) * 1000) / 1000
	elseif type(arg_2_2) == "boolean" then
		return cc.UserDefault:getInstance():getBoolForKey(arg_2_1, arg_2_2)
	end
end

function BackgroundEventData.initWithJson(arg_3_0)
	local var_3_0 = json.decode(arg_3_0:getUserDefaultData("title_overlap.json", ""))
	local var_3_1 = json.decode(arg_3_0:getUserDefaultData("title_overlap.logo_lang", ""))
	
	if not var_3_0 or not var_3_1 then
		arg_3_0.load_failed = true
		arg_3_0.bg_type = "image"
		arg_3_0.begin_time = 0
		arg_3_0.end_time = 0
		arg_3_0.logo_x = 0
		arg_3_0.logo_y = 0
		arg_3_0.logo_scale = 0
		arg_3_0.logo_path = ""
		
		return 
	end
	
	arg_3_0.json_init = true
	arg_3_0.bg_type = var_3_0.bg_type or "image"
	arg_3_0.begin_time = tonumber(var_3_0.begin_time) or 0
	arg_3_0.end_time = tonumber(var_3_0.end_time) or 0
	arg_3_0.logo_x = tonumber(var_3_0.logo_x) or 0
	arg_3_0.logo_y = tonumber(var_3_0.logo_y) or 0
	arg_3_0.logo_scale = tonumber(var_3_0.logo_scale) or 0
	
	local var_3_2 = getUserLanguage()
	
	if var_3_2 then
		arg_3_0.logo_path = var_3_1[var_3_2] or ""
	else
		arg_3_0.logo_path = var_3_1.en or ""
	end
	
	arg_3_0.ep_clear = BackgroundEventData:getUserDefaultData("main_quest_progress", "ep1")
	
	print("ep_clear : ", BackgroundEventData.ep_clear)
end

function BackgroundEventData.onLoadFailed(arg_4_0)
	arg_4_0.load_failed = true
end

function BackgroundEventData.onLoadSucceed(arg_5_0)
	arg_5_0.load_complete = true
end

function BackgroundEventData.isLoadSucceed(arg_6_0)
	return arg_6_0.load_complete
end

function BackgroundEventData.isEventTitle(arg_7_0)
	if not arg_7_0.json_init then
		arg_7_0:initWithJson()
	end
	
	if arg_7_0.load_failed then
		return 
	end
	
	local var_7_0 = tonumber(getenv("title_overlap.start", 0)) or 0
	local var_7_1 = tonumber(getenv("title_overlap.end", 0)) or 0
	
	if var_7_0 == 0 then
		var_7_0 = arg_7_0.begin_time
	end
	
	if var_7_1 == 0 then
		var_7_1 = arg_7_0.end_time
	end
	
	return var_7_0 < os.time() and var_7_1 > os.time()
end

function BackgroundEventData.isLogoFileExist(arg_8_0)
	local var_8_0 = arg_8_0:getLogoFilePath()
	
	return cc.FileUtils:getInstance():isFileExist(var_8_0)
end

function BackgroundEventData.isBGFileExist(arg_9_0)
	local var_9_0 = arg_9_0:getBGFilePath()
	
	return cc.FileUtils:getInstance():isFileExist(var_9_0)
end

function BackgroundEventData.isMusicFileExist(arg_10_0)
	local var_10_0 = arg_10_0:getMusicFilePath()
	
	return cc.FileUtils:getInstance():isFileExist(var_10_0)
end

function BackgroundEventData.getLogoFilePath(arg_11_0)
	if not arg_11_0.json_init then
		arg_11_0:initWithJson()
	end
	
	return cc.FileUtils:getInstance():getWritablePath() .. "data.ext/" .. arg_11_0.logo_path
end

function BackgroundEventData.getBGFilePath(arg_12_0)
	if not arg_12_0.json_init then
		arg_12_0:initWithJson()
	end
	
	local var_12_0 = arg_12_0.bg_type == "movie" and ".mp4" or ".png"
	
	return cc.FileUtils:getInstance():getWritablePath() .. "data.ext/current_bg" .. var_12_0
end

function BackgroundEventData.getMusicFilePath(arg_13_0)
	if not arg_13_0.json_init then
		arg_13_0:initWithJson()
	end
	
	return cc.FileUtils:getInstance():getWritablePath() .. "data.ext/current_bgm.mp3"
end

function BackgroundEventData.getLogoTransform(arg_14_0)
	if arg_14_0.load_failed then
		return 
	end
	
	if not arg_14_0.json_init then
		arg_14_0:initWithJson()
	end
	
	return {
		x = arg_14_0.logo_x,
		y = arg_14_0.logo_y,
		scale = arg_14_0.logo_scale
	}
end

TitleBackground.FSM = TitleBackground.FSM or {}
TitleBackground.FSM.STATES = TitleBackground.FSM.STATES or {}
TitleBackgroundStates = {
	DOWNLOAD = 33,
	VIDEO = 22,
	DEFAULT = 1,
	EVENT = 11,
	DONE = 55,
	IMAGE = 44
}

function TitleBackground.FSM.changeState(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0:_onExit(arg_15_0.current_state)
	
	arg_15_0.current_state = arg_15_1
	
	arg_15_0:_onEnter(arg_15_1, arg_15_2)
end

function TitleBackground.FSM.update(arg_16_0)
	if arg_16_0.current_state then
		arg_16_0:_onUpdate(arg_16_0.current_state)
	end
end

function TitleBackground.FSM.getCurrentState(arg_17_0)
	return arg_17_0.current_state
end

function TitleBackground.FSM._onEnter(arg_18_0, arg_18_1, arg_18_2)
	if not arg_18_1 or not arg_18_0.STATES[arg_18_1] then
		return 
	end
	
	if arg_18_0.STATES[arg_18_1].onEnter then
		arg_18_0.STATES[arg_18_1]:onEnter(arg_18_2)
	end
end

function TitleBackground.FSM._onUpdate(arg_19_0, arg_19_1)
	if not arg_19_1 or not arg_19_0.STATES[arg_19_1] then
		return 
	end
	
	if arg_19_0.STATES[arg_19_1].onUpdate then
		arg_19_0.STATES[arg_19_1]:onUpdate()
	end
end

function TitleBackground.FSM._onExit(arg_20_0, arg_20_1)
	if not arg_20_1 or not arg_20_0.STATES[arg_20_1] then
		return 
	end
	
	if arg_20_0.STATES[arg_20_1].onExit then
		arg_20_0.STATES[arg_20_1]:onExit()
	end
end

TitleBackground.FSM.STATES[TitleBackgroundStates.DEFAULT] = {}
TitleBackground.FSM.STATES[TitleBackgroundStates.DEFAULT].onEnter = function(arg_21_0, arg_21_1)
	TitleBackground:makeDefaultBackground()
	TitleBackground.FSM:changeState(TitleBackgroundStates.DONE)
end
TitleBackground.FSM.STATES[TitleBackgroundStates.DEFAULT].onExit = function(arg_22_0)
end
TitleBackground.FSM.STATES[TitleBackgroundStates.EVENT] = {}
TitleBackground.FSM.STATES[TitleBackgroundStates.EVENT].onEnter = function(arg_23_0, arg_23_1)
	TitleBackground:makeEventBackground()
	TitleBackground.FSM:changeState(TitleBackgroundStates.DONE)
end
TitleBackground.FSM.STATES[TitleBackgroundStates.EVENT].onExit = function(arg_24_0)
end
TitleBackground.FSM.STATES[TitleBackgroundStates.VIDEO] = {}
TitleBackground.FSM.STATES[TitleBackgroundStates.VIDEO].onEnter = function(arg_25_0, arg_25_1)
end
TitleBackground.FSM.STATES[TitleBackgroundStates.VIDEO].onUpdate = function(arg_26_0)
	local var_26_0 = getenv("cdn.url") and getenv("cdn.url") .. "/webpubs/res/"
	
	if var_26_0 then
		local var_26_1 = "title_" .. BackgroundEventData.ep_clear
		local var_26_2 = ""
		
		if LOW_RESOLUTION_MODE then
			var_26_2 = "_low"
		end
		
		local var_26_3 = var_26_0 .. "title/ep_cinema/" .. var_26_1 .. var_26_2 .. ".mp4"
		local var_26_4 = TitleBackground.n_bg
		
		if not get_cocos_refid(var_26_4) then
			TitleBackground.FSM:changeState(TitleBackgroundStates.DONE)
			
			return 
		end
		
		local var_26_5 = ccexp.VideoPlayer:new()
		
		var_26_5:setFileName(var_26_3 .. "?inet_cache=ignore_update")
		var_26_5:load()
		var_26_5:setName("movie_title")
		var_26_5:setAnchorPoint(0.5, 0.5)
		var_26_5:setPosition(0, 0)
		var_26_5:setLoop(true)
		var_26_5:setCascadeOpacityEnabled(true)
		adjustTitleMovieScale(var_26_5, var_26_4)
		var_26_4:addChild(var_26_5)
		
		if not var_26_5:isDownloadCompleted() then
			var_26_5:setVisible(false)
			TitleBackground.FSM:changeState(TitleBackgroundStates.DOWNLOAD, {
				download_movie = var_26_5
			})
		else
			var_26_5:play()
			TitleBackground.FSM:changeState(TitleBackgroundStates.DONE)
		end
	end
end
TitleBackground.FSM.STATES[TitleBackgroundStates.VIDEO].onExit = function(arg_27_0)
end
TitleBackground.FSM.STATES[TitleBackgroundStates.DOWNLOAD] = {}
TitleBackground.FSM.STATES[TitleBackgroundStates.DOWNLOAD].onEnter = function(arg_28_0, arg_28_1)
	arg_28_0.download_movie = arg_28_1.download_movie
	
	if not get_cocos_refid(arg_28_0.download_movie) then
		TitleBackground.FSM:changeState(TitleBackgroundStates.DONE)
		
		return 
	end
	
	local var_28_0 = TitleBackground.n_bg
	
	if not get_cocos_refid(var_28_0) then
		TitleBackground.FSM:changeState(TitleBackgroundStates.DONE)
		
		return 
	end
	
	local var_28_1 = getenv("cdn.url") and getenv("cdn.url") .. "/webpubs/res/"
	
	if var_28_1 then
		local var_28_2 = var_28_1 .. "title/ep_cinema/title_" .. BackgroundEventData.ep_clear .. ".png"
		
		if exists_inet_file_cache(var_28_2) then
			arg_28_0.prev_image = TitleBackground:makeImageBackground()
			
			if get_cocos_refid(arg_28_0.prev_image) then
				arg_28_0.prev_image:setName("prev_image")
				var_28_0:addChild(arg_28_0.prev_image)
				arg_28_0.prev_image:setVisible(false)
				arg_28_0.prev_image:setOpacity(0)
				
				local var_28_3 = cc.Sequence:create(cc.CallFunc:create(function()
					arg_28_0.prev_image:setVisible(true)
				end), cc.FadeIn:create(0.7))
				
				arg_28_0.prev_image:runAction(var_28_3)
			else
				arg_28_0.prev_default = TitleBackground:makeDefaultBackground()
			end
		else
			local var_28_4 = string.sub(BackgroundEventData.ep_clear, 3, 3) or "1"
			local var_28_5 = tonumber(var_28_4)
			
			if var_28_5 > 1 then
				local var_28_6 = var_28_5 - 1
				local var_28_7 = "title_ep" .. var_28_6
				local var_28_8 = ""
				
				if LOW_RESOLUTION_MODE then
					var_28_8 = "_low"
				end
				
				local var_28_9 = var_28_1 .. "/webpubs/res/title/ep_cinema/" .. var_28_7 .. var_28_8 .. ".mp4"
				
				if exists_inet_file_cache(var_28_9) then
					arg_28_0.prev_movie = ccexp.VideoPlayer:new()
					
					arg_28_0.prev_movie:setName("prev_movie")
					arg_28_0.prev_movie:setFileName(var_28_9 .. "?inet_cache=ignore_update")
					arg_28_0.prev_movie:load()
					arg_28_0.prev_movie:setAnchorPoint(0.5, 0.5)
					arg_28_0.prev_movie:setPosition(0, 0)
					arg_28_0.prev_movie:setLoop(true)
					arg_28_0.prev_movie:setCascadeOpacityEnabled(true)
					arg_28_0.prev_movie:play()
					adjustTitleMovieScale(arg_28_0.prev_movie, var_28_0)
					var_28_0:addChild(arg_28_0.prev_movie)
				else
					arg_28_0.prev_default = TitleBackground:makeDefaultBackground()
				end
			else
				arg_28_0.prev_default = TitleBackground:makeDefaultBackground()
			end
		end
	else
		arg_28_0.prev_default = TitleBackground:makeDefaultBackground()
	end
end
TitleBackground.FSM.STATES[TitleBackgroundStates.DOWNLOAD].onUpdate = function(arg_30_0)
	if not get_cocos_refid(arg_30_0.download_movie) then
		TitleBackground.FSM:changeState(TitleBackgroundStates.DONE)
		
		return 
	end
	
	if arg_30_0.download_movie:getDownloadState() < 0 then
		arg_30_0.download_movie:removeFromParent()
		
		arg_30_0.download_movie = nil
		
		if get_cocos_refid(arg_30_0.prev_image) then
			TitleBackground.FSM:changeState(TitleBackgroundStates.DONE)
		else
			TitleBackground.FSM:changeState(TitleBackgroundStates.IMAGE)
		end
	elseif arg_30_0.download_movie:isDownloadCompleted() then
		if get_cocos_refid(arg_30_0.prev_movie) then
			local var_30_0 = cc.Sequence:create(cc.FadeOut:create(0.7), cc.CallFunc:create(function()
				arg_30_0.prev_movie:stop()
				arg_30_0.prev_movie:removeFromParent()
			end))
			
			arg_30_0.prev_movie:runAction(var_30_0)
		end
		
		if get_cocos_refid(arg_30_0.prev_default) then
			local var_30_1 = cc.Sequence:create(cc.FadeOut:create(0.7), cc.CallFunc:create(function()
				arg_30_0.prev_default:removeFromParent()
			end))
			
			arg_30_0.prev_default:runAction(var_30_1)
		end
		
		if get_cocos_refid(arg_30_0.prev_image) then
			local var_30_2 = cc.Sequence:create(cc.FadeOut:create(0.7), cc.CallFunc:create(function()
				arg_30_0.prev_image:removeFromParent()
			end))
			
			arg_30_0.prev_image:runAction(var_30_2)
		end
		
		local var_30_3 = cc.Sequence:create(cc.CallFunc:create(function()
			arg_30_0.download_movie:setVisible(true)
			arg_30_0.download_movie:play()
		end), cc.FadeIn:create(0.7))
		
		arg_30_0.download_movie:runAction(var_30_3)
		TitleBackground.FSM:changeState(TitleBackgroundStates.DONE)
	end
end
TitleBackground.FSM.STATES[TitleBackgroundStates.DOWNLOAD].onExit = function(arg_35_0)
end
TitleBackground.FSM.STATES[TitleBackgroundStates.IMAGE] = {}
TitleBackground.FSM.STATES[TitleBackgroundStates.IMAGE].onEnter = function(arg_36_0, arg_36_1)
	local var_36_0 = getenv("cdn.url") and getenv("cdn.url") .. "/webpubs/res/"
	
	if not var_36_0 then
		TitleBackground.FSM:changeState(TitleBackgroundStates.DONE)
		
		return 
	end
	
	local var_36_1 = var_36_0 .. "title/ep_cinema/title_" .. BackgroundEventData.ep_clear .. ".png"
	local var_36_2 = cc.FileUtils:getInstance():fullPathForFilename(var_36_1)
	
	if not var_36_2 or string.len(var_36_2) == 0 then
		TitleBackground.FSM:changeState(TitleBackgroundStates.DONE)
		
		return 
	end
	
	arg_36_0.file_io = cc.FileUtils:getInstance():getFileIOFromFile(var_36_2, "rb")
	
	if not arg_36_0.file_io or not get_cocos_refid(arg_36_0.file_io) then
		TitleBackground.FSM:changeState(TitleBackgroundStates.DONE)
		
		return 
	end
	
	arg_36_0.download_node = cc.Node:create()
	
	arg_36_0.download_node:setUserObject(arg_36_0.file_io)
	arg_36_0.file_io:release()
	TitleBackground.scene:addChild(arg_36_0.download_node)
	arg_36_0.download_node:retain()
end
TitleBackground.FSM.STATES[TitleBackgroundStates.IMAGE].onUpdate = function(arg_37_0)
	if not arg_37_0.file_io or not get_cocos_refid(arg_37_0.file_io) then
		TitleBackground.FSM:changeState(TitleBackgroundStates.DONE)
		
		return 
	end
	
	if arg_37_0.file_io:getDownloadState() < 0 then
		TitleBackground.FSM:changeState(TitleBackgroundStates.DONE)
	elseif arg_37_0.file_io:isDownloadCompleted() then
		local var_37_0 = TitleBackground:makeImageBackground()
		
		if not get_cocos_refid(var_37_0) then
			TitleBackground.FSM:changeState(TitleBackgroundStates.DONE)
			
			return 
		end
		
		local var_37_1 = TitleBackground.n_bg
		
		if not get_cocos_refid(var_37_1) then
			TitleBackground.FSM:changeState(TitleBackgroundStates.DONE)
			
			return 
		end
		
		var_37_1:addChild(var_37_0)
		var_37_0:setVisible(false)
		var_37_0:setOpacity(0)
		
		local var_37_2 = var_37_1:getChildByName("default_bg")
		
		if get_cocos_refid(var_37_2) then
			local var_37_3 = cc.Sequence:create(cc.FadeOut:create(0.7), cc.CallFunc:create(function()
				var_37_2:removeFromParent()
			end))
			
			var_37_2:runAction(var_37_3)
		end
		
		local var_37_4 = var_37_1:getChildByName("prev_movie")
		
		if get_cocos_refid(var_37_4) then
			local var_37_5 = cc.Sequence:create(cc.FadeOut:create(0.7), cc.CallFunc:create(function()
				var_37_4:stop()
				var_37_4:removeFromParent()
			end))
			
			var_37_4:runAction(var_37_5)
		end
		
		local var_37_6 = cc.Sequence:create(cc.CallFunc:create(function()
			var_37_0:setVisible(true)
		end), cc.FadeIn:create(0.7))
		
		var_37_0:runAction(var_37_6)
		TitleBackground.FSM:changeState(TitleBackgroundStates.DONE)
	end
end
TitleBackground.FSM.STATES[TitleBackgroundStates.IMAGE].onExit = function(arg_41_0)
	if get_cocos_refid(arg_41_0.download_node) then
		arg_41_0.download_node:release()
		
		arg_41_0.download_node = nil
	end
end
TitleBackground.FSM.STATES[TitleBackgroundStates.DONE] = {}
TitleBackground.FSM.STATES[TitleBackgroundStates.DONE].onEnter = function(arg_42_0, arg_42_1)
end
TitleBackground.FSM.STATES[TitleBackgroundStates.DONE].onExit = function(arg_43_0)
end

function TitleBackground.getEffect(arg_44_0, arg_44_1, arg_44_2)
	arg_44_1 = "effect/" .. arg_44_1
	
	if string.find(arg_44_1, ".particle") then
		local var_44_0 = su.ParticleEffect2D:create(arg_44_1)
		
		var_44_0:setName(arg_44_1)
		
		return var_44_0
	end
	
	if arg_44_2 then
		arg_44_2 = "effect/" .. arg_44_2
	else
		arg_44_2 = arg_44_1
	end
	
	local var_44_1 = sp.SkeletonAnimation:create(arg_44_1 .. ".scsp", arg_44_2 .. ".atlas", 1)
	
	var_44_1:setName(arg_44_1)
	
	if not var_0_0 then
		var_0_1 = cc.GLProgramCache:getInstance():addGLProgramFromByteArray("@pre_model", var_0_3, var_0_4)
		
		if get_cocos_refid(var_0_1) then
			var_0_2 = cc.GLProgramState:create(var_0_1)
		end
		
		var_0_0 = true
	end
	
	if get_cocos_refid(var_0_2) then
		var_44_1:setDefaultGLProgramState(var_0_2)
		var_44_1:setGLProgramState(var_0_2)
	end
	
	return var_44_1
end

function TitleBackground.hide(arg_45_0)
	if get_cocos_refid(arg_45_0.scene) then
		arg_45_0.scene:removeFromParent()
	end
	
	arg_45_0.sound = nil
	arg_45_0.wnd = nil
	arg_45_0.logo = nil
	arg_45_0.n_patch = nil
	arg_45_0.progress_download = nil
	arg_45_0.progress_total = nil
	arg_45_0.txt_progress = nil
	arg_45_0.message_control = nil
	arg_45_0.message = nil
	arg_45_0.scene = nil
end

function TitleBackground.show(arg_46_0, arg_46_1)
	if get_cocos_refid(arg_46_0.scene) then
		arg_46_0.scene:ejectFromParent()
		arg_46_1:addChild(arg_46_0.scene)
		arg_46_0:playTitleAni()
	end
end

function TitleBackground.addScheduler(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	if not arg_47_0.schedulers then
		arg_47_0.schedulers = {}
	end
	
	arg_47_0.schedulers[#arg_47_0.schedulers + 1] = {
		tick = systick() + arg_47_1,
		func = arg_47_2,
		remove_func = arg_47_3
	}
end

function TitleBackground.removeAllScheduler(arg_48_0)
	arg_48_0.schedulers = nil
end

function TitleBackground.isShow(arg_49_0)
	return arg_49_0.scene ~= nil
end

function TitleBackground.stopMusic(arg_50_0)
	if get_cocos_refid(arg_50_0.sound) then
		arg_50_0.sound:stop()
	end
end

function TitleBackground.getMusicHandle(arg_51_0)
	return arg_51_0.sound
end

function TitleBackground.playMusic(arg_52_0)
	if get_cocos_refid(arg_52_0.sound) then
		arg_52_0.sound:stop()
	end
	
	if BackgroundEventData:getUserDefaultData("main_quest_progress", "") == "" then
		arg_52_0.sound = ccexp.SoundEngine:playSoundFile("bgm/bgm_ep1.mp3", true)
	elseif BackgroundEventData:isEventTitle() and BackgroundEventData:isMusicFileExist() then
		local var_52_0 = BackgroundEventData:getMusicFilePath()
		
		arg_52_0.sound = ccexp.SoundEngine:playSoundFile(var_52_0, true)
	elseif BackgroundEventData.ep_clear == "ep1" then
		arg_52_0.sound = ccexp.SoundEngine:playSoundFile("bgm/bgm_ep1.mp3", true)
	else
		local var_52_1 = getenv("cdn.url") and getenv("cdn.url") .. "/webpubs/res/"
		
		if var_52_1 then
			local var_52_2 = "title/ep_bgm/bgm_" .. BackgroundEventData.ep_clear .. ".mp3"
			
			arg_52_0.sound = ccexp.SoundEngine:playSoundFile(var_52_1 .. var_52_2, true)
		else
			arg_52_0.sound = ccexp.SoundEngine:playSoundFile("bgm/bgm_ep1.mp3", true)
		end
	end
	
	if get_cocos_refid(arg_52_0.sound) then
		local var_52_3 = math.round(cc.UserDefault:getInstance():getFloatForKey("sound.vol_bgm", 0.3) * 1000) / 1000 * (math.round(cc.UserDefault:getInstance():getFloatForKey("sound.vol_master", 1) * 1000) / 1000)
		local var_52_4 = math.min(var_52_3, 0.3)
		
		if cc.UserDefault:getInstance():getBoolForKey("sound.mute_bgm", false) or cc.UserDefault:getInstance():getBoolForKey("sound.mute_master", false) then
			var_52_4 = 0
		end
		
		arg_52_0.sound:setVolume(var_52_4)
	end
end

function TitleBackground.addEffect(arg_53_0, arg_53_1, arg_53_2, arg_53_3)
	local var_53_0 = arg_53_0:getEffect(arg_53_2, arg_53_3.atlas or arg_53_2)
	
	var_53_0:setPosition(0, 0)
	var_53_0:setAnimation(0, arg_53_3.ani or "idle", arg_53_3.loop == true)
	var_53_0:setScale(arg_53_3.scale or 1.6)
	var_53_0:setCascadeOpacityEnabled(true)
	arg_53_1:addChild(var_53_0)
	
	return var_53_0
end

function TitleBackground.updateOffsetCtrl(arg_54_0)
	if not get_cocos_refid(arg_54_0.wnd) then
		return 
	end
	
	arg_54_0.wnd:setPosition(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
	arg_54_0.wnd:findChildByName("LEFT"):setPositionX(VIEW_BASE_LEFT)
	arg_54_0.wnd:findChildByName("TOP"):setPositionY((TITLE_HEIGHT - VIEW_HEIGHT) / 2 + VIEW_HEIGHT)
	arg_54_0.wnd:findChildByName("n_versions"):setPositionY(0 - (TITLE_HEIGHT - VIEW_HEIGHT) / 2)
	arg_54_0.wnd:findChildByName("RIGHT"):setPositionX(VIEW_BASE_RIGHT)
	arg_54_0.wnd:findChildByName("RIGHT_TOP"):setPosition(-VIEW_BASE_LEFT, (TITLE_HEIGHT - VIEW_HEIGHT) / 2)
	arg_54_0.wnd:findChildByName("CENTER"):setPositionY(0 - (TITLE_HEIGHT - VIEW_HEIGHT) / 2)
	arg_54_0.wnd:findChildByName("BOTTOM"):setPositionY(0 - (TITLE_HEIGHT - VIEW_HEIGHT) / 2)
	arg_54_0.wnd:findChildByName("glow"):setPositionY(0 - (TITLE_HEIGHT - VIEW_HEIGHT) / 2 - 32)
	
	local var_54_0 = arg_54_0.wnd:findChildByName("CENTER_TOP")
	
	if get_cocos_refid(var_54_0) then
		var_54_0:setPositionY((TITLE_HEIGHT - VIEW_HEIGHT) / 2)
	end
	
	local var_54_1 = arg_54_0.wnd:findChildByName("download_reward")
	
	if get_cocos_refid(var_54_1) then
		var_54_1:setPositionY(0 - (TITLE_HEIGHT - VIEW_HEIGHT) / 2 + 51)
	end
	
	local var_54_2 = arg_54_0.wnd:findChildByName("n_bg")
	
	if BackgroundEventData:isEventTitle() then
		var_54_2:setScale(1)
	else
		var_54_2:setScale(1.3 * VIEW_WIDTH / TITLE_WIDTH * 0.65)
	end
	
	if get_cocos_refid(arg_54_0.movie) and arg_54_0.movie.getVideoSprite and arg_54_0.movie:getVideoSprite():getContentSize().width > 0 then
		adjustTitleMovieScale(arg_54_0.movie, var_54_2)
	end
	
	local var_54_3 = arg_54_0.progress_total:getContentSize()
	local var_54_4 = arg_54_0.progress_download:getContentSize()
	
	var_54_3.width = VIEW_WIDTH
	var_54_4.width = VIEW_WIDTH
	
	arg_54_0.progress_total:setContentSize(var_54_3)
	arg_54_0.progress_download:setContentSize(var_54_4)
end

function TitleBackground.createScene(arg_55_0)
	BackgroundEventData.ep_clear = BackgroundEventData:getUserDefaultData("main_quest_progress", "ep1")
	
	if get_cocos_refid(arg_55_0.scene) then
		return arg_55_0.scene
	end
	
	local var_55_0 = cc.Layer:create()
	local var_55_1 = cc.CSLoader:createNode("ui/title.csb")
	
	var_55_1:findChildByName("txt_r"):setString(PreDatas:getText("copyright"))
	var_55_1:setAnchorPoint(0.5, 0.5)
	var_55_0:addChild(var_55_1)
	
	arg_55_0.wnd = var_55_1
	arg_55_0.movie = nil
	arg_55_0.logo = arg_55_0.wnd:findChildByName("n_logo")
	arg_55_0.n_patch = arg_55_0.wnd:findChildByName("n_patch")
	arg_55_0.n_progress = arg_55_0.wnd:findChildByName("n_progress")
	arg_55_0.n_startable = arg_55_0.wnd:findChildByName("n_point")
	
	arg_55_0.n_startable:setVisible(false)
	
	arg_55_0.n_balloon_node = arg_55_0.n_startable:findChildByName("n_balloon")
	arg_55_0.n_balloon_img = arg_55_0.n_startable:findChildByName("img_balloon")
	arg_55_0.n_balloon_txt = arg_55_0.n_startable:findChildByName("txt")
	
	arg_55_0.n_balloon_txt:setString(PreDatas:getText("patch_required_point"))
	
	local var_55_2 = arg_55_0.n_balloon_img:getContentSize()
	local var_55_3 = arg_55_0.n_balloon_txt:getPositionX()
	
	var_55_2.width = arg_55_0.n_balloon_txt:getContentSize().width * arg_55_0.n_balloon_txt:getScaleX() + var_55_3 * 2
	
	arg_55_0.n_balloon_img:setContentSize(var_55_2.width, var_55_2.height)
	arg_55_0.n_patch:setVisible(false)
	arg_55_0.n_progress:setVisible(false)
	
	arg_55_0.progress_download = arg_55_0.wnd:findChildByName("progress_download")
	arg_55_0.progress_total = arg_55_0.wnd:findChildByName("progress_total")
	arg_55_0.txt_progress = arg_55_0.wnd:findChildByName("txt_progress")
	arg_55_0.message_control = arg_55_0.wnd:findChildByName("txt_message")
	arg_55_0.txt_download = arg_55_0.wnd:findChildByName("txt_update_status")
	
	arg_55_0.txt_download:setVisible(false)
	
	local var_55_4 = arg_55_0.progress_total:getContentSize()
	local var_55_5 = arg_55_0.progress_download:getContentSize()
	
	var_55_4.width = VIEW_WIDTH
	var_55_5.width = VIEW_WIDTH
	
	arg_55_0.progress_total:setContentSize(var_55_4)
	arg_55_0.progress_download:setContentSize(var_55_5)
	
	arg_55_0.n_bg = arg_55_0.wnd:findChildByName("n_bg")
	arg_55_0.scene = var_55_0
	
	arg_55_0:setMessage("")
	arg_55_0:makeLetterBox()
	arg_55_0:updateOffsetCtrl()
	arg_55_0:showPatchInformation({})
	arg_55_0:updateVersionInfo()
	
	if BackgroundEventData:getUserDefaultData("main_quest_progress", "") == "" then
		arg_55_0.FSM:changeState(TitleBackgroundStates.DEFAULT)
	elseif BackgroundEventData:isEventTitle() and BackgroundEventData:isBGFileExist() then
		arg_55_0.FSM:changeState(TitleBackgroundStates.EVENT)
	else
		arg_55_0.FSM:changeState(TitleBackgroundStates.VIDEO)
	end
	
	arg_55_0:addScheduler(800, function(arg_56_0)
		return false
	end, function()
		arg_55_0:playMusic()
	end)
	
	return var_55_0
end

function TitleBackground.makeLetterBox(arg_58_0)
	local var_58_0 = 3000
	local var_58_1 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_58_1:setName("left_letterbox")
	var_58_1:setContentSize({
		width = var_58_0,
		height = var_58_0
	})
	var_58_1:setPosition(-var_58_0, DESIGN_CENTER_Y - var_58_0 / 2)
	var_58_1:setLocalZOrder(999999)
	arg_58_0.wnd:findChildByName("LEFT"):addChild(var_58_1)
	
	local var_58_2 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_58_2:setName("right_letterbox")
	var_58_2:setContentSize({
		width = var_58_0,
		height = var_58_0
	})
	var_58_2:setPosition(0, DESIGN_CENTER_Y - var_58_0 / 2)
	var_58_2:setLocalZOrder(999999)
	arg_58_0.wnd:findChildByName("RIGHT"):addChild(var_58_2)
	
	local var_58_3 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_58_3:setName("top_letterbox")
	var_58_3:setContentSize({
		width = var_58_0,
		height = var_58_0
	})
	var_58_3:setPosition(-100, 0)
	var_58_3:setLocalZOrder(999999)
	arg_58_0.wnd:findChildByName("TOP"):addChild(var_58_3)
	
	local var_58_4 = cc.LayerColor:create(cc.c3b(0, 0, 0))
	
	var_58_4:setName("bottom_letterbox")
	var_58_4:setContentSize({
		width = var_58_0,
		height = var_58_0
	})
	var_58_4:setPosition(-100, -var_58_0)
	var_58_4:setLocalZOrder(999999)
	arg_58_0.wnd:findChildByName("BOTTOM"):addChild(var_58_4)
end

function TitleBackground.getTitleLang(arg_59_0)
	local var_59_0 = getUserLanguage()
	
	if ({
		zhs = 1,
		zht = 1
	})[var_59_0] then
		return var_59_0
	end
end

function TitleBackground.logoFadeIn(arg_60_0)
	arg_60_0.logo:setOpacity(0)
	arg_60_0:addScheduler(2000, function(arg_61_0)
		if get_cocos_refid(arg_60_0.logo) then
			if arg_60_0.logo:getOpacity() + 255 * (arg_61_0 / 2000) < 255 then
				arg_60_0.logo:setOpacity(arg_60_0.logo:getOpacity() + 255 * (arg_61_0 / 2000))
				
				return true
			else
				arg_60_0.logo:setOpacity(255)
				
				return false
			end
		end
	end, function()
		if arg_60_0.logo:getOpacity() < 255 then
			arg_60_0.logo:setOpacity(255)
		end
	end)
end

function TitleBackground.loadDefaultLogo(arg_63_0, arg_63_1)
	local var_63_0
	local var_63_1 = cc.UserDefault:getInstance():getBoolForKey("tune.v_tutorial_n2", false)
	local var_63_2 = BackgroundEventData:getUserDefaultData("main_quest_progress", "")
	
	if var_63_2 ~= "" then
		var_63_1 = true
	end
	
	local var_63_3
	
	if var_63_2 == "ep5" then
		var_63_3 = getUserLanguage()
	else
		var_63_3 = arg_63_0:getTitleLang()
	end
	
	if not var_63_1 then
		if var_63_3 then
			var_63_0 = "ui/epic7_" .. var_63_3 .. ".png"
		else
			var_63_0 = "ui/epic7.png"
		end
	elseif var_63_2 == "ep5" then
		var_63_0 = "ui/epic7_ep5_" .. var_63_3 .. ".png"
		
		arg_63_1:setPositionY(-103)
	elseif var_63_3 then
		var_63_0 = "ui/epic7_logo_" .. var_63_3 .. ".png"
	else
		var_63_0 = "ui/epic7_logo.png"
	end
	
	arg_63_1:setTexture(var_63_0)
end

function TitleBackground.playTitleAni(arg_64_0)
	local var_64_0 = arg_64_0.logo:findChildByName("epic7_1")
	local var_64_1 = arg_64_0.wnd:findChildByName("n_event_logo")
	local var_64_2 = false
	
	if BackgroundEventData:isEventTitle() and BackgroundEventData:isLogoFileExist() and var_64_1 then
		arg_64_0.logo:setVisible(false)
		
		var_64_2 = arg_64_0:setEventLogo(var_64_1)
		
		if var_64_2 then
			arg_64_0.logo = var_64_1
		end
	end
	
	if not var_64_2 then
		arg_64_0:loadDefaultLogo(var_64_0)
		
		arg_64_0.logo_reload_not_require = true
	end
	
	arg_64_0:logoFadeIn()
end

function TitleBackground.setEventLogo(arg_65_0, arg_65_1)
	local var_65_0 = BackgroundEventData:getLogoFilePath()
	local var_65_1 = cc.Sprite:create(var_65_0)
	
	if not var_65_1 then
		return 
	end
	
	arg_65_1:addChild(var_65_1)
	
	local var_65_2 = BackgroundEventData:getLogoTransform()
	local var_65_3 = tonumber(var_65_2.x)
	
	if var_65_3 and var_65_2.x ~= "default" then
		arg_65_1:setPositionX(var_65_3)
	end
	
	local var_65_4 = tonumber(var_65_2.y)
	
	if var_65_2.y and var_65_2.y ~= "default" then
		arg_65_1:setPositionY(var_65_4)
	end
	
	local var_65_5 = tonumber(var_65_2.scale)
	
	if var_65_2.scale and var_65_2.scale ~= "default" then
		arg_65_1:setScale(var_65_5)
	end
	
	arg_65_1:setVisible(true)
	
	return true
end

function TitleBackground.updatePatchInformation(arg_66_0, arg_66_1, arg_66_2, arg_66_3)
	if arg_66_2 > 0 and arg_66_2 < 1 then
		arg_66_0.txt_download:setVisible(true)
		arg_66_0.txt_download:setString(PreDatas:getText("patch_download"))
	elseif arg_66_3 > 0 and arg_66_3 < 1 then
		arg_66_0.txt_download:setVisible(true)
		arg_66_0.txt_download:setString(PreDatas:getText("patch_decompression"))
	else
		arg_66_0.txt_download:setVisible(false)
	end
	
	arg_66_0.progress_total:setPercent(arg_66_3 * 100)
	arg_66_0.progress_download:setPercent(arg_66_2 * 100)
	
	local var_66_0 = arg_66_2 + arg_66_3
	
	if type(var_66_0) ~= "number" then
		var_66_0 = 0
	end
	
	arg_66_0.txt_progress:setString(string.format("%.1f%%", var_66_0 / 2 * 100))
	arg_66_0:setMessage(arg_66_1)
	
	if getenv("patch.required.status") == "complete" then
		arg_66_0.n_balloon_node:setVisible(false)
	else
		arg_66_0.n_balloon_node:setPositionY(math.abs(math.sin(systick() / 300)) * 10)
	end
end

function TitleBackground.setMaintenanceMessage(arg_67_0, arg_67_1)
	arg_67_0:showPatchInformation({})
	arg_67_0:setMessage(arg_67_1)
end

function TitleBackground.setMessage(arg_68_0, arg_68_1)
	if arg_68_1 == nil then
		arg_68_1 = ""
	end
	
	if arg_68_0.message == arg_68_1 then
		return 
	end
	
	arg_68_0.message = arg_68_1
	
	if not arg_68_0.message_control then
		return 
	end
	
	arg_68_0.message_control:setString(arg_68_1)
end

function TitleBackground.hidePatchInfo(arg_69_0)
	arg_69_0.n_patch:runAction(cc.Sequence:create(cc.FadeOut:create(1.5), cc.Hide:create()))
end

function TitleBackground.showPatchInformation(arg_70_0, arg_70_1, arg_70_2, arg_70_3)
	arg_70_0.n_patch:setVisible(arg_70_1 and arg_70_1.text)
	arg_70_0.n_progress:setVisible(arg_70_1 and arg_70_1.gage)
	
	if getenv("zlong.download_reward_enable", "false") == "true" and not cc.UserDefault:getInstance():getBoolForKey("download_reward_disable", false) then
		local var_70_0 = arg_70_0.wnd:getChildByName("download_reward")
		
		if get_cocos_refid(var_70_0) then
			var_70_0:setVisible(arg_70_1 and arg_70_1.text and getenv("patch.status", "") == "downloading")
		end
	end
	
	local var_70_1 = 1
	
	arg_70_3 = tonumber(arg_70_3)
	
	if getenv("tutorial.status") ~= "complete" and cc.UserDefault:getInstance():getStringForKey("startable.status") ~= "hidden" and arg_70_0.n_progress:isVisible() and arg_70_3 then
		arg_70_0.n_startable:setVisible(true)
		arg_70_0.n_startable:setPositionX(arg_70_3)
		arg_70_0.n_startable:stopAllActionsByTag(var_70_1)
	elseif arg_70_0.n_startable:isVisible() and not arg_70_0.n_startable:getActionByTag(var_70_1) then
		cc.UserDefault:getInstance():setStringForKey("startable.status", "hidden")
		
		local var_70_2 = cc.Sequence:create(cc.FadeOut:create(0.5), cc.Hide:create())
		
		var_70_2:setTag(var_70_1)
		arg_70_0.n_startable:runAction(var_70_2)
	end
end

function TitleBackground.update(arg_71_0)
	if not get_cocos_refid(arg_71_0.scene) then
		return 
	end
	
	arg_71_0.FSM:update()
	
	if arg_71_0.schedulers then
		local var_71_0 = systick()
		
		for iter_71_0 = #arg_71_0.schedulers, 1, -1 do
			if var_71_0 > arg_71_0.schedulers[iter_71_0].tick and arg_71_0.schedulers[iter_71_0].func then
				arg_71_0.schedulers[iter_71_0].last_update_tick = arg_71_0.schedulers[iter_71_0].last_update_tick or arg_71_0.schedulers[iter_71_0].tick
				
				local var_71_1 = var_71_0 - arg_71_0.schedulers[iter_71_0].last_update_tick
				
				if var_71_1 > 100 then
					arg_71_0.schedulers[iter_71_0].tick = arg_71_0.schedulers[iter_71_0].tick + (var_71_1 - 100)
					var_71_1 = 100
				end
				
				arg_71_0.schedulers[iter_71_0].last_update_tick = var_71_0
				
				if not arg_71_0.schedulers[iter_71_0].func(var_71_1) then
					if arg_71_0.schedulers[iter_71_0].remove_func then
						arg_71_0.schedulers[iter_71_0].remove_func()
					end
					
					table.remove(arg_71_0.schedulers, iter_71_0)
				end
			end
		end
		
		if #arg_71_0.schedulers == 0 then
			arg_71_0.schedulers = nil
		end
	end
end

function TitleBackground.updateVersionInfo(arg_72_0)
	if not get_cocos_refid(arg_72_0.wnd) then
		return 
	end
	
	local var_72_0 = getVersionDetailString()
	local var_72_1 = arg_72_0.wnd:findChildByName("txt_version_detail")
	
	if var_72_1 then
		var_72_1:setString(var_72_0)
	end
	
	local var_72_2 = arg_72_0.wnd:findChildByName("txt_account")
	
	if var_72_2 then
		if IS_PUBLISHER_ZLONG then
			var_72_2:setString("")
		elseif AccountData and AccountData.user_number then
			var_72_2:setString("#" .. AccountData.user_number)
		else
			var_72_2:setString("?")
		end
	end
	
	local var_72_3 = arg_72_0.wnd:findChildByName("txt_health_zl")
	local var_72_4 = arg_72_0.wnd:findChildByName("txt_panho")
	local var_72_5 = arg_72_0.wnd:findChildByName("glow_panho")
	
	if get_cocos_refid(var_72_3) then
		var_72_3:setVisible(IS_PUBLISHER_ZLONG)
	end
	
	if get_cocos_refid(var_72_4) then
		var_72_4:setVisible(IS_PUBLISHER_ZLONG)
	end
	
	if get_cocos_refid(var_72_5) then
		var_72_5:setVisible(IS_PUBLISHER_ZLONG)
	end
	
	local var_72_6 = arg_72_0.wnd:findChildByName("txt_low_end_mode")
	
	if var_72_6 then
		if LOW_RESOLUTION_MODE then
			var_72_6:setVisible(true)
			var_72_6:setString(PreDatas:getText("low_end_mode"))
		else
			var_72_6:setVisible(false)
		end
	end
end

function TitleBackground.makeEventBackground(arg_73_0)
	if not get_cocos_refid(arg_73_0.n_bg) then
		return 
	end
	
	local var_73_0 = BackgroundEventData:getBGFilePath()
	local var_73_1 = cc.FileUtils:getInstance():getFileExtension(var_73_0)
	
	if var_73_1 == ".mp4" then
		local var_73_2 = cc.FileUtils:getInstance():fullPathForFilename(var_73_0)
		
		arg_73_0.movie = ccexp.VideoPlayer:new()
		
		arg_73_0.movie:setFileName(var_73_2)
		arg_73_0.movie:load()
		arg_73_0.movie:setAnchorPoint(0.5, 0.5)
		arg_73_0.movie:setPosition(0, 0)
		arg_73_0.movie:setLoop(true)
		arg_73_0.movie:setCascadeOpacityEnabled(true)
		adjustTitleMovieScale(arg_73_0.movie, arg_73_0.n_bg)
		arg_73_0.movie:play()
	elseif var_73_1 == ".png" then
		local var_73_3 = cc.Sprite:create(var_73_0)
		
		if not get_cocos_refid(var_73_3) then
			return 
		end
		
		arg_73_0.n_bg:addChild(var_73_3)
	else
		return 
	end
	
	BackgroundEventData:onLoadSucceed()
end

function TitleBackground.makeDefaultBackground(arg_74_0)
	if not get_cocos_refid(arg_74_0.n_bg) then
		return 
	end
	
	if get_cocos_refid(arg_74_0.n_bg:getChildByName("default_bg")) then
		return 
	end
	
	local var_74_0 = cc.Node:create()
	
	var_74_0:setName("default_bg")
	var_74_0:setCascadeOpacityEnabled(true)
	arg_74_0.n_bg:addChild(var_74_0)
	arg_74_0:addEffect(var_74_0, "main_sky", {
		atlas = "open_renew"
	})
	arg_74_0:addEffect(var_74_0, "main_waterfall", {
		atlas = "open_renew"
	})
	arg_74_0:addEffect(var_74_0, "main_light", {
		atlas = "open_renew"
	})
	arg_74_0:addEffect(var_74_0, "main_light2", {
		atlas = "open_renew"
	})
	arg_74_0:addEffect(var_74_0, "main_twinkle1", {
		atlas = "open_renew"
	})
	arg_74_0:addEffect(var_74_0, "main_twinkle2", {
		atlas = "open_renew"
	})
	
	return var_74_0
end

function TitleBackground.makeImageBackground(arg_75_0)
	local var_75_0 = getenv("cdn.url") and getenv("cdn.url") .. "/webpubs/res/"
	
	if not var_75_0 then
		return 
	end
	
	local var_75_1 = var_75_0 .. "title/ep_cinema/title_" .. BackgroundEventData.ep_clear .. ".png"
	local var_75_2 = cc.FileUtils:getInstance():fullPathForFilename(var_75_1)
	
	if not var_75_2 or string.len(var_75_2) == 0 then
		return 
	end
	
	local var_75_3 = cc.Sprite:create(var_75_2)
	
	if not get_cocos_refid(var_75_3) then
		return 
	end
	
	return var_75_3
end
