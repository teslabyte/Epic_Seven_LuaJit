LotaBoxSystem = {}

function LotaBoxSystem.init(arg_1_0)
	arg_1_0.vars = {}
	arg_1_0.vars.box_list = {}
end

function LotaBoxSystem.updateBoxList(arg_2_0, arg_2_1)
	arg_2_0.vars.box_list = arg_2_1
end

function LotaBoxSystem.getActiveRewardList(arg_3_0)
	local var_3_0 = {}
	
	for iter_3_0, iter_3_1 in pairs(arg_3_0.vars.box_list) do
		local var_3_1 = string.split(iter_3_1, ":")
		local var_3_2 = var_3_1[1]
		local var_3_3 = var_3_1[2]
		local var_3_4 = var_3_1[3]
		
		table.insert(var_3_0, {
			floor = var_3_2,
			tile_id = tostring(var_3_3),
			object_id = var_3_4
		})
	end
	
	return var_3_0
end

function LotaBoxSystem.isActiveRewardExist(arg_4_0)
	return not table.empty(arg_4_0.vars.box_list)
end
