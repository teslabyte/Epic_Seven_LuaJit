RelationPipeLine = {}
RelationPipeLine.LINE_FILE_NAME = {
	longing = "img/cm_lineicon_storymap_longing.png",
	locked = "img/cm_lineicon_storymap_off.png",
	love = "img/cm_lineicon_storymap_love.png",
	trust = "img/cm_lineicon_storymap_trust.png",
	grudge = "img/cm_lineicon_storymap_revenge.png",
	rival = "img/cm_lineicon_storymap_rival.png"
}

function RelationPipeLine.start(arg_1_0)
	arg_1_0.pipeline_cache = {}
end

function RelationPipeLine.getCache(arg_2_0, arg_2_1)
	return arg_2_0.pipeline_cache[arg_2_1]
end

function RelationPipeLine.setCache(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0.pipeline_cache[arg_3_1] = arg_3_2
end

function RelationPipeLine.End(arg_4_0)
	arg_4_0.pipeline_cache = nil
end

function RelationPipeLine.makeRelationWnd(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_3 = arg_5_3 or {}
	
	RelationPipeLine:setCache("unit", arg_5_1)
	
	local var_5_0 = arg_5_1.db.code
	
	if arg_5_1:isMoonlightDestinyUnit() then
		var_5_0 = MoonlightDestiny:getRelationCharacterCode(var_5_0)
	elseif is_mer_series(var_5_0) then
		var_5_0 = change_mer_code()
	end
	
	local var_5_1 = DB("character", var_5_0, {
		"face_id"
	})
	local var_5_2 = string.format("re_%s_%d", var_5_0, arg_5_2)
	local var_5_3 = DB("character_relationship_ui", var_5_2, {
		"relation_ui"
	})
	local var_5_4 = load_dlg(var_5_3 or "wnd_story_v10_1", true, "wnd", arg_5_3.back_func)
	local var_5_5 = var_5_4:getChildByName("chara_name")
	
	if var_5_5 then
		var_5_5:enableOutline(cc.c3b(0, 0, 0), 4)
	end
	
	if_set_sprite(var_5_4, "img_face", "face/" .. var_5_1 .. "_s.png")
	if_set(var_5_4, "chara_name", T(arg_5_1.db.name))
	
	if var_5_5 then
		var_5_5:enableOutline(cc.c3b(0, 0, 0), 4)
	end
	
	RelationPipeLine:setCache("current_id", var_5_2)
	
	return var_5_4
end

function RelationPipeLine.setGenerationButton(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	if_set_visible(arg_6_1, "n_gener", true)
	
	local var_6_0, var_6_1 = DB("character_relationship_ui", arg_6_3, {
		"name",
		"desc"
	})
	
	if var_6_0 and var_6_1 then
		if_set(arg_6_1, "txt_generation", T(var_6_0))
		if_set(arg_6_1, "txt_gen_ex", T(var_6_1))
	end
	
	if arg_6_4 == 1 then
		if_set_visible(arg_6_1, "btn_pre", false)
		if_set_visible(arg_6_1, "btn_cur", false)
		if_set_visible(arg_6_1, "n_gener", false)
		
		return 
	end
	
	if arg_6_5 == 1 then
		if_set_visible(arg_6_1, "btn_pre", false)
		if_set_visible(arg_6_1, "btn_cur", true)
	elseif arg_6_5 == arg_6_4 then
		if_set_visible(arg_6_1, "btn_pre", true)
		if_set_visible(arg_6_1, "btn_cur", false)
	else
		if_set_visible(arg_6_1, "btn_pre", true)
		if_set_visible(arg_6_1, "btn_cur", true)
	end
	
	local var_6_2 = arg_6_2.db.code
	
	if arg_6_2:isMoonlightDestinyUnit() then
		var_6_2 = MoonlightDestiny:getRelationCharacterCode(var_6_2)
	elseif is_mer_series(var_6_2) then
		var_6_2 = change_mer_code()
	end
	
	local var_6_3, var_6_4, var_6_5 = DB("character_relationship_ui", string.format("re_%s_%d", var_6_2, arg_6_5 + 1), {
		"id",
		"unlock_enter",
		"unlock_mltheater"
	})
	
	if DEBUG.DEBUG_RELATION_UNLOCK then
		var_6_4 = nil
		var_6_5 = nil
	end
	
	local var_6_6 = var_6_4 ~= nil and not Account:isMapCleared(var_6_4) or var_6_5 ~= nil and not Account:isCleared_mlt_ep(var_6_5)
	
	if var_6_3 ~= nil and var_6_6 then
		if_set_visible(arg_6_1, "btn_cur", false)
	end
end

function RelationPipeLine.addSlotLine(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = 0
	local var_7_1 = 0
	
	repeat
		local var_7_2 = RelationPipeLine.LINE_FILE_NAME[arg_7_2]
		local var_7_3 = cc.Sprite:create(var_7_2)
		
		var_7_3:setAnchorPoint(1, 0.5)
		var_7_3:setRotation(90)
		var_7_3:setPosition(0, var_7_0)
		
		var_7_1 = var_7_3:getContentSize().height
		var_7_0 = var_7_0 + var_7_3:getContentSize().width
		
		arg_7_1:addChild(var_7_3)
	until arg_7_3 < var_7_0
	
	return {
		width = var_7_1,
		height = var_7_0
	}
end

function RelationPipeLine.makeLine(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	if arg_8_2[arg_8_5].slot_type ~= "fix" then
		return 
	end
	
	local var_8_0 = arg_8_2[arg_8_5].relation_type
	
	if arg_8_2[arg_8_5].locked then
		var_8_0 = "locked"
	end
	
	local var_8_1 = arg_8_1:getChildByName("unit_frame_" .. arg_8_3)
	local var_8_2 = arg_8_1:getChildByName("line_" .. arg_8_3)
	
	if not get_cocos_refid(var_8_2) then
		return 
	end
	
	local var_8_3 = var_8_2:getContentSize()
	local var_8_4 = arg_8_1:getChildByName("main_unit_frame")
	local var_8_5 = var_8_4:getChildByName("cm_hero_cirfrm1")
	local var_8_6 = var_8_4:getPositionX() + var_8_5:getContentSize().width * var_8_5:getScaleX() / 2
	local var_8_7 = var_8_4:getPositionY() + var_8_5:getContentSize().height * var_8_5:getScaleY() / 2
	local var_8_8, var_8_9 = var_8_1:getPosition()
	local var_8_10 = cc.Node:create()
	local var_8_11 = var_8_3.height * var_8_2:getScaleY()
	local var_8_12 = RelationPipeLine:addSlotLine(var_8_10, var_8_0, var_8_11)
	local var_8_13 = math.atan2(var_8_7 - var_8_9, var_8_8 - var_8_6) * 180 / math.pi + 90
	
	var_8_10:setRotation(var_8_13)
	var_8_10:setPosition(var_8_6, var_8_7)
	var_8_10:setLocalZOrder(-1)
	var_8_10:setName(arg_8_4 or "new_line_" .. arg_8_3)
	
	return var_8_10, var_8_12
end

function RelationPipeLine.checkSameSlot(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = 1
	
	for iter_9_0 = var_9_0, arg_9_3 do
		local var_9_1 = string.format("%s_%d", arg_9_2, var_9_0)
		local var_9_2, var_9_3, var_9_4, var_9_5, var_9_6, var_9_7, var_9_8, var_9_9, var_9_10 = DB("character_relationship", var_9_1, {
			"relation_id",
			"slot_number",
			"relation_count",
			"slot_type",
			"relation_type",
			"relation_function",
			"relation_text",
			"unlock_enter",
			"unlock_mltheater"
		})
		
		if DEBUG.DEBUG_RELATION_UNLOCK then
			var_9_9 = nil
			var_9_10 = nil
		end
		
		if var_9_2 == nil then
			var_9_0 = var_9_0 - 1
			
			break
		end
		
		local var_9_11 = false
		
		if var_9_9 and not Account:isMapCleared(var_9_9) then
			var_9_11 = true
		elseif var_9_10 and not Account:isCleared_mlt_ep(var_9_10) then
			var_9_11 = true
		end
		
		if is_mer_series(var_9_7) then
			var_9_7 = change_mer_code()
		end
		
		arg_9_1[var_9_1] = {
			slot_number = var_9_3,
			relation_count = var_9_4,
			slot_type = var_9_5,
			relation_type = var_9_6,
			relation_function = var_9_7,
			relation_text = var_9_8,
			unlock_enter = var_9_9,
			unlock_mltheater = var_9_10,
			locked = var_9_11
		}
		var_9_0 = var_9_0 + 1
	end
	
	for iter_9_1 = var_9_0, 0, -1 do
		if arg_9_1[string.format("%s_%d", arg_9_2, iter_9_1)] and arg_9_1[string.format("%s_%d", arg_9_2, iter_9_1)].locked then
			var_9_0 = var_9_0 - 1
		end
	end
	
	if var_9_0 <= 0 then
		return string.format("%s", arg_9_2)
	else
		return string.format("%s_%d", arg_9_2, var_9_0)
	end
end

function RelationPipeLine.setRelations(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6, arg_10_7)
	local var_10_0, var_10_1 = DB("character", arg_10_3, {
		"name",
		"face_id"
	})
	
	if var_10_1 == nil then
		Log.e("잘못된 데이터(character_relationship.db)", "character_id값 : ", arg_10_3, "face_id값", var_10_1)
		
		var_10_1 = "c1007"
	end
	
	if arg_10_4 == "locked" then
		var_10_1 = "m0000"
	end
	
	if_set_sprite(arg_10_1, "img_face", "face/" .. var_10_1 .. "_s.png")
	if_set(arg_10_1, "chara_name", T(var_10_0))
	
	local var_10_2 = arg_10_1:getChildByName("chara_name")
	
	if var_10_2 then
		var_10_2:enableOutline(cc.c3b(0, 0, 0), 4)
	end
	
	arg_10_6 = tonumber(arg_10_6)
	
	local var_10_3 = arg_10_1:getChildByName("bg_charaface")
	
	if get_cocos_refid(var_10_3) then
		local var_10_4 = var_10_3:getContentSize()
		local var_10_5 = ccui.Button:create()
		
		var_10_5:setTouchEnabled(true)
		var_10_5:ignoreContentAdaptWithSize(false)
		var_10_5:setContentSize(var_10_4.width, var_10_4.height)
		var_10_5:addTouchEventListener(arg_10_2)
		var_10_5:setName("btn_slot_" .. arg_10_7)
		arg_10_1:getParent():addChild(var_10_5)
	end
	
	local var_10_6 = false
	
	if_set_visible(arg_10_1, "cm_cool_hero_1", true)
	if_set_visible(arg_10_1, "txt_name_0", true)
	
	if arg_10_5 == "fix" then
		local var_10_7, var_10_8 = UIUtil:getRelationColorIcon(arg_10_4)
		
		if_set_sprite(arg_10_1, "icon_longing", var_10_8)
		if_set_color(arg_10_1, "cm_hero_cirfrm_lock", var_10_7)
		if_set_color(arg_10_1, "t_relation", var_10_7)
		if_set(arg_10_1, "t_relation", T("rb_fix_" .. arg_10_4 .. "_tl"))
	else
		if_set_visible(arg_10_1, "img_face", false)
		if_set_visible(arg_10_1, "icon_longing", false)
		if_set_color(arg_10_1, "cm_hero_cirfrm_lock", cc.c3b(176, 176, 176))
		
		if not var_10_6 then
			arg_10_1:setScale(arg_10_1:getScale() * 0.7)
		end
	end
end

function RelationPipeLine.generateRelationMap(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = RelationPipeLine:getCache("current_id")
	local var_11_1 = RelationPipeLine:getCache("unit")
	local var_11_2 = {}
	local var_11_3 = var_11_1.db.code
	
	if var_11_1:isMoonlightDestinyUnit() then
		var_11_3 = MoonlightDestiny:getRelationCharacterCode(var_11_3)
	elseif is_mer_series(var_11_3) then
		var_11_3 = change_mer_code()
	end
	
	for iter_11_0 = 1, 16 do
		local var_11_4 = string.format("chre_%s_%d", var_11_3, iter_11_0)
		local var_11_5, var_11_6, var_11_7, var_11_8, var_11_9, var_11_10, var_11_11, var_11_12, var_11_13 = DB("character_relationship", var_11_4, {
			"relation_id",
			"slot_number",
			"relation_count",
			"slot_type",
			"relation_type",
			"relation_function",
			"relation_text",
			"unlock_enter",
			"unlock_mltheater"
		})
		
		if DEBUG.DEBUG_RELATION_UNLOCK then
			var_11_12 = nil
			var_11_13 = nil
		end
		
		if is_mer_series(var_11_10) then
			var_11_10 = change_mer_code()
		end
		
		local var_11_14 = false
		
		if AccountData.dictionary_hide then
			local var_11_15 = os.time()
			local var_11_16 = AccountData.dictionary_hide[var_11_10]
			
			if var_11_16 and var_11_16.start_time <= os.time() and var_11_16.end_time >= os.time() then
				var_11_14 = true
			end
		end
		
		if var_11_14 and var_11_6 then
			local var_11_17 = arg_11_1:getChildByName("line_" .. var_11_6)
			
			if var_11_17 then
				var_11_17:setVisible(false)
			end
		end
		
		if var_11_6 and var_11_5 == var_11_0 and not var_11_14 then
			if not (function(arg_12_0)
				local var_12_0 = {
					"trust",
					"love",
					"rival",
					"longing",
					"grudge"
				}
				local var_12_1 = false
				
				for iter_12_0, iter_12_1 in pairs(var_12_0) do
					if iter_12_1 == arg_12_0 then
						var_12_1 = true
					end
				end
				
				return var_12_1
			end)(var_11_9) then
				return 
			end
			
			local var_11_18 = arg_11_1:getChildByName("unit_frame_" .. var_11_6)
			local var_11_19 = arg_11_1:getChildByName("line_" .. var_11_6)
			local var_11_20 = false
			
			if var_11_12 and not Account:isMapCleared(var_11_12) then
				var_11_20 = true
			elseif var_11_13 and not Account:isCleared_mlt_ep(var_11_13) then
				var_11_20 = true
			end
			
			local var_11_21 = {
				slot_number = var_11_6,
				relation_count = var_11_7,
				slot_type = var_11_8,
				relation_type = var_11_9,
				relation_function = var_11_10,
				relation_text = var_11_11,
				unlock_enter = var_11_12,
				unlock_mltheater = var_11_13,
				locked = var_11_20
			}
			
			var_11_2[var_11_4] = var_11_21
			
			if var_11_7 >= 2 then
				var_11_4 = RelationPipeLine:checkSameSlot(var_11_2, var_11_4, var_11_7)
				var_11_21 = var_11_2[var_11_4]
				var_11_10 = var_11_2[var_11_4].relation_function
			end
			
			local var_11_22 = RelationPipeLine:makeLine(arg_11_1, var_11_2, var_11_6, nil, var_11_4)
			
			if get_cocos_refid(var_11_22) then
				arg_11_1:addChild(var_11_22)
				var_11_19:setVisible(false)
			end
			
			if var_11_18 then
				local var_11_23 = cc.CSLoader:createNode("wnd/wnd_story_target.csb")
				
				var_11_23:setAnchorPoint(0.5, 0.5)
				var_11_23:setName("target_ui_" .. var_11_4)
				var_11_18:addChild(var_11_23)
				if_set_visible(var_11_23, "icon_locked", false)
				
				if var_11_10 then
					if var_11_20 then
						RelationPipeLine:setRelations(var_11_23, arg_11_2, var_11_10, "locked", var_11_8, var_11_6, var_11_4)
					else
						RelationPipeLine:setRelations(var_11_23, arg_11_2, var_11_10, var_11_21.relation_type, var_11_8, var_11_6, var_11_4)
					end
				else
					var_11_18:setVisible(false)
					var_11_19:setVisible(false)
				end
				
				if var_11_20 then
					if_set_visible(var_11_23, "n_tag", false)
				end
			else
				if_set_visible(arg_11_1, "line_" .. var_11_6, false)
			end
		end
	end
	
	RelationPipeLine:setCache("slot_info", var_11_2)
end

function RelationPipeLine.getSimpleFace(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = cc.CSLoader:createNode("wnd/wnd_story_target.csb")
	
	var_13_0:setAnchorPoint(0.5, 0.5)
	
	local var_13_1, var_13_2 = DB("character", arg_13_1, {
		"name",
		"face_id"
	})
	
	if var_13_2 == nil then
		Log.e("잘못된 데이터(character_relationship.db)", "character_id값 : ", arg_13_1, "face_id값", var_13_2)
		
		var_13_2 = "c1007"
	end
	
	if_set_sprite(var_13_0, "img_face", "face/" .. var_13_2 .. "_s.png")
	if_set(var_13_0, "chara_name", T(var_13_1))
	
	if arg_13_2 then
		local var_13_3, var_13_4 = UIUtil:getRelationColorIcon(arg_13_2)
		
		if_set_sprite(var_13_0, "icon_longing", var_13_4)
		if_set_color(var_13_0, "cm_hero_cirfrm_lock", var_13_3)
	else
		if_set_visible(var_13_0, "icon_longing", false)
	end
	
	if_set_visible(var_13_0, "cm_cool_hero_1", false)
	if_set_visible(var_13_0, "icon_locked", false)
	if_set_visible(var_13_0, "txt_name_0", false)
	
	return var_13_0
end

function RelationPipeLine.getGeneration(arg_14_0, arg_14_1)
	local var_14_0 = 1
	local var_14_1 = 1
	
	for iter_14_0 = 2, 10 do
		local var_14_2, var_14_3, var_14_4 = DB("character_relationship_ui", string.format("re_%s_%d", arg_14_1, iter_14_0), {
			"id",
			"unlock_enter",
			"unlock_mltheater"
		})
		
		if var_14_2 == nil then
			break
		end
		
		if DEBUG.DEBUG_RELATION_UNLOCK then
			var_14_3 = nil
			var_14_4 = nil
		end
		
		var_14_1 = var_14_1 + 1
		
		if var_14_3 and var_14_4 then
			Log.e("invalid unlock condition", var_14_2)
			
			break
		end
		
		if (var_14_3 == nil or Account:isMapCleared(var_14_3)) and (var_14_4 == nil or Account:isCleared_mlt_ep(var_14_4)) then
			var_14_0 = var_14_1
		end
	end
	
	return var_14_1, var_14_0
end

function RelationPipeLine.showDetailPopup(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, arg_15_6, arg_15_7)
	if not arg_15_3 or not arg_15_5 then
		return 
	end
	
	local var_15_0 = false
	local var_15_1 = SceneManager:getRunningPopupScene()
	local var_15_2 = var_15_1:getChildByName("hero_story_fix_detail")
	
	if var_15_2 and get_cocos_refid(var_15_2) then
		var_15_2:removeFromParent()
		
		var_15_0 = true
	end
	
	local var_15_3 = load_dlg("hero_story_fix_detail", true, "wnd")
	
	if_set_visible(var_15_3, "btn_next", false)
	if_set_visible(var_15_3, "btn_pre", false)
	if_set_visible(var_15_3, "btn_move2", true)
	
	if arg_15_3.relation_count >= 2 then
		local var_15_4 = string.split(arg_15_5, "_")
		local var_15_5 = arg_15_5
		
		if not arg_15_6 then
			for iter_15_0 = 1, arg_15_3.relation_count do
				local var_15_6 = string.format("%s_%s_%d_%d", var_15_4[1], var_15_4[2], var_15_4[3], iter_15_0)
				
				if arg_15_1[var_15_6] and arg_15_1[var_15_6].locked == false then
					var_15_5 = var_15_6
					arg_15_3 = arg_15_1[var_15_5]
				end
			end
		end
		
		local var_15_7 = string.split(var_15_5, "_")
		
		if #var_15_7 < 4 then
			local var_15_8 = string.format("%s_%s_%d_%d", var_15_7[1], var_15_7[2], var_15_7[3], "1")
			
			if arg_15_1[var_15_8] then
				var_15_3:getChildByName("btn_next").code = var_15_8
				
				if_set_visible(var_15_3, "btn_pre", false)
				
				if not arg_15_1[var_15_8].locked then
					if_set_visible(var_15_3, "btn_next", true)
				end
			end
		else
			if_set_visible(var_15_3, "btn_pre", true)
			
			if tonumber(var_15_7[4]) == 1 then
				var_15_3:getChildByName("btn_pre").code = string.format("%s_%s_%d", var_15_7[1], var_15_7[2], var_15_7[3])
			else
				var_15_3:getChildByName("btn_pre").code = string.format("%s_%s_%d_%d", var_15_7[1], var_15_7[2], var_15_7[3], tonumber(var_15_7[4] - 1))
			end
			
			if_set_visible(var_15_3, "btn_next", false)
			
			local var_15_9 = tonumber(var_15_7[4]) + 1
			local var_15_10 = string.format("%s_%s_%d_%d", var_15_7[1], var_15_7[2], var_15_7[3], var_15_9)
			
			if arg_15_1[var_15_10] and get_cocos_refid(var_15_3) then
				local var_15_11 = var_15_3:getChildByName("btn_next")
				
				if get_cocos_refid(var_15_11) then
					var_15_11.code = var_15_10
					
					if not arg_15_1[var_15_10].locked then
						if_set_visible(var_15_3, "btn_next", true)
					end
				end
			end
		end
	end
	
	local function var_15_12()
		BackButtonManager:pop("hero_story_fix_detail")
		
		if get_cocos_refid(var_15_3) then
			var_15_3:removeFromParent()
		end
	end
	
	BackButtonManager:push({
		check_id = "hero_story_fix_detail",
		back_func = var_15_12
	})
	var_15_1:addChild(var_15_3)
	
	local var_15_13 = arg_15_3.relation_function
	local var_15_14 = arg_15_3.relation_type
	local var_15_15 = ccui.Button:create()
	
	var_15_15:setTouchEnabled(true)
	var_15_15:ignoreContentAdaptWithSize(false)
	var_15_15:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	var_15_15:setPosition(VIEW_BASE_LEFT, 0)
	var_15_15:setAnchorPoint(0, 0)
	var_15_15:setLocalZOrder(-1)
	var_15_15:addTouchEventListener(function(arg_17_0, arg_17_1)
		if arg_17_1 ~= 2 then
			return 
		end
		
		var_15_12()
	end)
	var_15_15:setName("btn_close")
	var_15_3:addChild(var_15_15)
	
	local var_15_16 = RelationPipeLine:getSimpleFace(var_15_13, var_15_14)
	local var_15_17 = DB("character", var_15_13, "name")
	
	if_set(var_15_3, "chara_name", T(var_15_17))
	
	local var_15_18, var_15_19 = UIUtil:getRelationColorIcon(var_15_14)
	
	if_set_visible(var_15_16, "chara_name", false)
	if_set_visible(var_15_16, "icon_longing", false)
	if_set_visible(var_15_16, "t_relation", false)
	if_set(var_15_3, "t_relation", T("rb_fix_" .. var_15_14 .. "_tl"))
	if_set_color(var_15_3, "t_relation", var_15_18)
	if_set_sprite(var_15_3, "icon_longing", var_15_19)
	var_15_16:setScale(var_15_16:getScale() * 0.7)
	if_set_visible(var_15_16, "icon_locked", not arg_15_4)
	
	if not arg_15_4 then
		local var_15_20 = arg_15_2[arg_15_3.slot_number]
		
		if var_15_20 then
			local var_15_21 = string.split(var_15_20, "_")
			
			if_set(var_15_3, "deactive_desc", T("cha_story_episode_long", {
				num = var_15_21[3]
			}))
		else
			if_set_visible(var_15_3, "active", true)
			if_set_visible(var_15_3, "deactive", false)
		end
	end
	
	var_15_3:getChildByName("face_node"):addChild(var_15_16)
	if_set(var_15_3, "active_desc", T(arg_15_3.relation_text or ""))
	
	local var_15_22 = var_15_3:getChildByName("LEFT")
	
	if var_15_0 == false then
		var_15_22:setPositionX(-400)
		UIAction:Add(LOG(MOVE_TO(250, VIEW_BASE_LEFT)), var_15_22, "block")
	else
		var_15_22:setPositionX(VIEW_BASE_LEFT)
	end
	
	local var_15_23 = var_15_3:getChildByName("btn_move2")
	
	var_15_23.code = var_15_13
	
	if arg_15_7 then
		if_set_opacity(var_15_23, nil, 127.5)
	end
	
	SoundEngine:play("event:/ui/popup/tap")
end
