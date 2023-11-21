LotaPingManager = ClassDef()

function LotaPingManager.constructor(arg_1_0)
	arg_1_0.vars = {}
	arg_1_0.vars.ping_data = {}
	arg_1_0.vars.memo_data = {}
end

function LotaPingManager.updateByResponse(arg_2_0, arg_2_1)
	if not arg_2_1 then
		return 
	end
	
	for iter_2_0, iter_2_1 in pairs(arg_2_1) do
		if string.find(iter_2_0, "ping") then
			local var_2_0 = iter_2_0
			local var_2_1 = iter_2_1
			local var_2_2 = to_n(string.sub(var_2_0, -1, -1))
			
			if tostring(var_2_1) ~= "-1" then
				arg_2_0.vars.ping_data[tostring(var_2_2)] = LotaPingData(tostring(var_2_2), tostring(var_2_1))
			else
				arg_2_0.vars.ping_data[tostring(var_2_2)] = nil
			end
		else
			local var_2_3 = iter_2_0
			local var_2_4 = iter_2_1
			local var_2_5 = to_n(string.sub(var_2_3, -1, -1))
			
			arg_2_0.vars.memo_data[tostring(var_2_5)] = var_2_4
		end
	end
	
	for iter_2_2, iter_2_3 in pairs(arg_2_0.vars.ping_data) do
		if not iter_2_3:isPingValid() then
			arg_2_0.vars.ping_data[iter_2_2] = nil
		end
	end
end

function LotaPingManager.getPingData(arg_3_0, arg_3_1)
	return arg_3_0.vars.ping_data[tostring(arg_3_1)]
end

function LotaPingManager.getPingDataByTileId(arg_4_0, arg_4_1)
	local var_4_0 = tostring(arg_4_1)
	
	for iter_4_0, iter_4_1 in pairs(arg_4_0.vars.ping_data) do
		if iter_4_1:getTileId() == var_4_0 then
			return iter_4_1
		end
	end
	
	return nil
end

function LotaPingManager.getMemoData(arg_5_0, arg_5_1)
	return arg_5_0.vars.memo_data[tostring(arg_5_1)]
end

function LotaPingManager.getPingCount(arg_6_0)
	return table.count(arg_6_0.vars.ping_data)
end

function LotaPingManager.isExistPing(arg_7_0, arg_7_1)
	for iter_7_0, iter_7_1 in pairs(arg_7_0.vars.ping_data) do
		if iter_7_1:getTileId() == arg_7_1 then
			return true
		end
	end
	
	return false
end
