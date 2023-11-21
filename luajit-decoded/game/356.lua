TalkVoicePlayer = ClassDef()

function TalkVoicePlayer.constructor(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	if string.empty(arg_1_1) or not get_cocos_refid(arg_1_2) then
		return false
	end
	
	arg_1_0.voc_path = arg_1_1
	arg_1_0.cursor = arg_1_2
	arg_1_0.move_updown = arg_1_3
	arg_1_0.move_updown_action_name = arg_1_4
	arg_1_0.skip_time_callback = arg_1_5
	arg_1_0.is_skippable = false
end

function TalkVoicePlayer.playAndBlock(arg_2_0)
	arg_2_0.voc = SoundEngine:play(arg_2_0.voc_path)
	
	if get_cocos_refid(arg_2_0.cursor) then
		arg_2_0.cursor:setVisible(false)
	end
	
	local var_2_0 = GAME_CONTENT_VARIABLE.voice_skip_time or 3000
	
	UIAction:Add(SEQ(DELAY(var_2_0), CALL(TalkVoicePlayer._onSkipTime, arg_2_0)), arg_2_0.cursor, "block")
end

function TalkVoicePlayer._onSkipTime(arg_3_0)
	arg_3_0.is_skippable = true
	
	if get_cocos_refid(arg_3_0.cursor) then
		arg_3_0.cursor:setVisible(true)
	end
	
	if get_cocos_refid(arg_3_0.move_updown) then
		UIAction:Add(LOOP(SEQ(LOG(MOVE_TO(220, 20, 30)), DELAY(120), RLOG(MOVE_TO(220, 20, 12)))), arg_3_0.move_updown, arg_3_0.move_updown_action_name)
	end
	
	if arg_3_0.skip_time_callback then
		arg_3_0.skip_time_callback()
	end
end

function TalkVoicePlayer.tryStop(arg_4_0)
	if not get_cocos_refid(arg_4_0.voc) then
		return true
	end
	
	if arg_4_0.is_skippable then
		arg_4_0.voc:stop()
		
		arg_4_0.voc = nil
		
		return true
	end
	
	return false
end

UIHelper = {}

function UIHelper.playTalkVoice(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = TalkVoicePlayer(arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	
	if var_5_0 then
		var_5_0:playAndBlock()
	end
	
	return var_5_0
end
