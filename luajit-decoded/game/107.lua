SeasonPassPack = SeasonPassPack or {}

function SeasonPassPack.show(arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = {}
	
	if SeasonPass:getRank(arg_1_1.event_id) ~= arg_1_1.rank then
		var_1_0.rank_info = {
			pass_id = arg_1_1.event_id,
			prev_rank = SeasonPass:getRank(arg_1_1.event_id),
			rank = arg_1_1.rank
		}
	end
	
	var_1_0.upgrade_info = {
		pass_id = arg_1_1.event_id,
		grade = arg_1_1.grade
	}
	
	if var_1_0.rank_info or var_1_0.upgrade_info then
		local var_1_1 = var_1_0.rank_info and var_1_0.rank_info.pass_id or var_1_0.upgrade_info and var_1_0.upgrade_info.pass_id
		
		query("refresh_season_pass_data", {
			event_id = var_1_1
		})
	end
	
	local function var_1_2(arg_2_0)
		if var_1_0.upgrade_info then
			SeasonPassUnlock:open(var_1_0.upgrade_info, arg_2_0)
		elseif arg_2_0 then
			arg_2_0()
		end
	end
	
	;(function(arg_3_0)
		if var_1_0.rank_info then
			SeasonPassRankUpMsgBox:show(var_1_0.rank_info.pass_id, var_1_0.rank_info.prev_rank, var_1_0.rank_info.rank, arg_3_0)
		elseif arg_3_0 then
			arg_3_0()
		end
	end)(function()
		var_1_2(arg_1_2)
	end)
end

function SeasonPassPack.testShow(arg_5_0)
	if PRODUCTION_MODE then
		return 
	end
	
	local var_5_0 = {
		crystal = 1000799,
		res = "ok",
		_qid = "6",
		packages = {
			{
				package = "sp_season1_common",
				items = {
					{
						code = "to_crystal",
						count = 900,
						opts = {
							voucher_type = "package"
						}
					},
					{
						rank = 12,
						prev_rank = 2,
						count = 1,
						pass_type = "pass_rank",
						pass_id = "season1"
					},
					{
						grade = 2,
						pass_id = "season1",
						pass_type = "pass_upgrade",
						count = 1
					}
				}
			}
		},
		currency_time = {},
		tip = {
			user_id = "12610622",
			name = "epic7#10n0h0",
			type = "gacha",
			tm = 1562550907,
			info = {
				code = "c3052",
				type = "unit"
			}
		},
		idx = {
			"62045"
		}
	}
	local var_5_1 = {}
	
	for iter_5_0, iter_5_1 in pairs(var_5_0.packages[1].items) do
		if iter_5_1.pass_type == "pass_rank" then
			var_5_1.rank_info = {
				pass_id = iter_5_1.pass_id,
				prev_rank = iter_5_1.prev_rank,
				rank = iter_5_1.rank
			}
		elseif iter_5_1.pass_type == "pass_upgrade" or iter_5_1.pass_type == "pass_unlock" then
			var_5_1.upgrade_info = {
				pass_id = iter_5_1.pass_id,
				grade = iter_5_1.grade,
				type = iter_5_1.pass_type
			}
		end
	end
	
	arg_5_0:show(var_5_1)
end
