SoundEngine = SoundEngine or ccexp.SoundEngine
SoundEngine.soundEventTick = {}
SoundEngine.volume = SoundEngine.volume or {
	master = 1,
	voice = 1,
	battle = 1,
	ui = 1,
	bgm = 0.7
}
SoundEngine.mute = SoundEngine.mute or {
	master = false,
	voice = false,
	battle = false,
	ui = false,
	bgm = false
}

local var_0_0 = 0
local var_0_1 = 999
local var_0_2 = 10
local var_0_3 = 11
local var_0_4 = 12
local var_0_5 = 13

SoundEngine.AMB_MUSIC_TRACK_0 = var_0_2
SoundEngine.AMB_MUSIC_TRACK_1 = var_0_3
SoundEngine.AMB_MUSIC_TRACK_2 = var_0_4
SoundEngine.AMB_MUSIC_TRACK_3 = var_0_5
SoundEngine.START_SOUND_NODE = nil

function SoundEngine.linearChangeParam(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = {
		switch = function(arg_2_0, arg_2_1)
			SoundEngine:setMusicParam(var_0_0, "battle", arg_2_1)
		end
	}
	
	Action:Add(LINEAR_CALL(arg_1_3 or 3000, var_1_0, "switch", 1 - arg_1_2, arg_1_2), var_1_0)
end

function SoundEngine.pause(arg_3_0)
	SoundEngine:setPausedBus("bus:/", true)
end

function SoundEngine.resume(arg_4_0)
	SoundEngine:setPausedBus("bus:/", false)
end

function SoundEngine.clear(arg_5_0)
	SoundEngine.soundEventTick = {}
end

function SoundEngine.isPlayingBGM(arg_6_0, arg_6_1)
	if arg_6_0._defaultBGM == arg_6_1 then
		return true
	end
	
	return false
end

function SoundEngine.getMusicLength(arg_7_0, arg_7_1)
	arg_7_0.tmp_bgm_se = SoundEngine:playMusic(var_0_1, tostring(arg_7_1))
	
	if not arg_7_0.tmp_bgm_se then
		return 
	end
	
	local var_7_0 = arg_7_0:getLength(var_0_1)
	
	arg_7_0:stopMusic(var_0_1, false)
	
	arg_7_0.tmp_bgm_se = nil
	
	return var_7_0
end

function SoundEngine.playBGMatTime(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	arg_8_2 = arg_8_2 or 0
	arg_8_0.bgm_se = SoundEngine:playMusic(arg_8_3 or var_0_0, tostring(arg_8_1 or arg_8_0._defaultBGM))
	
	arg_8_0:setTrackTimelinePosition(arg_8_3 or var_0_0, arg_8_2)
	arg_8_0:updateBGM()
	
	return arg_8_0.bgm_se
end

function SoundEngine.changeToReadyToBGM(arg_9_0)
	if arg_9_0.ready_to_change_bgm then
		ResourceCollect:add("sound@", tostring(arg_9_0.ready_to_change_bgm))
		
		arg_9_0.bgm_se = SoundEngine:playMusic(var_0_0, tostring(arg_9_0.ready_to_change_bgm))
		
		arg_9_0:updateBGM()
		
		arg_9_0.ready_to_change_bgm = nil
	end
end

function SoundEngine.playStreamSound(arg_10_0, arg_10_1, arg_10_2)
	arg_10_2 = arg_10_2 or {}
	
	local var_10_0 = SoundEngine:playMusic(arg_10_2.track or var_0_0, cc.FileUtils:getInstance():fullPathForFilename(arg_10_1))
	local var_10_1 = false
	
	UIAction:Add(COND_LOOP(DELAY(100), function()
		if not get_cocos_refid(var_10_0) then
			return false
		end
		
		if not var_10_0.getAvailableRate then
			return false
		end
		
		local var_11_0 = var_10_0:getAvailableRate()
		
		if var_11_0 > 0 then
			if not var_10_1 then
				var_10_1 = true
				
				if arg_10_2.OnStart then
					if not get_cocos_refid(var_10_0) then
						return false
					end
					
					UIAction:Add(SEQ(WAIT_FRAME(1), CALL(function()
						arg_10_2.OnStart(var_10_0)
					end)), var_10_0, "block")
				end
			end
			
			if arg_10_2.OnUpdate then
				arg_10_2.OnUpdate(var_11_0, var_10_0)
			end
			
			if var_10_1 and var_11_0 >= 1 then
				if arg_10_2.OnEnd then
					arg_10_2.OnEnd(var_10_0)
				end
				
				return true
			end
		end
	end), var_10_0, "SoundEngine." .. arg_10_1)
	
	return var_10_0
end

function SoundEngine.playBGMWithFadeInOut(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if arg_13_0:processMusicBox() then
		return 
	end
	
	if arg_13_3 then
	elseif Action:Find("bgm.fade") then
		return 
	end
	
	local var_13_0 = arg_13_0.bgm_se
	local var_13_1
	
	if get_cocos_refid(var_13_0) then
		var_13_1 = LINEAR_CALL(arg_13_2 / 2, nil, function(arg_14_0, arg_14_1)
			if get_cocos_refid(var_13_0) then
				var_13_0:setVolume(arg_14_1)
			end
		end, arg_13_0:getRealVolume("bgm"), 0)
	else
		var_13_1 = DELAY(0)
	end
	
	arg_13_0.current_bgm = arg_13_1
	arg_13_0.ready_to_change_bgm = arg_13_1
	
	local var_13_2 = LINEAR_CALL(arg_13_2 / 2, nil, function(arg_15_0, arg_15_1)
		if get_cocos_refid(arg_13_0.bgm_se) then
			arg_13_0.bgm_se:setVolume(arg_15_1)
		end
	end, 0, arg_13_0:getRealVolume("bgm"))
	
	if Action:Find("bgm.fade") then
		arg_13_0:changeToReadyToBGM()
		Action:Remove("bgm.fade")
	end
	
	Action:Add(SEQ(var_13_1, CALL(function()
		ResourceCollect:add("sound@", tostring(arg_13_1 or arg_13_0._defaultBGM))
		
		arg_13_0.bgm_se = SoundEngine:playMusic(var_0_0, tostring(arg_13_1 or arg_13_0._defaultBGM))
		
		if get_cocos_refid(arg_13_0.bgm_se) then
			arg_13_0.bgm_se:setVolume(0)
		end
		
		arg_13_0.ready_to_change_bgm = nil
	end), var_13_2), arg_13_0, "bgm.fade")
end

function SoundEngine.processMusicBox(arg_17_0)
	local var_17_0 = MusicBox:isEnableScene(SceneManager:getCurrentSceneName()) and not is_playing_story()
	
	if MusicBox:isPauseReasonByDisableScene() and var_17_0 then
		MusicBox:resume()
		
		return true
	end
	
	if MusicBox:isPlaying() and var_17_0 then
		return true
	end
	
	if MusicBox:isPlaying() and not var_17_0 then
		MusicBox:stop({
			is_disable_scene = true
		})
		
		return 
	end
end

function SoundEngine.playBGM(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	arg_18_0.current_bgm = arg_18_1
	
	if not arg_18_2 and arg_18_1 then
		arg_18_0._defaultBGM = arg_18_1
	end
	
	if arg_18_0:processMusicBox() then
		return 
	end
	
	ResourceCollect:add("sound@", tostring(arg_18_1 or arg_18_0._defaultBGM))
	
	arg_18_0.bgm_se = SoundEngine:playMusic(var_0_0, tostring(arg_18_1 or arg_18_0._defaultBGM), arg_18_3)
	
	arg_18_0:updateBGM()
end

function SoundEngine.playAmbient(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_2 or var_0_2
	
	if var_19_0 < var_0_2 or var_19_0 > var_0_5 then
		return 
	end
	
	if not arg_19_1 then
		arg_19_0:stopAmbient(var_19_0)
	else
		local var_19_1 = SoundEngine:playMusic(var_19_0, arg_19_1)
		
		if get_cocos_refid(var_19_1) then
			var_19_1:setVolume(arg_19_0:getRealVolume("ui") or 1)
		end
	end
end

function SoundEngine.stopAmbient(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1 or var_0_2
	
	if var_20_0 < var_0_2 or var_20_0 > var_0_5 then
		return 
	end
	
	SoundEngine:stopMusic(var_20_0, true)
end

function SoundEngine.stopAllAmbient(arg_21_0)
	SoundEngine:stopMusic(var_0_2, true)
	SoundEngine:stopMusic(var_0_3, true)
	SoundEngine:stopMusic(var_0_4, true)
	SoundEngine:stopMusic(var_0_5, true)
end

function SoundEngine._play(arg_22_0, arg_22_1, arg_22_2)
	ResourceCollect:add("sound@", arg_22_1)
	
	arg_22_2 = arg_22_2 or {}
	
	return (SoundEngine:playWithControl(arg_22_1, arg_22_2))
end

function SoundEngine.collectStart(arg_23_0)
	arg_23_0.collect = {}
end

function SoundEngine.collectEnd(arg_24_0)
	arg_24_0.collect = nil
end

function SoundEngine.getCollectSound(arg_25_0)
	local var_25_0 = {}
	
	for iter_25_0, iter_25_1 in pairs(arg_25_0.collect or {}) do
		if get_cocos_refid(iter_25_1.sound) then
			table.insert(var_25_0, iter_25_1)
		end
	end
	
	return var_25_0
end

function SoundEngine.play(arg_26_0, arg_26_1, arg_26_2)
	if string.starts(arg_26_1, "event:/voc/") then
		return arg_26_0:playVoice(arg_26_1, arg_26_2)
	end
	
	if arg_26_0:getRealVolume("ui") == 0 then
		return 
	end
	
	local var_26_0 = arg_26_0:_play(arg_26_1, arg_26_2)
	
	if get_cocos_refid(var_26_0) then
		var_26_0:setVolume(arg_26_0:getRealVolume("ui") or 1)
	end
	
	return var_26_0
end

function SoundEngine.collectSound(arg_27_0, arg_27_1, arg_27_2)
	if arg_27_0.collect then
		table.insert(arg_27_0.collect, {
			sound = arg_27_1,
			mode = arg_27_2
		})
	end
end

function SoundEngine.playBattle(arg_28_0, arg_28_1)
	if arg_28_0:getRealVolume("battle") == 0 then
		return 
	end
	
	local var_28_0 = arg_28_0:_play(arg_28_1)
	
	if get_cocos_refid(var_28_0) then
		var_28_0:setVolume(arg_28_0:getRealVolume("battle") or 1)
		arg_28_0:collectSound(var_28_0, "battle")
	end
	
	return var_28_0
end

function _PLAY_BATTLE_SOUND(arg_29_0, arg_29_1)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_29_0 = DB("character", arg_29_0, "skin_check") or "action"
	local var_29_1 = #arg_29_0 <= 5 and arg_29_0 or string.sub(arg_29_0, 0, 5)
	local var_29_2 = DB("skillact", "sk_" .. var_29_1 .. "_" .. arg_29_1, var_29_0)
	
	if not var_29_2 then
		print("error : wrong char_code or skill number..")
		
		return 
	end
	
	SoundEngine:playBattle("event:/skill/" .. var_29_2)
	SoundEngine:play("event:/voc/skill/" .. var_29_2)
end

function SoundEngine.playVoice(arg_30_0, arg_30_1)
	if arg_30_0:getRealVolume("voice") == 0 then
		return 
	end
	
	if SoundEngine.block_voc then
		return 
	end
	
	local var_30_0 = arg_30_0:_play(arg_30_1)
	
	if get_cocos_refid(var_30_0) then
		var_30_0:setVolume(arg_30_0:getRealVolume("voice") or 1)
		arg_30_0:collectSound(var_30_0, "voice")
	end
	
	return var_30_0
end

function SoundEngine.playWithControl(arg_31_0, arg_31_1, arg_31_2)
	arg_31_2 = arg_31_2 or {}
	arg_31_2.gap = arg_31_2.gap or 200
	
	local var_31_0 = SoundEngine.soundEventTick[arg_31_1]
	
	if LAST_UI_TICK < to_n(var_31_0) + arg_31_2.gap then
		return 
	end
	
	local var_31_1 = SoundEngine:createEvent(arg_31_1)
	
	if get_cocos_refid(var_31_1) then
		var_31_1:start()
		
		if arg_31_2.vol then
			var_31_1:setVolume(arg_31_2.vol)
		end
		
		SoundEngine.soundEventTick[arg_31_1] = LAST_UI_TICK
	end
	
	return var_31_1
end

function SOUND(...)
	return CALL(SoundEngine.play, SoundEngine, ...)
end

function SoundEngine.setFadeSoundOnStoryBGM(arg_33_0, arg_33_1)
	if arg_33_0.mute.bgm then
		if not arg_33_1 then
			SoundEngine:resume()
		end
		
		return 
	end
	
	local function var_33_0(arg_34_0, arg_34_1)
		if get_cocos_refid(arg_34_0.bgm_se) then
			arg_34_0.bgm_se:setVolume(arg_34_1)
		end
		
		if arg_34_1 <= 0 then
			SoundEngine:pause()
		else
			SoundEngine:resume()
		end
	end
	
	if Action:Find("bgm.fade") then
		arg_33_0:changeToReadyToBGM()
		Action:Remove("bgm.fade")
	end
	
	if arg_33_1 then
		arg_33_0.origin_bgm_vol = arg_33_0:getRealVolume("bgm")
		
		Action:Add(LINEAR_CALL(1500, arg_33_0, var_33_0, arg_33_0.origin_bgm_vol, 0), arg_33_0, "bgm.fade")
	else
		arg_33_0.origin_bgm_vol = arg_33_0:getRealVolume("bgm")
		
		Action:Add(LINEAR_CALL(1500, arg_33_0, var_33_0, 0, arg_33_0.origin_bgm_vol or 1), arg_33_0, "bgm.fade")
	end
end

function SoundEngine.setMute(arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	arg_35_0.mute[arg_35_1] = arg_35_2
	
	if arg_35_1 == "master" then
		arg_35_0:updateBGM()
	elseif arg_35_1 == "bgm" then
		local function var_35_0(arg_36_0, arg_36_1)
			if get_cocos_refid(arg_36_0.bgm_se) then
				arg_36_0.bgm_se:setVolume(arg_36_1)
			end
		end
		
		if Action:Find("bgm.fade") then
			arg_35_0:changeToReadyToBGM()
			Action:Remove("bgm.fade")
		end
		
		if not arg_35_2 and arg_35_3 then
			Action:Add(LINEAR_CALL(1500, arg_35_0, var_35_0, 0, arg_35_0:getRealVolume("bgm")), arg_35_0, "bgm.fade")
		else
			arg_35_0:updateBGM()
		end
	end
end

function SoundEngine.setVolumeMaster(arg_37_0, arg_37_1)
	arg_37_1 = arg_37_1 or 1
	arg_37_0.volume.master = arg_37_1
end

function SoundEngine.setVolumeBGM(arg_38_0, arg_38_1, arg_38_2)
	arg_38_1 = arg_38_1 or 1
	
	local var_38_0 = arg_38_0.volume.bgm
	
	arg_38_0.volume.bgm = arg_38_1
	
	if var_38_0 == 0 and arg_38_1 > 0 and not MusicBox:isPlaying() then
		if arg_38_2 then
			arg_38_0:playBGM(arg_38_0.current_bgm)
		else
			arg_38_0:playBGM(arg_38_0._defaultBGM)
		end
		
		print("replay bgm", arg_38_0._defaultBGM)
	end
	
	arg_38_0:updateBGM()
	
	if arg_38_1 == 0 and not MusicBox:isPlaying() then
		arg_38_0.bgm_se = nil
	end
end

function SoundEngine.setVolumeBattle(arg_39_0, arg_39_1)
	arg_39_1 = arg_39_1 or 1
	arg_39_0.volume.battle = arg_39_1
end

function SoundEngine.setVolumeVoice(arg_40_0, arg_40_1)
	arg_40_1 = arg_40_1 or 1
	arg_40_0.volume.voice = arg_40_1
end

function SoundEngine.setVolumeUI(arg_41_0, arg_41_1)
	arg_41_1 = arg_41_1 or 1
	arg_41_0.volume.ui = arg_41_1
end

function SoundEngine.getRealVolume(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0.mute.master == true and 0 or arg_42_0:getVolume("master")
	
	return arg_42_0.mute[arg_42_1] and 0 or arg_42_0:getVolume(arg_42_1) * var_42_0
end

function SoundEngine.getVolume(arg_43_0, arg_43_1)
	return arg_43_0.volume[arg_43_1] or 1
end

function SoundEngine.updateBGM(arg_44_0)
	if get_cocos_refid(arg_44_0.bgm_se) then
		arg_44_0.bgm_se:setVolume(arg_44_0:getRealVolume("bgm"))
	end
end
