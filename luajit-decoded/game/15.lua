local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	if get_cocos_refid(arg_1_0) then
		if not arg_1_2 or not arg_1_1 or arg_1_2 == 0 then
			arg_1_0:setGLProgramState(nil)
			
			return false
		else
			local var_1_0
			
			if has_area_texture(arg_1_0) then
				var_1_0 = "dynbat_blend"
			elseif arg_1_0:getDefaultGLProgramState() then
				local var_1_1 = cc.GLProgramCache:getInstance():getGLProgram("dreamer_base")
				
				if var_1_1 and var_1_1 == arg_1_0:getDefaultGLProgramState():getGLProgram() then
					var_1_0 = "dreamer_blend"
				end
			end
			
			var_1_0 = var_1_0 or "sprite_blend"
			
			local var_1_2 = cc.GLProgramCache:getInstance():getGLProgram(var_1_0)
			local var_1_3 = arg_1_0:getGLProgramState()
			
			if not var_1_3 or var_1_3:getGLProgram() ~= var_1_2 then
				var_1_3 = cc.GLProgramState:create(var_1_2)
				
				if var_1_3 then
					arg_1_0:setGLProgramState(var_1_3)
					
					local var_1_4 = arg_1_0:getDefaultGLProgramState()
					
					if var_1_4 and var_1_4.assignUniform then
						var_1_4:assignUniform(var_1_3)
					end
				end
			end
			
			if var_1_3 then
				var_1_3:setUniformVec4("u_BlendColor", cc.vec4(arg_1_1.r, arg_1_1.g, arg_1_1.b, arg_1_2 or 0))
			end
			
			return true
		end
	end
end

local function var_0_1(arg_2_0)
	if arg_2_0.body and tolua.type(arg_2_0.body) == "sp.SkeletonAnimation" then
		return arg_2_0.body
	end
	
	return arg_2_0
end

function hasBlendColor(arg_3_0)
	local var_3_0 = var_0_1(arg_3_0)["--blend-colors"] or {}
	
	return not table.empty(var_3_0)
end

function setBlendColor2(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = var_0_1(arg_4_0)
	local var_4_1 = var_4_0["--blend-colors"] or {}
	
	if not arg_4_3 or not arg_4_2 or arg_4_3 == 0 then
		var_4_1[arg_4_1] = nil
	else
		var_4_1[arg_4_1] = {
			color = arg_4_2,
			factor = arg_4_3
		}
	end
	
	local var_4_2
	local var_4_3
	
	var_4_0["--blend-colors"] = var_4_1
	
	for iter_4_0, iter_4_1 in pairs(var_4_1) do
		local var_4_4 = iter_4_1.color
		local var_4_5 = var_4_2 or {
			g = 0,
			b = 0,
			r = 0
		}
		
		var_4_2 = cc.c4f(var_4_5.r + var_4_4.r * iter_4_1.factor, var_4_5.g + var_4_4.g * iter_4_1.factor, var_4_5.b + var_4_4.b * iter_4_1.factor, 1)
		var_4_3 = math.max(var_4_3 or 0, iter_4_1.factor)
	end
	
	var_0_0(var_4_0, var_4_2, var_4_3)
	
	local var_4_6 = cc.EventCustom:new("blend_changed")
	
	var_4_6.target = var_4_0
	
	var_4_0:getEventDispatcher():dispatchEvent(var_4_6)
	
	if arg_4_0.attached_models then
		for iter_4_2, iter_4_3 in pairs(arg_4_0.attached_models or {}) do
			if get_cocos_refid(iter_4_3) then
				setBlendColor2(iter_4_3, arg_4_1, arg_4_2, arg_4_3)
			end
		end
	end
	
	return var_4_2, var_4_3
end

function setBlendColor(arg_5_0, arg_5_1, arg_5_2)
	return setBlendColor2(arg_5_0, "def", arg_5_1, arg_5_2)
end

function testBlend(arg_6_0)
	local var_6_0 = SceneManager:getDefaultLayer()
	
	var_6_0:removeAllChildren()
	
	local var_6_1 = cc.Sprite:create("img/game_hud_go_right.png")
	
	var_6_1:setPosition(DESIGN_WIDTH / 2, DESIGN_HEIGHT / 2)
	var_6_0:addChild(var_6_1)
	
	g_sprite = var_6_1
	
	setBlendColor2(var_6_1, "key1", cc.c4f(1, 0, 0), arg_6_0)
	setBlendColor2(var_6_1, "key2", cc.c4f(0, 1, 0), arg_6_0)
	setBlendColor2(var_6_1, "key1")
	setBlendColor2(var_6_1, "key2")
end
