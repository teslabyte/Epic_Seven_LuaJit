Substory_ArtBouns = {}

function Substory_ArtBouns.open(arg_1_0)
	local var_1_0 = load_control("wnd/dungeon_story_bonus.csb")
	
	arg_1_0:update(var_1_0)
	WidgetUtils:showPopup({
		popup = var_1_0
	})
end

function Substory_ArtBouns.update(arg_2_0, arg_2_1)
	local var_2_0 = SubstoryManager:getInfo()
	
	local function var_2_1(arg_3_0)
		local function var_3_0(arg_4_0)
			return DB("item_material", arg_4_0, "name") or DB("item_token", arg_4_0, "name")
		end
		
		if type(arg_3_0) == "string" then
			local var_3_1 = var_3_0(arg_3_0)
			
			return var_3_1 and T(var_3_1) or ""
		elseif type(arg_3_0) == "table" then
			local var_3_2 = ""
			
			for iter_3_0, iter_3_1 in pairs(arg_3_0) do
				local var_3_3 = var_3_0(iter_3_1)
				
				if var_3_3 then
					if string.len(var_3_2) > 0 then
						var_3_2 = var_3_2 .. ", "
					end
					
					var_3_2 = var_3_2 .. T(var_3_3)
				end
			end
			
			return var_3_2
		end
		
		return ""
	end
	
	local var_2_2 = {
		cc.c3b(134, 81, 231),
		cc.c3b(20, 151, 211),
		cc.c3b(248, 194, 0),
		cc.c3b(107, 193, 27)
	}
	
	for iter_2_0 = 1, 4 do
		local var_2_3 = arg_2_1:getChildByName(tostring(iter_2_0))
		
		if get_cocos_refid(var_2_3) then
			local var_2_4 = var_2_3:getChildByName("n_artifact_bonus_item")
			local var_2_5 = var_2_0["bonus_artifact" .. iter_2_0] or ""
			local var_2_6 = totable(var_2_5)
			local var_2_7 = (var_2_6 and var_2_6.artifact) ~= nil
			
			if not var_2_0.bonus_artifact_unkown_icon then
				local var_2_8 = "icon_unkown_art1"
			end
			
			local var_2_9 = var_2_0.bonus_artifact_open_schedule or nil
			local var_2_13
			
			if var_2_7 then
				local var_2_10 = {
					disable_slv = true,
					job_icon_offset_y = -22
				}
				local var_2_11 = EQUIP:createByInfo({
					code = var_2_6.artifact
				})
				local var_2_12
				
				var_2_13 = load_control("wnd/artifact_bonus_item.csb")
				
				local var_2_14 = var_2_13:getChildByName("n_arti")
				
				var_2_10.arti_unkown_icon = var_2_0.bonus_artifact_unknown_icon or "icon_unknown_art1"
				var_2_10.arti_unkown_thumbnail = var_2_0.bonus_artifact_unknown_thunbnail or "unknown_art1_l"
				
				if var_2_11 ~= nil and (not var_2_9 or SubstoryManager:isArtiOpen(var_2_9, var_2_6.artifact)) then
					var_2_12 = UIUtil:updateEquipBar(nil, var_2_11, var_2_10)
				else
					var_2_12 = UIUtil:updateUnkownArtifactBar(var_2_11, var_2_10)
				end
				
				var_2_14:addChild(var_2_12)
				var_2_4:addChild(var_2_13)
				
				local var_2_16
				
				if type(var_2_6.token) == "string" then
					local var_2_15 = var_2_3:getChildByName("reward_item1")
					
					UIUtil:getRewardIcon(nil, var_2_6.token, {
						no_count = true,
						parent = var_2_15
					})
				else
					var_2_16 = var_2_6.token
					
					for iter_2_1 = 1, 2 do
						if var_2_16[iter_2_1] then
							local var_2_17 = var_2_3:getChildByName("reward_item" .. iter_2_1)
							
							UIUtil:getRewardIcon(nil, var_2_16[iter_2_1], {
								no_count = true,
								parent = var_2_17
							})
						end
					end
				end
				
				for iter_2_2 = 1, 4 do
					local var_2_18 = var_2_13:getChildByName("lv_" .. iter_2_2)
					
					if_set(var_2_18, "t_value", string.format("+%d%%", (var_2_6["arti" .. iter_2_2] or 0) * 100))
					if_set_color(var_2_18, "t_value", var_2_2[iter_2_2])
				end
			end
			
			var_2_3:setVisible(var_2_7)
		end
	end
end
