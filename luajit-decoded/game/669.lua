LotaOverSceneDataSystem = {}

function LotaOverSceneDataSystem.init(arg_1_0)
	if arg_1_0.vars then
		return 
	end
	
	arg_1_0.vars = {}
	arg_1_0.vars.storage = {}
end

function LotaOverSceneDataSystem.append(arg_2_0, arg_2_1, arg_2_2)
	if not arg_2_0.vars.storage[arg_2_1] then
		arg_2_0.vars.storage[arg_2_1] = {}
	end
	
	table.insert(arg_2_0.vars.storage[arg_2_1], arg_2_2)
end

function LotaOverSceneDataSystem.clear(arg_3_0, arg_3_1)
	arg_3_0.vars.storage[arg_3_1] = nil
end

function LotaOverSceneDataSystem.get(arg_4_0, arg_4_1)
	return arg_4_0.vars.storage[arg_4_1]
end

function LotaOverSceneDataSystem.destroy(arg_5_0)
	arg_5_0.vars = nil
end
