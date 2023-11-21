LotaFogData = ClassDef()
LotaFogVisibilityEnum = {
	DISCOVER = 2,
	NOT_DISCOVER = 1,
	VISIBLE = 3
}
LotaFogVisibilityInvEnum = {
	"NOT_DISCOVER",
	"DISCOVER",
	"VISIBLE"
}
LotaFogDataInterface = {
	id = 1,
	visibility = 1,
	pos = {
		x = 0,
		y = 0
	}
}

function LotaFogData.constructor(arg_1_0, arg_1_1)
	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		arg_1_0[iter_1_0] = iter_1_1
	end
end

function LotaFogData.getPos(arg_2_0)
	return arg_2_0.pos
end

function LotaFogData.getVisibility(arg_3_0)
	return arg_3_0.visibility
end

function LotaFogData.setVisibility(arg_4_0, arg_4_1)
	arg_4_0.visibility = arg_4_1
end
