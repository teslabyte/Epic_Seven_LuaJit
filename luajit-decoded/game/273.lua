Timeline = Timeline or {}
Timeline._FUNC = Timeline._FUNC or {}
Timeline._FRAME_QUEUE_LIST = Timeline._FRAME_QUEUE_LIST or {}
Timeline._FUNC = {}

function Timeline._FUNC.SHAKE(arg_1_0, arg_1_1)
	local var_1_0 = Timeline:getPlayLayer(arg_1_1.layer)
	local var_1_1 = arg_1_1.act_name
	local var_1_2 = arg_1_0.param
	
	var_1_2.name = "timeline"
	
	local var_1_3 = ShakeManager:createAction(var_1_2)
	
	Action:Add(var_1_3, var_1_0, var_1_1)
end

function Timeline._FUNC.DARK(arg_2_0, arg_2_1)
	local var_2_0 = {
		Default = 0,
		IgnoreCasterAndTarget = 2,
		IgnoreCaster = 1
	}
	local var_2_1 = arg_2_1.layer
	
	if BGI and BGI.main then
		var_2_1 = BGI.main.fade_layer or BGI.main.layer or arg_2_1.layer
	end
	
	local var_2_2 = arg_2_0.param
	local var_2_3 = tocolor(var_2_2.color)
	
	play_curtain(var_2_1, 0, var_2_2.fadeIn or 0, var_2_2.duration or 1000, var_2_2.fadeOut or 0, act_name, false, var_2_2.localZ or 0, var_2_2.opacity, var_2_3, var_2_2.globalZ)
end

function Timeline._FUNC.EFFECT(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0.param
	
	if not var_3_0.source then
		return 
	end
	
	local var_3_1 = var_3_0.id or var_3_0.source
	local var_3_2 = var_3_0.location
	local var_3_3
	local var_3_4
	
	if var_3_0.locationBone and string.len(var_3_0.locationBone) > 0 then
		var_3_4 = arg_3_1.actor:getBoneNode(var_3_0.locationBone)
		
		if var_3_4 then
			var_3_3 = PivotByBone(var_3_4, arg_3_1.actor)
		elseif IS_TOOL_MODE then
			balloon_message(string.format("timeline: \"%s\" 본이 없습니다. ( \"%s\" \"%s\" 이펙트 재생중  )", var_3_0.locationBone, arg_3_1.ani, var_3_0.source))
		end
	end
	
	var_3_3 = var_3_3 or PivotByModel(arg_3_1.actor)
	
	local var_3_5 = arg_3_1.layer
	
	if string.len(var_3_1) == 0 then
		var_3_1 = var_3_0.source
	end
	
	local var_3_6 = arg_3_1.actor:removeTimelineObject(var_3_1)
	
	for iter_3_0, iter_3_1 in pairs(var_3_6) do
		if get_cocos_refid(iter_3_1) and (not iter_3_1.getDuration or iter_3_1:getDuration() <= 0) then
			stop_or_remove(iter_3_1)
		end
	end
	
	local var_3_7 = CACHE:getEffect(var_3_0.source)
	
	if not var_3_7 then
		return 
	end
	
	var_3_7:setName(var_3_1)
	arg_3_1.actor:addTimelineObject(var_3_1, var_3_7)
	
	if var_3_4 then
		arg_3_1.actor:insertPartsObject(var_3_1, var_3_7)
	end
	
	local var_3_8 = not var_3_0.disableAutoFlipX and arg_3_1.actor:getScaleX() < 0 and arg_3_1.actor ~= var_3_5
	local var_3_9 = arg_3_1.actor:getScaleFactor()
	local var_3_10 = (var_3_0.scale or 1) * arg_3_1.actor:getScaleY()
	local var_3_11 = (var_3_0.x or 0) * var_3_9 * var_3_10
	local var_3_12 = (var_3_0.y or 0) * var_3_9 * var_3_10
	local var_3_13 = var_3_0.z or 0
	local var_3_14, var_3_15 = var_3_3:getWorldPosition()
	local var_3_16 = var_3_3:getLocalZOrder()
	
	if var_3_8 then
		var_3_11 = -var_3_11
	end
	
	local var_3_17 = tonumber(arg_3_1.elapsed_time) or 0
	
	EffectManager:EffectPlay({
		extractNodes = true,
		is_battle_effect = true,
		effect = var_3_7,
		name = var_3_1,
		layer = var_3_5,
		ancestor = var_3_5,
		x = var_3_14 + var_3_11,
		y = var_3_15 + var_3_12,
		z = var_3_16 + var_3_13,
		scale = var_3_10,
		base_scale = var_3_0.scale or 1,
		flip_x = var_3_8,
		scaleFactor = var_3_9,
		tag = arg_3_1.actor:getLuaTag(),
		owner = arg_3_1.actor
	})
	
	while var_3_17 > 0 do
		var_3_7:update(math.min(200, var_3_17) / 1000)
		
		var_3_17 = var_3_17 - 200
	end
	
	if LOCATION_TYPE_ATTACH_TYPE_TABLE[var_3_2] then
		local function var_3_18()
		end
		
		var_3_3:setFollower(var_3_7, var_3_11, var_3_12, var_3_13, var_3_18)
	end
end

function Timeline._FUNC.REMOVE(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.param
	local var_5_1 = arg_5_1.actor:removeTimelineObject(var_5_0.targetId)
	
	for iter_5_0, iter_5_1 in pairs(var_5_1) do
		stop_or_remove(iter_5_1, var_5_0.delay)
	end
end

function Timeline.getPlayLayer(arg_6_0, arg_6_1)
	if BGI and get_cocos_refid(BGI.game_layer) then
		return BGI.game_layer
	end
	
	return arg_6_1
end

function Timeline.executeFrames(arg_7_0, arg_7_1)
	if not arg_7_1.frames then
		Log.e("Timeline", "no frames")
		
		return 
	end
	
	if not arg_7_1.actor:getParent() then
		Log.e("Timeline", "no parent ", debug.traceback())
		
		return 
	end
	
	local var_7_0 = SceneManager:getRunningNativeScene()
	
	if not get_cocos_refid(var_7_0) then
		return 
	end
	
	arg_7_0:flushCascadeFrames(var_7_0, arg_7_1.actor)
	
	local var_7_1 = {
		actor = arg_7_1.actor,
		layer = arg_7_1.actor:getParent(),
		ani = arg_7_1.ani,
		duration = arg_7_1.duration,
		act_name = arg_7_1.act_name or "timeline",
		values = {}
	}
	local var_7_2 = math.ceil(arg_7_1.duration * 1000)
	local var_7_3 = {}
	local var_7_4 = 1
	
	for iter_7_0, iter_7_1 in ipairs(arg_7_1.frames) do
		iter_7_1.time = iter_7_1.time or 0
		
		local var_7_5 = string.upper(iter_7_1.func or "")
		local var_7_6 = arg_7_0._FUNC[var_7_5]
		
		if var_7_6 then
			local var_7_7 = {
				actor = arg_7_1.actor,
				order = var_7_4,
				time = GET_LAST_TICK() + iter_7_1.time,
				cascade = var_7_2 >= iter_7_1.time,
				arg = var_7_1,
				call = function()
					xpcall(var_7_6, __G__TRACKBACK__, iter_7_1, var_7_1)
				end
			}
			
			table.insert(var_7_3, var_7_7)
			
			var_7_4 = var_7_4 + 1
		end
	end
	
	table.sort(var_7_3, function(arg_9_0, arg_9_1)
		if arg_9_0.time == arg_9_1.time then
			return arg_9_0.order < arg_9_1.order
		end
		
		return arg_9_0.time < arg_9_1.time
	end)
	
	local var_7_8 = arg_7_0._FRAME_QUEUE_LIST[arg_7_1.actor]
	
	if not var_7_8 then
		var_7_8 = {}
		arg_7_0._FRAME_QUEUE_LIST[arg_7_1.actor] = var_7_8
	end
	
	for iter_7_2, iter_7_3 in pairs(var_7_3) do
		table.insert(var_7_8, iter_7_3)
	end
	
	if not arg_7_0._SCHEDULER or arg_7_0._SCHEDULER.removed then
		arg_7_0._SCHEDULER = Scheduler:add(var_7_0, Timeline.procFrames, arg_7_0)
	end
end

function Timeline.flushCascadeFrames(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0._SCHEDULER or arg_10_0._SCHEDULER.removed or arg_10_1 ~= arg_10_0._SCHEDULER.obj then
		if arg_10_0._SCHEDULER and arg_10_1 ~= arg_10_0._SCHEDULER.obj then
			Log.i("Timeline", "이전 씬의 스케쥴러임")
		end
		
		arg_10_0._SCHEDULER = nil
		arg_10_0._FRAME_QUEUE_LIST = {}
		
		return 
	end
	
	local var_10_0 = arg_10_0._FRAME_QUEUE_LIST[arg_10_2]
	
	if not var_10_0 then
		return 
	end
	
	local var_10_1 = {}
	
	for iter_10_0 = #var_10_0, 1, -1 do
		if var_10_0[iter_10_0].cascade then
			local var_10_2 = table.remove(var_10_0, iter_10_0)
			
			table.insert(var_10_1, var_10_2)
		end
	end
	
	for iter_10_1, iter_10_2 in pairs(var_10_1) do
		iter_10_2.call()
	end
end

function Timeline.procFrames(arg_11_0)
	if not arg_11_0._SCHEDULER or arg_11_0._SCHEDULER.removed then
		arg_11_0._SCHEDULER = nil
		arg_11_0._FRAME_QUEUE_LIST = {}
		
		return 
	end
	
	for iter_11_0, iter_11_1 in pairs(arg_11_0._FRAME_QUEUE_LIST) do
		if get_cocos_refid(iter_11_0) then
			while iter_11_1[1] do
				local var_11_0 = iter_11_1[1].arg
				
				if not var_11_0.track_time then
					local var_11_1 = iter_11_0:getCurrent()
					
					if var_11_1 and var_11_1.animation == var_11_0.ani then
						var_11_0.track_time = var_11_1.time * 1000
					else
						var_11_0.track_time = 0
					end
				end
				
				local var_11_2 = GET_LAST_TICK()
				
				if iter_11_1[1].time <= var_11_2 + var_11_0.track_time then
					local var_11_3 = table.remove(iter_11_1, 1)
					
					var_11_0.elapsed_time = var_11_2 + var_11_0.track_time - var_11_3.time
					
					var_11_3.call()
				else
					break
				end
			end
		else
			iter_11_1 = {}
		end
		
		if table.empty(iter_11_1) then
			arg_11_0._FRAME_QUEUE_LIST[iter_11_0] = nil
		end
	end
	
	if table.empty(arg_11_0._FRAME_QUEUE_LIST) then
		arg_11_0._SCHEDULER.removed = true
		arg_11_0._SCHEDULER = nil
	end
end

function Timeline.getDuration(arg_12_0, arg_12_1, arg_12_2)
	if not arg_12_1 then
		return 0
	end
	
	local var_12_0 = arg_12_1[arg_12_2]
	
	if not var_12_0 then
		return 0
	end
	
	return var_12_0.duration
end

function Timeline.getEventMap(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_1 then
		return {}
	end
	
	local var_13_0 = arg_13_1[arg_13_2]
	
	if not var_13_0 or not var_13_0.frames then
		return {}
	end
	
	local var_13_1 = {}
	
	for iter_13_0, iter_13_1 in ipairs(var_13_0.frames) do
		local var_13_2 = iter_13_1.time or 0
		local var_13_3 = string.lower(iter_13_1.func or "")
		
		if string.starts(var_13_3, "event") then
			var_13_1[iter_13_1.param.name] = var_13_2 / 1000
		end
	end
	
	return var_13_1
end

function Timeline.getEvents(arg_14_0, arg_14_1, arg_14_2)
	if not arg_14_1 then
		return {}
	end
	
	local var_14_0 = arg_14_1[arg_14_2]
	
	if not var_14_0 or not var_14_0.frames then
		return {}
	end
	
	local var_14_1
	local var_14_2 = {}
	
	for iter_14_0, iter_14_1 in ipairs(var_14_0.frames) do
		local var_14_3 = iter_14_1.time or 0
		local var_14_4 = string.lower(iter_14_1.func or "")
		
		if string.starts(var_14_4, "fire") or string.starts(var_14_4, "hit") then
			table.insert(var_14_2, {
				var_14_4,
				var_14_3 / 1000
			})
			
			var_14_1 = true
		elseif string.starts(var_14_4, "event") then
			table.insert(var_14_2, {
				iter_14_1.param.name,
				var_14_3 / 1000
			})
		end
	end
	
	return var_14_2, var_14_1
end

function Timeline.executeFromData(arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_1 then
		return 
	end
	
	local var_15_0 = arg_15_1[arg_15_2.ani]
	
	if not var_15_0 then
		return 
	end
	
	arg_15_0:executeFrames({
		frames = var_15_0.frames,
		actor = arg_15_2.actor,
		ani = arg_15_2.ani,
		duration = arg_15_2.duration
	})
end

function Timeline.build(arg_16_0, arg_16_1)
	local var_16_0 = cc.FileUtils:getInstance():fullPathForFilename(arg_16_1 .. ".timeline")
	
	if IS_TOOL_MODE then
		local var_16_1 = cc.FileUtils:getInstance():fullPathForFilename(arg_16_1 .. ".timeline.work")
		
		if io.exists(var_16_1) then
			var_16_0 = var_16_1
		end
	end
	
	local var_16_2 = cc.FileUtils:getInstance():getStringFromFile(var_16_0)
	
	if var_16_2 == "" then
		return {}
	end
	
	return (json.decode(var_16_2) or {}).timeline or {}
end
