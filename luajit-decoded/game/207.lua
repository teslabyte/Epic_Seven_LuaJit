PvpSATeam = {}

function PvpSATeam.show(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.vars = {}
	arg_1_0.vars.opts = arg_1_2 or {}
	arg_1_0.vars.info = arg_1_1 or {}
	arg_1_0.vars.parent = arg_1_0.vars.opts.parent or SceneManager:getDefaultLayer()
	
	if arg_1_1.mode == "pvp_ready" then
		if arg_1_1 and arg_1_1.enemy_info then
			local var_1_0 = {}
			
			for iter_1_0, iter_1_1 in pairs(arg_1_1.enemy_info.units) do
				local var_1_1 = UNIT:create(iter_1_1.unit)
				
				for iter_1_2, iter_1_3 in pairs(iter_1_1.equips) do
					if iter_1_3.p == iter_1_1.unit.id then
						local var_1_2 = EQUIP:createByInfo(iter_1_3)
						
						if var_1_2 then
							var_1_1:addEquip(var_1_2, true)
						end
					end
				end
				
				var_1_1:calc()
				
				var_1_0[iter_1_1.pos] = var_1_1
			end
			
			local var_1_3 = {}
			
			for iter_1_4, iter_1_5 in pairs(var_1_0) do
				var_1_3[iter_1_4] = iter_1_5
			end
			
			if not (arg_1_1.enemy_uid and string.starts(tostring(arg_1_1.enemy_uid), "npc")) and PvpSA:isCurrentBlind() then
				table.shuffle(var_1_3)
			end
			
			local var_1_4 = {
				no_repeat = arg_1_1.no_repeat,
				my_score = arg_1_1.my_info.score,
				my_battle_count = arg_1_1.my_info.battle_count,
				my_league = arg_1_1.my_info.league,
				repeat_reward_period = arg_1_1.my_info.repeat_reward_period,
				repeat_reward_type_max = arg_1_1.my_info.repeat_reward_type_max,
				continuous_victory = arg_1_1.my_info.continuous_victory,
				enemy_team = var_1_3,
				enemy_info = {
					enemy_uid = arg_1_1.enemy_uid,
					name = arg_1_1.enemy_info.name,
					level = arg_1_1.enemy_info.level,
					score = arg_1_1.enemy_score,
					revenge_id = arg_1_1.revenge_id,
					revenge_count = arg_1_1.revenge_count
				}
			}
			
			UnitMain:beginPVPMode(arg_1_0.vars.parent, var_1_4, arg_1_0.vars.opts.hide_layer)
			
			return 
		end
	elseif arg_1_1.mode == "defend_mode" then
		TutorialGuide:procGuide("system_008")
		UnitMain:beginPVPMode(arg_1_0.vars.parent, {
			defend_mode = true,
			pop_scene = arg_1_0.vars.opts.pop_scene
		}, arg_1_0.vars.opts.hide_layer, true)
		
		return 
	end
	
	Log.e("PvpSATeam.show - info is nil")
end

function PvpSATeam.getSceneState(arg_2_0)
	if not arg_2_0.vars then
		return {}
	end
	
	return {
		mode = arg_2_0.vars.info.mode
	}
end
