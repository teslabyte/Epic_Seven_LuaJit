SPLFogData = ClassDef(HTBFogData)

function SPLFogData.constructor(arg_1_0, arg_1_1)
	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		arg_1_0[iter_1_0] = iter_1_1
	end
end
