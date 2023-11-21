NewNotice = NewNotice or {}
NewNotice.ID = {
	DESTINY = "DESTINY",
	MAZE = "MAZE",
	CLASS_CHANGE = "CLASS_CHANGE"
}

local var_0_0 = "new_notice"

local function var_0_1(arg_1_0)
	return (Account:getConfigData(var_0_0) or {})[arg_1_0] or {}
end

local function var_0_2(arg_2_0, arg_2_1)
	local var_2_0 = Account:getConfigData(var_0_0) or {}
	
	var_2_0[arg_2_0] = arg_2_1
	
	SAVE:setTempConfigData(var_0_0, var_2_0)
end

local var_0_3 = {
	DESTINY = {
		id = "id",
		db_name = "destiny_category",
		update_date = "update_date"
	},
	CLASS_CHANGE = {
		id = "id",
		db_name = "classchange_category",
		update_date = "update_date"
	},
	MAZE = {
		id = "id",
		db_name = "level_battlemenu_dungeon",
		update_date = "update_date"
	}
}
local var_0_4 = {}

local function var_0_5(arg_3_0)
	if var_0_4[arg_3_0] then
		return var_0_4[arg_3_0]
	end
	
	if not var_0_3[arg_3_0] then
		return {}
	end
	
	var_0_4[arg_3_0] = {}
	
	for iter_3_0 = 1, 9999 do
		local var_3_0 = {}
		
		var_3_0.id, var_3_0.update_date = DBN(var_0_3[arg_3_0].db_name, iter_3_0, {
			var_0_3[arg_3_0].id,
			var_0_3[arg_3_0].update_date
		})
		
		if not var_3_0.id then
			break
		end
		
		if var_3_0.update_date then
			table.insert(var_0_4[arg_3_0], var_3_0)
		end
	end
	
	return var_0_4[arg_3_0]
end

local function var_0_6(arg_4_0)
	local var_4_0 = {
		day = arg_4_0 % 100,
		month = math.floor(arg_4_0 / 100) % 100,
		year = 2000 + math.floor(arg_4_0 / 10000)
	}
	local var_4_1, var_4_2, var_4_3 = Account:serverTimeDayLocalDetail(os.time(var_4_0))
	
	return var_4_1
end

function NewNotice.checkNew(arg_5_0, arg_5_1)
	local var_5_0, var_5_1, var_5_2 = Account:serverTimeDayLocalDetail()
	local var_5_3 = var_0_1(arg_5_1)
	local var_5_4 = false
	local var_5_5 = var_0_5(arg_5_1)
	
	for iter_5_0, iter_5_1 in pairs(var_5_5) do
		if iter_5_1.update_date and var_5_0 <= var_0_6(iter_5_1.update_date) and not table.find(var_5_3, iter_5_1.id) then
			var_5_4 = true
			
			table.insert(var_5_3, iter_5_1.id)
		end
	end
	
	if var_5_4 then
		var_0_2(arg_5_1, var_5_3)
	end
end

function NewNotice.isNew(arg_6_0, arg_6_1)
	local var_6_0, var_6_1, var_6_2 = Account:serverTimeDayLocalDetail()
	local var_6_3 = var_0_1(arg_6_1)
	local var_6_4 = {}
	local var_6_5 = false
	local var_6_6 = var_0_5(arg_6_1)
	
	for iter_6_0, iter_6_1 in pairs(var_6_6) do
		if iter_6_1.update_date then
			if var_6_0 <= var_0_6(iter_6_1.update_date) then
				table.insert(var_6_4, iter_6_1.id)
			else
				var_6_5 = true
				
				table.deleteByValue(var_6_3, iter_6_1.id)
			end
		end
	end
	
	if var_6_5 then
		var_0_2(arg_6_1, var_6_3)
	end
	
	return #var_6_4 ~= #var_6_3
end

local var_0_7 = false

function NewNotice.cleanUp(arg_7_0)
	if var_0_7 then
		return 
	end
	
	var_0_7 = true
	
	local var_7_0 = false
	local var_7_1 = Account:getConfigData(var_0_0) or {}
	local var_7_2 = {}
	
	for iter_7_0, iter_7_1 in pairs(var_7_1) do
		if table.empty(iter_7_1) or table.empty(var_0_5(iter_7_0)) then
			var_7_0 = true
		else
			var_7_2[iter_7_0] = iter_7_1
		end
	end
	
	for iter_7_2, iter_7_3 in pairs(var_7_2) do
		local var_7_3 = var_0_5(iter_7_2)
		
		for iter_7_4, iter_7_5 in pairs(iter_7_3) do
			if table.find(var_7_3, iter_7_5) then
				var_7_0 = true
				
				table.deleteByValue(iter_7_3, iter_7_5)
			end
		end
	end
	
	if var_7_0 then
		SAVE:setTempConfigData(var_0_0, var_7_2)
	end
end
