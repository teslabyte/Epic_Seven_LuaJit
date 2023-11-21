EmojiManager = {}
EmojiManager.RewardType = {
	default = "default",
	reward = "reward"
}

function EmojiManager.isUsableEmoji(arg_1_0, arg_1_1)
	if getenv("app.viewer") == "true" then
		return true
	end
	
	return Account:getItemCount(arg_1_1) > 0
end

function EmojiManager._merge_db(arg_2_0)
	arg_2_0.vars.db = {}
	
	for iter_2_0 = 1, 99 do
		local var_2_0, var_2_1, var_2_2, var_2_3, var_2_4, var_2_5, var_2_6, var_2_7 = DBN("pvp_rta_emoji", iter_2_0, {
			"id",
			"set",
			"type",
			"sort",
			"name",
			"res",
			"material_id",
			"reward_type"
		})
		
		if var_2_0 then
			arg_2_0.vars.db[var_2_6] = {
				rta_id = var_2_0,
				set = var_2_1,
				type = var_2_2,
				rta_sort = var_2_3,
				icon = var_2_4,
				rta_res = var_2_5,
				rta_reward_type = var_2_7
			}
		end
	end
	
	for iter_2_1 = 1, 99 do
		local var_2_8, var_2_9, var_2_10, var_2_11, var_2_12 = DBN("chat_emoji", iter_2_1, {
			"id",
			"sort",
			"material_id",
			"reward_type",
			"res"
		})
		
		if var_2_8 then
			if arg_2_0.vars.db[var_2_10] then
				arg_2_0.vars.db[var_2_10].chat_sort = var_2_9
				arg_2_0.vars.db[var_2_10].chat_id = var_2_8
				arg_2_0.vars.db[var_2_10].chat_reward_type = var_2_11
				arg_2_0.vars.db[var_2_10].chat_res = var_2_12
			else
				print("error : pvp_rta_emoji db 에서 찾은 material_id(", var_2_10, ") 를 chat_emoji db 에서 찾을 수 없었습니다.")
			end
		end
	end
end

function EmojiManager._init(arg_3_0)
	arg_3_0.vars = {}
	
	arg_3_0:_merge_db()
end

function EmojiManager.getMyEmojis(arg_4_0)
	if not arg_4_0.vars or not arg_4_0.vars.db then
		arg_4_0:_init()
	end
	
	local var_4_0 = {}
	
	for iter_4_0, iter_4_1 in pairs(arg_4_0.vars.db) do
		if iter_4_1.chat_reward_type == EmojiManager.RewardType.default or iter_4_1.rta_reward_type == EmojiManager.RewardType.default or arg_4_0:isUsableEmoji(iter_4_0) then
			var_4_0[iter_4_0] = iter_4_1
		end
	end
	
	return var_4_0
end

function EmojiManager.getAllEmojis(arg_5_0)
	if not arg_5_0.vars or not arg_5_0.vars.db then
		arg_5_0:_init()
	end
	
	return arg_5_0.vars.db
end

function EmojiManager.getMyEmojisForChat(arg_6_0)
	local var_6_0 = {}
	
	for iter_6_0, iter_6_1 in pairs(arg_6_0:getMyEmojis() or {}) do
		if iter_6_1.chat_reward_type == EmojiManager.RewardType.default or arg_6_0:isUsableEmoji(iter_6_0) then
			local var_6_1 = {
				id = iter_6_1.chat_id,
				sort = iter_6_1.chat_sort,
				icon = iter_6_1.icon,
				res = iter_6_1.chat_res,
				material_id = iter_6_0
			}
			
			table.insert(var_6_0, var_6_1)
		end
	end
	
	return var_6_0
end

function EmojiManager.getMyEmojisForRTA(arg_7_0)
	local var_7_0 = {}
	
	for iter_7_0, iter_7_1 in pairs(arg_7_0:getMyEmojis() or {}) do
		if iter_7_1.rta_reward_type == EmojiManager.RewardType.default or arg_7_0:isUsableEmoji(iter_7_0) then
			var_7_0[iter_7_0] = {
				id = iter_7_1.rta_id,
				sort = iter_7_1.rta_sort,
				name = iter_7_1.icon,
				res = iter_7_1.rta_res,
				type = iter_7_1.type,
				set = iter_7_1.set
			}
		end
	end
	
	return var_7_0
end
