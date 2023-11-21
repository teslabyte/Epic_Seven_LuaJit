SubstorySortOrder = {}
SubstorySortOrder.ELEMENT_SORT_ORDER = {
	fire = 5,
	wind = 3,
	light = 2,
	dark = 1,
	ice = 4
}
SubstorySortOrder.ROLE_SORT_ORDER = {
	manauser = 1,
	knight = 5,
	assassin = 4,
	warrior = 6,
	ranger = 3,
	mage = 2
}

function SubstorySortOrder.getFilterCheckList(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_3 = arg_1_3 or {}
	
	local var_1_0 = {}
	local var_1_1 = ({
		element = 5,
		role = 6
	})[arg_1_2]
	local var_1_2 = true
	
	for iter_1_0 = 1, var_1_1 do
		local var_1_3 = arg_1_1[arg_1_2][iter_1_0]
		
		if not var_1_3 then
			break
		end
		
		if arg_1_3[var_1_3] ~= nil then
			var_1_0[iter_1_0] = arg_1_3[var_1_3]
		else
			var_1_0[iter_1_0] = true
		end
		
		if not var_1_0[iter_1_0] then
			var_1_2 = false
		end
	end
	
	var_1_0.all = var_1_2
	
	if var_1_2 then
		for iter_1_1 = 1, var_1_1 do
			var_1_0[iter_1_1] = false
		end
	end
	
	return var_1_0
end

function SubstorySortOrder.getDefaultUnHashTable(arg_2_0)
	return {
		role = {
			"warrior",
			"knight",
			"assassin",
			"ranger",
			"mage",
			"manauser",
			all = "all"
		},
		element = {
			"fire",
			"ice",
			"wind",
			"light",
			all = "all",
			[5] = "dark"
		}
	}
end

function SubstorySortOrder.getUnHashTableByGroup(arg_3_0, arg_3_1)
	if not arg_3_1 then
		return {}
	end
	
	local var_3_0 = {}
	
	if arg_3_1 == "element" then
		var_3_0 = {
			"fire",
			"ice",
			"wind",
			"light",
			"dark"
		}
	elseif arg_3_1 == "role" then
		var_3_0 = {
			"warrior",
			"knight",
			"assassin",
			"ranger",
			"mage",
			"manauser"
		}
	end
	
	return var_3_0
end

function SubstorySortOrder.greaterThanUnlockOrder(arg_4_0, arg_4_1)
	return arg_4_0.db_sort > arg_4_1.db_sort
end

function SubstorySortOrder.greaterThanElement(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0.hero_db.element
	local var_5_1 = arg_5_1.hero_db.element
	
	return SubstorySortOrder.ELEMENT_SORT_ORDER[var_5_0] > SubstorySortOrder.ELEMENT_SORT_ORDER[var_5_1]
end

function SubstorySortOrder.greaterThanRole(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.hero_db.role
	local var_6_1 = arg_6_1.hero_db.role
	
	return SubstorySortOrder.ROLE_SORT_ORDER[var_6_0] > SubstorySortOrder.ROLE_SORT_ORDER[var_6_1]
end

function SubstorySortOrder.greaterThanName(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.hero_db.name
	local var_7_1 = arg_7_1.hero_db.name
	
	if isLatinAccentLanguage() then
		return utf8LatinAccentCompare(var_7_0, var_7_1)
	end
	
	return string.lower(var_7_0) < string.lower(var_7_1)
end
