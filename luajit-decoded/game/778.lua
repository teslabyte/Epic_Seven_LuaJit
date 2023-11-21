SPLStoryData = ClassDef()

function SPLStoryData.constructor(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = string.format("%s_%02d", arg_1_1, arg_1_2)
	
	arg_1_0.db = DBT("tile_sub_npc_text", var_1_0, {
		"id",
		"npc_icon",
		"npc_name",
		"message",
		"talkbox_l",
		"eff",
		"touch_delay"
	})
end

function SPLStoryData.getStoryID(arg_2_0)
	if not arg_2_0.db then
		return 
	end
	
	return arg_2_0.db.id
end

function SPLStoryData.getIcon(arg_3_0)
	if not arg_3_0.db then
		return 
	end
	
	return arg_3_0.db.npc_icon
end

function SPLStoryData.getName(arg_4_0)
	if not arg_4_0.db then
		return 
	end
	
	return arg_4_0.db.npc_name
end

function SPLStoryData.getText(arg_5_0)
	if not arg_5_0.db then
		return 
	end
	
	return arg_5_0.db.message
end

function SPLStoryData.getDelay(arg_6_0)
	if not arg_6_0.db then
		return 
	end
	
	return arg_6_0.db.touch_delay
end

SPLSpeechData = ClassDef(SPLStoryData)

function SPLSpeechData.constructor(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = string.format("%s_%02d", arg_7_1, arg_7_2)
	
	arg_7_0.db = DBT("tile_sub_speech", var_7_0, {
		"id",
		"value",
		"message",
		"offset",
		"reflect",
		"delay"
	})
end

function SPLSpeechData.getOffset(arg_8_0)
	if not arg_8_0.db then
		return 
	end
	
	local var_8_0 = string.split(arg_8_0.db.offset, ",") or {}
	
	return var_8_0[1] or 0, var_8_0[2] or 0
end

function SPLSpeechData.isReflect(arg_9_0)
	if not arg_9_0.db then
		return 
	end
	
	return arg_9_0.db.reflect
end

function SPLSpeechData.getTargetObject(arg_10_0)
	if not arg_10_0.db then
		return 
	end
	
	return SPLObjectSystem:getObjectByKey(arg_10_0.db.value)
end

function SPLSpeechData.getDelay(arg_11_0)
	if not arg_11_0.db then
		return 
	end
	
	return arg_11_0.db.delay
end
