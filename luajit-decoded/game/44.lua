function WAIT_FRAME(arg_1_0)
	return USER_ACT({
		FRAME_COUNT = 0,
		TOTAL_TIME = 33,
		Start = function(arg_2_0)
		end,
		Update = function(arg_3_0, arg_3_1, arg_3_2)
			arg_3_0.FRAME_COUNT = arg_3_0.FRAME_COUNT + 1
		end,
		Finish = function(arg_4_0)
		end,
		IsFinished = function(arg_5_0, arg_5_1)
			return arg_5_0.FRAME_COUNT > arg_1_0
		end
	})
end
