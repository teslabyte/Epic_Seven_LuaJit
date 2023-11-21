EffectManager = EffectManager or {}

function EffectManager.init(arg_1_0)
	arg_1_0._defaultLayer = nil
end

function EffectManager.Attach(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_5 = arg_2_5 or 1
	
	if arg_2_4 then
		local var_2_0, var_2_1 = arg_2_2:getBonePosition(arg_2_3)
		
		return arg_2_0:Play(arg_2_1, BGIManager:getBGI().main.layer, var_2_0, var_2_1, arg_2_2:getLocalZOrder() + 2, arg_2_5, arg_2_2:getScaleX() < 0, arg_2_2:getScaleY() < 0, nil, true)
	else
		if arg_2_2.getRawBonePosition == nil then
			Log.e("EffectManager.Attach() : no getRawBonePosition")
			Log.e(arg_2_2:getName())
		end
		
		local var_2_2, var_2_3 = arg_2_2:getRawBonePosition(arg_2_3)
		
		return arg_2_0:Play(arg_2_1, arg_2_2, var_2_2, var_2_3, 1, arg_2_5, arg_2_2:getScaleX() < 0, arg_2_2:getScaleY() < 0, nil, true)
	end
end

function EffectManager.AttachEffect(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	if not get_cocos_refid(arg_3_1) or tolua.type(arg_3_1) ~= "yuna2d.CompositiveEffect2D" or not arg_3_2 then
		return 
	end
	
	if not get_cocos_refid(arg_3_3) or tolua.type(arg_3_3) ~= "yuna2d.CompositiveEffect2D" then
		return 
	end
	
	local var_3_0 = arg_3_1:getPrimitiveNode(arg_3_2)
	
	if get_cocos_refid(var_3_0) then
		if var_3_0.setInheritScale and type(var_3_0.setInheritScale) == "function" then
			var_3_0:setInheritScale(true)
		end
		
		local var_3_1 = arg_3_3:getParent()
		
		if get_cocos_refid(var_3_1) then
			arg_3_3:ejectFromParent()
		end
		
		var_3_0:addChild(arg_3_3)
	end
end

function EffectManager.Play(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_9, arg_4_10)
	if type(arg_4_1) == "string" then
		return arg_4_0:EffectPlay({
			effect = CACHE:getEffect(arg_4_1, "effect", true),
			layer = arg_4_2,
			x = arg_4_3,
			y = arg_4_4,
			z = arg_4_5,
			scale = arg_4_6,
			flip_x = arg_4_7,
			flip_y = arg_4_8,
			action = arg_4_9,
			extractNodes = arg_4_10
		})
	end
	
	if type(arg_4_1) == "table" then
		local var_4_0 = arg_4_1.source or arg_4_1.name or arg_4_1.fn
		
		arg_4_1.effect = CACHE:getEffect(var_4_0, "effect", true)
		
		return arg_4_0:EffectPlay(arg_4_1)
	end
end

function EffectManager.CompositiveEffectPlay(arg_5_0, arg_5_1)
	arg_5_1.effect = su.CompositiveEffect2D:create(getEffectPath(arg_5_1.source))
	
	return arg_5_0:EffectPlay(arg_5_1)
end

G_ANIEVENT_EFFECT = {
	dust = {
		effect = "dust_landing.scsp",
		bone = "shadow",
		field = true
	},
	charge = {
		bone = "target",
		effect = "skill_ready.cfx"
	},
	flash = function()
		play_curtain(BGI.main.layer, 0, 1, 80, 1, "battle", false, -999, 0.7, cc.c3b(255, 255, 255))
	end
}

function EffectManager.onAniEvent(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.target
	local var_7_1 = G_ANIEVENT_EFFECT[arg_7_1.name]
	
	if var_7_1 then
		if type(var_7_1) == "function" then
			xpcall(var_7_1, __G__TRACKBACK__)
		else
			EffectManager:Attach(var_7_1.effect, var_7_0, var_7_1.bone, var_7_1.field)
		end
	end
end

function EffectManager.onFireEvent(arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_2.luaTag then
	end
	
	if arg_8_2.luaTag and not arg_8_2.luaTag.ignore_event then
	end
end

function getDefAction(arg_9_0)
	local var_9_0 = {
		battle = BattleAction
	}
	
	return arg_9_0 or var_9_0[SceneManager:getCurrentSceneName()] or Action
end

function PlayEffect(arg_10_0)
	EffectManager:Play({
		fn = arg_10_0,
		layer = cc.Director:getInstance():getRunningScene(),
		pivot_x = DESIGN_WIDTH / 2,
		pivot_y = DESIGN_HEIGHT / 2
	})
end

function EffectManager.addLoopSoundNode(arg_11_0, arg_11_1)
	if not arg_11_0._loop_sound_nodes then
		arg_11_0._loop_sound_nodes = {}
	end
	
	table.insert(arg_11_0._loop_sound_nodes, arg_11_1)
end

function EffectManager.checkLoopSoundNode(arg_12_0)
	if not arg_12_0._loop_sound_nodes then
		arg_12_0._loop_sound_nodes = {}
	end
	
	if table.empty(arg_12_0._loop_sound_nodes) then
		return 
	end
	
	for iter_12_0, iter_12_1 in pairs(arg_12_0._loop_sound_nodes) do
		if get_cocos_refid(iter_12_1) and iter_12_1.n_parent and get_cocos_refid(iter_12_1.n_parent) then
		else
			iter_12_1.remove = true
		end
	end
	
	for iter_12_2 = table.count(arg_12_0._loop_sound_nodes), 1, -1 do
		if get_cocos_refid(arg_12_0._loop_sound_nodes[iter_12_2]) and arg_12_0._loop_sound_nodes[iter_12_2].stop and arg_12_0._loop_sound_nodes[iter_12_2].remove then
			arg_12_0._loop_sound_nodes[iter_12_2]:stop()
			table.remove(arg_12_0._loop_sound_nodes, iter_12_2)
		end
	end
end

function EffectManager.EffectPlay(arg_13_0, arg_13_1)
	local function var_13_0(arg_14_0)
		local var_14_0 = arg_14_0.effect
		local var_14_1 = arg_14_0.action
		
		if not var_14_0.start then
			function var_14_0.start(arg_15_0)
				var_14_1:Add(SEQ(DMOTION("animation"), REMOVE()), arg_15_0, "battle")
			end
		end
		
		if not var_14_0.setStartDelay then
			function var_14_0.setStartDelay()
			end
		end
		
		if not var_14_0.setExtractNodes then
			function var_14_0.setExtractNodes()
			end
		end
		
		if not var_14_0.setAutoRemoveOnFinish then
			function var_14_0.setAutoRemoveOnFinish()
			end
		end
	end
	
	local var_13_1 = type(arg_13_1)
	
	if var_13_1 == "userdata" and get_cocos_refid(arg_13_1) then
		arg_13_1 = {
			effect = arg_13_1
		}
	elseif var_13_1 ~= "table" then
		return 
	end
	
	if not get_cocos_refid(arg_13_1.effect) then
		return 
	end
	
	var_13_0(arg_13_1)
	
	local var_13_2 = arg_13_1.effect
	local var_13_3 = "event:/effect/" .. var_13_2:getName()
	local var_13_4 = arg_13_1.check_loop_sound
	
	arg_13_1.name = arg_13_1.name or var_13_2:getName()
	arg_13_1.x = arg_13_1.x or arg_13_1.pivot_x or 0
	arg_13_1.y = arg_13_1.y or arg_13_1.pivot_y or 0
	arg_13_1.z = arg_13_1.z or arg_13_1.pivot_z or 0
	arg_13_1.scale = arg_13_1.scale or 1
	arg_13_1.rotation = arg_13_1.rotation or 0
	arg_13_1.delay = arg_13_1.delay or 0
	arg_13_1.flip_x = arg_13_1.flip_x or false
	arg_13_1.scaleFactor = arg_13_1.scaleFactor or BASE_SCALE
	arg_13_1.action = getDefAction(arg_13_1.action)
	arg_13_1.extractNodes = if_nil(arg_13_1.extractNodes, false)
	arg_13_1.layer = arg_13_0:getContainLayer(arg_13_1.layer)
	var_13_2.luaTag = arg_13_1.tag or {}
	
	arg_13_1.layer:addChild(var_13_2)
	
	if arg_13_1.node_name or arg_13_1.name then
		var_13_2:setName(arg_13_1.node_name or arg_13_1.name)
	end
	
	var_13_2:setPosition(arg_13_1.x, arg_13_1.y)
	var_13_2:setLocalZOrder(arg_13_1.z)
	var_13_2:setScale(arg_13_1.scale)
	var_13_2:setScaleFactor(arg_13_1.scaleFactor)
	var_13_2:setRotation(arg_13_1.rotation)
	
	if arg_13_1.scaleX then
		var_13_2:setScaleX(arg_13_1.scaleX)
	end
	
	if arg_13_1.scaleY then
		var_13_2:setScaleY(arg_13_1.scaleY)
	end
	
	if arg_13_1.flip_x then
		var_13_2:setScaleX(-math.abs(var_13_2:getScaleX()))
	end
	
	var_13_2:setStartDelay((arg_13_1.delay or 0) / 1000)
	var_13_2:setExtractNodes(arg_13_1.extractNodes)
	var_13_2:setAncestor(arg_13_1.ancestor)
	var_13_2:setAutoRemoveOnFinish(true)
	var_13_2:start()
	arg_13_1.action:Add(SEQ(DELAY(arg_13_1.delay), CALL(function()
		if DEBUG.EFFECT_SOUND_TEST then
			if not SoundEngine:existsEvent(var_13_3) then
				print("need effect sound !!  ", var_13_3)
			end
			
			print("#SoundEngine:play('" .. var_13_3 .. "')")
		end
		
		if arg_13_1.is_battle_effect then
			var_13_2.sd = SoundEngine:playBattle(var_13_3)
		else
			var_13_2.sd = SoundEngine:play(var_13_3)
		end
		
		if var_13_2 and var_13_2.sd and var_13_4 then
			var_13_2.sd.n_parent = var_13_2
			
			EffectManager:addLoopSoundNode(var_13_2.sd)
		end
	end), COND_LOOP(DELAY(100), function()
		if not arg_13_1.owner or not get_cocos_refid(arg_13_1.owner) then
			return true
		end
		
		var_13_2:setScale(arg_13_1.base_scale * arg_13_1.owner:getScaleY())
		
		if arg_13_1.flip_x then
			var_13_2:setScaleX(-math.abs(var_13_2:getScaleX()))
		end
	end)), var_13_2)
	
	if var_13_2.getActionTimes then
		local var_13_5 = var_13_2:getActionTimes("Fire")
		
		for iter_13_0, iter_13_1 in pairs(var_13_5) do
			arg_13_1.action:Add(SEQ(DELAY(iter_13_1), CALL(EffectManager.onFireEvent, EffectManager, "Fire", var_13_2)), arg_13_1.layer, "battle")
		end
	end
	
	return var_13_2
end

function EffectManager.setDefaultLayer(arg_21_0, arg_21_1)
	arg_21_0._defaultLayer = arg_21_1
end

function EffectManager.getContainLayer(arg_22_0, arg_22_1)
	return arg_22_1 or arg_22_0._defaultLayer or BGIManager:getBGI().main.layer
end
