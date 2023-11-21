SPLWhiteboard = {}

copy_functions(LotaWhiteboard, SPLWhiteboard)

function SPLWhiteboard.init(arg_1_0)
	arg_1_0.vars = {}
	arg_1_0.vars.white_board = {}
	
	for iter_1_0 = 1, 99 do
		local var_1_0, var_1_1 = DBN("tile_sub_config", iter_1_0, {
			"id",
			"client_value"
		})
		
		if not var_1_0 then
			break
		end
		
		arg_1_0:set(var_1_0, var_1_1)
	end
end
