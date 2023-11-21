ItemMaterial = {}
ItemMaterial.vars = {}

function ItemMaterial.initFragments(arg_1_0)
	if arg_1_0.vars.fragments then
		return arg_1_0.vars.fragments
	end
	
	arg_1_0.vars.fragments = {}
	arg_1_0.vars.fragmentss_by_devotion_target = {}
	
	for iter_1_0 = 1, 99999 do
		local var_1_0 = DBNFields("item_material", iter_1_0, {
			"id",
			"name",
			"ma_type",
			"ma_type2",
			"devotion_target",
			"devotion_need_count",
			"price",
			"sort"
		})
		
		if not var_1_0.id then
			break
		end
		
		if var_1_0.ma_type == "fragment" then
			var_1_0.code = var_1_0.id
			arg_1_0.vars.fragments[var_1_0.code] = var_1_0
			
			if var_1_0.devotion_target and string.starts(var_1_0.devotion_target, "c") then
				arg_1_0.vars.fragmentss_by_devotion_target[var_1_0.devotion_target] = arg_1_0.vars.fragmentss_by_devotion_target[var_1_0.devotion_target] or {}
				
				table.insert(arg_1_0.vars.fragmentss_by_devotion_target[var_1_0.devotion_target], var_1_0)
			end
		end
	end
end

function ItemMaterial.getFragments(arg_2_0)
	if not arg_2_0.vars.fragments then
		arg_2_0:initFragments()
	end
	
	return arg_2_0.vars.fragments
end

function ItemMaterial.getPrivateFragments(arg_3_0, arg_3_1)
	if not arg_3_0.vars.fragmentss_by_devotion_target then
		arg_3_0:initFragments()
	end
	
	return arg_3_0.vars.fragmentss_by_devotion_target[arg_3_1.db.variation_group] or arg_3_0.vars.fragmentss_by_devotion_target[arg_3_1.db.code]
end

function ItemMaterial.isFragment(arg_4_0, arg_4_1)
	return DB("item_material", arg_4_1, {
		"ma_type"
	}) == "fragment"
end
