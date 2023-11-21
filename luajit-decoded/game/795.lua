RumbleSynergyPopup = {}

function HANDLER.rumble_synergy_detail(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_close" then
		RumbleSynergyPopup:close()
	end
end

function RumbleSynergyPopup.open(arg_2_0, arg_2_1)
	if arg_2_0.vars and get_cocos_refid(arg_2_0.vars.wnd) then
		return 
	end
	
	arg_2_1 = arg_2_1 or {}
	
	local var_2_0 = arg_2_1.layer or SceneManager:getRunningPopupScene()
	
	if not get_cocos_refid(var_2_0) then
		return 
	end
	
	arg_2_0.vars = {}
	arg_2_0.vars.wnd = load_dlg("rumble_synergy_detail", true, "wnd", function()
		arg_2_0:close()
	end)
	
	arg_2_0:setUnitList(arg_2_1.id)
	arg_2_0:setInfo(arg_2_1.id)
	
	if arg_2_1.no_dim then
		arg_2_0:setDimVisible(false)
	end
	
	var_2_0:addChild(arg_2_0.vars.wnd)
end

function RumbleSynergyPopup.setInfo(arg_4_0, arg_4_1)
	if not arg_4_0.vars or not get_cocos_refid(arg_4_0.vars.wnd) then
		return 
	end
	
	local var_4_0 = arg_4_0.vars.wnd:getChildByName("n_frame")
	
	if not get_cocos_refid(var_4_0) then
		return 
	end
	
	local var_4_1, var_4_2, var_4_3, var_4_4 = DB("rumble_synergy", arg_4_1, {
		"name",
		"icon",
		"desc",
		"need_desc"
	})
	local var_4_5 = RumbleSynergy:getSynergyLevel(arg_4_1)
	
	if_set(var_4_0, "txt_title", T(var_4_1))
	if_set_sprite(var_4_0, "n_icon", var_4_2)
	if_set_visible(var_4_0, "txt_disc_2", false)
	
	local var_4_6 = "<#765e40>" .. T(var_4_3) .. "</>\n"
	
	for iter_4_0 = 1, 4 do
		local var_4_7 = DB("rumble_synergy", arg_4_1, "sk_desc_" .. iter_4_0)
		
		if not var_4_7 then
			break
		end
		
		if iter_4_0 == var_4_5 then
			var_4_6 = var_4_6 .. "\n<#ffffff>" .. T(var_4_7) .. "</>"
		else
			var_4_6 = var_4_6 .. "\n<#888888>" .. T(var_4_7) .. "</>"
		end
	end
	
	local var_4_8
	local var_4_9 = var_4_4 and "txt_disc_1" or "txt_disc_2"
	
	upgradeLabelToRichLabel(var_4_0, var_4_9, true)
	if_set(var_4_0, var_4_9, var_4_6)
	if_set_visible(var_4_0, var_4_9, true)
	
	local function var_4_10(arg_5_0, arg_5_1)
		if get_cocos_refid(arg_5_0) then
			local var_5_0 = arg_5_0:getContentSize()
			
			var_5_0.height = arg_5_1
			
			arg_5_0:setContentSize(var_5_0)
		end
	end
	
	local var_4_12, var_4_17, var_4_18
	
	if var_4_4 then
		local var_4_11 = var_4_0:getChildByName("scroll_info")
		
		if get_cocos_refid(var_4_11) then
			var_4_12 = load_control("wnd/rumble_synergy_grid.csb")
			
			var_4_11:addChild(var_4_12)
			
			local var_4_13 = load_control("wnd/rumble_synergy_item.csb")
			
			var_4_13:setAnchorPoint(0, 1)
			var_4_12:getChildByName("n_item1"):addChild(var_4_13)
			
			local var_4_14 = var_4_13:getChildByName("n_info")
			
			if_set(var_4_14, "txt", T(var_4_4))
			if_set_visible(var_4_14, nil, true)
			if_set_visible(var_4_13, "n_skill", false)
			
			local var_4_15 = var_4_14:getChildByName("txt")
			local var_4_16 = var_4_15:getStringNumLines() * 26
			
			var_4_10(var_4_15, var_4_16)
			
			var_4_17 = 2
			var_4_18 = (var_4_16 - 26) * var_4_15:getScale()
			
			for iter_4_1, iter_4_2 in pairs(arg_4_0.vars.units) do
				local var_4_19 = DB("rumble_character", iter_4_2, "skill3")
				
				if var_4_19 then
					local var_4_20, var_4_21 = DB("rumble_skill", var_4_19, {
						"name",
						"desc"
					})
					local var_4_22 = load_control("wnd/rumble_synergy_item.csb")
					
					var_4_22:setAnchorPoint(0, 1)
					var_4_22:setPositionY(-var_4_18)
					var_4_12:getChildByName("n_item" .. var_4_17):addChild(var_4_22)
					
					local var_4_23 = var_4_22:getChildByName("n_skill")
					
					if_set(var_4_23, "txt_name", T(var_4_20))
					if_set(var_4_23, "txt", T(var_4_21))
					
					local var_4_24 = var_4_23:getChildByName("txt")
					local var_4_25 = var_4_24:getStringNumLines() * 26
					
					var_4_10(var_4_24, var_4_25)
					
					local var_4_26 = RumbleUtil:getSkillIcon(var_4_19)
					
					if get_cocos_refid(var_4_26) then
						var_4_22:getChildByName("n_skill_icon"):addChild(var_4_26)
					end
					
					var_4_18 = var_4_18 + (var_4_25 - 26) * var_4_24:getScale()
					var_4_17 = var_4_17 + 1
					
					if var_4_17 > 6 then
						break
					end
				end
			end
		end
	end
	
	if_set_visible(var_4_0, "n_skill_info", var_4_4)
end

function RumbleSynergyPopup.setUnitList(arg_6_0, arg_6_1)
	if not arg_6_0.vars or not get_cocos_refid(arg_6_0.vars.wnd) then
		return 
	end
	
	local var_6_0 = arg_6_0.vars.wnd:getChildByName("n_hero")
	
	if not get_cocos_refid(var_6_0) then
		return 
	end
	
	local var_6_1 = DB("rumble_synergy", arg_6_1, "type")
	local var_6_2 = {}
	
	if var_6_1 then
		var_6_2[var_6_1] = arg_6_1
	end
	
	arg_6_0.vars.units = RumbleUtil:getUnitList(var_6_2)
	
	local var_6_3 = 1
	
	for iter_6_0, iter_6_1 in pairs(arg_6_0.vars.units) do
		local var_6_4 = var_6_0:getChildByName("n_" .. var_6_3)
		
		if not get_cocos_refid(var_6_4) then
			break
		end
		
		if RumbleSystem:isValid() and not RumblePlayer:getTeamUnit(iter_6_1) then
			var_6_4:setCascadeColorEnabled(true)
			var_6_4:setColor(cc.c3b(91, 91, 91))
		end
		
		local var_6_5 = RumbleUtil:getHeroIcon(iter_6_1, {
			popup = true,
			no_star = true
		})
		
		if get_cocos_refid(var_6_5) then
			var_6_4:getChildByName("n_mob_icon"):addChild(var_6_5)
			
			var_6_3 = var_6_3 + 1
			
			if var_6_3 > 7 then
				break
			end
		end
		
		local var_6_6 = DB("rumble_character", iter_6_1, "skill3")
		
		if var_6_6 then
			local var_6_7 = var_6_4:getChildByName("n_skll")
			
			if get_cocos_refid(var_6_7) then
				local var_6_8 = RumbleUtil:getSkillIcon(var_6_6)
				
				if get_cocos_refid(var_6_8) then
					var_6_7:addChild(var_6_8)
				end
				
				var_6_7:setVisible(true)
			end
		end
	end
end

function RumbleSynergyPopup.setDimVisible(arg_7_0, arg_7_1)
	if not arg_7_0.vars or not get_cocos_refid(arg_7_0.vars.wnd) then
		return 
	end
	
	if_set_visible(arg_7_0.vars.wnd, "n_base", arg_7_1)
end

function RumbleSynergyPopup.close(arg_8_0)
	if not arg_8_0.vars or not get_cocos_refid(arg_8_0.vars.wnd) then
		return 
	end
	
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_8_0.vars.wnd, "block")
	BackButtonManager:pop("rumble_synergy_detail")
	
	arg_8_0.vars = nil
end
