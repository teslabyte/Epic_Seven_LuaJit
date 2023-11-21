SHADER_METHOD = {}

local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = cc.GLProgramCache:getInstance():getGLProgram("dreamer_base")
	
	if var_1_0 then
		local var_1_1 = cc.GLProgramState:create(var_1_0)
		
		if var_1_1 then
			var_1_1.uniform_functor = {}
			
			local var_1_2 = get_texture_object(arg_1_1)
			
			if var_1_2 then
				var_1_2:setTexParameters(gl.LINEAR, gl.LINEAR, gl.REPEAT, gl.REPEAT)
				
				function var_1_1.uniform_functor.u_AniTexture(arg_2_0)
					if not get_cocos_refid(var_1_2) then
						return 
					end
					
					arg_2_0:setUniformTexture("u_AniTexture", var_1_2)
				end
			end
			
			local var_1_3 = get_texture_object(arg_1_2)
			
			if var_1_3 then
				var_1_3:setTexParameters(gl.LINEAR, gl.LINEAR, gl.CLAMP_TO_EDGE, gl.CLAMP_TO_EDGE)
				
				function var_1_1.uniform_functor.u_AniMask(arg_3_0)
					if not get_cocos_refid(var_1_3) then
						return 
					end
					
					arg_3_0:setUniformTexture("u_AniMask", var_1_3)
				end
				
				function var_1_1.uniform_functor.u_resolution(arg_4_0)
					if not get_cocos_refid(var_1_3) then
						return 
					end
					
					arg_4_0:setUniformVec2("u_resolution", {
						x = DESIGN_HEIGHT * 0.5,
						y = DESIGN_HEIGHT * 0.5
					})
				end
			end
			
			function var_1_1.assignUniform(arg_5_0, arg_5_1)
				for iter_5_0, iter_5_1 in pairs(arg_5_0.uniform_functor) do
					iter_5_1(arg_5_1 or arg_5_0)
				end
			end
			
			var_1_1:assignUniform()
			arg_1_0:setDefaultGLProgramState(var_1_1)
			arg_1_0:setGLProgramState(var_1_1)
		end
	end
end

SHADER_METHOD.dreamer_base = var_0_0
_G["@apply_spine_shader"] = function(arg_6_0, arg_6_1)
	local var_6_0, var_6_1 = string.match(arg_6_1, "(%g+)(%b())")
	local var_6_2 = SHADER_METHOD[var_6_0]
	
	if var_6_2 then
		local var_6_3 = string.split(var_6_1:sub(2, var_6_1:len() - 1), ",")
		
		var_6_2(arg_6_0, argument_unpack(var_6_3))
	end
end
