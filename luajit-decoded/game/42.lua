CACHE = CACHE or {}

function getModelNameAndAtlasPath(arg_1_0, arg_1_1, arg_1_2)
	if not string.ends(arg_1_0, ".skel") and not string.ends(arg_1_0, ".json") and not string.ends(arg_1_0, ".scsp") then
		arg_1_0 = arg_1_1 .. "/" .. arg_1_0 .. ".scsp"
	end
	
	local var_1_0, var_1_1, var_1_2 = Path.split(arg_1_0)
	
	arg_1_2 = arg_1_2 or var_1_1
	
	if not string.ends(arg_1_2, ".atlas") then
		arg_1_2 = Path.join(var_1_0, arg_1_2, ".atlas")
	end
	
	return arg_1_0, arg_1_2
end

function loadModel(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0
	
	arg_2_0, arg_2_2 = getModelNameAndAtlasPath(arg_2_0, arg_2_1, arg_2_2)
	
	if string.ends(arg_2_0, ".skel") or string.ends(arg_2_0, ".json") or string.ends(arg_2_0, ".scsp") then
		var_2_0 = ur.Model:create(arg_2_0, arg_2_2)
	end
	
	if var_2_0 == nil then
		print("Load model : " .. arg_2_0)
		
		var_2_0 = ur.Model:create("model/slime.scsp", "model/slime.atlas")
	end
	
	var_2_0:setAnchorPoint(0.5, 0)
	
	return var_2_0
end

function CACHE.releaseModel(arg_3_0, arg_3_1)
	if arg_3_1 and get_cocos_refid(arg_3_1) then
		arg_3_1:removeFromParent()
	end
end

function CACHE._getModel(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_4 = arg_4_4 or "model"
	
	if arg_4_1 then
		for iter_4_0, iter_4_1 in pairs(arg_4_1) do
			if iter_4_1.name == arg_4_2 and iter_4_1.atlas == arg_4_5 and iter_4_1.ref == 0 then
				iter_4_1.ref = iter_4_1.ref + 1
				
				iter_4_1.model:setColor(cc.c3b(255, 255, 255))
				iter_4_1.model:setOpacity(255)
				iter_4_1.model:setOpacityModifyRGB(true)
				iter_4_1.model:setVisible(true)
				iter_4_1.model:reset()
				
				return iter_4_1.model
			end
		end
	end
	
	return (loadModel(arg_4_2, arg_4_4, arg_4_5))
end

function CACHE.getModel(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	if type(arg_5_1) == "table" then
		local var_5_0 = arg_5_1
		
		arg_5_1 = var_5_0.model_id
		arg_5_5 = var_5_0.model_opt
		arg_5_2 = var_5_0.skin
		arg_5_4 = var_5_0.atlas
		arg_5_6 = var_5_0.ignore_timeline
		arg_5_3 = var_5_0.model_ani
	end
	
	local var_5_1 = arg_5_0:_getModel(nil, arg_5_1, arg_5_2, "model", arg_5_4)
	
	if arg_5_2 ~= nil then
		var_5_1:setSkin(arg_5_2)
	end
	
	if arg_5_5 then
		var_5_1:loadOption("model/" .. arg_5_5)
	end
	
	var_5_1:setTimeScale(1)
	var_5_1:setAnimation(0, arg_5_3 or "idle", true)
	
	local var_5_2 = var_5_1:getCurrent()
	
	if var_5_2 then
		var_5_2.time = var_5_2.endTime
		
		var_5_1:update(0)
		
		if var_5_1.body then
			var_5_1.body:update(0)
		end
	end
	
	var_5_1:setScaleFactor(BASE_SCALE)
	
	return var_5_1
end

function CACHE.getModelWithCheckAnim(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	local var_6_0 = arg_6_0:_getModel(nil, arg_6_1, arg_6_2, "model", arg_6_5)
	
	if arg_6_2 ~= nil then
		var_6_0:setSkin(arg_6_2)
	end
	
	if arg_6_6 then
		var_6_0:loadOption("model/" .. arg_6_6)
	end
	
	var_6_0:setTimeScale(1)
	
	if var_6_0:isExistAnimation(arg_6_3) then
		var_6_0:setAnimation(0, arg_6_3, true)
	else
		var_6_0:setAnimation(0, arg_6_4, true)
	end
	
	var_6_0:setScaleFactor(BASE_SCALE)
	
	return var_6_0
end

function getEffectPath(arg_7_0, arg_7_1)
	arg_7_1 = arg_7_1 or "effect"
	
	if not string.find(arg_7_0, "/") then
		arg_7_0 = arg_7_1 .. "/" .. arg_7_0
	end
	
	local var_7_0
	
	if not string.ends(arg_7_0, ".cfx") and not string.ends(arg_7_0, ".scsp") and not string.ends(arg_7_0, ".skel") and not string.ends(arg_7_0, ".particle") then
		local var_7_1 = arg_7_0 .. ".cfx"
		
		if cc.FileUtils:getInstance():isFileExist(var_7_1) then
			return var_7_1
		end
		
		local var_7_2 = arg_7_0 .. ".scsp"
		
		if cc.FileUtils:getInstance():isFileExist(var_7_2) then
			return var_7_2
		end
		
		local var_7_3 = arg_7_0 .. ".skel"
		
		if cc.FileUtils:getInstance():isFileExist(var_7_3) then
			return var_7_3
		end
		
		local var_7_4 = arg_7_0 .. ".particle"
		
		if cc.FileUtils:getInstance():isFileExist(var_7_4) then
			return var_7_4
		end
	end
	
	return arg_7_0
end

function CACHE.getEffect(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if not arg_8_1 then
		return 
	end
	
	local var_8_0 = Path.filename_withoutext(arg_8_1)
	
	if DEBUG.EFFECT_SOUND_TEST then
		print("CACHE.getEffect", var_8_0, arg_8_1)
	end
	
	arg_8_2 = arg_8_2 or "effect"
	
	local var_8_1 = getEffectPath(arg_8_1, arg_8_2)
	
	if string.ends(var_8_1, ".particle") then
		local var_8_2 = su.ParticleEffect2D:create(var_8_1)
		
		if not var_8_2 and not arg_8_3 then
			if not arg_8_3 then
				print("cant found file ", var_8_1)
			end
			
			return 
		end
		
		var_8_2:setScaleFactor(BASE_SCALE)
		var_8_2:setName(var_8_0)
		
		return var_8_2
	end
	
	if string.ends(var_8_1, ".cfx") then
		local var_8_3 = su.CompositiveEffect2D:create(var_8_1)
		
		if not var_8_3 then
			if not arg_8_3 then
				print("cant found file ", var_8_1)
			end
			
			return 
		end
		
		var_8_3:setScaleFactor(BASE_SCALE)
		var_8_3:setName(var_8_0)
		
		return var_8_3
	end
	
	if string.ends(arg_8_1, ".scsp") then
		arg_8_1 = string.gsub(arg_8_1, ".scsp", "")
	end
	
	local var_8_4 = arg_8_0:_getModel(nil, arg_8_1, nil, arg_8_2)
	
	var_8_4:setScaleFactor(BASE_SCALE)
	
	function var_8_4.setExtractNodes(arg_9_0)
	end
	
	function var_8_4.getEventDispatcher(arg_10_0)
	end
	
	function var_8_4.getDuration(arg_11_0)
		return arg_11_0:getAnimationDuration("animation")
	end
	
	function var_8_4.start(arg_12_0)
		arg_12_0:setAnimation(0, "animation", false)
		
		local var_12_0 = "event:/effect/" .. (arg_8_1 or "")
		
		if DEBUG.EFFECT_SOUND_TEST and not SoundEngine:existsEvent(var_12_0) then
			print("need effect sound !!  ", var_12_0)
		end
		
		SoundEngine:play(var_12_0)
	end
	
	function var_8_4.start_loop(arg_13_0)
		arg_13_0:setAnimation(0, "animation", true)
	end
	
	function var_8_4.stop(arg_14_0)
		arg_14_0:removeFromParent()
	end
	
	var_8_4:setName(var_8_0)
	
	return var_8_4
end

function CACHE.getMainEffect(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0
	local var_15_1
	local var_15_2
	local var_15_3, var_15_4, var_15_5 = Path.split(arg_15_1)
	
	return (arg_15_0:_getModel(nil, Path.join(var_15_3, var_15_4, ".scsp"), nil, arg_15_2))
end
