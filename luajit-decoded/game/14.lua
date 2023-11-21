sp.ANIMATION_START = 0
sp.ANIMATION_END = 1
sp.ANIMATION_COMPLETE = 2
sp.ANIMATION_EVENT = 3
sp.MASK_SLOT_RENDER = 1

local var_0_0 = {
	no_sound_anis = {}
}
local var_0_1 = {}

ur = ur or {}
ur.Model = var_0_0
ur.ModelStage = var_0_1

local function var_0_2(arg_1_0)
	if not string.find(arg_1_0, "/") then
		return "model/" .. arg_1_0
	end
	
	return arg_1_0
end

function var_0_1.create(arg_2_0, arg_2_1)
	local var_2_0 = cc.Node:create()
	
	var_2_0.model = arg_2_1
	
	var_2_0:addChild(arg_2_1)
	
	return copy_functions(ur.ModelStage, var_2_0)
end

function var_0_1.setAnimation(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	return arg_3_0.model:setAnimation(arg_3_1, arg_3_2, arg_3_3)
end

function var_0_1.getCurrent(arg_4_0)
	return arg_4_0.model:getCurrent()
end

function var_0_0.create(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = cc.Node:create()
	
	var_5_0:setCascadeColorEnabled(true)
	var_5_0:setCascadeOpacityEnabled(true)
	
	var_5_0.super = getmetatable(var_5_0)
	var_5_0.attr = {}
	var_5_0.prop = {}
	var_5_0.next_animations = {}
	
	local var_5_1, var_5_2, var_5_3 = path.split(arg_5_1)
	
	var_5_0.res_id = var_5_2
	var_5_0.retrivePath = var_5_1
	var_5_0.source = arg_5_1
	var_5_0.atlas = arg_5_2
	var_5_0.init_source = arg_5_1
	var_5_0.init_atlas = arg_5_2
	var_5_0.body = sp.SkeletonAnimation:create(arg_5_1, arg_5_2, arg_5_3 or 1)
	
	if not var_5_0.body then
		var_5_0.body = sp.SkeletonAnimation:create("system/default/404.scsp", "system/default/404.atlas", arg_5_3 or 1)
		var_5_0.is_err = true
		
		local var_5_4 = create_label(arg_5_1)
		
		var_5_4:setFontSize(24)
		var_5_4:setScale(1.5)
		var_5_4:setAnchorPoint(0.5, 2)
		var_5_0.body:addChild(var_5_4)
	end
	
	var_5_0.body:setAnchorPoint(0.5, 0)
	var_5_0.body:update(math.random())
	
	local function var_5_5(arg_6_0)
		if arg_6_0.target == var_5_0.body then
			var_5_0:onBlendColorChanged()
		end
	end
	
	local var_5_6 = cc.EventListenerCustom:create("blend_changed", var_5_5)
	
	var_5_0.body:getEventDispatcher():addEventListenerWithSceneGraphPriority(var_5_6, var_5_0.body)
	var_5_0:setName(arg_5_1)
	var_5_0:addChild(var_5_0.body)
	var_5_0.body:setIgnoreMask("global_base_shadow", sp.MASK_SLOT_RENDER)
	
	var_5_0.is_model = true
	
	var_5_0.body:registerSpineEventHandler(function(arg_7_0, arg_7_1)
		if arg_7_0.animation == "run" then
			local var_7_0 = arg_7_0.eventData
			
			LuaEventDispatcher:dispatchEvent("spine.ani", EVENT.ANI(var_7_0.name, var_5_0, arg_7_0.animation))
		end
	end, sp.ANIMATION_EVENT)
	
	var_5_0.parts_list = {}
	var_5_0.prop.parts_flags = {}
	var_5_0["-onscript_handlers"] = {}
	var_5_0["-onupdate_handlers"] = {}
	
	var_5_0:registerUpdateLuaHandler(function(arg_8_0)
		local var_8_0 = var_5_0["-onupdate_handlers"]
		
		for iter_8_0, iter_8_1 in pairs(var_8_0) do
			iter_8_1(var_5_0, arg_8_0)
		end
	end)
	var_5_0:registerScriptHandler(function(arg_9_0)
		local var_9_0 = var_5_0["-onscript_handlers"]
		
		for iter_9_0, iter_9_1 in pairs(var_9_0) do
			iter_9_1(var_5_0, arg_9_0)
		end
		
		if arg_9_0 == "enter" then
			var_5_0:scheduleUpdate()
		end
	end)
	
	arg_5_0.extra_info = nil
	
	return copy_functions(ur.Model, var_5_0)
end

function var_0_0.addScriptHandler(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0["-onscript_handlers"][arg_10_2] = arg_10_1
end

function var_0_0.removeScriptHandler(arg_11_0, arg_11_1)
	arg_11_0["-onscript_handlers"][arg_11_1] = nil
end

function var_0_0.addUpdateHandler(arg_12_0, arg_12_1, arg_12_2)
	arg_12_0["-onupdate_handlers"][arg_12_2] = arg_12_1
end

function var_0_0.removeUpdatetHandler(arg_13_0, arg_13_1)
	arg_13_0["-onupdate_handlers"][arg_13_1] = nil
end

function var_0_0.setLuaTag(arg_14_0, arg_14_1)
	arg_14_0["-tag"] = arg_14_1
end

function var_0_0.getLuaTag(arg_15_0)
	return arg_15_0["-tag"]
end

function var_0_0.getRenderingBoundingbox(arg_16_0)
	local var_16_0 = get_skeleton_rendering_boundingbox(arg_16_0.body)
	local var_16_1 = arg_16_0.body:getRealScaleX()
	local var_16_2 = arg_16_0.body:getRealScaleY()
	local var_16_3 = 1
	local var_16_4 = 1
	
	return {
		x = var_16_0.x * var_16_1,
		y = var_16_0.y * var_16_2,
		width = var_16_0.width * var_16_1,
		height = var_16_0.height * var_16_2
	}
end

function var_0_0.showRenderingBoundingbox(arg_17_0, arg_17_1, arg_17_2)
	arg_17_0:removeChildByName("@RenderingBoundingbox")
	
	if arg_17_1 then
		local var_17_0 = arg_17_0:getRenderingBoundingbox()
		local var_17_1 = cc.DrawNode:create()
		
		var_17_1:drawRect(cc.p(var_17_0.x, var_17_0.y), cc.p(var_17_0.x + var_17_0.width, var_17_0.y + var_17_0.height), arg_17_2 or cc.c4f(1, 1, 1, 1))
		var_17_1:setName("@RenderingBoundingbox")
		arg_17_0:addChild(var_17_1)
	end
end

function var_0_0.reset(arg_18_0)
	local var_18_0 = arg_18_0:getChildren()
	
	for iter_18_0, iter_18_1 in pairs(var_18_0) do
		if arg_18_0.body == iter_18_1 then
			iter_18_1:removeAllChildren()
		else
			arg_18_0:removeChild(iter_18_1)
		end
	end
	
	arg_18_0:resetTimeline()
	arg_18_0.body:removeAllBoneNode()
end

function var_0_0.loadOption(arg_19_0, arg_19_1)
	local var_19_0 = cc.FileUtils:getInstance():getStringFromFile(arg_19_1)
	
	if not var_19_0 then
		return 
	end
	
	local var_19_1 = json.decode(var_19_0)
	
	if not var_19_1 then
		return 
	end
	
	if var_19_1.body and var_19_1.body.shader and SHADER_METHOD then
		local var_19_2 = SHADER_METHOD[var_19_1.body.shader.name]
		
		if var_19_2 then
			arg_19_0.prop.shader_name = var_19_1.body.shader.name
			
			var_19_2(arg_19_0.body, table.unpack(var_19_1.body.shader.args))
		end
	end
	
	if var_19_1.attach then
		for iter_19_0, iter_19_1 in pairs(var_19_1.attach) do
			arg_19_0:loadNodeSource(iter_19_1)
		end
	end
	
	arg_19_0.body:setGLProgramState(nil)
end

function var_0_0.loadNodeSource(arg_20_0, arg_20_1)
	local var_20_0
	
	if not arg_20_1 or not arg_20_1.source then
		return 
	end
	
	if string.ends(arg_20_1.source, ".cfx") then
		arg_20_0:addPartsObject({
			name = string.format("%s/%s", arg_20_1.bone or "", arg_20_1.source or ""),
			source = arg_20_1.source,
			bone = arg_20_1.bone,
			z = arg_20_1.z
		})
	end
end

function var_0_0.setSetupPose(arg_21_0)
	arg_21_0.body:setBonesToSetupPose()
	arg_21_0.body:setSlotsToSetupPose()
end

function var_0_0.getLastAnimation(arg_22_0)
	return arg_22_0.prop.last_animation
end

function var_0_0.playRunAnimation(arg_23_0)
	local var_23_0 = arg_23_0:getCurrent()
	
	if not var_23_0 or var_23_0.animation ~= "run" then
		arg_23_0:setAnimation(0, "run_start", false)
		
		local var_23_1 = "run"
		
		if not SAVE:isTutorialFinished() and arg_23_0:isExistAnimation("run_intro") then
			var_23_1 = "run_intro"
		end
		
		local var_23_2 = arg_23_0:setAnimation(0, var_23_1, true)
		
		if var_23_2 then
			var_23_2.time = var_23_2.endTime * math.random()
		end
	end
end

function var_0_0.setNoSoundAniFlag(arg_24_0, arg_24_1, arg_24_2)
	var_0_0.no_sound_anis[arg_24_1] = arg_24_2
end

function var_0_0.setIgnoreTimeline(arg_25_0, arg_25_1)
	arg_25_0.prop.ignore_timeline = arg_25_1
end

function var_0_0.pauseAnimation(arg_26_0)
	local var_26_0 = arg_26_0.body:getCurrent()
	
	if not var_26_0 then
		return 
	end
	
	arg_26_0.prop.trackTimeScale = var_26_0.timeScale
	var_26_0.timeScale = 0
end

function var_0_0.resumeAnimation(arg_27_0)
	if not arg_27_0.prop.trackTimeScale then
		return 
	end
	
	local var_27_0 = arg_27_0.body:getCurrent()
	
	if not var_27_0 then
		return 
	end
	
	var_27_0.timeScale = arg_27_0.prop.trackTimeScale
	arg_27_0.prop.trackTimeScale = nil
end

function var_0_0.setExtraData(arg_28_0, arg_28_1)
	arg_28_0.extra_info = arg_28_1
end

function var_0_0.getExtraData(arg_29_0)
	return arg_29_0.extra_info
end

function var_0_0.getExtraSound(arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0:getExtraData() or {}
	local var_30_1 = {}
	
	for iter_30_0 = 1, 4 do
		table.insert(var_30_1, "type" .. iter_30_0)
		table.insert(var_30_1, "value" .. iter_30_0)
		table.insert(var_30_1, "change_sound" .. iter_30_0)
	end
	
	local var_30_2 = {}
	local var_30_3 = DBT("character_extra_sound", arg_30_1, var_30_1)
	
	if var_30_3 then
		for iter_30_1 = 1, 4 do
			local var_30_4 = var_30_3["type" .. iter_30_1]
			local var_30_5 = var_30_3["value" .. iter_30_1]
			local var_30_6 = var_30_3["change_sound" .. iter_30_1]
			local var_30_7 = false
			
			if var_30_4 and var_30_6 then
				local var_30_8 = string.split(var_30_5, ",")
				
				if var_30_4 == "enemy" then
					local var_30_9 = false
					
					for iter_30_2, iter_30_3 in pairs(var_30_8) do
						if (var_30_0.enemies or {})[iter_30_3] then
							var_30_9 = true
						end
					end
					
					if var_30_9 then
						var_30_7 = true
					end
				elseif var_30_4 == "self_cs" and var_30_0.unit then
					local var_30_10 = false
					
					for iter_30_4, iter_30_5 in pairs(var_30_8) do
						if var_30_0.unit.states:isExistById(iter_30_5) then
							var_30_10 = true
						end
					end
					
					if var_30_10 then
						var_30_7 = true
					end
				end
			end
			
			if var_30_7 then
				table.insert(var_30_2, {
					type = var_30_4,
					value = var_30_5,
					change_sound = var_30_6
				})
			end
		end
	end
	
	local var_30_11
	
	if table.count(var_30_2) > 0 then
		var_30_11 = (var_30_2[math.random(1, table.count(var_30_2))] or {}).change_sound
	end
	
	return var_30_11
end

function var_0_0.setAnimation(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4)
	if not arg_31_2 then
		Log.e("NO_ANI:", arg_31_0.source)
	end
	
	if arg_31_3 then
		local var_31_0 = arg_31_0.body:getCurrent()
		
		if var_31_0 and var_31_0.animation == arg_31_2 and var_31_0.loop == arg_31_3 then
			return var_31_0
		end
	end
	
	local var_31_1 = arg_31_0:initTimeline()
	
	arg_31_0.body:setBonesToSetupPose()
	arg_31_0.body:setSlotsToSetupPose()
	
	if not var_0_0.no_sound_anis[arg_31_2] and (not arg_31_0.sound_rate or math.random() < arg_31_0.sound_rate) then
		ccexp.SoundEngine:playBattle("event:/model/" .. arg_31_0.res_id .. "/ani/" .. arg_31_2)
		
		if not arg_31_4 then
			local var_31_2
			local var_31_3 = string.format("%s@%s", arg_31_0.res_id, arg_31_2)
			local var_31_4 = arg_31_0:getExtraSound(var_31_3)
			
			if var_31_4 then
				var_31_2 = ccexp.SoundEngine:play("event:/voc/character/" .. arg_31_0.res_id .. "/ani/" .. var_31_4)
			end
			
			if not var_31_2 then
				ccexp.SoundEngine:play("event:/voc/character/" .. arg_31_0.res_id .. "/ani/" .. arg_31_2)
			end
		end
	end
	
	local var_31_5 = arg_31_0.body:setAnimation(arg_31_1, arg_31_2, arg_31_3)
	
	if not var_31_5 then
		return 
	end
	
	arg_31_0.body:update(0)
	
	local var_31_6 = arg_31_0.body:getAnimationDuration(arg_31_2)
	
	arg_31_0.prop.last_animation = arg_31_2
	
	if not arg_31_0.prop.ignore_timeline then
		arg_31_0:runAction(cc.CallFunc:create(function()
			Timeline:executeFromData(var_31_1, {
				ani = arg_31_2,
				duration = var_31_6,
				actor = arg_31_0
			})
		end))
	end
	
	local var_31_7
	
	if arg_31_0.attached_models then
		var_31_7 = {
			"down",
			"knock_down",
			"flying",
			"rise",
			"attacked_damage"
		}
		
		for iter_31_0, iter_31_1 in pairs(arg_31_0.attached_models) do
			if not get_cocos_refid(iter_31_1) or table.isInclude(var_31_7, arg_31_2) then
			else
				iter_31_1:setAnimation(arg_31_1, arg_31_2, arg_31_3, arg_31_4)
			end
		end
	end
	
	return var_31_5
end

function var_0_0.getSkin(arg_33_0)
	return arg_33_0.prop.skin or "default"
end

function var_0_0.setSkin(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0.body:setSkin(arg_34_1)
	
	if not var_34_0 then
		arg_34_0.body:setSkin(arg_34_0:getSkin())
		
		if not PRODUCTION_MODE and getenv("debug.face_skin_err") == "true" then
			local var_34_1 = "[error] face skin fail : " .. tostring(arg_34_1)
			
			balloon_message_with_sound(var_34_1)
			print(var_34_1)
		end
		
		return 
	end
	
	arg_34_0.prop.skin = arg_34_1
	
	arg_34_0:resetTimeline()
	arg_34_0:initTimeline(arg_34_1)
	arg_34_0.body:setSlotsToSetupPose()
	
	return var_34_0
end

function var_0_0.onBlendColorChanged(arg_35_0)
	arg_35_0:updateVisibleOptionProp()
end

function var_0_0.setBlendColor(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	setBlendColor2(arg_36_0.body, arg_36_2, arg_36_3)
	arg_36_0:updateVisibleOptionProp()
end

function var_0_0.updateVisibleOptionProp(arg_37_0)
	local var_37_0 = arg_37_0:getOpacity() > 0 and not hasBlendColor(arg_37_0.body)
	
	arg_37_0:setVisibleOptionProp(var_37_0)
end

function var_0_0.addChild(arg_38_0, arg_38_1, ...)
	arg_38_1:setScaleFactor(1)
	
	return arg_38_0.super.addChild(arg_38_0, arg_38_1, ...)
end

function var_0_0.setVisibleOptionProp(arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0:getChildren()
	
	for iter_39_0, iter_39_1 in pairs(var_39_0) do
		if iter_39_1 ~= arg_39_0.body and not table.isInclude(arg_39_0.attached_models or {}, iter_39_1) then
			iter_39_1:setVisible(arg_39_1)
		end
	end
	
	local var_39_1 = arg_39_0.body:getBoneNodeList()
	
	for iter_39_2, iter_39_3 in pairs(var_39_1) do
		iter_39_3:setVisible(arg_39_1)
	end
end

function var_0_0.setVisible(arg_40_0, arg_40_1)
	arg_40_0.super.setVisible(arg_40_0, arg_40_1)
	arg_40_0:setPartsVisibility("_", arg_40_1)
	arg_40_0:foreachTimelineObject(function(arg_41_0)
		arg_41_0:setVisible(arg_40_1)
	end)
end

function var_0_0.setColor(arg_42_0, arg_42_1)
	arg_42_0.prop.color = arg_42_1
	
	arg_42_0.body:setColor(arg_42_1)
	
	if arg_42_0.attached_models then
		for iter_42_0, iter_42_1 in pairs(arg_42_0.attached_models) do
			if get_cocos_refid(iter_42_1) then
				iter_42_1:setColor(arg_42_1)
			end
		end
	end
end

function var_0_0.getAttributeTable(arg_43_0, arg_43_1)
	if not arg_43_0.attr[arg_43_1] then
		arg_43_0.attr[arg_43_1] = {}
	end
	
	return arg_43_0.attr[arg_43_1]
end

function var_0_0.getOpacityByKey(arg_44_0, arg_44_1)
	return arg_44_0:getAttributeTable("opacity")[arg_44_1] or 1
end

function var_0_0.setOpacityByKey(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_0:getAttributeTable("opacity")
	
	if arg_45_2 == 1 then
		var_45_0[arg_45_1] = nil
	else
		var_45_0[arg_45_1] = arg_45_2
	end
	
	local var_45_1 = 1
	
	for iter_45_0, iter_45_1 in pairs(var_45_0) do
		var_45_1 = var_45_1 * (iter_45_1 / 255)
	end
	
	arg_45_0:setOpacity(var_45_1 * 255)
end

function var_0_0.setOpacity(arg_46_0, arg_46_1)
	arg_46_0.super.setOpacity(arg_46_0, arg_46_1)
	arg_46_0:foreachLocalCacheObject(function(arg_47_0)
		arg_47_0:setOpacity(arg_46_1)
	end)
	arg_46_0:foreachPartsObject(function(arg_48_0)
		arg_48_0:setOpacity(arg_46_1)
	end)
	arg_46_0:foreachTimelineObject(function(arg_49_0)
		arg_49_0:setOpacity(arg_46_1)
	end)
	arg_46_0:updateVisibleOptionProp()
end

function var_0_0.getTimeScale(arg_50_0, arg_50_1)
	return arg_50_0.body:getTimeScale()
end

function var_0_0.setTimeScale(arg_51_0, arg_51_1)
	arg_51_0.body:setTimeScale(arg_51_1)
end

function var_0_0.getSprite(arg_52_0, arg_52_1)
	return arg_52_0.body:getSprite(arg_52_1)
end

function var_0_0.addTimelineObject(arg_53_0, arg_53_1, arg_53_2)
	if not arg_53_0.timeline_object then
		arg_53_0.timeline_object = {}
	end
	
	if not arg_53_0.timeline_object[arg_53_1] then
		arg_53_0.timeline_object[arg_53_1] = {}
	end
	
	if arg_53_2 then
		arg_53_2:setVisible(arg_53_0:isVisible())
		arg_53_2:setOpacity(arg_53_0:getOpacity())
	end
	
	table.insert(arg_53_0.timeline_object[arg_53_1], arg_53_2)
end

function var_0_0.removeTimelineObject(arg_54_0, arg_54_1)
	local var_54_0
	
	if arg_54_0.timeline_object then
		var_54_0 = arg_54_0.timeline_object[arg_54_1]
		
		if var_54_0 then
			arg_54_0.timeline_object[arg_54_1] = nil
		end
	end
	
	return var_54_0 or {}
end

function var_0_0.foreachTimelineObject(arg_55_0, arg_55_1)
	if arg_55_0.timeline_object then
		for iter_55_0, iter_55_1 in pairs(arg_55_0.timeline_object) do
			for iter_55_2 = #iter_55_1, 1, -1 do
				local var_55_0 = iter_55_1[iter_55_2]
				
				if get_cocos_refid(var_55_0) then
					arg_55_1(var_55_0)
				end
				
				if not get_cocos_refid(var_55_0) then
					table.remove(iter_55_1, iter_55_2)
				end
			end
		end
	end
end

function var_0_0.addLocalCacheObject(arg_56_0, arg_56_1, arg_56_2)
	if not arg_56_0.cached then
		arg_56_0.cached = {}
	end
	
	if not arg_56_0.cached[arg_56_1] then
		arg_56_0.cached[arg_56_1] = {}
	end
	
	table.insert(arg_56_0.cached[arg_56_1], arg_56_2)
end

function var_0_0.getLocalCacheTable(arg_57_0, arg_57_1)
	local var_57_0
	
	if arg_57_0.cached then
		var_57_0 = arg_57_0.cached[arg_57_1] or {}
	else
		var_57_0 = {}
	end
	
	return var_57_0
end

function var_0_0.removeLocalCacheObject(arg_58_0, arg_58_1)
	local var_58_0
	
	if arg_58_0.cached then
		var_58_0 = arg_58_0.cached[arg_58_1]
		
		if var_58_0 then
			arg_58_0.cached[arg_58_1] = nil
		end
	end
	
	return var_58_0 or {}
end

function var_0_0.foreachLocalCacheObject(arg_59_0, arg_59_1)
	if arg_59_0.cached then
		for iter_59_0, iter_59_1 in pairs(arg_59_0.cached) do
			for iter_59_2 = #iter_59_1, 1, -1 do
				local var_59_0 = iter_59_1[iter_59_2]
				
				if get_cocos_refid(var_59_0) then
					arg_59_1(var_59_0)
				else
					table.remove(iter_59_1, iter_59_2)
				end
			end
		end
	end
end

function var_0_0.cleanupLocalCacheObject(arg_60_0)
	arg_60_0:foreachLocalCacheObject(function(arg_61_0)
		if type(arg_61_0.stop) == "function" then
			arg_61_0:stop()
		end
		
		arg_61_0:removeFromParent()
	end)
	
	arg_60_0.cached = {}
end

function var_0_0.cleanupReferencedObject(arg_62_0)
	arg_62_0:cleanupLocalCacheObject()
	arg_62_0:foreachTimelineObject(function(arg_63_0)
		if type(arg_63_0.stop) == "function" then
			arg_63_0:stop()
		end
		
		arg_63_0:removeFromParent()
	end)
	
	arg_62_0.timeline_object = {}
end

function var_0_0.getEventTimings(arg_64_0, arg_64_1, ...)
	local var_64_0 = {
		arg_64_0.body:getEventTimings(arg_64_1, ...)
	}
	local var_64_1 = arg_64_0:initTimeline()
	local var_64_2 = Timeline:getEventMap(var_64_1, arg_64_1)
	
	for iter_64_0, iter_64_1 in ipairs({
		...
	}) do
		var_64_0[iter_64_0] = var_64_2[iter_64_1] or var_64_0[iter_64_0]
	end
	
	return unpack(var_64_0, 1, table.maxn(var_64_0))
end

function var_0_0.getEvents(arg_65_0, arg_65_1)
	local var_65_0 = arg_65_0:initTimeline()
	local var_65_1, var_65_2 = Timeline:getEvents(var_65_0, arg_65_1)
	local var_65_3 = arg_65_0.body:getEvents(arg_65_1)
	
	if var_65_3 then
		for iter_65_0, iter_65_1 in pairs(var_65_3) do
			if not var_65_2 or not string.starts(iter_65_1[1], "fire") and not string.starts(iter_65_1[1], "hit") then
				table.insert(var_65_1, iter_65_1)
			end
		end
	end
	
	return var_65_1
end

function var_0_0.setGlobalZOrder(arg_66_0, arg_66_1)
	arg_66_0.body:setGlobalZOrder(arg_66_1)
end

function var_0_0.resetTimeline(arg_67_0)
	arg_67_0.prop.tmline = nil
	arg_67_0.prop.acttml = nil
end

function var_0_0.initTimeline(arg_68_0)
	if not arg_68_0.prop.acttml then
		local var_68_0 = arg_68_0.prop.tmline
		
		if not var_68_0 then
			if string.ends(arg_68_0.source, ".scsp") then
				var_68_0 = Timeline:build(string.gsub(arg_68_0.source, ".scsp", ""))
			end
			
			var_68_0 = var_68_0 or {}
		end
		
		local var_68_1 = var_68_0[arg_68_0:getSkin()] or {}
		
		arg_68_0.prop.tmline = var_68_0
		arg_68_0.prop.acttml = var_68_1
	end
	
	return arg_68_0.prop.acttml or {}
end

function var_0_0.loadTexture(arg_69_0)
	return arg_69_0.body:loadTexture()
end

function var_0_0.setAttachment(arg_70_0, arg_70_1, arg_70_2)
	return arg_70_0.body:setAttachment(arg_70_1, arg_70_2)
end

function var_0_0.getBoundingBox(arg_71_0)
	return arg_71_0:getAttachmentBoundingBox("bounding_box", "bounding_box")
end

function var_0_0.getAttachmentBoundingBox(arg_72_0, arg_72_1, arg_72_2)
	if arg_72_0.body.getAttachmentBoundingBox then
		local var_72_0 = arg_72_0.body:getAttachmentBoundingBox(arg_72_1, arg_72_2)
		local var_72_1 = math.abs(arg_72_0:getRealScaleX())
		local var_72_2 = math.abs(arg_72_0:getRealScaleY())
		
		var_72_0.x = var_72_0.x * var_72_1
		var_72_0.y = var_72_0.y * var_72_2
		var_72_0.width = var_72_0.width * var_72_1
		var_72_0.height = var_72_0.height * var_72_2
		
		return var_72_0
	end
	
	return cc.rect(0, 0, 0, 0)
end

function var_0_0.getPivotPosition(arg_73_0)
	if arg_73_0.body.getAttachmentBoundingBox then
		if arg_73_0._pivot_sy ~= arg_73_0:getRealScaleY() or not arg_73_0.pivot then
			arg_73_0._pivot_sy = arg_73_0:getRealScaleY()
			
			local var_73_0 = arg_73_0.body:getAttachmentBoundingBox("bounding_box", "bounding_box")
			local var_73_1 = math.abs(arg_73_0._pivot_sy)
			
			arg_73_0.pivot = cc.p(0, var_73_0.y * var_73_1 + var_73_0.height * var_73_1 * 0.5)
		end
		
		return 0, arg_73_0.pivot.y
	end
	
	return 0, 0
end

function var_0_0.getFocusPosition(arg_74_0)
	local var_74_0, var_74_1 = arg_74_0:getPosition()
	local var_74_2, var_74_3 = arg_74_0:getPivotPosition()
	
	return var_74_0 + var_74_2, var_74_1 + var_74_3
end

function var_0_0.setDebugBonesEnabled(arg_75_0, arg_75_1)
	return arg_75_0.body:setDebugBonesEnabled(arg_75_1)
end

function var_0_0.setDebugSlotsEnabled(arg_76_0, arg_76_1)
	return arg_76_0.body:setDebugSlotsEnabled(arg_76_1)
end

function var_0_0.isExistAnimation(arg_77_0, arg_77_1)
	return arg_77_0.body:isExistAnimation(arg_77_1)
end

function var_0_0.getAnimationDuration(arg_78_0, arg_78_1)
	local var_78_0 = arg_78_0:initTimeline()
	
	return math.max(Timeline:getDuration(var_78_0, arg_78_1) / 1000, arg_78_0.body:getAnimationDuration(arg_78_1))
end

function var_0_0.getBoneNode(arg_79_0, arg_79_1)
	return arg_79_0.body:getBoneNode(arg_79_1)
end

function var_0_0.getBonePosition(arg_80_0, arg_80_1)
	local var_80_0, var_80_1 = arg_80_0.body:getBonePosition(arg_80_1)
	local var_80_2, var_80_3 = arg_80_0:getPosition()
	
	return var_80_2 + var_80_0 * arg_80_0:getRealScaleX(), var_80_3 + var_80_1 * arg_80_0:getRealScaleY()
end

function var_0_0.setBonePosition(arg_81_0, arg_81_1, arg_81_2, arg_81_3)
	local var_81_0, var_81_1 = arg_81_0:getPosition()
	
	return arg_81_0.body:setBonePosition(arg_81_1, (arg_81_2 - var_81_0) / arg_81_0:getRealScaleX(), (arg_81_3 - var_81_1) / arg_81_0:getRealScaleY())
end

function var_0_0.setBonePositionX(arg_82_0, arg_82_1, arg_82_2)
	local var_82_0, var_82_1 = arg_82_0:getPosition()
	
	return arg_82_0.body:setBonePositionX(arg_82_1, (arg_82_2 - var_82_0) / arg_82_0:getRealScaleX())
end

function var_0_0.setBonePositionY(arg_83_0, arg_83_1, arg_83_2)
	local var_83_0, var_83_1 = arg_83_0:getPosition()
	
	return arg_83_0.body:setBonePositionY(arg_83_1, (arg_83_2 - var_83_1) / arg_83_0:getRealScaleY())
end

function var_0_0.getRawBonePosition(arg_84_0, arg_84_1)
	return arg_84_0.body:getRawBonePosition(arg_84_1)
end

function var_0_0.getCurrent(arg_85_0)
	return arg_85_0.body:getCurrent()
end

function var_0_0.getBoneNodeList(arg_86_0)
	return arg_86_0.body:getBoneNodeList()
end

function var_0_0.getAllChildByName(arg_87_0, arg_87_1)
	local var_87_0 = {}
	
	local function var_87_1(arg_88_0)
		table.insert(var_87_0, arg_88_0)
	end
	
	local var_87_2 = arg_87_0.body:getBoneNodeList()
	
	for iter_87_0, iter_87_1 in pairs(var_87_2) do
		iter_87_1:enumerateChildren("//" .. arg_87_1, var_87_1)
	end
	
	arg_87_0:enumerateChildren("//" .. arg_87_1, var_87_1)
	
	return var_87_0
end

function var_0_0.createShadow(arg_89_0)
	local var_89_0 = cc.Sprite:create(get_texture_filename("model/default/shadow.png"))
	
	var_89_0:setAnchorPoint(0.5, 0.5)
	var_89_0:setGlobalZOrder(-100000000)
	
	local var_89_1 = arg_89_0.body:getBoneNode("shadow")
	
	if var_89_1 then
		local function var_89_2()
			var_89_0:setScale(var_89_1:getSlotScaleX() * var_89_1:getAttachmentScaleX(), var_89_1:getSlotScaleY() * var_89_1:getAttachmentScaleY())
			
			local var_90_0 = var_89_1:getSlotColor()
			
			var_89_0:setColor(cc.c3b(var_90_0.r * 255, var_90_0.g * 255, var_90_0.b * 255))
			var_89_0:setOpacity(var_90_0.a * (arg_89_0:getOpacity() / 255) * 255)
			var_89_0:setPositionX(var_89_1:getPositionX())
			var_89_0:setPositionY(var_89_1:getPositionY())
			var_89_0:setVisible(arg_89_0:isVisible())
		end
		
		arg_89_0.shadow = var_89_0
		
		arg_89_0:addChild(var_89_0)
		var_89_2()
		var_89_0:registerUpdateLuaHandler(var_89_2)
		var_89_0:registerScriptHandler(function(arg_91_0)
			if arg_91_0 == "enter" then
				var_89_0:scheduleUpdate()
			end
		end)
		var_89_0:scheduleUpdate()
		var_89_0:setVisible(false)
	end
	
	return var_89_0
end

function var_0_0.getShadowY(arg_92_0)
	return arg_92_0.prop.shadowY or 0
end

function var_0_0.setShadowY(arg_93_0, arg_93_1)
	arg_93_0.prop.shadowY = arg_93_1
	
	if arg_93_0.shadow then
		arg_93_0.shadow:setPositionY(-arg_93_1 / arg_93_0:getRealScaleY())
	end
end

function var_0_0.addPartsObject(arg_94_0, arg_94_1, arg_94_2)
	arg_94_2 = arg_94_2 or "default"
	
	local var_94_0
	
	if arg_94_1.bone then
		var_94_0 = arg_94_0:getBoneNode(arg_94_1.bone)
	end
	
	var_94_0 = var_94_0 or arg_94_0
	
	local var_94_1
	
	if not arg_94_0.parts_list[arg_94_2] then
		arg_94_0.parts_list[arg_94_2] = {}
	end
	
	local var_94_2 = arg_94_0.parts_list[arg_94_2]
	
	for iter_94_0 = #var_94_2, 1, -1 do
		if not get_cocos_refid(var_94_2[iter_94_0].object) then
			table.remove(var_94_2, iter_94_0)
		end
	end
	
	for iter_94_1, iter_94_2 in pairs(var_94_2) do
		if iter_94_2.object:getName() == arg_94_1.name then
			return 
		end
	end
	
	local var_94_3 = arg_94_1.object
	
	if not get_cocos_refid(var_94_3) and arg_94_1.source and arg_94_1.source ~= "nil" then
		var_94_3 = CACHE:getEffect(arg_94_1.source)
	end
	
	if not get_cocos_refid(var_94_3) then
		return 
	end
	
	if arg_94_1.loop_only and var_94_3:getDuration() > -1 then
		return 
	end
	
	var_94_3:setName(arg_94_1.name)
	var_94_3:setLocalZOrder(tonumber(arg_94_1.z) or 0)
	var_94_3:setScale(tonumber(arg_94_1.scale) or 1)
	var_94_0:setCascadeOpacityEnabled(true)
	var_94_0:addChild(var_94_3)
	
	if var_94_3.start_loop then
		var_94_3:start_loop()
	elseif var_94_3.start then
		var_94_3:start()
	end
	
	table.insert(var_94_2, {
		name = arg_94_1.name,
		object = var_94_3,
		always_visible = arg_94_1.always_visible
	})
	
	return var_94_3
end

function var_0_0.insertPartsObject(arg_95_0, arg_95_1, arg_95_2, arg_95_3)
	arg_95_3 = arg_95_3 or "default"
	
	local var_95_0
	
	if not arg_95_0.parts_list[arg_95_3] then
		arg_95_0.parts_list[arg_95_3] = {}
	end
	
	local var_95_1 = arg_95_0.parts_list[arg_95_3]
	
	table.insert(var_95_1, {
		name = arg_95_1,
		object = arg_95_2
	})
	arg_95_0:updatePartsVisibility(arg_95_2)
end

function var_0_0.removePartsObject(arg_96_0, arg_96_1, arg_96_2, arg_96_3)
	arg_96_2 = arg_96_2 or "default"
	
	local var_96_0
	
	if not arg_96_0.parts_list[arg_96_2] then
		arg_96_0.parts_list[arg_96_2] = {}
	end
	
	local var_96_1 = arg_96_0.parts_list[arg_96_2]
	
	if not var_96_1 then
		return 
	end
	
	for iter_96_0 = #var_96_1, 1, -1 do
		local var_96_2 = var_96_1[iter_96_0]
		
		if not get_cocos_refid(var_96_2.object) or var_96_2.object:getName() == arg_96_1 or arg_96_3 then
			table.remove(var_96_1, iter_96_0)
			
			if get_cocos_refid(var_96_2.object) then
				var_96_2.object:setName("")
				stop_or_remove(var_96_2.object)
			end
		end
	end
end

function var_0_0.setPartsVisibility(arg_97_0, arg_97_1, arg_97_2, arg_97_3)
	arg_97_3 = arg_97_3 or "default"
	
	if arg_97_2 == nil then
		arg_97_2 = true
	end
	
	local var_97_0 = arg_97_0.prop.parts_flags[arg_97_3]
	
	if not var_97_0 then
		var_97_0 = {}
		arg_97_0.prop.parts_flags[arg_97_3] = var_97_0
	end
	
	if not arg_97_2 then
		var_97_0[arg_97_1] = arg_97_2
	else
		var_97_0[arg_97_1] = nil
	end
	
	arg_97_0:updatePartsVisibility()
end

function var_0_0.updatePartsVisibility(arg_98_0, arg_98_1)
	for iter_98_0, iter_98_1 in pairs(arg_98_0.parts_list or {}) do
		local var_98_0 = true
		local var_98_1 = arg_98_0.prop.parts_flags[iter_98_0]
		
		if var_98_1 then
			for iter_98_2, iter_98_3 in pairs(var_98_1) do
				var_98_0 = false
				
				break
			end
		end
		
		for iter_98_4 = #iter_98_1, 1, -1 do
			local var_98_2 = iter_98_1[iter_98_4]
			
			if get_cocos_refid(var_98_2.object) then
				if not var_98_2.always_visible then
					var_98_2.object:setVisible(arg_98_0:isVisible() and var_98_0)
				end
			else
				table.remove(iter_98_1, iter_98_4)
			end
		end
	end
end

function var_0_0.restoreEffPartsObject(arg_99_0)
	if not arg_99_0.parts_list then
		return 
	end
	
	if not arg_99_0.parts_list.effect then
		return 
	end
	
	local var_99_0 = arg_99_0.parts_list.effect
	
	for iter_99_0 = table.count(var_99_0), 1, -1 do
		local var_99_1 = var_99_0[iter_99_0]
		local var_99_2 = var_99_1.name
		local var_99_3 = var_99_1.object
		local var_99_4 = string.split(var_99_2, "/")
		
		if table.count(var_99_4) > 1 then
			local var_99_5 = var_99_4[1]
			local var_99_6 = var_99_4[2]
			
			if not get_cocos_refid(var_99_3) then
				var_99_3 = CACHE:getEffect(var_99_6)
				
				var_99_3:setName(var_99_2)
				var_99_3:setLocalZOrder(0)
				
				var_99_1.object = var_99_3
			end
			
			local var_99_7 = arg_99_0:getBoneNode(var_99_5)
			
			if get_cocos_refid(var_99_7) then
				var_99_7:setCascadeOpacityEnabled(true)
				var_99_7:addChild(var_99_3)
				
				if var_99_3.start_loop then
					var_99_3:start_loop()
				elseif var_99_3.start then
					var_99_3:start()
				end
			end
		end
	end
end

function var_0_0.foreachPartsObject(arg_100_0, arg_100_1)
	if arg_100_0.parts_list then
		for iter_100_0, iter_100_1 in pairs(arg_100_0.parts_list) do
			for iter_100_2 = #iter_100_1, 1, -1 do
				local var_100_0 = iter_100_1[iter_100_2].object
				
				if get_cocos_refid(var_100_0) then
					arg_100_1(var_100_0)
				else
					table.remove(iter_100_1, iter_100_2)
				end
			end
		end
	end
end

function var_0_0.changeBodyTo(arg_101_0, arg_101_1, arg_101_2, arg_101_3)
	if not get_cocos_refid(arg_101_0.body) then
		return 
	end
	
	if not arg_101_1 then
		if arg_101_0.source == arg_101_0.init_source then
			return 
		end
		
		arg_101_1 = arg_101_0.init_source
		arg_101_2 = arg_101_0.init_atlas
	elseif arg_101_0.source == arg_101_1 then
		return 
	end
	
	local var_101_0 = arg_101_0.body["-change_callbacks"] or {}
	
	arg_101_0.body:removeFromParent()
	
	local var_101_1, var_101_2, var_101_3 = path.split(arg_101_1)
	
	arg_101_0.res_id = var_101_2
	arg_101_0.retrivePath = var_101_1
	arg_101_0.source = arg_101_1
	arg_101_0.atlas = arg_101_2
	arg_101_0.body = sp.SkeletonAnimation:create(arg_101_1, arg_101_2, 1)
	
	if not get_cocos_refid(arg_101_0.body) then
		model.body = sp.SkeletonAnimation:create("system/default/404.scsp", "system/default/404.atlas", scale or 1)
		model.is_err = true
		
		local var_101_4 = create_label(arg_101_1)
		
		var_101_4:setFontSize(24)
		var_101_4:setScale(1.5)
		var_101_4:setAnchorPoint(0.5, 2)
		model.body:addChild(var_101_4)
		
		return 
	end
	
	arg_101_0.body["-change_callbacks"] = arg_101_3
	
	arg_101_0.body:setAnchorPoint(0.5, 0)
	arg_101_0.body:update(math.random())
	
	if arg_101_0.prop.color then
		arg_101_0.body:setColor(arg_101_0.prop.color)
	end
	
	local function var_101_5(arg_102_0)
		if arg_102_0.target == arg_101_0.body then
			arg_101_0:onBlendColorChanged()
		end
	end
	
	local var_101_6 = cc.EventListenerCustom:create("blend_changed", var_101_5)
	
	arg_101_0.body:getEventDispatcher():addEventListenerWithSceneGraphPriority(var_101_6, arg_101_0.body)
	arg_101_0:setName(arg_101_1)
	arg_101_0:addChild(arg_101_0.body)
	arg_101_0.body:setIgnoreMask("global_base_shadow", sp.MASK_SLOT_RENDER)
	arg_101_0:resetTimeline()
	arg_101_0:initTimeline()
	
	if get_cocos_refid(arg_101_0.shadow) then
		arg_101_0.shadow:removeFromParent()
		arg_101_0:createShadow()
	end
	
	arg_101_0:restoreEffPartsObject()
	
	if var_101_0 and type(var_101_0.finish) == "function" then
		var_101_0.finish()
	end
	
	return true
end

function var_0_0.attachRelatedModel(arg_103_0, arg_103_1, arg_103_2)
	local var_103_0 = arg_103_2 or {}
	
	arg_103_0.attached_models = arg_103_0.attached_models or {}
	
	local var_103_1 = arg_103_1.setVisible
	
	function arg_103_1.setVisible(arg_104_0, arg_104_1)
		arg_104_0.my_visible = arg_104_1
		
		var_103_1(arg_104_0, arg_104_1)
	end
	
	local var_103_2 = arg_103_1.setOpacity
	
	function arg_103_1.setOpacity(arg_105_0, arg_105_1)
		arg_105_0.my_opacity = arg_105_1
		
		var_103_2(arg_105_0, arg_105_1)
	end
	
	arg_103_1.offset_scale = var_103_0.offset_scale or 1
	arg_103_1.offset_x = var_103_0.offset_x or 0
	arg_103_1.offset_y = var_103_0.offset_y or 0
	arg_103_1.offset_z = var_103_0.offset_z or 0
	
	arg_103_1:setScale(arg_103_1.offset_scale)
	arg_103_1:setPositionX(arg_103_1.offset_x)
	arg_103_1:setPositionY(arg_103_1.offset_y)
	arg_103_1:setLocalZOrder(arg_103_1.offset_z)
	table.insert(arg_103_0.attached_models, arg_103_1)
	
	local function var_103_3(arg_106_0, arg_106_1)
		if get_cocos_refid(arg_106_1) then
			local var_106_0, var_106_1 = arg_106_1:getPosition()
			local var_106_2 = arg_106_1:getLocalZOrder()
			local var_106_3 = arg_106_1:getScaleX()
			local var_106_4 = arg_106_1:getScaleY()
			local var_106_5 = arg_106_1:isVisible()
			
			if arg_106_0.my_visible == nil then
				arg_106_0.my_visible = arg_106_0:isVisible()
			end
			
			var_103_1(arg_106_0, arg_106_0.my_visible == true and var_106_5 == true)
			var_103_2(arg_106_0, 255 * (arg_106_1:getOpacity() / 255 * ((arg_106_0.my_opacity or 255) / 255)))
			
			local var_106_6 = var_106_3 / math.abs(var_106_3)
			
			arg_106_0:setPosition(var_106_0 + (arg_106_0.offset_x or 0) * var_106_6, var_106_1 + (arg_106_0.offset_y or 0))
			arg_106_0:setLocalZOrder(var_106_2 + (arg_106_0.offset_z or 0))
			arg_106_0:setScaleX(var_106_3 * (arg_106_0.offset_scale or 1))
			arg_106_0:setScaleY(var_106_4 * (arg_106_0.offset_scale or 1))
			arg_106_0:update(0)
		else
			Scheduler:remove(arg_106_0.tag)
			
			if get_cocos_refid(arg_106_0:getParent()) then
				arg_106_0:removeFromParent()
			end
		end
	end
	
	Scheduler:add(arg_103_1, var_103_3, arg_103_1, arg_103_0).priority = "afterdraw"
end

function var_0_0.updateModelParent(arg_107_0, arg_107_1)
	if get_cocos_refid(arg_107_1) and arg_107_0.attached_models then
		for iter_107_0, iter_107_1 in pairs(arg_107_0.attached_models) do
			local var_107_0 = iter_107_1:getParent()
			
			if get_cocos_refid(var_107_0) then
				iter_107_1:retain()
				iter_107_1:removeFromParent()
			end
			
			arg_107_1:addChild(iter_107_1)
			iter_107_1:setName(arg_107_0:getName() .. "#" .. get_cocos_refid(iter_107_1))
		end
	end
end

function var_0_0.setVisibleAttachedModel(arg_108_0, arg_108_1)
	if arg_108_0.attached_models then
		for iter_108_0, iter_108_1 in pairs(arg_108_0.attached_models) do
			if get_cocos_refid(iter_108_1) then
				iter_108_1:setVisible(arg_108_1)
			end
		end
	end
end

function var_0_0.runActionForAttachedModel(arg_109_0, arg_109_1)
	if arg_109_0.attached_models then
		for iter_109_0, iter_109_1 in pairs(arg_109_0.attached_models) do
			if get_cocos_refid(iter_109_1) then
				arg_109_1(iter_109_1)
			end
		end
	end
end

function var_0_0.setReverseY(arg_110_0, arg_110_1)
	if arg_110_0.attached_models then
		for iter_110_0, iter_110_1 in pairs(arg_110_0.attached_models) do
			if get_cocos_refid(iter_110_1) then
				iter_110_1:setPositionY(-arg_110_1 * iter_110_1:getScaleY())
			end
		end
	end
end
