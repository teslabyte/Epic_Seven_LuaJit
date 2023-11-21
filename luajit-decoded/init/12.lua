cc = cc or {}

if cc.BackendProgramState then
	cc.GLProgramCache = {}
	
	function cc.GLProgramCache.getInstance()
		return {
			addGLProgramFromByteArray = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
				return cc.BackendProgramCache:getInstance():addProgramFromByteArray(arg_2_1, arg_2_2, arg_2_3)
			end,
			addGLProgramFromFile = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				arg_3_2 = string.gsub(arg_3_2, "/program/", "/program_v4/")
				arg_3_3 = string.gsub(arg_3_3, "/program/", "/program_v4/")
				
				return cc.BackendProgramCache:getInstance():addProgramFromFile(arg_3_1, arg_3_2, arg_3_3)
			end,
			getGLProgram = function(arg_4_0, arg_4_1)
				return cc.BackendProgramCache:getInstance():getCustomProgram(arg_4_1)
			end
		}
	end
	
	local var_0_0 = getmetatable(cc.BackendProgramState)
	
	function var_0_0.getGLProgram(arg_5_0)
		return arg_5_0:getProgram()
	end
	
	function var_0_0.setUniformTexture(arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = arg_6_0["-tex-slot"] or {
			u_texture1 = 1,
			u_texture = 0
		}
		local var_6_1 = var_6_0[arg_6_1]
		
		if not var_6_1 then
			var_6_1 = 0
			
			for iter_6_0, iter_6_1 in pairs(var_6_0) do
				var_6_1 = var_6_1 + 1
			end
			
			var_6_0[arg_6_1] = var_6_1
		end
		
		arg_6_0["-tex-slot"] = var_6_0
		
		return arg_6_0:setTexture(arg_6_1, var_6_1, arg_6_2)
	end
	
	cc.GLProgramState = cc.BackendProgramState
	
	local var_0_1 = getmetatable(cc.Node)
	
	function var_0_1.getDefaultGLProgramState(arg_7_0)
		return arg_7_0:getDefaultProgramState()
	end
	
	function var_0_1.setDefaultGLProgramState(arg_8_0, arg_8_1)
		return arg_8_0:setDefaultProgramState(arg_8_1)
	end
	
	function var_0_1.getGLProgramState(arg_9_0)
		return arg_9_0:getProgramState()
	end
	
	function var_0_1.setGLProgramState(arg_10_0, arg_10_1)
		return arg_10_0:setProgramState(arg_10_1)
	end
elseif not cc.GLProgramCache then
	cc.GLProgram = {}
	
	function cc.GLProgram.create()
		return {
			getProgram = function()
			end
		}
	end
	
	cc.GLProgramCache = {}
	
	function cc.GLProgramCache.getInstance()
		return {
			addGLProgramFromByteArray = function()
			end,
			addGLProgramFromFile = function()
			end,
			getGLProgram = function()
				return cc.GLProgram:create()
			end
		}
	end
	
	cc.GLProgramState = {}
	
	function cc.GLProgramState.create()
		return {
			getGLProgram = function()
				return cc.GLProgram:create()
			end,
			setUniformVec4 = function()
			end,
			setUniformVec2 = function()
			end,
			setUniformFloat = function()
			end,
			setUniformTexture = function()
			end,
			setUniformMat4 = function()
			end
		}
	end
	
	local var_0_2 = getmetatable(cc.Node)
	
	function var_0_2.getDefaultGLProgramState()
	end
	
	function var_0_2.setDefaultGLProgramState()
	end
	
	function var_0_2.setGLProgramState()
	end
	
	function var_0_2.getGLProgramState()
		return cc.GLProgramState:create()
	end
end
