ItemTooltip = {}

function ItemTooltip.getArtifactTooltip(arg_1_0, arg_1_1)
	return cc.Layer:create()
end

function ItemTooltip.getItemDetail(arg_2_0, arg_2_1)
	local var_2_0 = {
		acquision_data = 0,
		main_stat = 0,
		lines = 0,
		exclusive = 0,
		charge_data = 0,
		set_drop_conversion_data = 0,
		sub_stat = 0,
		desc = 0,
		count_data = 0,
		set_drop_data = 0,
		head = 108,
		lota_object = 0,
		lota_reward_preview = 0,
		set_data = 0,
		lota_coop_monster = 0,
		equip_point = 0
	}
	local var_2_1 = {
		heights = var_2_0
	}
	
	if arg_2_1.equip then
		var_2_1.code = arg_2_1.code or arg_2_1.equip.code
	else
		var_2_1.code = arg_2_1.code
	end
	
	var_2_1.grade = arg_2_1.grade
	
	local var_2_2 = string.split(var_2_1.code, "_")[1]
	
	if string.starts(var_2_1.code, "e") then
		var_2_1.set_fx = arg_2_1.set_fx
		var_2_1.equip_stat = arg_2_1.equip_stat
		var_2_1.set_drop = arg_2_1.set_drop
		
		if arg_2_1.equip then
			var_2_1.equip = arg_2_1.equip
			var_2_1.code = var_2_1.code or arg_2_1.equip.code
			var_2_1.set_fx = var_2_1.set_fx or arg_2_1.equip.set_fx
			var_2_1.grade = var_2_1.grade or arg_2_1.equip.grade
			var_2_1.equip_stat = var_2_1.equip_stat or arg_2_1.equip.op
			var_2_1.point = var_2_1.point or arg_2_1.equip.point
			
			if var_2_1.equip.parent then
				var_2_1.owner = Account:getUnit(var_2_1.equip.parent)
			end
			
			if var_2_1.equip.cloneParent then
				var_2_1.owner = var_2_1.equip.cloneParent
			end
		end
		
		var_2_1.title, var_2_1.type, var_2_1.desc, var_2_1.main_stat, var_2_1.stat_cnt, var_2_1.equip_grade_min, var_2_1.equip_grade_max, var_2_1.xp, var_2_1.get_xp, var_2_1.role, var_2_1.character, var_2_1.character_group, var_2_1.artifact_skill, var_2_1.unique_type, var_2_1.sub_stat, var_2_1.variation_group, var_2_1.pick_max, var_2_1.pick_min, var_2_1.min_offset, var_2_1.max_offset = DB("equip_item", var_2_1.code, {
			"name",
			"type",
			"desc",
			"main_stat",
			"sub_stat_count",
			"grade_min",
			"grade_max",
			"xp",
			"get_xp",
			"role",
			"character",
			"character_group",
			"artifact_skill",
			"unique_type",
			"sub_stat",
			"variation_group",
			"pick_max",
			"pick_min",
			"min_offset",
			"max_offset"
		})
		var_2_1.is_equip = true
		var_2_1.is_artifact = DB("equip_item", var_2_1.code, "type") == "artifact"
		var_2_1.is_stone = DB("equip_item", var_2_1.code, "stone") == "y"
		var_2_1.is_exclusive = DB("equip_item", var_2_1.code, "type") == "exclusive"
		
		if var_2_1.is_exclusive then
			var_2_1.exclusive_unit, var_2_1.exclusive_skill, var_2_1.exclusive_skill_idx = DB("equip_item", var_2_1.code, {
				"exclusive_unit",
				"exclusive_skill",
				"exclusive_skill_idx"
			})
			var_2_1.exclusive_skill_idx = arg_2_1.exclusive_skill_idx or var_2_1.exclusive_skill_idx
			var_2_1.show_all_exc_skills = arg_2_1.show_all_exc_skills
		end
		
		if var_2_1.character then
			var_2_1.character_name = DB("character", var_2_1.character, {
				"name"
			})
		end
	elseif var_2_2 == "ma" then
		var_2_1.title = DB("item_material", arg_2_1.code, "name")
		var_2_1.desc = DB("item_material", arg_2_1.code, "desc")
		var_2_1.is_material = true
		var_2_1.hide_own_count = DB("item_material", arg_2_1.code, "hide_own") == "y"
	elseif var_2_2 == "sp" then
		var_2_1.title = DB("item_special", arg_2_1.code, "name")
		var_2_1.desc = DB("item_special", arg_2_1.code, "desc")
		var_2_1.is_item_special = true
	elseif var_2_2 == "ct" then
		var_2_1.title = DB("item_clantoken", arg_2_1.code, "name")
		var_2_1.desc = DB("item_clantoken", arg_2_1.code, "desc")
	elseif var_2_2 == "to" then
		var_2_1.title = DB("item_token", arg_2_1.code, "name")
		var_2_1.desc = DB("item_token", arg_2_1.code, "desc")
		var_2_1.is_token = true
	elseif DB("character", arg_2_1.code, "name") then
		var_2_1.title = T("item_herocard_name")
		var_2_1.desc = T("item_herocard_desc")
	elseif DB("clan_heritage_object_data", arg_2_1.code, "id") then
		local var_2_3, var_2_4, var_2_5 = DB("clan_heritage_object_data", arg_2_1.code, {
			"name",
			"desc",
			"map_icon_before"
		})
		
		var_2_1.title = var_2_3
		var_2_1.desc = var_2_4
		
		local var_2_6, var_2_7 = DB("character", var_2_5, {
			"id",
			"2line"
		})
		
		if var_2_6 ~= nil then
			var_2_1.desc = var_2_7
		end
	elseif arg_2_1.faction then
		var_2_1.title = arg_2_1.faction .. "_tl"
		var_2_1.desc = arg_2_1.faction .. "_tde"
	elseif arg_2_1.custom_v2 then
		var_2_1.desc = arg_2_1.custom_v2_desc
	elseif arg_2_1.custom then
		var_2_1.title = arg_2_1.title
		var_2_1.desc = arg_2_1.desc
	end
	
	var_2_1.grade = var_2_1.grade or 1
	
	return var_2_1
end

function ItemTooltip.updateItemFrame(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	arg_3_3 = arg_3_3 or "frame"
	arg_3_4 = arg_3_4 or "frame_grade"
	
	if not get_cocos_refid(arg_3_1) then
		return 
	end
	
	if not arg_3_2 then
		return 
	end
	
	if arg_3_2.equip then
		arg_3_2 = arg_3_2.equip
	end
	
	if arg_3_2.isBasicEquip and not arg_3_2:isBasicEquip() then
		return 
	end
	
	if arg_3_2.is_exclusive then
		return 
	end
	
	if arg_3_2.is_token then
		return 
	end
	
	if arg_3_2.is_material then
		return 
	end
	
	if arg_3_2.is_item_special then
		return 
	end
	
	if not arg_3_2.grade then
		return 
	end
	
	if_set_visible(arg_3_1, arg_3_3, false)
	if_set_visible(arg_3_1, arg_3_4, true)
	if_set_sprite(arg_3_1, arg_3_4, "img/_box_equip_" .. arg_3_2.grade .. ".png")
end

function ItemTooltip.updateItemInformation(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_3 = arg_4_3 or arg_4_0:getItemDetail(arg_4_1)
	arg_4_2 = arg_4_2 or arg_4_1.wnd
	
	local var_4_0 = arg_4_3.heights
	local var_4_1 = false
	
	if arg_4_3.is_equip then
		if arg_4_3.is_stone then
			if_set(arg_4_2, "txt_stone", T("equip_stone_title", {
				exp = comma_value(arg_4_3.get_xp)
			}))
		else
			arg_4_3.grade = arg_4_3.grade or arg_4_3.equip_grade_min
			
			local var_4_2, var_4_3, var_4_4 = DB("equip_stat", arg_4_3.main_stat .. "_1", {
				"stat_type",
				"val_min",
				"val_max"
			})
			local var_4_5 = DB("equip_stat", arg_4_3.main_stat .. "_2", "id") ~= nil
			local var_4_6 = DB("equip_item", arg_4_3.code, {
				"tier"
			})
			local var_4_7, var_4_8, var_4_9 = DB("item_equip_stat_revision", var_4_2, {
				"revise_min",
				"revise_max",
				"t" .. var_4_6
			})
			
			if var_4_7 ~= 1 then
				var_4_3 = var_4_3 * var_4_7
			end
			
			if var_4_8 ~= 1 then
				var_4_4 = var_4_4 * var_4_8
			end
			
			if var_4_2 then
				if_set(arg_4_2, "txt_main_name", getStatName(var_4_2))
			end
			
			var_4_0.main_stat = 68
			
			local var_4_10 = ""
			
			if (not arg_4_3.equip_stat or table.empty(arg_4_3.equip_stat)) and arg_4_3.unique_type == "y" then
				local var_4_11 = arg_4_3.variation_group .. "_" .. arg_4_3.grade
				local var_4_12 = {}
				
				var_4_12[0], var_4_12[1], var_4_12[2], var_4_12[3], var_4_12[4] = DB("item_equip_stat_count", var_4_11, {
					"sub0",
					"sub1",
					"sub2",
					"sub3",
					"sub4"
				})
				
				local var_4_13
				
				for iter_4_0, iter_4_1 in pairs(var_4_12) do
					if iter_4_1 == 100 then
						var_4_13 = iter_4_0
						
						break
					end
				end
				
				if var_4_13 then
					arg_4_3.equip_stat = {}
					
					table.insert(arg_4_3.equip_stat, {
						var_4_2,
						var_4_4 * var_4_9
					})
					
					for iter_4_2 = 1, var_4_13 do
						local var_4_14, var_4_15, var_4_16 = DB("equip_stat", arg_4_3.sub_stat .. "_" .. iter_4_2, {
							"stat_type",
							"val_min",
							"val_max"
						})
						local var_4_17 = DB("itemgrade", tostring(arg_4_3.grade), "power")
						local var_4_18, var_4_19, var_4_20 = DB("item_equip_stat_revision", var_4_14, {
							"revise_min",
							"revise_max",
							"t" .. var_4_6
						})
						
						var_4_20 = var_4_20 or 1
						
						if var_4_18 ~= 1 then
							var_4_15 = var_4_15 * var_4_18
						end
						
						if var_4_19 ~= 1 then
							var_4_16 = var_4_16 * var_4_19
						end
						
						if arg_4_3.min_offset then
							var_4_15 = var_4_15 + (UNIT.is_percentage_stat(var_4_14) and arg_4_3.min_offset / 100 or arg_4_3.min_offset)
						end
						
						if arg_4_3.max_offset then
							var_4_16 = var_4_16 + (UNIT.is_percentage_stat(var_4_14) and arg_4_3.max_offset / 100 or arg_4_3.max_offset)
						end
						
						if arg_4_3.pick_max == "y" or var_4_15 == var_4_16 then
							table.insert(arg_4_3.equip_stat, {
								var_4_14,
								var_4_16 * var_4_20 * var_4_17
							})
						elseif arg_4_3.pick_min == "y" then
							table.insert(arg_4_3.equip_stat, {
								var_4_14,
								var_4_15 * var_4_20 * var_4_17
							})
						else
							table.insert(arg_4_3.equip_stat, {
								var_4_14,
								{
									var_4_15 * var_4_20 * var_4_17,
									var_4_16 * var_4_20 * var_4_17
								}
							})
						end
					end
				end
			end
			
			if arg_4_3.equip_stat and #arg_4_3.equip_stat > 0 then
				if_set(arg_4_2, "txt_main_name", getStatName(arg_4_3.equip_stat[1][1]))
				
				local var_4_21
				local var_4_22
				local var_4_23
				local var_4_24
				local var_4_25 = arg_4_3.equip_stat[1][2]
				local var_4_26 = arg_4_3.equip_stat[1][1]
				
				if arg_4_3.equip_stat[2] then
					var_4_23 = arg_4_3.equip_stat[2][2]
					var_4_24 = arg_4_3.equip_stat[2][1]
				end
				
				if arg_4_3.equip then
					var_4_25, var_4_26, var_4_23, var_4_24 = arg_4_3.equip:getMainStat()
				end
				
				if_set(arg_4_2, "txt_main_stat", to_var_str(var_4_25, var_4_26))
				SpriteCache:resetSprite(arg_4_2:getChildByName("main_icon"), "img/cm_icon_stat_" .. string.gsub(var_4_26, "_rate", "") .. ".png")
				
				if arg_4_3.is_artifact and var_4_23 then
					if_set(arg_4_2, "txt_main_name2", getStatName(var_4_24))
					if_set(arg_4_2, "txt_main_stat2", to_var_str(var_4_23, var_4_24))
					SpriteCache:resetSprite(arg_4_2:getChildByName("main_icon2"), "img/cm_icon_stat_" .. string.gsub(var_4_24, "_rate", "") .. ".png")
				end
				
				if_set_visible(arg_4_2, "txt_main_name2", var_4_23 ~= nil)
				if_set_visible(arg_4_2, "txt_main_stat2", var_4_23 ~= nil)
				if_set_visible(arg_4_2, "main_icon2", var_4_23 ~= nil)
				
				local var_4_27 = {}
				local var_4_28 = {}
				local var_4_29
				local var_4_30 = 0
				
				for iter_4_3 = 2, 99 do
					if arg_4_3.equip_stat[iter_4_3] then
						local var_4_31 = arg_4_3.equip_stat[iter_4_3][1]
						local var_4_32 = arg_4_3.equip_stat[iter_4_3][2]
						
						if not var_4_28[var_4_31] then
							var_4_30 = var_4_30 + 1
							var_4_28[var_4_31] = var_4_30
						end
						
						if arg_4_3.equip_stat[iter_4_3][3] == "c" then
							var_4_29 = var_4_28[var_4_31]
						end
						
						if type(var_4_32) == "table" then
							var_4_27[var_4_31] = var_4_32
						else
							var_4_27[var_4_31] = (var_4_27[var_4_31] or 0) + var_4_32
						end
					end
				end
				
				var_4_1 = table.empty(var_4_27)
				
				for iter_4_4, iter_4_5 in pairs(var_4_27) do
					local var_4_33 = var_4_28[iter_4_4]
					
					if_set(arg_4_2, "txt_sub_name" .. var_4_33, getStatName(iter_4_4))
					
					if type(iter_4_5) == "table" then
						if_set(arg_4_2, "txt_sub_stat" .. var_4_33, to_var_str(iter_4_5[1], iter_4_4, nil, true) .. "-" .. to_var_str(iter_4_5[2], iter_4_4))
					else
						if_set(arg_4_2, "txt_sub_stat" .. var_4_33, to_var_str(iter_4_5, iter_4_4))
					end
					
					if get_cocos_refid(arg_4_2) then
						local var_4_34 = arg_4_2:findChildByName("txt_sub_name" .. var_4_33)
						
						if_set_visible(var_4_34, "icon_option_change", var_4_29 == var_4_33)
					end
				end
				
				local var_4_35 = {
					"ui_enchant_3lock_desc",
					"ui_enchant_6lock_desc",
					"ui_enchant_9lock_desc",
					"ui_enchant_12lock_desc"
				}
				
				if arg_4_1.is_enhancer then
					for iter_4_6 = 0, 3 do
						local var_4_36 = arg_4_2:getChildByName(tostring(iter_4_6))
						
						if get_cocos_refid(var_4_36) then
							local var_4_37 = iter_4_6 + 1
							
							if iter_4_6 < var_4_30 then
								if_set_color(var_4_36, nil, tocolor("#FFFFFF"))
								if_set_visible(var_4_36, "lock_stat" .. var_4_37, false)
								if_set_visible(var_4_36, "txt_sub_stat" .. var_4_37, true)
							else
								if_set_color(var_4_36, nil, tocolor("#FF7800"))
								if_set_visible(var_4_36, "lock_stat" .. var_4_37, true)
								if_set_visible(var_4_36, "txt_sub_stat" .. var_4_37, false)
								if_set(var_4_36, "txt_sub_name" .. var_4_37, T(var_4_35[var_4_37]))
							end
						end
					end
				else
					for iter_4_7 = 0, 3 do
						if_set_visible(arg_4_2, tostring(iter_4_7), iter_4_7 < var_4_30)
					end
				end
				
				if var_4_30 > 0 and not arg_4_3.is_exclusive then
					local var_4_38 = math.min(4, var_4_30)
					local var_4_39 = arg_4_2:getChildByName("n_sub_stat_base")
					
					if var_4_39 and not arg_4_1.no_resize then
						var_4_39:setPositionY(0 - (4 - var_4_38) * 24)
					end
					
					var_4_0.sub_stat = 4 + var_4_38 * 24
				end
			else
				if var_4_5 then
					SpriteCache:resetSprite(arg_4_2:getChildByName("main_icon"), "img/cm_icon_stat_what.png")
					if_set(arg_4_2, "txt_main_name", T("random_main_stat"))
					if_set(arg_4_2, "txt_main_stat", "")
				else
					SpriteCache:resetSprite(arg_4_2:getChildByName("main_icon"), "img/cm_icon_stat_" .. string.gsub(var_4_2, "_rate", "") .. ".png")
					
					if arg_4_3.is_artifact then
						local var_4_40 = DB("itemgrade", tostring(arg_4_3.equip_grade_max), "power")
						local var_4_41 = to_var_str(var_4_40 * var_4_4, var_4_2)
						
						if_set(arg_4_2, "txt_main_stat", var_4_41)
					else
						local var_4_42
						
						if var_4_4 == var_4_4 then
							var_4_42 = to_var_str(var_4_4 * var_4_9, var_4_2)
						else
							var_4_42 = to_var_str(var_4_3 * var_4_9, var_4_2) .. "-" .. to_var_str(var_4_4 * var_4_9, var_4_2)
						end
						
						if_set(arg_4_2, "txt_main_stat", var_4_42)
						
						if var_4_4 ~= var_4_3 and arg_4_2:getName() == "item_tooltip_simple" and (arg_4_3.is_exclusive or arg_4_3.is_equip) then
							local var_4_43 = arg_4_2:getChildByName("txt_main_name")
							
							if var_4_43 and get_cocos_refid(var_4_43) then
								UIUserData:call(var_4_43, "SINGLE_WSCALE(135)", {
									origin_scale_x = 0.46
								})
							end
						end
					end
				end
				
				local var_4_44 = ""
				local var_4_45, var_4_46 = DB("item_equip_grade_rate", arg_4_1.grade_rate, {
					"min",
					"max"
				})
				
				var_4_45 = var_4_45 or arg_4_3.grade
				var_4_46 = var_4_46 or arg_4_3.grade
				
				local var_4_47
				local var_4_48
				
				if var_4_45 == var_4_46 then
					var_4_47 = var_4_45 - 1
				else
					var_4_47 = var_4_45 - 1
					var_4_48 = var_4_46 - 1
				end
				
				if not var_4_48 or var_4_47 == var_4_48 then
					var_4_44 = var_4_47
				else
					var_4_44 = var_4_47 .. "-" .. var_4_48
				end
				
				if_set_visible(arg_4_2, "1", false)
				if_set_visible(arg_4_2, "txt_sub_stat1", false)
				if_set(arg_4_2, "txt_sub_name1", T("txt_equip_random_option", {
					add_opt = var_4_44
				}))
				
				local var_4_49 = arg_4_2:getChildByName("n_sub_stat_base")
				
				if var_4_49 and not arg_4_1.no_resize then
					var_4_49:setPositionY(-72)
				end
				
				var_4_0.sub_stat = 36
				var_4_0.sub_stat = var_4_0.sub_stat - 8
				
				if arg_4_3.is_exclusive then
					if_set_visible(arg_4_2, "n_sub_stat", false)
					
					var_4_0.sub_stat = 0
				end
			end
			
			if not arg_4_3.point and arg_4_3.type and arg_4_3.equip_stat and not table.empty(arg_4_3.equip_stat) then
				arg_4_3.point = EQUIP:calcEquipPoint(arg_4_3)
			end
			
			if arg_4_3.point then
				local var_4_50 = arg_4_2:getChildByName("n_equip_point")
				
				if get_cocos_refid(var_4_50) then
					if_set_visible(var_4_50, nil, true)
					if_set(var_4_50, "t_ep_desc", T("ui_equip_score"))
					if_set(var_4_50, "t_equip_point", arg_4_3.point)
					
					var_4_0.equip_point = 3
				end
			end
		end
		
		if false then
		end
		
		if_set_visible(arg_4_2, "n_stone", arg_4_3.is_stone)
		if_set_visible(arg_4_2, "n_stats", not arg_4_3.is_stone)
		
		if arg_4_3.is_artifact then
			if_set_visible(arg_4_2, "n_skills", not arg_4_3.is_stone)
			
			local var_4_51 = arg_4_2:getChildByName("n_img")
			
			if var_4_51 then
				var_4_51:removeAllChildren()
				
				local var_4_52 = cc.Sprite:create("item_arti/" .. DB("equip_item", arg_4_3.code, "image") .. ".png")
				
				if var_4_52 then
					var_4_51:addChild(var_4_52)
				end
			end
			
			local var_4_53 = arg_4_2:getChildByName("star1")
			
			if var_4_53 and not arg_4_1.no_star_align then
				var_4_53:setPositionX((6 - arg_4_3.grade) * 12)
			end
			
			local var_4_54
			local var_4_55
			local var_4_56
			local var_4_57
			local var_4_58 = 0
			local var_4_59 = false
			
			if arg_4_3.equip then
				var_4_58 = arg_4_3.equip:getDupPoint()
				var_4_55 = arg_4_3.equip:getSkillLevel()
				var_4_54 = arg_4_3.equip:getSkillId()
				var_4_57 = arg_4_3.equip:getMaxSkillLevel() + 1
				var_4_59 = arg_4_3.equip:isStone()
			else
				if arg_4_3.artifact_skill then
					var_4_54 = arg_4_3.artifact_skill
				end
				
				var_4_55 = 0
				var_4_57 = 6
			end
			
			local var_4_60 = var_4_55 + 1
			
			UIUtil:setLimitBreakGauge(arg_4_2:getChildByName("n_limit_break"), var_4_58, var_4_59)
			
			local var_4_61 = arg_4_2:getChildByName("n_lv")
			
			if var_4_61 then
				local var_4_62 = 15
				
				if arg_4_1 and arg_4_1.offset_per_char then
					var_4_62 = arg_4_1.offset_per_char
				end
				
				local var_4_63 = UIUtil:numberDigitToCharOffset(var_4_60, 1, var_4_62)
				
				UIUtil:warpping_setLevel(var_4_61, var_4_60, var_4_57, 2, {
					force_offset = true,
					show_max_lv = true,
					offset_per_char = var_4_63
				})
				
				local var_4_64 = var_4_61:findChildByName("lv_slash")
				
				if var_4_60 == var_4_57 and var_4_64 then
					if not var_4_64.move_pos then
						var_4_64.move_pos = var_4_64:getPositionX()
					end
					
					var_4_64:setPositionX(var_4_64.move_pos + 7)
				end
			end
			
			var_4_54 = var_4_54 or DB("equip_item", arg_4_3.code, "skill1")
			
			if arg_4_1.set_desc_richtext then
				upgradeLabelToRichLabel(arg_4_2, "txt_skill_desc")
			end
			
			local var_4_65 = DB("skill", var_4_54, "name")
			
			if_set(arg_4_2, "txt_skill_desc", TooltipUtil:getSkillTooltipText(var_4_54, var_4_55))
			
			local var_4_66 = arg_4_2:getChildByName("txt_type")
			
			if var_4_66 then
				if arg_4_3.equip then
					var_4_66:setString(T("ui_item_grade", {
						grade = arg_4_3.equip:getGradeTitle(arg_4_3.grade)
					}))
					var_4_66:setTextColor(UIUtil:getGradeColor(nil, arg_4_3.equip_grade_min))
				else
					var_4_66:setString(T("ui_item_grade", {
						grade = EQUIP.getGradeTitle(arg_4_3.code, arg_4_3.grade)
					}))
					var_4_66:setTextColor(UIUtil:getGradeColor(nil, arg_4_3.equip_grade_min))
				end
			end
			
			local var_4_67 = arg_4_2:getChildByName("n_zoom")
			
			if get_cocos_refid(var_4_67) then
				local var_4_68 = var_4_67:getChildByName("btn_zoom")
				
				if var_4_68 then
					var_4_68.equip = arg_4_3.equip
				end
				
				local var_4_69 = var_4_67:getParent()
				local var_4_70 = getChildByPath(var_4_69, "btn_zoom")
				
				if get_cocos_refid(var_4_70) then
					var_4_70.equip = arg_4_3.equip
				end
				
				if_set_visible(var_4_67, nil, arg_4_1.zoom_on)
				if_set_visible(var_4_70, nil, arg_4_1.zoom_on)
				
				if arg_4_1.zoom_on then
					ArtiZoom:ArtiZoomNodeAction(var_4_67)
				end
			end
			
			arg_4_1.no_resize_name = true
		end
		
		if not arg_4_3.is_stone or not arg_4_3.is_exclusive then
			if arg_4_3.set_drop and not arg_4_3.is_artifact then
				local var_4_71
				local var_4_72 = 0
				
				for iter_4_8 = 1, 20 do
					local var_4_73 = DB("item_set_rate", string.format("%s_%02d", arg_4_3.set_drop, iter_4_8), "set_id")
					
					if var_4_73 then
						var_4_71 = var_4_73
						var_4_72 = var_4_72 + 1
					end
					
					local var_4_74 = arg_4_2:getChildByName("n_set_drop_data"):getChildByName(tostring(iter_4_8))
					
					if var_4_74 then
						if var_4_73 then
							arg_4_0:updateSetEquipInfo(var_4_74, var_4_73)
						end
						
						if_set_visible(arg_4_2:getChildByName("n_set_drop_data"), tostring(iter_4_8), var_4_73 ~= nil)
					end
				end
				
				if var_4_72 > 0 then
					var_4_0.set_drop_data = 30 * var_4_72 + 45
					
					if not arg_4_1.no_resize then
						arg_4_2:getChildByName("n_set_drop_data"):getChildByName("n_set_drop_content"):setPositionY(30 * var_4_72)
					end
				end
				
				if arg_4_3.unique_type == "y" and var_4_72 == 1 and not arg_4_3.set_fx then
					arg_4_3.set_fx = var_4_71
					var_4_0.set_drop_data = 0
				end
			end
			
			if arg_4_3.is_equip and arg_4_3.set_fx then
				local var_4_75 = to_n(arg_4_0:updateSetEquipInfo(arg_4_2:getChildByName("n_set_data"), arg_4_3.set_fx, arg_4_3.owner, arg_4_3.equip))
				
				var_4_0.set_data = 62 + var_4_75
				
				local var_4_76 = arg_4_2:getChildByName("n_set_content")
				
				if var_4_76 and not arg_4_1.no_resize then
					var_4_76:setPositionY(14 + var_4_75)
				end
				
				if arg_4_3.point then
					var_4_0.set_data = var_4_0.set_data + 35
				end
			end
		end
		
		if var_4_0.sub_stat ~= 0 then
			var_4_0.sub_stat = var_4_0.sub_stat + 4
		end
		
		if_set_visible(arg_4_2, "n_sub_stat", to_n(var_4_0.sub_stat) ~= 0)
		
		if arg_4_1.is_enhancer and var_4_1 then
			if_set_visible(arg_4_2, "n_sub_stat", true)
		end
		
		if arg_4_3.equip and to_n(arg_4_3.equip.enhance) > 0 then
			if_set_visible(arg_4_2, "cur_up", true)
			if_set(arg_4_2, "cur_txt_up", "+" .. arg_4_3.equip.enhance)
		else
			if_set_visible(arg_4_2, "cur_up", false)
			if_set_visible(arg_4_2, "up", false)
		end
		
		if arg_4_3.equip and arg_4_1.up_cont and arg_4_1.up_cont:getName() == "n_up" then
			if_set_visible(arg_4_2, "cur_up", false)
			if_set_visible(arg_4_2, "up", false)
		end
	elseif arg_4_3.is_material then
		local var_4_77, var_4_78 = DB("item_material", arg_4_1.code, {
			"ma_type",
			"ma_type2"
		})
		
		if var_4_77 == "ext_drop" then
			local var_4_79 = DB("item_ext", var_4_78, "set_range")
			
			if var_4_79 then
				local var_4_80 = string.split(var_4_79, ",")
				local var_4_81 = table.count(var_4_80)
				local var_4_82 = arg_4_2:getChildByName("n_set_drop_conversion_data")
				
				if get_cocos_refid(var_4_82) then
					for iter_4_9 = 1, 10 do
						if iter_4_9 <= var_4_81 then
							local var_4_83 = var_4_82:getChildByName(tostring(iter_4_9))
							
							if get_cocos_refid(var_4_83) then
								local var_4_84 = var_4_80[iter_4_9]
								local var_4_85 = UIUtil:getSetIDByAlias(var_4_84)
								
								arg_4_0:updateSetEquipInfo(var_4_83, var_4_85)
							end
						end
						
						if_set_visible(var_4_82, tostring(iter_4_9), iter_4_9 <= var_4_81)
					end
					
					var_4_0.set_drop_conversion_data = 30 * var_4_81 + 60
					
					if not arg_4_1.no_resize then
						var_4_82:getChildByName("n_set_drop_content"):setPositionY(30 * var_4_81)
					end
					
					if_set_visible(arg_4_2, "n_set_drop_conversion_data", var_4_0.set_drop_conversion_data > 0)
				end
			end
		end
	end
	
	if_set_visible(arg_4_2, "n_set_data", arg_4_3.is_equip ~= nil and arg_4_3.set_fx ~= nil)
	if_set_visible(arg_4_2, "n_set_drop_data", var_4_0.set_drop_data > 0)
	
	if not arg_4_3.is_equip or arg_4_3.is_stone then
		var_4_0.main_stat = 0
		var_4_0.sub_stat = 0
		
		if_set_visible(arg_4_2, "n_main_stat", false)
		if_set_visible(arg_4_2, "n_sub_stat", false)
	end
	
	if arg_4_3.is_equip and not arg_4_3.equip_stat then
		if arg_4_3.equip_grade_min == arg_4_3.equip_grade_max then
			if_set(arg_4_2:getChildByName("bg_item"), "txt_type", T("ui_item_grade", {
				grade = EQUIP:getGradeText(arg_4_3.equip_grade_min)
			}))
		else
			if_set(arg_4_2:getChildByName("bg_item"), "txt_type", T("ui_item_grade", {
				grade = EQUIP:getGradeText(arg_4_3.equip_grade_min) .. "-" .. EQUIP:getGradeText(arg_4_3.equip_grade_max)
			}))
		end
	end
	
	local var_4_86 = arg_4_2:getChildByName("txt_name2")
	local var_4_87 = arg_4_2:getChildByName("txt_desc")
	local var_4_88 = DB("item_material", arg_4_1.code, "ma_type") == "xpup" and true or false
	
	if (var_4_88 or arg_4_3.is_artifact) and get_cocos_refid(var_4_87) and get_cocos_refid(var_4_86) then
		local var_4_89 = UIUtil:setTextAndReturnHeight(var_4_86, T(arg_4_3.title))
		local var_4_90 = var_4_89 - var_4_89 / var_4_86:getStringNumLines()
		local var_4_91 = var_4_86:getChildByName("txt_desc_no_role")
		
		if_set_visible(var_4_87, nil, true)
		if_set_visible(var_4_91, nil, false)
		
		var_4_91._origin_size = var_4_91._origin_size or var_4_91:getContentSize()
		var_4_87._origin_size = var_4_87._origin_size or var_4_87:getContentSize()
		
		local var_4_92 = arg_4_3.role and 0 or var_4_91._origin_size.height - var_4_87._origin_size.height
		
		var_4_87._origin_scroll_size = {
			width = var_4_87._origin_size.width,
			height = var_4_87._origin_size.height - var_4_90 + var_4_92
		}
	end
	
	if arg_4_1.no_desc or not get_cocos_refid(var_4_87) or not arg_4_3.desc then
		if_set_visible(arg_4_2, "n_desc", false)
	else
		local var_4_93 = T(arg_4_3.desc)
		
		if not var_4_87.is_inner_scroll_view then
			UIUtil:setTextAndReturnHeight(var_4_87, var_4_93)
			var_4_87:ignoreContentAdaptWithSize(false)
		end
		
		if_set(var_4_87, nil, var_4_93)
		
		local var_4_94 = var_4_87:getContentSize().height * var_4_87:getScaleY()
		local var_4_95 = 20
		
		var_4_0.desc = var_4_0.desc + var_4_94 + var_4_95
	end
	
	if_set(arg_4_2, "txt_name", T(arg_4_3.title))
	if_set(arg_4_2, "txt_info", T(arg_4_3.desc))
	
	local var_4_96 = arg_4_1.txt_name
	local var_4_97 = arg_4_1.bg_item or arg_4_2:getChildByName("bg_item")
	local var_4_98 = arg_4_1.up_cont or arg_4_2:getChildByName("n_up") or arg_4_2:getChildByName("up")
	local var_4_99 = string.find(arg_4_3.code, "ma_petpoint")
	local var_4_100 = UIUtil:getRewardIcon(arg_4_1.count, arg_4_3.code, {
		no_tooltip = true,
		is_tooltip_icon = true,
		show_name = true,
		scale = 1,
		detail = true,
		grade = arg_4_3.grade,
		parent = var_4_97,
		set_fx = arg_4_3.set_fx,
		equip = arg_4_3.equip,
		txt_name = var_4_96,
		txt_type = arg_4_1.txt_type,
		txt_name_width = arg_4_1.txt_name_width or 185,
		txt_scale = arg_4_1.txt_scale or 0.91,
		faction = arg_4_1.faction,
		no_resize_name = arg_4_1.no_resize_name,
		icon_scale = arg_4_1.icon_scale,
		equip_stat = arg_4_3.equip_stat,
		up_cont = var_4_98,
		custom = arg_4_1.custom,
		img = arg_4_1.img,
		category = arg_4_1.category,
		grade_rate = arg_4_1.grade_rate,
		faction_category = arg_4_1.faction_category,
		custom_v2_category = arg_4_1.custom_v2_category,
		custom_v2 = arg_4_1.custom_v2,
		custom_v2_desc = arg_4_1.custom_v2_desc,
		grade_max = arg_4_1.grade_max,
		no_name = arg_4_3.is_artifact,
		show_equip_type = arg_4_1.show_equip_type,
		is_enhancer = arg_4_1.is_enhancer,
		type = arg_4_1.type,
		use_drop_icon = var_4_99 or arg_4_1.use_drop_icon,
		no_bg = var_4_88 == true and true or arg_4_1.no_bg,
		right_hero_name = arg_4_1.right_hero_name,
		right_hero_type = arg_4_1.right_hero_type
	})
	
	if arg_4_3.is_artifact then
		if_set_visible(var_4_100, "n_stars", false)
		
		for iter_4_10 = 1, 6 do
			if_set_visible(arg_4_2, "s" .. iter_4_10, iter_4_10 <= arg_4_3.grade)
			if_set_visible(arg_4_2, "a_star" .. iter_4_10, iter_4_10 <= arg_4_3.grade)
		end
		
		if_set_visible(arg_4_2, "n_art_ok", false)
		if_set_visible(arg_4_2, "n_art_no", false)
		
		if arg_4_3.role and arg_4_3.character_group then
			local var_4_101 = DB("character", arg_4_3.character_group, {
				"name"
			})
			
			if_set_visible(arg_4_2, "n_job", true)
			if_set(arg_4_2, "t_job", T("ui_artifact_detail_sub_role_character", {
				role = T("ui_hero_role_" .. arg_4_3.role),
				character = T(var_4_101)
			}))
			if_set_sprite(arg_4_2, "icon_job", "img/cm_icon_role_" .. arg_4_3.role .. ".png")
		elseif arg_4_3.role and arg_4_3.character_name then
			if_set_visible(arg_4_2, "n_job", true)
			if_set(arg_4_2, "t_job", T("ui_artifact_detail_sub_role_character", {
				role = T("ui_hero_role_" .. arg_4_3.role),
				character = T(arg_4_3.character_name)
			}))
			if_set_sprite(arg_4_2, "icon_job", "img/cm_icon_role_" .. arg_4_3.role .. ".png")
		elseif arg_4_3.role then
			if_set_visible(arg_4_2, "n_job", true)
			if_set(arg_4_2, "t_job", T("ui_artifact_detail_sub_role", {
				role = T("ui_hero_role_" .. arg_4_3.role)
			}))
			if_set_sprite(arg_4_2, "icon_job", "img/cm_icon_role_" .. arg_4_3.role .. ".png")
		else
			if_set_visible(arg_4_2, "n_job", false)
		end
		
		if_set(arg_4_2, "txt_art_name", T(arg_4_3.title))
	end
	
	local var_4_102 = (arg_4_3.is_material or arg_4_3.is_token) and not arg_4_3.hide_own_count
	
	if_set_visible(arg_4_2, "n_count_data", var_4_102)
	
	if var_4_102 then
		local var_4_103 = 0
		local var_4_104 = Account:isCurrencyType(arg_4_3.code)
		
		if var_4_104 == nil and (arg_4_3.code == "to_paidcrystal" or arg_4_3.code == "paidcrystal") then
			var_4_104 = "crystal"
		end
		
		if var_4_104 then
			var_4_103 = Account:getCurrency(var_4_104)
		else
			var_4_103 = Account:getItemCount(arg_4_3.code)
		end
		
		if var_4_88 then
			local var_4_105, var_4_106 = UnitLevelUp:get_all_penguin_count()
			local var_4_107
			local var_4_108 = UnitLevelUp:get_sorted_penguin_table()
			
			for iter_4_11, iter_4_12 in pairs(var_4_108 or {}) do
				if iter_4_12.id == arg_4_3.code then
					var_4_107 = iter_4_12
				end
			end
			
			if not var_4_107 then
				print("error cant found ", arg_4_3.code, " in get_sorted_penguin_table!")
				
				return 
			end
			
			var_4_103 = var_4_106[var_4_107.grade].count or 0
		end
		
		if_set(arg_4_2, "txt_count", T("it_count", {
			count = comma_value(var_4_103)
		}))
		
		var_4_0.count_data = 50
	end
	
	if arg_4_2:getName() == "item_tooltip_simple" and (arg_4_3.is_material or arg_4_3.is_token) and Material_Tooltip:isPopupExist(arg_4_3.code) and not arg_4_1.no_detail_popup then
		local var_4_109 = arg_4_2:getChildByName("n_acquisition")
		
		if var_4_109 then
			var_4_109:setVisible(true)
			if_set(var_4_109, "txt_info", T("item_info_touch"))
			var_4_109:getChildByName("txt_info"):setScale(0.69)
		end
		
		var_4_0.acquision_data = 20
	end
	
	if arg_4_2:getChildByName("diff_icon") then
		if arg_4_1.diff and arg_4_1.diff ~= 0 then
			if arg_4_1.diff_down then
				arg_4_2:getChildByName("diff_icon"):setColor(cc.c3b(0, 120, 255))
			end
			
			if_set(arg_4_2, "diff_stat", arg_4_1.diff)
			if_set_visible(arg_4_2, "diff_icon", true)
		else
			if_set_visible(arg_4_2, "diff_icon", false)
		end
	end
	
	if arg_4_2:getChildByName("diff_icon2") then
		if arg_4_1.diff2 and arg_4_1.diff2 ~= 0 then
			if arg_4_1.diff_down2 then
				arg_4_2:getChildByName("diff_icon2"):setColor(cc.c3b(0, 120, 255))
			end
			
			if_set(arg_4_2, "diff_stat2", arg_4_1.diff2)
			if_set_visible(arg_4_2, "diff_icon2", true)
		else
			if_set_visible(arg_4_2, "diff_icon2", false)
		end
	end
	
	if_set_visible(arg_4_2, "t_code", PLATFORM == "win32")
	
	if PLATFORM == "win32" then
		if_set(arg_4_2, "t_code", arg_4_3.code)
	end
	
	if not arg_4_3.equip_stat and arg_4_3.is_exclusive then
		arg_4_0:set_exclusiveSkills(arg_4_2, arg_4_3, var_4_0)
	end
	
	if arg_4_3.is_exclusive and arg_4_2:getName() == "item_detail_sub" then
		local var_4_110 = {
			"main_icon",
			"txt_main_name",
			"txt_main_stat"
		}
		
		for iter_4_13, iter_4_14 in pairs(var_4_110) do
			local var_4_111 = arg_4_2:getChildByName(iter_4_14)
			
			if get_cocos_refid(var_4_111) then
				var_4_111:setPositionY(var_4_111:getPositionY() - 8)
			end
		end
	end
	
	arg_4_0:set_nPrivate(arg_4_2, arg_4_1.equip, var_4_0)
end

function HANDLER.artifact_tooltip(arg_5_0, arg_5_1)
	if (arg_5_1 == "btn_check_box" or arg_5_1 == "check_box_before") and ItemTooltip.vars then
		local var_5_0 = {}
		
		if not ItemTooltip.vars.enable_max_view then
			ItemTooltip.vars.enable_max_view = true
			var_5_0 = ItemTooltip.vars.max_equip
		else
			ItemTooltip.vars.enable_max_view = false
			var_5_0 = ItemTooltip.vars.origin_equip
		end
		
		if get_cocos_refid(ItemTooltip.vars.check_box) then
			ItemTooltip.vars.check_box:setSelected(ItemTooltip.vars.enable_max_view)
		end
		
		ItemTooltip.vars.opts.equip = var_5_0
		
		ItemTooltip:updateItemInformation(ItemTooltip.vars.opts, ItemTooltip.vars.tooltip)
	end
end

function ItemTooltip.getItemTooltip(arg_6_0, arg_6_1)
	arg_6_1 = arg_6_1 or {}
	
	local var_6_0 = arg_6_0:getItemDetail(arg_6_1)
	local var_6_1 = arg_6_1.wnd
	
	if not var_6_1 then
		if var_6_0.is_artifact then
			if arg_6_1.artifact_popup then
				var_6_1 = load_control("wnd/artifact_detail_popup.csb")
				
				local var_6_2 = load_control("wnd/artifact_tooltip.csb")
				
				if_set_visible(var_6_2, "n_arti_maxium_view", arg_6_1.show_max_check_box)
				var_6_1:getChildByName("n_tooltip_pos"):addChild(var_6_2)
				
				arg_6_0.vars = {}
				arg_6_0.vars.detail = var_6_0
				arg_6_0.vars.max_equip = table.clone(arg_6_1.equip)
				arg_6_0.vars.origin_equip = arg_6_1.equip
				arg_6_0.vars.max_equip.dup_pt = 5
				arg_6_0.vars.max_equip.exp = arg_6_0.vars.max_equip:getMaxExp()
				
				arg_6_0.vars.max_equip:calcEnhance()
				
				arg_6_0.vars.tooltip = var_6_1
				arg_6_0.vars.opts = arg_6_1
				arg_6_0.vars.check_box = var_6_2:getChildByName("check_box_before")
				
				if_set_visible(arg_6_0.vars.check_box, nil, arg_6_1.show_max_check_box)
			else
				var_6_1 = load_control("wnd/artifact_tooltip.csb")
			end
			
			local var_6_3 = load_control("wnd/artifact_detail_sub_popup.csb")
			
			var_6_1:getChildByName("n_pos"):addChild(var_6_3)
		else
			var_6_1 = load_dlg("item_tooltip_simple", true, "wnd")
			
			arg_6_0:updateItemFrame(var_6_1, var_6_0)
		end
	end
	
	arg_6_0:updateItemInformation(arg_6_1, var_6_1, var_6_0)
	
	if not var_6_0.is_stone and not var_6_0.is_artifact then
		local var_6_4 = var_6_1:getChildByName("txt_type")
		
		if get_cocos_refid(var_6_4) then
			local var_6_5 = var_6_4:getContentSize()
			local var_6_6 = 238
			
			if var_6_6 < var_6_5.width then
				local var_6_7 = math.ceil(var_6_5.width / var_6_6)
				
				var_6_4:setTextAreaSize({
					width = var_6_6,
					height = var_6_5.height * var_6_7
				})
				var_6_4:setPositionY(35)
				var_6_1:getChildByName("txt_name"):setPositionY(32)
			end
		end
	end
	
	local var_6_8 = var_6_1:getChildByName("txt_type")
	local var_6_9 = var_6_1:getChildByName("txt_name")
	local var_6_10, var_6_11 = DB("item_material", arg_6_1.code, {
		"ma_type",
		"name"
	})
	local var_6_12 = DB("clan_heritage_object_data", arg_6_1.code, "id") ~= nil
	
	if get_cocos_refid(var_6_8) then
		if var_6_8:getStringNumLines() >= 3 and get_cocos_refid(var_6_8) and get_cocos_refid(var_6_9) then
			var_6_8:setPositionY(var_6_8:getPositionY() - 20)
			var_6_9:setPositionY(var_6_9:getPositionY() - 20)
			
			local var_6_13 = var_6_8:getContentSize()
			
			var_6_8:setTextAreaSize({
				width = var_6_13.width,
				height = var_6_13.height + 20
			})
		end
		
		if var_6_0.is_exclusive then
			if_set(var_6_1, "txt_type", T("item_type_exclusive"))
			var_6_1:getChildByName("txt_type"):setTextColor(cc.c3b(165, 92, 255))
		end
	end
	
	local var_6_14 = var_6_0.heights
	
	if var_6_0.is_token and DB("item_token", arg_6_1.code, "charge_type") then
		local var_6_15 = string.split(arg_6_1.code, "_")[2]
		local var_6_16 = Account:getCurrency(var_6_15)
		
		local function var_6_17()
			local var_7_0, var_7_1, var_7_2 = Account:getRemainCurrencyTime(var_6_15)
			
			if_set(var_6_1, "txt_charge_next", T("charge_next", {
				time = sec_to_full_string(var_7_0)
			}))
			if_set(var_6_1, "txt_charge_all", T("charge_full", {
				time = sec_to_full_string(var_7_1)
			}))
			
			local var_7_3 = Account:getCurrency(var_6_15)
			
			if not var_7_2 and var_6_16 and var_7_3 and var_7_3 ~= var_6_16 then
				if_set(var_6_1, "txt_count", T("it_count", {
					count = comma_value(var_7_3)
				}))
			end
		end
		
		if_set_visible(var_6_1, "n_charge_data", true)
		
		local var_6_18 = AccountData.token_info[var_6_15] or {}
		local var_6_19 = Account:getCurrencyMax(var_6_15)
		
		if var_6_18 and var_6_19 then
			local var_6_20 = var_6_14.count_data > 0
			
			if var_6_19 > Account:getCurrency(var_6_15) then
				var_6_17()
				Scheduler:addSlow(var_6_1, var_6_17, arg_6_0)
				
				var_6_14.charge_data = var_6_20 and 70 or 90
			else
				local var_6_21, var_6_22, var_6_23 = Account:getRemainCurrencyTime(var_6_15)
				
				if_set(var_6_1, "txt_charge_next", T("charge_interval", {
					time = sec_to_full_string(var_6_21)
				}))
				if_set_visible(var_6_1, "txt_charge_all", false)
				if_set_visible(var_6_1, "ic2", false)
				
				local var_6_24 = var_6_1:getChildByName("txt_charge_next")
				
				var_6_24:setPositionY(var_6_24:getPositionY() - 40)
				
				local var_6_25 = var_6_1:getChildByName("ic1")
				
				var_6_25:setPositionY(var_6_25:getPositionY() - 40)
				
				local var_6_26 = var_6_1:getChildByName("cm_bar210_1_1_0")
				
				var_6_26:setPositionY(var_6_26:getPositionY() - 40)
				
				var_6_14.charge_data = var_6_20 and 30 or 40
			end
			
			if_set_visible(var_6_1, "cm_bar210_1_1_0", not var_6_20)
		else
			if_set_visible(var_6_1, "n_charge_data", false)
		end
	else
		if_set_visible(var_6_1, "n_charge_data", false)
	end
	
	local var_6_27 = 24
	local var_6_28 = 0
	local var_6_29 = 0
	
	if var_6_9 and get_cocos_refid(var_6_9) then
		var_6_29 = var_6_9:getStringNumLines()
	end
	
	if var_6_29 >= 3 then
		var_6_28 = -20 * (var_6_29 - 3)
		
		local var_6_30 = var_6_1:getChildByName("txt_main_name")
		
		if var_6_30 and get_cocos_refid(var_6_30) then
			local var_6_31 = var_6_30:getStringNumLines()
			
			if var_6_31 == 1 then
				var_6_28 = var_6_28 - 20
			end
			
			if var_6_31 == 2 then
				var_6_28 = var_6_28 - 26
			end
			
			var_6_27 = var_6_27 + var_6_28 * -1
		end
	end
	
	local var_6_32 = 0
	
	if get_cocos_refid(var_6_8) then
		var_6_32 = var_6_8:getStringNumLines()
	end
	
	if var_6_32 >= 3 then
		var_6_28 = var_6_28 - 20
		var_6_27 = var_6_27 + var_6_28 * -1
	end
	
	if var_6_14.acquision_data and var_6_14.acquision_data > 0 then
		var_6_27 = var_6_27 + 45
	end
	
	if var_6_12 then
		local var_6_33 = arg_6_1.lota_object
		local var_6_34 = var_6_1:findChildByName("frame_grade")
		
		if var_6_33 and LotaUtil:isTooltipRewardPreviewType(var_6_33) then
			local var_6_35 = var_6_1:findChildByName("n_heritage_reward")
			local var_6_36 = LotaUtil:getRewardData(var_6_33:getDisplayRewardId(), var_6_33:getDBId())
			local var_6_37 = table.count(var_6_36)
			local var_6_38 = 71.39999999999999
			local var_6_39 = table.count(var_6_36)
			
			for iter_6_0 = 1, 3 do
				local var_6_40 = var_6_35:findChildByName("heritage_reward_item" .. iter_6_0)
				local var_6_41 = var_6_36[iter_6_0]
				
				if var_6_41 then
					local var_6_42 = LotaUtil:getPreviewItemIcon(var_6_41)
					
					var_6_40:addChild(var_6_42)
					
					local var_6_43 = var_6_40:getPositionX()
					
					if var_6_39 == 1 then
						var_6_40:setPositionX(var_6_43 + var_6_38 * 1.25)
					elseif var_6_39 == 2 then
						if iter_6_0 == 1 then
							var_6_40:setPositionX(var_6_43 + var_6_38 * 1.25 * 0.5)
						else
							var_6_40:setPositionX(var_6_43 + var_6_38 * 1.25 * 0.5)
						end
					end
				end
			end
			
			if_set_visible(var_6_35, nil, true)
			
			var_6_14.lota_reward_preview = 132
		end
		
		if var_6_33 and not var_6_33:isMonsterType() and var_6_33:getType() == "clan" and get_cocos_refid(var_6_34) then
			local var_6_44 = var_6_1:findChildByName("n_object")
			local var_6_45 = var_6_33:isUsedClanObject()
			
			if_set_visible(var_6_44, nil, true)
			if_set_visible(var_6_44, "txt_vsited", var_6_45)
			if_set_visible(var_6_44, "txt_count", not var_6_45)
			
			local var_6_46 = var_6_33:getMaxUse()
			local var_6_47 = var_6_33:getClanObjectUseCount()
			local var_6_48 = var_6_46 <= var_6_47
			
			if var_6_46 == 999 then
				if_set(var_6_44, "txt_count", T("get_count_999"))
			elseif not var_6_48 then
				if_set(var_6_44, "txt_count", T("get_count", {
					number = var_6_46 - var_6_47
				}))
			else
				if_set(var_6_44, "txt_count", T("use_all_complete"))
			end
			
			var_6_14.lota_object = 80
		elseif var_6_33 and var_6_33:isCoopMonsterType() then
			local var_6_49 = var_6_1:findChildByName("n_monster")
			
			if_set_visible(var_6_49, nil, true)
			if_set_visible(var_6_49, "n_condition", true)
			if_set_visible(var_6_49, "txt_participation", true)
			
			local var_6_50 = LotaBattleDataSystem:getBattleDataByTileId(var_6_33:getUID(), var_6_33:getDBId())
			local var_6_51 = 0
			
			if var_6_50 then
				var_6_51 = table.count(var_6_50:getInvitee() or {})
			end
			
			if_set(var_6_49, "txt_participation", T("heritage_monster_battle_user", {
				number = var_6_51
			}))
			
			local var_6_52 = var_6_49:findChildByName("n_condition")
			
			LotaUtil:updateBossCondition(var_6_52, var_6_50)
			
			var_6_14.lota_coop_monster = 120
		end
	end
	
	if not arg_6_1.no_resize and not var_6_0.is_artifact then
		var_6_1:setAnchorPoint(0, 0)
		var_6_1:setPosition(arg_6_1.x or var_6_1:getPositionX(), arg_6_1.y or var_6_1:getPositionY())
		var_6_1:getChildByName("n_object"):setPositionY(var_6_27 + var_6_28 + 16)
		
		local var_6_53 = var_6_27 + var_6_14.lota_object
		
		var_6_1:getChildByName("n_monster"):setPositionY(var_6_53 + var_6_28 + 56)
		
		local var_6_54 = var_6_53 + var_6_14.lota_coop_monster
		
		var_6_1:getChildByName("n_heritage_reward"):setPositionY(var_6_54 + var_6_28 + 88)
		
		local var_6_55 = var_6_54 + var_6_14.lota_reward_preview
		
		var_6_1:getChildByName("n_set_drop_data"):setPositionY(var_6_55 + var_6_28)
		
		local var_6_56 = var_6_55 + var_6_14.set_drop_data
		
		var_6_1:getChildByName("n_set_drop_conversion_data"):setPositionY(var_6_56 + var_6_28)
		
		local var_6_57 = var_6_56 + var_6_14.set_drop_conversion_data
		
		var_6_1:getChildByName("n_acquisition"):setPositionY(var_6_57 + var_6_28)
		
		local var_6_58 = var_6_57 + var_6_14.acquision_data
		
		var_6_1:getChildByName("n_charge_data"):setPositionY(var_6_58 + var_6_28)
		
		local var_6_59 = var_6_58 + var_6_14.charge_data
		
		var_6_1:getChildByName("n_count_data"):setPositionY(var_6_59 + var_6_28)
		
		local var_6_60 = var_6_59 + var_6_14.count_data
		
		var_6_1:getChildByName("n_set_data"):setPositionY(var_6_60 + var_6_28)
		
		local var_6_61 = var_6_60 + var_6_14.set_data
		
		var_6_1:getChildByName("n_equip_point"):setPositionY(var_6_61 + var_6_28)
		
		local var_6_62 = var_6_61 + var_6_14.equip_point
		
		var_6_1:getChildByName("n_sub_stat"):setPositionY(var_6_62 + var_6_28)
		
		local var_6_63 = var_6_62 + var_6_14.sub_stat
		
		var_6_1:getChildByName("n_private"):setPositionY(var_6_63 + var_6_28 - 144 + var_6_14.lines)
		
		local var_6_64 = var_6_63 + var_6_14.exclusive
		local var_6_65 = 0
		
		if var_6_0.is_exclusive then
			var_6_65 = -6
		end
		
		var_6_1:getChildByName("n_main_stat"):setPositionY(var_6_64 + var_6_28 + var_6_65)
		
		local var_6_66 = var_6_64 + var_6_14.main_stat
		
		var_6_1:getChildByName("n_desc"):setPositionY(var_6_66 + var_6_28 + var_6_65)
		
		local var_6_67 = var_6_66 + var_6_14.desc
		
		var_6_1:getChildByName("n_head"):setPositionY(var_6_67)
		
		if var_6_14.before_addtional_height then
			var_6_1:getChildByName("n_effs"):setPositionY(var_6_67 + var_6_28 - 465 + var_6_14.lines)
		else
			var_6_1:getChildByName("n_effs"):setPositionY(var_6_67 + var_6_28 - 260 + var_6_14.lines)
		end
		
		var_6_1:getChildByName("n_effs"):setPositionX(var_6_1:getChildByName("n_effs"):getPositionX() - 377)
		
		local var_6_68 = var_6_1:getChildByName("frame")
		
		if get_cocos_refid(var_6_68) and not var_6_68:isVisible() then
			var_6_68 = var_6_1:getChildByName("frame_grade")
		end
		
		if get_cocos_refid(var_6_68) then
			local var_6_69 = var_6_68:getContentSize()
			
			var_6_68:setContentSize({
				width = var_6_69.width,
				height = var_6_67 + var_6_14.head + 64
			})
			var_6_68:setAnchorPoint(0, 0)
			var_6_68:setPosition(-32, -32)
			var_6_1:setContentSize(var_6_68:getContentSize())
		end
	end
	
	if arg_6_1.scale then
		var_6_1:setScale(arg_6_1.scale)
	end
	
	if arg_6_1.use_badge then
		UIUtil:setItemBadge(var_6_1:getChildByName("n_head"), arg_6_1.code)
	end
	
	if var_6_10 == "xpup" then
		if_set(var_6_1, "txt_name", T(var_6_11))
	end
	
	return var_6_1
end

function ItemTooltip.updateSetEquipInfo(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	if not arg_8_1 then
		return 0
	end
	
	if not arg_8_2 then
		return 0
	end
	
	local var_8_0 = 0
	
	if_set_visible(arg_8_1, "n_set_data", EQUIP:isSetItem(arg_8_2))
	if_set(arg_8_1, "txt_set_title", EQUIP:getSetTitle(arg_8_2))
	
	local var_8_1 = arg_8_1:getChildByName("txt_set_info")
	
	if get_cocos_refid(var_8_1) then
		if_set(var_8_1, nil, EQUIP:getSetDetail(arg_8_2))
		UIUtil:setAutoTextArea(var_8_1)
		
		var_8_0 = var_8_1:getContentSize().height * var_8_1:getScaleY()
	end
	
	replaceSprite(arg_8_1, "icon_element", EQUIP:getSetItemIconPath(arg_8_2))
	
	local var_8_2 = 0
	
	if arg_8_3 and arg_8_4 then
		var_8_2 = arg_8_3:getEquipIndexOfSetItem(arg_8_2, arg_8_4) or 0
	end
	
	local var_8_3 = EQUIP:getSetItemTotalCount(arg_8_2)
	local var_8_4 = COLOR_SET_ITEM_LACK_FONT
	
	if arg_8_3 and var_8_3 <= arg_8_3:getEquipCountOfSetItem(arg_8_2) then
		var_8_4 = COLOR_SET_ITEM_FULL_FONT
	end
	
	local var_8_5 = arg_8_1:getChildByName("txt_set_title")
	
	if var_8_5 and arg_8_4 then
		local var_8_6 = var_8_5:getContentSize()
		
		var_8_5:removeChildByName("set_item_amount")
		
		local var_8_7 = ccui.Text:create()
		
		var_8_7:setName("set_item_amount")
		var_8_7:setFontName(var_8_5:getFontName())
		var_8_7:setColor(var_8_4)
		var_8_7:setFontSize(var_8_5:getFontSize())
		var_8_7:setAnchorPoint(0, 0)
		var_8_7:setPosition(var_8_6.width + 5, 0)
		var_8_7:setString("(" .. var_8_2 .. "/" .. var_8_3 .. ")")
		var_8_7:enableOutline(cc.c3b(0, 0, 0), 1)
		var_8_5:addChild(var_8_7)
	end
	
	return var_8_0
end

function ItemTooltip.updateEquipDetail(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_1:getParent()
	
	if not get_cocos_refid(var_9_0) then
		return 
	end
	
	local var_9_1 = var_9_0:getChildByName(".reward_icon"):getChildByName("txt_name")
	local var_9_2 = var_9_0:getChildByName("txt_desc")
	local var_9_3 = var_9_0:getChildByName("txt_set_info")
	
	if not get_cocos_refid(var_9_1) or not get_cocos_refid(var_9_2) or not get_cocos_refid(var_9_3) then
		return 
	end
	
	local var_9_4 = 0
	local var_9_5 = 2
	
	if var_9_5 < var_9_1:getStringNumLines() then
		var_9_4 = (var_9_1:getStringNumLines() - var_9_5) * var_9_1:getLineHeight() - 9
		
		local var_9_6 = var_9_0:getChildByName("n_desc")
		
		if get_cocos_refid(var_9_6) then
			var_9_6:setPositionY(var_9_6:getPositionY() - var_9_4)
		end
	end
	
	local var_9_7 = 0
	local var_9_8 = 3
	
	if var_9_8 < var_9_2:getStringNumLines() then
		var_9_7 = (var_9_2:getStringNumLines() - var_9_8) * var_9_2:getLineHeight() - 9
	end
	
	local var_9_9 = 0
	local var_9_10 = 3
	
	if var_9_10 < var_9_3:getStringNumLines() then
		var_9_9 = (var_9_3:getStringNumLines() - var_9_10) * var_9_3:getLineHeight()
	end
	
	local var_9_11 = 0
	local var_9_12 = 5
	local var_9_13 = false
	local var_9_14 = var_9_0:getChildByName("txt_skill_desc")
	local var_9_15 = var_9_0:getChildByName("n_private")
	
	if get_cocos_refid(var_9_15) and var_9_15:isVisible() and get_cocos_refid(var_9_14) then
		var_9_11 = (var_9_14:getStringNumLines() - var_9_12) * 20
		var_9_13 = true
		
		if var_9_11 < 0 then
			var_9_11 = 0
		end
	end
	
	local var_9_16 = var_9_7 + var_9_9 + var_9_4 + var_9_11
	local var_9_17 = var_9_0:getContentSize()
	
	if not var_9_0.origin_height then
		var_9_0.origin_height = var_9_17.height
	end
	
	var_9_0:setContentSize({
		width = var_9_17.width,
		height = var_9_0.origin_height + var_9_16
	})
	
	local var_9_18 = {
		"n_head",
		"n_desc",
		"n_wearer"
	}
	
	for iter_9_0, iter_9_1 in pairs(var_9_18) do
		local var_9_19 = var_9_0:getChildByName(iter_9_1)
		
		if get_cocos_refid(var_9_19) then
			if not var_9_19.origin_y then
				var_9_19.origin_y = var_9_19:getPositionY()
			end
			
			var_9_19:setPositionY(var_9_19.origin_y + var_9_16)
		end
	end
	
	local var_9_20 = var_9_13 and var_9_11 or var_9_9
	local var_9_21 = {
		"n_main_stat",
		"n_sub_stat",
		"n_set_data",
		"n_private",
		"n_equip_point"
	}
	
	for iter_9_2, iter_9_3 in pairs(var_9_21) do
		local var_9_22 = var_9_0:getChildByName(iter_9_3)
		
		if get_cocos_refid(var_9_22) then
			if not var_9_22.origin_y then
				var_9_22.origin_y = var_9_22:getPositionY()
			end
			
			var_9_22:setPositionY(var_9_22.origin_y + var_9_20)
		end
	end
	
	local var_9_23 = var_9_0:getChildByName("bar1_r_0")
	local var_9_24 = var_9_0:getChildByName("bar1_l_1")
	
	if not var_9_23.orign_y then
		var_9_23.orign_y = var_9_23:getPositionY()
	end
	
	if not var_9_23.origin_width then
		var_9_23.origin_width = var_9_23:getContentSize().width
	end
	
	if not var_9_24.orign_y then
		var_9_24.orign_y = var_9_24:getPositionY()
	end
	
	if not var_9_24.origin_width then
		var_9_24.origin_width = var_9_24:getContentSize().width
	end
	
	var_9_23:setPositionY(var_9_23.orign_y + var_9_16 * 0.5)
	var_9_23:setContentSize({
		width = var_9_23.origin_width + var_9_16 * 0.5,
		height = var_9_23:getContentSize().height
	})
	var_9_24:setPositionY(var_9_24.orign_y + var_9_16 * 0.5)
	var_9_24:setContentSize({
		width = var_9_24.origin_width + var_9_16 * 0.5,
		height = var_9_24:getContentSize().height
	})
end

function ItemTooltip.updateItemDetail(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1:getChildByName(".reward_icon"):getChildByName("txt_name")
	local var_10_1 = arg_10_1:getChildByName("txt_desc")
	
	if not get_cocos_refid(var_10_0) or not get_cocos_refid(var_10_1) then
		return 
	end
	
	if var_10_1.origin_position_y then
		var_10_1:setPositionY(var_10_1.origin_position_y)
	end
	
	local var_10_2 = 0
	local var_10_3 = 2
	
	if var_10_3 < var_10_0:getStringNumLines() then
		local var_10_4 = (var_10_0:getStringNumLines() - var_10_3) * var_10_0:getLineHeight() - 9
		
		if not var_10_1.origin_position_y then
			var_10_1.origin_position_y = var_10_1:getPositionY()
		end
		
		var_10_1:setPositionY(var_10_1.origin_position_y - var_10_4)
	end
end

function ItemTooltip.setupSkillIcon(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
	local var_11_0, var_11_1, var_11_2 = DB("character", arg_11_1, {
		"skill1",
		"skill2",
		"skill3"
	})
	local var_11_3 = UNIT:create({
		code = arg_11_1
	})
	local var_11_4
	local var_11_5
	local var_11_6
	
	if arg_11_6 then
		var_11_4 = UIUtil:getSkillIcon(var_11_3, var_11_0, {
			notMyUnit = true,
			no_tooltip = true,
			show_exclusive_target = 1
		})
		var_11_5 = UIUtil:getSkillIcon(var_11_3, var_11_1, {
			notMyUnit = true,
			no_tooltip = true,
			show_exclusive_target = 2
		})
		var_11_6 = UIUtil:getSkillIcon(var_11_3, var_11_2, {
			notMyUnit = true,
			no_tooltip = true,
			show_exclusive_target = 3
		})
	else
		var_11_4 = UIUtil:getSkillIcon(var_11_3, var_11_0, {
			no_tooltip = true
		})
		var_11_5 = UIUtil:getSkillIcon(var_11_3, var_11_1, {
			no_tooltip = true
		})
		var_11_6 = UIUtil:getSkillIcon(var_11_3, var_11_2, {
			no_tooltip = true
		})
	end
	
	local var_11_7 = {}
	
	for iter_11_0 = 1, 3 do
		var_11_7[iter_11_0] = 0
	end
	
	for iter_11_1 = 1, 3 do
		local var_11_8 = arg_11_2 .. "_0" .. iter_11_1
		local var_11_9, var_11_10, var_11_11, var_11_12 = DB("skill_equip", var_11_8, {
			"exc_number",
			"exc_effect",
			"exc_desc",
			"exc_change_desc"
		})
		
		if not var_11_9 then
		end
		
		local var_11_13 = arg_11_4:getChildByName(arg_11_3 .. iter_11_1)
		local var_11_14 = var_11_13:getChildByName("n_skill_icon")
		
		if arg_11_5 then
			var_11_14 = var_11_13
		end
		
		local var_11_15 = var_11_4
		local var_11_16 = var_11_0
		
		if var_11_9 == 1 then
			var_11_15 = var_11_4:clone()
			var_11_16 = var_11_0
		elseif var_11_9 == 2 then
			var_11_15 = var_11_5:clone()
			var_11_16 = var_11_1
		elseif var_11_9 == 3 then
			var_11_15 = var_11_6:clone()
			var_11_16 = var_11_2
		end
		
		if_set_visible(var_11_15, "n_skill_num", true)
		if_set_sprite(var_11_15, "img_skill_num_roma", "img/itxt_num" .. iter_11_1 .. "_roma_b")
		if_set_visible(var_11_15, "soul1", false)
		
		local var_11_17 = DB("skill", var_11_16, "name")
		local var_11_18 = upgradeLabelToRichLabel(var_11_13, "txt_skill_desc")
		
		if_set(var_11_18, nil, T(var_11_11))
		if_set(var_11_13, "txt_skill_name", T(var_11_17))
		var_11_14:addChild(var_11_15)
		
		if not arg_11_5 then
			var_11_18:formatText()
			
			local var_11_19 = var_11_18:getStringNumLines()
			
			if var_11_19 >= 4 then
				var_11_7[iter_11_1] = 25 * (var_11_19 - 3)
			else
				var_11_7[iter_11_1] = 25
			end
		end
	end
	
	return var_11_7
end

function ItemTooltip.getExclusiveStatRange(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0
	
	if arg_12_1 == arg_12_2 then
		var_12_0 = to_var_str(arg_12_1, arg_12_3)
	else
		var_12_0 = to_var_str(arg_12_1, arg_12_3) .. "-" .. to_var_str(arg_12_2, arg_12_3)
	end
	
	return var_12_0
end

function ItemTooltip.makeExclusiveSkillUI(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = load_dlg("item_private_info", true, "wnd")
	local var_13_1 = var_13_0:getChildByName("n_con")
	local var_13_2 = arg_13_0:setupSkillIcon(arg_13_1, arg_13_2, "n_", var_13_1)
	local var_13_3, var_13_4, var_13_5 = DB("equip_stat", arg_13_3 .. "_1", {
		"stat_type",
		"val_min",
		"val_max"
	})
	
	if_set(var_13_1, "txt_skill_desc_0", getStatName(var_13_3))
	
	local var_13_6 = arg_13_0:getExclusiveStatRange(var_13_4, var_13_5, var_13_3)
	
	if_set(var_13_1, "txt_skill_desc_0_0", var_13_6)
	SpriteCache:resetSprite(var_13_1:getChildByName("icon_stat"), "img/cm_icon_stat_" .. string.gsub(var_13_3, "_rate", "") .. ".png")
	
	return var_13_0, var_13_2
end

function ItemTooltip.set_exclusiveSkills(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if not arg_14_2.is_exclusive or not arg_14_2.is_equip then
		return 
	end
	
	if arg_14_1:getName() ~= "item_tooltip_simple" then
		return 
	end
	
	if_set_visible(arg_14_1, "n_private", true)
	
	local var_14_0 = arg_14_1:getChildByName("n_private")
	local var_14_1 = arg_14_1:getChildByName("n_effs")
	local var_14_2 = arg_14_2.exclusive_unit
	local var_14_3 = arg_14_2.exclusive_skill
	local var_14_4 = arg_14_2.exclusive_skill_idx
	
	if arg_14_2.show_all_exc_skills then
		var_14_4 = nil
	end
	
	local var_14_5
	
	if var_14_4 == nil then
		local var_14_6, var_14_7 = arg_14_0:makeExclusiveSkillUI(var_14_2, var_14_3, arg_14_2.main_stat)
		
		var_14_1:addChild(var_14_6)
		
		var_14_5 = var_14_7
	end
	
	arg_14_0:setupSkillIcon(var_14_2, var_14_3, "n_skill_icon", var_14_0, true, var_14_4 ~= nil)
	
	local var_14_8
	
	if var_14_4 ~= nil then
		var_14_4 = to_n(var_14_4)
		var_14_8 = UNIT:create({
			z = 6,
			code = var_14_2
		})
		
		for iter_14_0 = 1, 3 do
			local var_14_9 = var_14_0:getChildByName("n_skill_icon" .. iter_14_0)
			local var_14_10, var_14_11 = DB("skill_equip", var_14_3 .. "_0" .. iter_14_0, {
				"exc_number",
				"exc_desc"
			})
			
			if_set_visible(var_14_9, "soul1", false)
			
			if iter_14_0 == var_14_4 then
				var_14_9:setOpacity(255)
				
				local var_14_12 = UIUtil:getSkillByUIIdx(var_14_8, var_14_10)
				local var_14_13 = DB("skill", var_14_12, "name")
				
				if_set_scale_fit_width_long_word(var_14_0, "txt_skill_name", T(var_14_13), 450)
				if_set_visible(var_14_9, "exclusive", true)
				
				local var_14_14 = var_14_0:getChildByName("txt_skill_desc")
				local var_14_15 = upgradeLabelToRichLabel(var_14_0, "txt_skill_desc")
				
				if_set(var_14_15, nil, T(var_14_11))
			else
				var_14_9:setOpacity(76.5)
			end
		end
	end
	
	if_set_visible(arg_14_1:getChildByName("n_private"), "n_detail", var_14_4 ~= nil)
	if_set_visible(arg_14_1:getChildByName("n_private"), "icon_check", false)
	
	local var_14_16 = {
		no_popup = true,
		name = false,
		no_lv = true,
		no_role = true,
		no_grade = true,
		parent = arg_14_1:getChildByName("mob_icon")
	}
	
	UIUtil:getUserIcon(var_14_2, var_14_16)
	
	local var_14_17 = var_14_0:getChildByName("txt_before"):getStringNumLines()
	
	if arg_14_3 then
		arg_14_3.exclusive = 100 + 24 * var_14_17
		arg_14_3.lines = 24 * var_14_17
	end
	
	local var_14_18 = 0
	
	if var_14_5 then
		for iter_14_1 = 3, 1, -1 do
			if var_14_5[iter_14_1] then
				local var_14_19 = var_14_1:getChildByName("n_" .. iter_14_1)
				
				if not var_14_19 then
					break
				end
				
				var_14_19:setPositionY(var_14_19:getPositionY() + var_14_5[iter_14_1] + var_14_18)
				
				var_14_18 = var_14_18 + var_14_5[iter_14_1]
			end
		end
		
		arg_14_3.before_addtional_height = var_14_18
		
		local var_14_20 = var_14_1:getChildByName("bg")
		local var_14_21 = var_14_20:getContentSize()
		
		var_14_20:setContentSize({
			width = var_14_21.width,
			height = var_14_21.height + var_14_18
		})
	else
		arg_14_3.before_addtional_height = 0
	end
	
	if var_14_5 then
		for iter_14_2 = 3, 1, -1 do
			if var_14_5[iter_14_2] then
				local var_14_22 = var_14_1:getChildByName("n_" .. iter_14_2)
				
				if not var_14_22 then
					break
				end
				
				var_14_22:setPositionY(var_14_22:getPositionY() - var_14_18)
			end
		end
	end
	
	if_set(arg_14_1, "txt_before", T("random_skill_exclusive_de"))
	if_set_visible(var_14_0, "txt_before", var_14_4 == nil)
	if_set_visible(var_14_0, "txt_skill_num", var_14_4 == nil)
	
	local var_14_23, var_14_24, var_14_25 = DB("equip_stat", arg_14_2.main_stat .. "_1", {
		"stat_type",
		"val_min",
		"val_max"
	})
	local var_14_26 = arg_14_0:getExclusiveStatRange(var_14_24, var_14_25, var_14_23)
	
	if_set(arg_14_1, "txt_main_stat", var_14_26)
end

function ItemTooltip.set_nPrivate(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
	if not get_cocos_refid(arg_15_1) then
		return 
	end
	
	local var_15_0
	local var_15_1
	
	if arg_15_2 then
		var_15_0 = arg_15_2.db.exclusive_unit
		var_15_1 = arg_15_2.db.exclusive_skill
	else
		return 
	end
	
	if not var_15_0 or not var_15_1 then
		return 
	end
	
	local var_15_2 = arg_15_1:getChildByName("n_private")
	
	if not get_cocos_refid(var_15_2) then
		return 
	end
	
	if_set_visible(arg_15_1, "n_sub_stat", false)
	var_15_2:setVisible(true)
	
	local var_15_3 = {
		no_popup = true,
		name = false,
		no_lv = true,
		no_role = true,
		no_grade = true,
		parent = var_15_2:getChildByName("mob_icon")
	}
	
	UIUtil:getUserIcon(var_15_0, var_15_3)
	if_set_visible(var_15_2, "txt_before", false)
	if_set_visible(var_15_2, "txt_skill_num", false)
	
	local var_15_4
	
	if arg_15_2.op then
		var_15_4 = arg_15_2.op[2][2]
	end
	
	local var_15_5
	local var_15_6 = UNIT:create({
		z = 6,
		code = var_15_0
	})
	
	for iter_15_0 = 1, 3 do
		local var_15_7, var_15_8 = DB("skill_equip", var_15_1 .. "_0" .. iter_15_0, {
			"exc_number",
			"exc_desc"
		})
		local var_15_9 = UIUtil:getSkillIcon(var_15_6, var_15_7, {
			notMyUnit = true,
			no_tooltip = true,
			show_exclusive_target = iter_15_0
		})
		
		if_set_visible(var_15_9, "soul1", false)
		
		if get_cocos_refid(var_15_2:getChildByName("n_skill_icon" .. iter_15_0)) then
			var_15_2:getChildByName("n_skill_icon" .. iter_15_0):removeAllChildren()
			var_15_2:getChildByName("n_skill_icon" .. iter_15_0):addChild(var_15_9)
		end
		
		if var_15_4 == iter_15_0 then
			local var_15_10 = UIUtil:getSkillByUIIdx(var_15_6, var_15_7)
			local var_15_11 = DB("skill", var_15_10, "name")
			
			if_set_scale_fit_width_long_word(var_15_2, "txt_skill_name", T(var_15_11), 450)
			
			var_15_5 = var_15_8
			
			if_set_visible(var_15_9, "exclusive", true)
		else
			var_15_9:setOpacity(76.5)
		end
	end
	
	local var_15_12 = var_15_2:getChildByName("txt_skill_desc")
	local var_15_13 = upgradeLabelToRichLabel(var_15_2, "txt_skill_desc")
	
	if_set(var_15_13, nil, T(var_15_5))
	if_set_visible(var_15_2, "icon_check", false)
	var_15_13:formatText()
	
	local var_15_14 = var_15_13:getStringNumLines()
	local var_15_15 = 0
	
	if arg_15_3 then
		arg_15_3.exclusive = 100 + 24 * var_15_14
		arg_15_3.lines = 24 * var_15_14
	end
	
	if_set(arg_15_1, "txt_type", T("item_type_exclusive"))
	
	local var_15_16 = arg_15_1:getParent()
	
	if var_15_16 and get_cocos_refid(var_15_16) and var_15_16:getName() == "frame" then
		local var_15_17 = var_15_16:getChildByName("n_wearer")
		
		if var_15_6 and var_15_17 then
			if arg_15_2.parent then
				var_15_6 = Account:getUnit(arg_15_2.parent)
				var_15_6 = var_15_6 or UNIT:create({
					z = 6,
					code = var_15_0
				})
			end
			
			local var_15_18 = var_15_17:getChildByName("n_unit")
			
			SpriteCache:resetSprite(var_15_18:getChildByName("role"), "img/cm_icon_role_" .. var_15_6.db.role .. ".png")
			SpriteCache:resetSprite(var_15_18:getChildByName("color"), "img/cm_icon_pro" .. var_15_6:getColor() .. ".png")
			UIUtil:setLevelDetail(var_15_18:getChildByName("n_lv"), var_15_6:getLv(), var_15_6:getMaxLevel())
			
			local var_15_19 = var_15_17:getChildByName("txt_unit_name")
			local var_15_20 = get_word_wrapped_name(var_15_19, var_15_6:getName())
			
			UIUtil:setTextAndReturnHeight(var_15_19, var_15_20)
		end
	end
	
	local var_15_21 = var_15_2:findChildByName("bg")
	
	if get_cocos_refid(var_15_21) then
		local var_15_22 = var_15_21:getContentSize()
		local var_15_23 = var_15_21:getAnchorPoint()
		local var_15_24, var_15_25 = var_15_21:getPosition()
		local var_15_26 = var_15_21:getScaleX()
		local var_15_27 = var_15_21:getScaleY()
		local var_15_28 = var_15_21:getParent():findChildByName("tooltip_parent")
		
		if not get_cocos_refid(var_15_28) then
			var_15_28 = cc.Node:create()
			
			var_15_28:setContentSize(var_15_22)
			var_15_28:setAnchorPoint(var_15_23.x, var_15_23.y)
			var_15_28:setPosition(var_15_24, var_15_25)
			var_15_28:setScaleX(var_15_26)
			var_15_28:setScaleY(var_15_27)
			var_15_28:setName("tooltip_parent")
			var_15_21:getParent():addChild(var_15_28)
		end
		
		var_15_28:removeAllChildren()
		
		var_15_28._TOUCH_LISTENER = nil
		
		WidgetUtils:setupTooltip({
			control = var_15_28,
			creator = function()
				return ItemTooltip:makeExclusiveSkillUI(var_15_0, var_15_1, arg_15_2.db.main_stat)
			end
		})
	end
end

function ItemTooltip.updateEquipSubWindow(arg_17_0, arg_17_1, arg_17_2)
	arg_17_2 = arg_17_2 or {}
	
	local var_17_0 = arg_17_1:isArtifact()
	local var_17_1 = arg_17_1:isExclusive()
	
	if arg_17_2.wnd and not arg_17_1 then
		if arg_17_2.wnd.item_detail then
			arg_17_2.wnd.item_detail:removeFromParent()
		end
		
		return 
	end
	
	local var_17_2
	local var_17_3
	
	if var_17_0 then
		var_17_2 = "artifact_detail"
		var_17_3 = arg_17_2.sub_artifact_name or "wnd/artifact_detail_sub.csb"
	else
		var_17_2 = "item_detail"
		var_17_3 = arg_17_2.sub_equip_name or "wnd/item_detail_sub.csb"
	end
	
	local var_17_4
	local var_17_5
	
	if arg_17_2.unit then
		var_17_4 = arg_17_2.unit:getEquipByPos(arg_17_1.db.type)
		var_17_5 = var_17_4 and var_17_4 == arg_17_1
	end
	
	if not arg_17_2.wnd then
		arg_17_2.wnd = load_dlg(var_17_2, true, "wnd")
		
		local var_17_6 = load_control(var_17_3)
		
		var_17_6:setAnchorPoint(0.5, 0.5)
		var_17_6:setPosition(arg_17_2.wnd:getChildByName("pos_detail"):getPosition())
		arg_17_2.wnd:addChild(var_17_6)
		
		arg_17_2.wnd.item_detail = var_17_6
	end
	
	arg_17_2.wnd:setAnchorPoint(0.5, 0.5)
	
	local var_17_7 = arg_17_2.wnd:getChildByName("artifact_detail_sub_popup")
	local var_17_8
	
	if var_17_0 and get_cocos_refid(var_17_7) then
		var_17_8 = getChildByPath(var_17_7, "LEFT/n_artifact/n_up") or getChildByPath(var_17_7, "LEFT/n_artifact/up")
	end
	
	local var_17_9 = arg_17_2.wnd:getChildByName("btn_equip_arti")
	
	if get_cocos_refid(var_17_9) then
		local var_17_10 = IS_PUBLISHER_STOVE and not ContentDisable:byAlias("eq_arti_statistics")
		
		if_set_visible(var_17_9, nil, var_17_10)
		
		var_17_9.equip = arg_17_1
	end
	
	arg_17_0:updateItemInformation({
		detail = true,
		no_resize = true,
		wnd = arg_17_2.wnd,
		equip = arg_17_1,
		up_cont = var_17_8,
		zoom_on = arg_17_2.zoom_on
	})
	
	if not var_17_0 then
		if arg_17_2.wnd:getName() == "n_equip_detail" then
			arg_17_0:updateEquipDetail(arg_17_2.wnd)
		elseif arg_17_2.wnd:getName() == "item_detail" then
			arg_17_0:updateItemDetail(arg_17_2.wnd)
		end
	end
	
	if var_17_0 and arg_17_2.unit then
		if arg_17_1.db.role then
			if_set_visible(arg_17_2.wnd, "n_art_ok", arg_17_1.db.role == arg_17_2.unit.db.role)
			if_set_visible(arg_17_2.wnd, "n_art_no", arg_17_1.db.role ~= arg_17_2.unit.db.role)
		end
		
		if arg_17_1.db.character then
			if_set_visible(arg_17_2.wnd, "n_art_ok", arg_17_1.db.character == arg_17_2.unit.db.code)
			if_set_visible(arg_17_2.wnd, "n_art_no", arg_17_1.db.character ~= arg_17_2.unit.db.code)
		end
		
		if arg_17_1.db.character_group then
			if_set_visible(arg_17_2.wnd, "n_art_ok", arg_17_1.db.character_group == arg_17_2.unit.db.set_group)
			if_set_visible(arg_17_2.wnd, "n_art_no", arg_17_1.db.character_group ~= arg_17_2.unit.db.set_group)
		end
	end
	
	arg_17_2.wnd.equip = arg_17_1
	arg_17_2.wnd.equip_id = arg_17_1.id
	
	local var_17_11 = arg_17_2.wnd:getChildByName("n_btn")
	local var_17_12 = 255
	
	if var_17_11 then
		if arg_17_1:isStone() then
			var_17_12 = 80
		end
		
		var_17_11:setOpacity(var_17_12)
		if_set_visible(var_17_11, "btn_puton", not var_17_4 and arg_17_1.parent == nil)
		if_set_visible(var_17_11, "btn_puton_cost", not var_17_5 and (arg_17_1.parent ~= nil or var_17_4 ~= nil))
		if_set_visible(var_17_11, "btn_putoff", var_17_5)
		
		local var_17_13 = var_17_4 and var_17_4:getUnequipCost() or 0
		local var_17_14 = (not var_17_5 and arg_17_1.parent and arg_17_1:getUnequipCost() or 0) + var_17_13
		
		if var_17_14 <= 0 then
			if_set(var_17_11, "txt_putoff_cost", T("shop_price_free"))
			if_set(var_17_11, "txt_puton_cost", T("shop_price_free"))
		else
			if_set(var_17_11, "txt_putoff_cost", comma_value(var_17_14))
			if_set(var_17_11, "txt_puton_cost", comma_value(var_17_14))
		end
	end
	
	if arg_17_1.lock then
		if_set_sprite(arg_17_2.wnd, "icon_lock", "img/cm_icon_etclocked.png")
		if_set_color(arg_17_2.wnd, "btn_lock", cc.c3b(255, 255, 255))
		if_set_opacity(arg_17_2.wnd, "icon_lock", 255)
		if_set_opacity(arg_17_2.wnd, "btn_lock", 255)
	else
		if_set_color(arg_17_2.wnd, "btn_lock", cc.c3b(0, 0, 0))
		if_set_sprite(arg_17_2.wnd, "icon_lock", "img/cm_icon_etclockun.png")
		if_set_opacity(arg_17_2.wnd, "icon_lock", 127.5)
		if_set_opacity(arg_17_2.wnd, "btn_lock", 127.5)
	end
	
	if_set_visible(arg_17_2.wnd, "n_before", arg_17_2.is_before_equip)
	if_set_visible(arg_17_2.wnd, "n_after", arg_17_2.is_after_equip)
	
	if var_17_0 then
		local var_17_15 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_ALL_FREE_EVENT) or Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_ARTI_FREE)
		
		var_17_15 = (arg_17_2.is_before_equip or var_17_4 and arg_17_2.is_after_equip) and var_17_15
		
		if var_17_0 and arg_17_2.unit and arg_17_1.db.role and arg_17_1.db.role ~= arg_17_2.unit.db.role then
			if_set_opacity(arg_17_2.wnd, "event_badge", 127.5)
		else
			if_set_opacity(arg_17_2.wnd, "event_badge", 255)
		end
		
		if_set_visible(arg_17_2.wnd, "event_badge", var_17_15)
	else
		local var_17_16 = Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_ALL_FREE_EVENT) or Booster:isActiveBoosterSubType(EVENT_BOOSTER_SUB_TYPE.EQUIP_NO_ARTI_FREE)
		
		var_17_16 = (arg_17_2.is_before_equip or var_17_4 and arg_17_2.is_after_equip) and var_17_16
		
		if_set_visible(arg_17_2.wnd, "event_badge", var_17_16)
	end
	
	return arg_17_2.wnd
end

function HANDLER.item_acquisition_info(arg_18_0, arg_18_1, arg_18_2)
	if (arg_18_1 == "btn_go" or arg_18_1 == "btn_move") and arg_18_0.link then
		Material_Tooltip:moveToLink(arg_18_0.link, arg_18_0.system_unlock, arg_18_0.datasource)
	end
end

Material_Tooltip = {}

function Material_Tooltip._check_chapter_shop_is_unlock(arg_19_0, arg_19_1)
	if not arg_19_1 then
		return 
	end
	
	local var_19_0, var_19_1 = DB("shop_chapter_category", arg_19_1, {
		"id",
		"unlock_stage"
	})
	
	if not var_19_0 then
		return 
	end
	
	if string.starts(var_19_0, "wrd_") and not UnlockSystem:isUnlockSystem(UNLOCK_ID.WORLD_LEVEL) then
		return false
	end
	
	local var_19_2 = not var_19_1 or Account:isMapCleared(var_19_1)
	local var_19_3 = var_19_2 and Account:isClearedChapterShopQuest(var_19_0)
	
	if not var_19_2 then
		return false
	end
	
	if var_19_2 and not var_19_3 then
		return false
	end
	
	return true
end

function Material_Tooltip.getMaterialTooltip(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	if not arg_20_2 then
		return 
	end
	
	if Account:checkQueryEmptyDungeonData("material_toolip", {
		code = arg_20_2,
		opts = arg_20_3
	}) then
		return 
	end
	
	local var_20_0 = arg_20_3 or {}
	local var_20_1 = {}
	local var_20_2 = {}
	
	for iter_20_0 = 1, 99999 do
		local var_20_3 = arg_20_2 .. "_" .. iter_20_0
		local var_20_4, var_20_5, var_20_6, var_20_7, var_20_8, var_20_9, var_20_10, var_20_11, var_20_12 = DB("item_info", var_20_3, {
			"id",
			"sort",
			"type",
			"data",
			"clear_check",
			"mission_check",
			"shop_chapter_id",
			"limit_count",
			"contents_type"
		})
		
		if not var_20_4 or not var_20_7 then
			break
		end
		
		local var_20_13 = DBT("item_link", var_20_7, {
			"id",
			"name",
			"icon",
			"link",
			"enter_unlock",
			"system_unlock",
			"irregular",
			"shop_category_id",
			"unlock_title",
			"unlock_desc"
		})
		local var_20_14
		
		if var_20_8 then
			var_20_14 = Account:isMapCleared(var_20_8)
		end
		
		local var_20_15
		
		if var_20_7 and string.starts(var_20_7, "link_shop") and var_20_10 and var_20_11 and var_20_11 <= Account:getLimitCount("sh:" .. var_20_10) then
			var_20_15 = true
		end
		
		local var_20_16
		
		if var_20_9 then
			local var_20_17 = string.split(var_20_9, ";")
			local var_20_18 = 0
			
			for iter_20_1, iter_20_2 in pairs(var_20_17 or {}) do
				local var_20_19 = false
				
				if var_20_8 and var_20_12 == CONTENTS_TYPE.BATTLE_MISSION and string.starts(iter_20_2, "smis_wrd") then
					var_20_19 = Account:isClearedDungeonMissionSubstory("vewrda", var_20_8, iter_20_2)
				end
				
				if not var_20_19 then
					local var_20_20 = ConditionContentsManager:getContents(var_20_12)
					
					if var_20_20 and var_20_20.getState and var_20_6(var_20_20.getState) == "function" then
						var_20_19 = var_20_20:getState(iter_20_2)
						
						if var_20_19 == 2 then
							var_20_19 = true
						else
							var_20_19 = false
						end
					elseif var_20_20 then
						var_20_19 = var_20_20:isCleared(iter_20_2)
					end
				end
				
				if var_20_19 then
					var_20_18 = var_20_18 + 1
				end
			end
			
			if var_20_18 >= table.count(var_20_17 or {}) then
				var_20_16 = true
			end
		end
		
		local var_20_21
		
		if var_20_13.enter_unlock then
			var_20_13.is_enterable = Account:checkEnterMap(var_20_13.enter_unlock) or false
		end
		
		local var_20_22
		
		if var_20_13.system_unlock then
			var_20_13.unlock_content = UnlockSystem:isUnlockSystem(var_20_13.system_unlock)
			
			if ContentDisable:byAlias(var_20_13.system_unlock) then
				var_20_13.unlock_content = true
			end
		end
		
		var_20_13.is_unlock_chapter_shop = nil
		
		if var_20_13.shop_category_id then
			var_20_13.is_unlock_chapter_shop = Material_Tooltip:_check_chapter_shop_is_unlock(var_20_13.shop_category_id)
		end
		
		var_20_13.irregular_check = nil
		
		if var_20_13.irregular then
			var_20_13.irregular_check = Material_Tooltip:_check_irregular_condition(var_20_13.irregular)
		end
		
		local var_20_23 = var_20_13.irregular and not var_20_13.irregular_check or var_20_13.shop_category_id and not var_20_13.is_unlock_chapter_shop or var_20_13.system_unlock and not var_20_13.unlock_content or var_20_13.enter_unlock and not var_20_13.is_enterable or var_20_10 and var_20_15
		
		if var_20_13 and not table.empty(var_20_13) then
			local var_20_24 = {
				db_id = var_20_4,
				sort = var_20_5,
				type = var_20_6,
				data = var_20_7,
				clear_check = var_20_8,
				is_map_cleared = var_20_14,
				mission_check = var_20_9,
				is_mission_cleared = var_20_16,
				link_info = var_20_13,
				is_unlock = var_20_23,
				shop_chapter_id = var_20_10,
				limit_count = var_20_11,
				is_buy_limit = var_20_15
			}
			
			if var_20_6 == "get" then
				table.insert(var_20_1, var_20_24)
			elseif var_20_6 == "use" then
				table.insert(var_20_2, var_20_24)
			end
		end
	end
	
	if table.empty(var_20_1) then
		return 
	end
	
	table.sort(var_20_1, function(arg_21_0, arg_21_1)
		if arg_21_0.is_unlock and not arg_21_1.is_unlock then
			return false
		end
		
		if not arg_21_0.is_unlock and arg_21_1.is_unlock then
			return true
		end
		
		if arg_21_0.is_map_cleared and not arg_21_1.is_map_cleared then
			return false
		end
		
		if not arg_21_0.is_map_cleared and arg_21_1.is_map_cleared then
			return true
		end
		
		if arg_21_0.is_mission_cleared and not arg_21_1.is_mission_cleared then
			return false
		end
		
		if not arg_21_0.is_mission_cleared and arg_21_1.is_mission_cleared then
			return true
		end
		
		if arg_21_0.is_mission_cleared and arg_21_1.is_map_cleared then
			return false
		end
		
		if arg_21_1.is_mission_cleared and arg_21_0.is_map_cleared then
			return false
		end
		
		if arg_21_0.type and arg_21_1.type then
			return arg_21_0.sort < arg_21_1.sort
		end
		
		return false
	end)
	
	local var_20_25 = load_dlg("item_acquisition_info", true, "wnd")
	
	if_set_visible(var_20_25, "listview", true)
	
	local var_20_26 = var_20_25:getChildByName("listview")
	local var_20_27 = ItemListView:bindControl(var_20_26)
	local var_20_28 = load_control("wnd/item_acquisition_card.csb")
	local var_20_29 = {
		onUpdate = function(arg_22_0, arg_22_1, arg_22_2)
			local var_22_0 = arg_22_2.link_info or {}
			
			if_set(arg_22_1, "txt_place", T(var_22_0.name or "empty_name"))
			
			if var_22_0.icon then
				if_set_sprite(arg_22_1, "icon_grouping", "img/" .. var_22_0.icon .. ".png")
			end
			
			if var_22_0.link then
				if var_22_0.enter_unlock and not var_22_0.is_enterable then
					if_set_opacity(arg_22_1, "n_place", 76.5)
					if_set_visible(arg_22_1, "icon_locked", true)
				end
				
				if arg_22_2.clear_check and arg_22_2.is_map_cleared then
				end
				
				if false then
				end
				
				if arg_22_2.mission_check and arg_22_2.is_mission_cleared then
					if_set_opacity(arg_22_1, "n_place", 76.5)
				end
				
				if arg_22_2.shop_chapter_id and arg_22_2.is_buy_limit then
					if_set_opacity(arg_22_1, "n_place", 76.5)
				end
				
				if var_22_0.system_unlock and not var_22_0.unlock_content then
					if_set_opacity(arg_22_1, "n_place", 76.5)
					if_set_visible(arg_22_1, "icon_locked", true)
				end
				
				if var_22_0.shop_category_id and not var_22_0.is_unlock_chapter_shop then
					if_set_opacity(arg_22_1, "n_place", 76.5)
					if_set_visible(arg_22_1, "icon_locked", true)
				end
				
				if var_22_0.irregular and not var_22_0.irregular_check then
					if_set_opacity(arg_22_1, "n_place", 76.5)
					if_set_visible(arg_22_1, "icon_locked", true)
				end
				
				if false then
				end
				
				local var_22_1 = arg_22_1:getChildByName("btn_move")
				
				if var_22_1 then
					var_22_1.link = var_22_0.link
					var_22_1.system_unlock = var_22_0.system_unlock
					var_22_1.datasource = arg_22_2
				end
			else
				if_set_visible(arg_22_1, "btn_move", false)
			end
			
			arg_22_1.datasource = arg_22_2
		end
	}
	
	var_20_27:setRenderer(var_20_28, var_20_29)
	var_20_27:setItems(var_20_1)
	
	if var_20_2 and not table.empty(var_20_2) then
		if table.count(var_20_2) >= 2 then
			Log.e("use_type_more_than_2", arg_20_2, table.cont(var_20_2))
		end
		
		if var_20_2[1] then
			local var_20_30 = var_20_2[1].link_info
			
			if var_20_30 then
				if_set(var_20_25, "txt_place", T(var_20_30.name))
				if_set_sprite(var_20_25, "icon_ministry", "img/" .. var_20_30.icon .. ".png")
				
				local var_20_31 = var_20_25:getChildByName("btn_go")
				
				if var_20_31 then
					var_20_31.link = var_20_30.link
					var_20_31.system_unlock = var_20_30.system_unlock
				end
			end
		end
	else
		if_set_visible(var_20_25, "n_usage_place", false)
	end
	
	local var_20_32 = 0
	local var_20_33 = Account:isCurrencyType(arg_20_2)
	
	if var_20_33 == nil and (arg_20_2 == "to_paidcrystal" or arg_20_2 == "paidcrystal") then
		var_20_33 = "crystal"
	end
	
	if var_20_33 then
		var_20_32 = Account:getCurrency(var_20_33)
	else
		var_20_32 = Account:getItemCount(arg_20_2)
	end
	
	if_set(var_20_25, "txt_count", T("it_count", {
		count = comma_value(var_20_32)
	}))
	
	local var_20_34 = string.split(arg_20_2, "_")[1]
	local var_20_35
	local var_20_36
	local var_20_37
	
	if var_20_34 == "ma" then
		var_20_35, var_20_36 = DB("item_material", arg_20_2, {
			"desc",
			"desc_use"
		})
		var_20_37 = DB("item_material", arg_20_2, "hide_own") == "y"
	elseif var_20_34 == "sp" then
		var_20_35 = DB("item_special", arg_20_2, "desc")
	elseif var_20_34 == "ct" then
		var_20_35 = DB("item_clantoken", arg_20_2, "desc")
	elseif var_20_34 == "to" then
		var_20_35, var_20_36 = DB("item_token", arg_20_2, {
			"desc",
			"desc_use"
		})
	end
	
	if var_20_36 then
		if_set(var_20_25, "txt_guide", T(var_20_36))
	elseif var_20_35 then
		if_set(var_20_25, "txt_guide", T(var_20_35))
	end
	
	if var_20_37 then
		if_set_visible(var_20_25, "txt_count", false)
	end
	
	local var_20_38 = var_20_25:getChildByName("txt_name")
	local var_20_39 = UIUtil:getRewardIcon(nil, arg_20_2, {
		no_tooltip = true,
		show_name = true,
		is_tooltip_icon = true,
		scale = 1,
		parent = var_20_25:getChildByName("n_item"),
		txt_name = var_20_38,
		txt_type = var_20_25:getChildByName("txt_grade"),
		txt_name_width = var_20_0.txt_name_width or 195,
		txt_scale = var_20_0.txt_scale or 0.91,
		no_resize_name = var_20_0.no_resize_name,
		icon_scale = var_20_0.icon_scale,
		custom = var_20_0.custom,
		category = var_20_0.category
	})
	
	if var_20_38 then
		local var_20_40 = var_20_38:getStringNumLines()
		
		if var_20_40 >= 2 then
			local var_20_41 = var_20_25:getChildByName("n_item_info")
			
			if var_20_41 then
				var_20_41:setPositionY(var_20_41:getPositionY() + 12 * (var_20_40 - 1))
			end
		end
	end
	
	return var_20_25
end

function Material_Tooltip._check_irregular_condition(arg_23_0, arg_23_1)
	if not arg_23_1 then
		return 
	end
	
	if arg_23_1 == "check_clan" then
		return Account:getClanId() or UnlockSystem:isUnlockSystem(UNLOCK_ID.CLAN)
	end
end

function Material_Tooltip.moveToLink(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	if not arg_24_1 then
		return 
	end
	
	if arg_24_3 then
		if arg_24_3.mission_check and arg_24_3.is_mission_cleared then
			balloon_message_with_sound("item_go_mission_clear")
			
			return 
		end
		
		local var_24_0 = arg_24_3.link_info
		
		if var_24_0 and var_24_0.shop_category_id and not var_24_0.is_unlock_chapter_shop then
			if not var_24_0.unlock_desc or not var_24_0.unlock_title then
				Log.e("Err: no unlock desc, unlock title ", var_24_0.id)
			else
				Dialog:msgBox(T(var_24_0.unlock_desc), {
					title = T(var_24_0.unlock_title)
				})
			end
			
			return 
		end
		
		if arg_24_3.shop_chapter_id and arg_24_3.limit_count and arg_24_3.is_buy_limit then
			balloon_message_with_sound("item_go_mission_clear")
			
			return 
		end
	end
	
	local var_24_1 = arg_24_1
	local var_24_2 = arg_24_2
	
	if var_24_2 and not string.find(arg_24_1, "unlock") then
		var_24_1 = var_24_1 .. "&unlock=" .. var_24_2
	end
	
	if arg_24_3 then
		local var_24_3 = arg_24_3.link_info
		
		if var_24_3 and var_24_3.enter_unlock and not var_24_3.is_enterable then
			local var_24_4 = var_24_3.enter_unlock
			local var_24_5 = {}
			
			Account:checkEnterMap(var_24_4, var_24_5)
			
			local var_24_6 = UIUtil:setMsgCheckEnterMapErr(var_24_4, var_24_5)
			
			balloon_message_with_sound_raw_text(var_24_6 or "ui_story_ready_progress_error")
			
			return 
		end
	end
	
	local var_24_7 = WorldMapManager:getNavigator()
	
	if var_24_7 and var_24_7.isOpen and var_24_7.wnd and get_cocos_refid(var_24_7.wnd) then
		var_24_7:backNavi()
	end
	
	local var_24_8 = SceneManager:getRunningPopupScene():getChildByName("item_acquisition_info")
	
	if get_cocos_refid(var_24_8) then
		var_24_8:removeFromParent()
		BackButtonManager:pop("WidgetUtils.showPopup")
	end
	
	if Inventory:isShow() then
		Inventory:close()
	end
	
	if UnitMain:isVisible() and UnitMain:isPopupMode() then
		UnitMain:destroyOnPopupMode()
		BackButtonManager:pop("UnitMain")
	end
	
	if BattleReady:isShow() then
		BattleReady:onButtonClose()
	end
	
	if EpisodeAdinUI:isShow() then
		if UnitZodiac.vars and get_cocos_refid(UnitZodiac.vars.wnd) then
			UnitZodiac:onLeave()
			EpisodeAdinUI:closeCharacterPopUp()
			TopBarNew:pop()
			BackButtonManager:pop()
		end
		
		EpisodeAdinUI:close()
	end
	
	OriginTree:close()
	
	if string.find(var_24_1, "sanctuary") then
		SceneManager:reserveResetSceneFlow()
	end
	
	if SubStoryEntrance:isVisible() then
		SubStoryEntrance:setForceBackLobby(nil)
	end
	
	Dialog:closeAll()
	movetoPath(var_24_1)
end

function Material_Tooltip.isPopupExist(arg_25_0, arg_25_1)
	if not arg_25_1 then
		return 
	end
	
	local var_25_0 = arg_25_1 .. "_" .. "1"
	
	return (DB("item_info", var_25_0, {
		"id"
	}))
end
