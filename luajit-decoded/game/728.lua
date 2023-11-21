HTBFogData = ClassDef()
HTBFogVisibilityEnum = {
	DISCOVER = 2,
	NOT_DISCOVER = 1,
	VISIBLE = 3
}
HTBFogVisibilityInvEnum = {
	"NOT_DISCOVER",
	"DISCOVER",
	"VISIBLE"
}
HTBFogDataInterface = {
	id = 1,
	visibility = 1,
	pos = {
		x = 0,
		y = 0
	}
}

function HTBFogData.constructor(arg_1_0, arg_1_1)
	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		arg_1_0[iter_1_0] = iter_1_1
	end
end

function HTBFogData.getPos(arg_2_0)
	return arg_2_0.pos
end

function HTBFogData.getVisibility(arg_3_0)
	return arg_3_0.visibility
end

function HTBFogData.setVisibility(arg_4_0, arg_4_1)
	arg_4_0.visibility = arg_4_1
end
