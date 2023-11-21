LotaWhiteboard = {}

local function var_0_0(arg_1_0)
	return DB("clan_heritage_config", arg_1_0, "client_value")
end

function LotaWhiteboard.init(arg_2_0)
	arg_2_0.vars = {}
	arg_2_0.vars.white_board = {}
	
	arg_2_0:set("map_move_cell", var_0_0("map_move_cell"))
	arg_2_0:set("map_sight_cell", var_0_0("map_sight_cell"))
end

function LotaWhiteboard.set(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.vars.white_board[arg_3_1] = arg_3_2
end

function LotaWhiteboard.get(arg_4_0, arg_4_1)
	return arg_4_0.vars.white_board[arg_4_1]
end
