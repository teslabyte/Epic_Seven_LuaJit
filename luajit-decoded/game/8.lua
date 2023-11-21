print("LuaJit Version = ", jit and jit.version)
print("LuaJit status", jit and jit.status())

if jit and jit.version == "LuaJIT 2.1.0-beta3" then
	jit.off()
	print("LuaJit off : ", jit and jit.status())
end

math.mod = math.mod or math.fmod
