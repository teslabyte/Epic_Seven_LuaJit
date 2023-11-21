DefaultShake = ClassDef()

function DefaultShake.constructor(arg_1_0, arg_1_1)
	local var_1_0 = 30
	
	arg_1_0.INFO = arg_1_1
	arg_1_0.TOTAL_TIME = math.max(0, arg_1_1.duration)
	arg_1_0.POWER_X = arg_1_1.powerX
	arg_1_0.POWER_Y = arg_1_1.powerY
	arg_1_0.INTERVAL = var_1_0 / (arg_1_1.timeScale or 1)
	arg_1_0.ELAPSED_TIME = 0
	arg_1_0.RAND = getRandom(systick())
	arg_1_0.OFFSET_X = 0
	arg_1_0.OFFSET_Y = 0
end

function DefaultShake.destroy(arg_2_0)
end

function DefaultShake.getName(arg_3_0)
	return arg_3_0.INFO.name
end

function DefaultShake.calc(arg_4_0)
	local var_4_0 = math.floor(arg_4_0.ELAPSED_TIME / arg_4_0.INTERVAL)
	
	if arg_4_0.turn ~= var_4_0 then
		arg_4_0.turn = var_4_0
		arg_4_0.OFFSET_X = arg_4_0.POWER_X * (arg_4_0.RAND:get() - 0.5)
		arg_4_0.OFFSET_Y = arg_4_0.POWER_Y * (arg_4_0.RAND:get() - 0.5)
	end
	
	return {
		arg_4_0.OFFSET_X,
		arg_4_0.OFFSET_Y,
		0
	}
end

SpineShake = ClassDef()

function SpineShake.constructor(arg_5_0, arg_5_1)
	arg_5_0.INFO = arg_5_1
	
	local var_5_0 = arg_5_1.source
	
	if not var_5_0:find("/") then
		var_5_0 = "camera/" .. var_5_0
	end
	
	if not var_5_0:ends(".scsp") then
		var_5_0 = var_5_0 .. ".scsp"
	end
	
	local var_5_1 = sp.SkeletonAnimation:create(var_5_0)
	local var_5_2 = 30
	
	arg_5_0.SOURCE = var_5_0
	arg_5_0.TOTAL_TIME = arg_5_1.duration
	arg_5_0.ANINODE = var_5_1
	arg_5_0.TIME_SCALE = arg_5_1.timeScale or 1
	arg_5_0.INTERVAL = var_5_2 / (arg_5_1.timeScale or 1)
	arg_5_0.ELAPSED_TIME = 0
	arg_5_0.OFFSET_X = 0
	arg_5_0.OFFSET_Y = 0
	arg_5_0.NSCENE = get_cocos_refid(BGI.game_layer) and BGI.game_layer or BGIManager:getBGI() and BGIManager:getBGI().game_layer
	
	if arg_5_0.TIME_SCALE < 0.001 then
		arg_5_0.TIME_SCALE = 0.001
	end
	
	if arg_5_0.NSCENE and get_cocos_refid(arg_5_0.ANINODE) then
		arg_5_0.NSCENE:addChild(arg_5_0.ANINODE)
		
		if arg_5_0.TOTAL_TIME < 0 then
			arg_5_0.IS_LOOP = false
			arg_5_0.TOTAL_TIME = 1000 * (arg_5_0.ANINODE:getAnimationDuration("animation") / arg_5_0.TIME_SCALE)
		end
	else
		arg_5_0.TOTAL_TIME = 0
	end
	
	if DEBUG.SHAKE then
		print("shake load ", arg_5_0.SOURCE, arg_5_0.TOTAL_TIME)
	end
end

function SpineShake.destroy(arg_6_0)
	if get_cocos_refid(arg_6_0.ANINODE) then
		arg_6_0.ANINODE:removeFromParent()
	end
end

function SpineShake.getName(arg_7_0)
	return arg_7_0.INFO.name
end

function SpineShake.calc(arg_8_0)
	if not get_cocos_refid(arg_8_0.ANINODE) then
		return {
			0,
			0,
			0
		}
	end
	
	if not arg_8_0.STARTED then
		arg_8_0.STARTED = true
		
		local var_8_0 = arg_8_0.ANINODE:setAnimation(0, "animation", arg_8_0.IS_LOOP)
		
		if var_8_0 then
			var_8_0.timeScale = arg_8_0.TIME_SCALE
		end
	end
	
	arg_8_0.OFFSET_X, arg_8_0.OFFSET_Y = arg_8_0.ANINODE:getBonePosition("camera")
	
	if DEBUG.SHAKE then
		print("shaking ", arg_8_0.OFFSET_X, arg_8_0.OFFSET_Y)
	end
	
	return {
		arg_8_0.OFFSET_X,
		arg_8_0.OFFSET_Y,
		0
	}
end

ShakeManager = {}
ShakeManager.shake_level = 1

function ShakeManager.createAction(arg_9_0, arg_9_1)
	if is_using_story_v2() and BGIManager:getBGI() and get_cocos_refid(BGIManager:getBGI().game_layer) then
	elseif not BGI or not get_cocos_refid(BGI.game_layer) then
		return NONE()
	end
	
	local var_9_0 = {
		Default = 0,
		Spine = 1
	}
	local var_9_1
	
	if var_9_0.Spine == arg_9_1.type then
		var_9_1 = SpineShake(arg_9_1)
	else
		var_9_1 = DefaultShake(arg_9_1)
	end
	
	return SPAWN(DELAY(var_9_1.TOTAL_TIME), CALL(ShakeManager.add, ShakeManager, var_9_1))
end

function ShakeManager.each(arg_10_0, arg_10_1)
	if not arg_10_0.list then
		return 
	end
	
	for iter_10_0, iter_10_1 in pairs(arg_10_0.list) do
		if arg_10_1(iter_10_1) == false then
			break
		end
	end
end

function ShakeManager.add(arg_11_0, arg_11_1)
	if not arg_11_0.list then
		arg_11_0.list = {}
	end
	
	table.insert(arg_11_0.list, arg_11_1)
end

function ShakeManager.stop(arg_12_0)
	arg_12_0.list = {}
end

function ShakeManager.getLastTransform(arg_13_0)
	return arg_13_0.offset_x or 0, arg_13_0.offset_y or 0, arg_13_0.offset_z or 0
end

function ShakeManager.update(arg_14_0)
	if not arg_14_0.list then
		return 
	end
	
	local var_14_0 = {
		0,
		0,
		0
	}
	local var_14_1 = false
	
	for iter_14_0 = #arg_14_0.list, 1, -1 do
		local var_14_2 = arg_14_0.list[iter_14_0]
		
		if not var_14_2.START_TIME then
			var_14_2.START_TIME = GET_LAST_TICK()
			var_14_2.FINISH_TIME = GET_LAST_TICK() + var_14_2.TOTAL_TIME
		end
		
		var_14_2.ELAPSED_TIME = GET_LAST_TICK() - var_14_2.START_TIME
		
		local var_14_3 = var_14_2:calc()
		
		if var_14_2.FINISH_TIME < GET_LAST_TICK() then
			var_14_2:destroy()
			table.remove(arg_14_0.list, iter_14_0)
		elseif var_14_3 then
			var_14_0[1] = var_14_0[1] + var_14_3[1] or 0
			var_14_0[2] = var_14_0[2] + var_14_3[2] or 0
			var_14_0[3] = var_14_0[3] + var_14_3[3] or 0
			var_14_1 = true
		end
	end
	
	if var_14_1 then
		arg_14_0.last_offset_x = arg_14_0.offset_x or 0
		arg_14_0.last_offset_y = arg_14_0.offset_y or 0
		arg_14_0.last_offset_z = arg_14_0.offset_z or 0
		arg_14_0.offset_x = var_14_0[1] * arg_14_0.shake_level
		arg_14_0.offset_y = var_14_0[2] * arg_14_0.shake_level
		arg_14_0.offset_z = var_14_0[3] * arg_14_0.shake_level
	else
		arg_14_0.offset_x = 0
		arg_14_0.offset_y = 0
		arg_14_0.offset_z = 0
	end
end

function ShakeManager.setShakeLevel(arg_15_0, arg_15_1)
	arg_15_0.shake_level = arg_15_1 or 1
end

function ShakeManager.resetDefault(arg_16_0)
	arg_16_0.shake_level = 1
	arg_16_0.offset_x = 0
	arg_16_0.offset_y = 0
	arg_16_0.offset_z = 0
end
