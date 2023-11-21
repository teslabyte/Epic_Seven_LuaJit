UnitStory = {}

function HANDLER.hero_story(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_cur" then
		UnitStory:select_generation(UnitStory.vars.current_generation, "next")
	elseif arg_1_1 == "btn_pre" then
		UnitStory:select_generation(UnitStory.vars.current_generation, "pre")
	end
end

function HANDLER.hero_story_go(arg_2_0, arg_2_1)
	if arg_2_1 == "btn_go" then
		UnitStory:playStory()
		UnitStory:hidePopup()
	elseif arg_2_1 == "btn_cancel" then
		UnitStory:hidePopup()
	end
end

function HANDLER.hero_story_fix_detail(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0.code
	
	if arg_3_1 == "btn_move2" and var_3_0 then
		if UnitMain:isPvpMode() then
			balloon_message_with_sound("cant_pvp_mode")
			
			return 
		end
		
		if CollectionNewHero:isStoryVailed() then
			local var_3_1 = "re_" .. var_3_0 .. "_1"
			local var_3_2 = DB("character_relationship_ui", var_3_1, {
				"id"
			})
			
			if string.find(arg_3_0.code, "npc") then
				balloon_message_with_sound("msg_relation_npc")
				
				return 
			end
			
			if not var_3_2 then
				balloon_message_with_sound("no_story")
				
				return 
			end
			
			CollectionNewHero:heroChangeInStory(var_3_0, true)
		else
			local var_3_3
			local var_3_4
			
			for iter_3_0, iter_3_1 in pairs(Account:getUnits()) do
				if var_3_0 == iter_3_1.db.code then
					local var_3_5 = iter_3_1:getZodiacGrade()
					
					if not var_3_4 or var_3_4 < var_3_5 then
						var_3_4 = var_3_5
						var_3_3 = iter_3_1
					end
				end
			end
			
			if var_3_3 then
				if SceneManager:getCurrentSceneName() ~= "unit_ui" then
					balloon_message_with_sound("error_not_now")
					
					return 
				end
				
				if not var_3_3:check_relationUI() then
					balloon_message_with_sound("no_story")
					
					return 
				end
				
				UnitDetailStory:heroChangeInStory(var_3_3)
			else
				local var_3_6 = "re_" .. arg_3_0.code .. "_1"
				local var_3_7 = DB("character_relationship_ui", var_3_6, {
					"id"
				})
				
				if string.find(arg_3_0.code, "npc") or var_3_7 == nil then
					balloon_message_with_sound("msg_relation_npc")
					
					return 
				end
				
				Dialog:msgBox(T("msg_relation_no_hero"), {
					yesno = true,
					handler = function(arg_4_0)
						if not Account:checkQueryEmptyDungeonData("collection.unitstory", {
							code = var_3_0
						}) then
							CollectionController:open_unitStory(var_3_0)
						end
					end
				})
			end
		end
	end
	
	if arg_3_1 == "btn_pre" then
		UnitStory:changeDetailPopup_Info(arg_3_0.code, "pre")
	elseif arg_3_1 == "btn_next" then
		UnitStory:changeDetailPopup_Info(arg_3_0.code, "next")
	end
end

function HANDLER.hero_story_clear(arg_5_0, arg_5_1)
	if arg_5_1 == "btn_ok" then
		getParentWindow(arg_5_0):removeFromParent()
	end
end

function UnitStory.onPushBackButton(arg_6_0)
	UnitMain:setMode("Detail", {
		unit = arg_6_0.vars.unit
	})
end

function UnitStory.onPushBackground(arg_7_0)
end

function UnitStory.create(arg_8_0)
	arg_8_0.vars = {}
	arg_8_0.vars.released_slot = {}
	arg_8_0.vars.slot_req_story = {}
	arg_8_0.vars.wnd = load_dlg("hero_story", true, "wnd")
	
	UnitMain.vars.base_wnd:addChild(arg_8_0.vars.wnd)
	
	return arg_8_0
end

function UnitStory.onEnter(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0:create()
	arg_9_0.vars.wnd:setLocalZOrder(1)
	
	local var_9_0 = HeroBelt:getInst("UnitMain")
	local var_9_1 = arg_9_2 and arg_9_2.unit or var_9_0:getCurrentItem()
	
	arg_9_0.vars.unit = var_9_1
	
	if CollectionNewHero.vars and CollectionNewHero.vars.mode then
		CollectionNewHero.vars.mode = "DETAIL"
	end
	
	TopBarNew:setTitleName(T(var_9_1.db.name))
	TopBarNew:forcedHelp_OnOff(false)
	
	for iter_9_0 = 1, 6 do
		SpriteCache:resetSprite(arg_9_0.vars.wnd:getChildByName("star" .. iter_9_0), "img/cm_icon_star.png")
	end
	
	UIUtil:setUnitAllInfo(arg_9_0.vars.wnd, var_9_1)
	
	local var_9_2 = var_9_1:getZodiacGrade()
	
	arg_9_0.vars.zodiac_grade = var_9_2
	arg_9_0.vars.totla_generation, arg_9_0.vars.current_generation = RelationPipeLine:getGeneration(var_9_1.db.code)
	
	var_9_0:scrollToUnit(var_9_1)
	arg_9_0:updateUnitInfo(var_9_1)
	arg_9_0:makeUnitRelation(var_9_1)
	SoundEngine:play("event:/ui/hero_story")
	
	if not arg_9_2.skip_ani then
		if_set_opacity(arg_9_0.vars.wnd, "LEFT", 0)
		if_set_opacity(arg_9_0.vars.wnd, "RIGHT", 0)
		if_set_opacity(arg_9_0.vars.wnd, "pivot", 0)
		UIAction:Add(SEQ(SLIDE_IN(200, 600)), arg_9_0.vars.wnd:getChildByName("LEFT"), "block")
		UIAction:Add(SEQ(SLIDE_IN_Y(200, 600)), arg_9_0.vars.wnd:getChildByName("pivot"), "block")
		UIAction:Add(SEQ(SLIDE_IN(200, -600)), arg_9_0.vars.wnd:getChildByName("RIGHT"), "block")
		
		for iter_9_1, iter_9_2 in pairs(arg_9_0.vars.wnd:getChildByName("pivot"):getChildren()) do
			for iter_9_3, iter_9_4 in pairs(iter_9_2:getChildren()) do
				if string.starts(iter_9_4:getName(), "new_line_") then
					for iter_9_5, iter_9_6 in pairs(iter_9_4:getChildren()) do
						iter_9_6:setOpacity(0)
						UIAction:Add(SEQ(FADE_IN(600)), iter_9_6, "block")
					end
				end
			end
		end
	end
end

function UnitStory.select_generation(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_2 == "next" then
		arg_10_1 = arg_10_1 + 1
	else
		arg_10_1 = arg_10_1 - 1
	end
	
	if arg_10_1 > arg_10_0.vars.totla_generation or arg_10_1 <= 0 then
		return 
	end
	
	arg_10_0.vars.current_generation = arg_10_1
	
	arg_10_0.vars.relation_wnd:removeFromParent()
	arg_10_0:makeUnitRelation(arg_10_0.vars.unit)
end

function UnitStory.set_generationButton(arg_11_0, arg_11_1)
	if not arg_11_0.vars or not get_cocos_refid(arg_11_0.vars.wnd) then
		return 
	end
	
	if_set_visible(arg_11_0.vars.wnd, "n_gener", true)
	
	local var_11_0, var_11_1 = DB("character_relationship_ui", arg_11_1, {
		"name",
		"desc"
	})
	
	if var_11_0 and var_11_1 then
		if_set(arg_11_0.vars.wnd, "txt_generation", T(var_11_0))
		if_set(arg_11_0.vars.wnd, "txt_gen_ex", T(var_11_1))
	end
	
	if arg_11_0.vars.totla_generation == 1 then
		if_set_visible(arg_11_0.vars.wnd, "btn_pre", false)
		if_set_visible(arg_11_0.vars.wnd, "btn_cur", false)
		if_set_visible(arg_11_0.vars.wnd, "n_gener", false)
		
		return 
	end
	
	if arg_11_0.vars.current_generation == 1 then
		if_set_visible(arg_11_0.vars.wnd, "btn_pre", false)
		if_set_visible(arg_11_0.vars.wnd, "btn_cur", true)
	elseif arg_11_0.vars.current_generation == arg_11_0.vars.totla_generation then
		if_set_visible(arg_11_0.vars.wnd, "btn_pre", true)
		if_set_visible(arg_11_0.vars.wnd, "btn_cur", false)
	else
		if_set_visible(arg_11_0.vars.wnd, "btn_pre", true)
		if_set_visible(arg_11_0.vars.wnd, "btn_cur", true)
	end
	
	local var_11_2, var_11_3, var_11_4 = DB("character_relationship_ui", string.format("re_%s_%d", arg_11_0.vars.unit.db.code, arg_11_0.vars.current_generation + 1), {
		"id",
		"unlock_enter",
		"unlock_mltheater"
	})
	
	if DEBUG.DEBUG_RELATION_UNLOCK then
		var_11_3 = nil
		var_11_4 = nil
	end
	
	if var_11_2 ~= nil and (var_11_3 ~= nil and not Account:isMapCleared(var_11_3) or var_11_4 ~= nil and not Account:isCleared_mlt_ep(var_11_4)) then
		if_set_visible(arg_11_0.vars.wnd, "btn_cur", false)
	end
end

function UnitStory.onLeave(arg_12_0, arg_12_1)
	UIAction:Add(SEQ(REMOVE()), arg_12_0.vars.wnd, "block")
	UnitDetail:updateUnitInfo(arg_12_0.vars.unit)
	
	arg_12_0.vars = nil
end

function UnitStory.onAfterUpdate(arg_13_0)
	if arg_13_0.vars and get_cocos_refid(arg_13_0.vars.relation_layer) then
		local var_13_0 = math.sin(uitick() / 720 * 3.141592 / 2)
		
		arg_13_0.vars.relation_layer:setRotation((var_13_0 + 1) / 2 * 0.03)
	end
end

function UnitStory.updateUnitInfo(arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0.vars.wnd:getChildByName("txt_name")
	
	var_14_0:setString(T(arg_14_1.db.name))
	if_call(arg_14_0.vars.wnd, "star1", "setPositionX", 10 + var_14_0:getContentSize().width * var_14_0:getScaleX() + var_14_0:getPositionX())
	
	local var_14_1 = arg_14_0.vars.wnd:getChildByName("txt_summary")
	
	if get_cocos_refid(var_14_1) then
		UIAction:Remove(var_14_1)
		var_14_1:setString("")
		UIAction:Add(SEQ(SOUND_TEXT(T(DB("character", arg_14_1.db.code, "2line"), "text"), true, 20, nil, 60)), var_14_1)
	end
	
	local var_14_2 = T(DB("character", arg_14_1.db.code, "story"))
	local var_14_3 = arg_14_0.vars.wnd:getChildByName("txt_story")
	
	UIAction:Remove(var_14_3)
	var_14_3:setString("")
	UIAction:Add(SEQ(SOUND_TEXT(var_14_2, true, 20, nil, 60)), var_14_3)
	arg_14_0:updateSlotInfo(arg_14_1)
	arg_14_0:updateSpecialty(arg_14_1)
end

function UnitStory.updateSpecialty(arg_15_0, arg_15_1)
	UIUtil:setSubTaskSkillInfo(arg_15_0.vars.wnd, arg_15_1)
end

function UnitStory.updateSlotInfo(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.vars.released_slot
	local var_16_1 = {}
	local var_16_2 = {}
	local var_16_3 = {}
	local var_16_4 = Account:getRelationUnit(arg_16_1.db.code).fx or {}
	
	for iter_16_0 = 1, 5 do
		local var_16_5 = string.format("chsl_%s_%02d", arg_16_1.db.code, iter_16_0)
		local var_16_6 = {}
		
		var_16_6.release_slot, var_16_6.req_zodiac, var_16_6.pre_story = DB("character_story_list", var_16_5, {
			"release_slot",
			"req_zodiac",
			"pre_story"
		})
		var_16_6.release_slot = var_16_6.release_slot and string.split(var_16_6.release_slot, ";") or {}
		
		for iter_16_1, iter_16_2 in pairs(var_16_6.release_slot) do
			local var_16_7 = tonumber(iter_16_2)
			
			if var_16_4[var_16_5] then
				if not var_16_0[var_16_7] then
					table.insert(var_16_1, var_16_7)
				end
				
				var_16_2[var_16_7] = true
			end
			
			var_16_3[var_16_7] = var_16_5
		end
	end
	
	arg_16_0.vars.released_slot = var_16_2
	arg_16_0.vars.slot_req_story = var_16_3
	arg_16_0.vars.open_slots = var_16_1
end

function UnitStory.makeUnitRelation(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0.vars.wnd:getChildByName("pivot")
	
	arg_17_0.vars.relation_layer = var_17_0
	
	local var_17_1 = string.format("re_%s_%d", arg_17_1.db.code, arg_17_0.vars.current_generation)
	
	arg_17_0:set_generationButton(var_17_1)
	
	local var_17_2 = DB("character_relationship_ui", var_17_1, {
		"relation_ui"
	})
	local var_17_3 = DB("character", arg_17_1.db.code, {
		"face_id"
	})
	local var_17_4 = load_dlg(var_17_2 or "wnd_story_v10_1", true, "wnd")
	
	arg_17_0.vars.relation_wnd = var_17_4
	
	var_17_4:setPosition(0, 0)
	var_17_0:addChild(var_17_4)
	if_set_sprite(var_17_4, "img_face", "face/" .. var_17_3 .. "_s.png")
	if_set(var_17_4, "chara_name", T(arg_17_1.db.name))
	
	local var_17_5 = var_17_4:getChildByName("chara_name")
	
	if var_17_5 then
		var_17_5:enableOutline(cc.c3b(0, 0, 0), 4)
	end
	
	arg_17_0.vars.slot_info = {}
	
	for iter_17_0 = 1, 16 do
		local var_17_6 = string.format("chre_%s_%d", arg_17_1.db.code, iter_17_0)
		local var_17_7, var_17_8, var_17_9, var_17_10, var_17_11, var_17_12, var_17_13, var_17_14, var_17_15 = DB("character_relationship", var_17_6, {
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
			var_17_14 = nil
			var_17_15 = nil
		end
		
		local var_17_16 = false
		
		if AccountData.dictionary_hide and AccountData.dictionary_hide[var_17_12] then
			var_17_16 = true
		end
		
		if var_17_16 and var_17_8 then
			local var_17_17 = var_17_4:getChildByName("line_" .. var_17_8)
			
			if var_17_17 then
				var_17_17:setVisible(false)
			end
		end
		
		if var_17_8 and var_17_7 == var_17_1 and not var_17_16 then
			if not (function(arg_18_0)
				local var_18_0 = {
					"trust",
					"love",
					"rival",
					"longing",
					"grudge"
				}
				local var_18_1 = false
				
				for iter_18_0, iter_18_1 in pairs(var_18_0) do
					if iter_18_1 == arg_18_0 then
						var_18_1 = true
					end
				end
				
				return var_18_1
			end)(var_17_11) then
				return 
			end
			
			local var_17_18 = var_17_4:getChildByName("unit_frame_" .. var_17_8)
			local var_17_19 = var_17_4:getChildByName("line_" .. var_17_8)
			local var_17_20 = false
			
			if var_17_14 and not Account:isMapCleared(var_17_14) then
				var_17_20 = true
			elseif var_17_15 and not Account:isCleared_mlt_ep(var_17_15) then
				var_17_20 = true
			end
			
			local var_17_21 = {
				slot_number = var_17_8,
				relation_count = var_17_9,
				slot_type = var_17_10,
				relation_type = var_17_11,
				relation_function = var_17_12,
				relation_text = var_17_13,
				unlock_enter = var_17_14,
				unlock_mltheater = var_17_15,
				locked = var_17_20
			}
			
			arg_17_0.vars.slot_info[var_17_6] = var_17_21
			
			if var_17_9 >= 2 then
				var_17_6 = arg_17_0:check_SameSlot(var_17_6, var_17_9)
				var_17_21 = arg_17_0.vars.slot_info[var_17_6]
				var_17_12 = arg_17_0.vars.slot_info[var_17_6].relation_function
			end
			
			local var_17_22 = arg_17_0:makeLine(var_17_8, nil, var_17_6)
			
			if get_cocos_refid(var_17_22) then
				var_17_4:addChild(var_17_22)
				var_17_19:setVisible(false)
			end
			
			if var_17_18 then
				local var_17_23 = cc.CSLoader:createNode("wnd/wnd_story_target.csb")
				
				var_17_23:setAnchorPoint(0.5, 0.5)
				var_17_23:setName("target_ui_" .. var_17_6)
				var_17_18:addChild(var_17_23)
				if_set_visible(var_17_23, "icon_locked", false)
				
				if var_17_12 then
					if var_17_20 then
						arg_17_0:setRelations(var_17_23, var_17_12, "locked", var_17_10, var_17_8, var_17_6)
					else
						arg_17_0:setRelations(var_17_23, var_17_12, var_17_21.relation_type, var_17_10, var_17_8, var_17_6)
					end
				else
					var_17_18:setVisible(false)
					var_17_19:setVisible(false)
				end
				
				if var_17_20 then
					if_set_visible(var_17_23, "n_tag", false)
				end
			else
				if_set_visible(var_17_4, "line_" .. var_17_8, false)
			end
		end
	end
end

function UnitStory.check_SameSlot(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = 1
	
	for iter_19_0 = 1, arg_19_2 do
		local var_19_1 = string.format("%s_%d", arg_19_1, iter_19_0)
		local var_19_2, var_19_3, var_19_4, var_19_5, var_19_6, var_19_7, var_19_8, var_19_9, var_19_10 = DB("character_relationship", var_19_1, {
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
			var_19_9 = nil
			var_19_10 = nil
		end
		
		if var_19_2 == nil then
			iter_19_0 = iter_19_0 - 1
			
			break
		end
		
		local var_19_11 = false
		
		if var_19_9 and not Account:isMapCleared(var_19_9) then
			var_19_11 = true
		elseif var_19_10 and not Account:isCleared_mlt_ep(var_19_10) then
			var_19_11 = true
		end
		
		local var_19_12 = {
			slot_number = var_19_3,
			relation_count = var_19_4,
			slot_type = var_19_5,
			relation_type = var_19_6,
			relation_function = var_19_7,
			relation_text = var_19_8,
			unlock_enter = var_19_9,
			unlock_mltheater = var_19_10,
			locked = var_19_11
		}
		
		arg_19_0.vars.slot_info[var_19_1] = var_19_12
	end
	
	for iter_19_1 = var_19_0, 0, -1 do
		if arg_19_0.vars.slot_info[string.format("%s_%d", arg_19_1, iter_19_1)] and arg_19_0.vars.slot_info[string.format("%s_%d", arg_19_1, iter_19_1)].locked then
			var_19_0 = var_19_0 - 1
		end
	end
	
	if var_19_0 <= 0 then
		return string.format("%s", arg_19_1)
	else
		return string.format("%s_%d", arg_19_1, var_19_0)
	end
end

function UnitStory.getLineFileName(arg_20_0, arg_20_1)
	return ({
		longing = "img/cm_lineicon_storymap_longing.png",
		locked = "img/cm_lineicon_storymap_off.png",
		love = "img/cm_lineicon_storymap_love.png",
		trust = "img/cm_lineicon_storymap_trust.png",
		grudge = "img/cm_lineicon_storymap_revenge.png",
		rival = "img/cm_lineicon_storymap_rival.png"
	})[arg_20_1]
end

function UnitStory.makeLine(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	if arg_21_0.vars.slot_info[arg_21_3].slot_type ~= "fix" then
		return 
	end
	
	local var_21_0 = arg_21_0.vars.slot_info[arg_21_3].relation_type
	local var_21_1 = arg_21_0.vars.relation_wnd
	
	if arg_21_0.vars.slot_info[arg_21_3].locked then
		var_21_0 = "locked"
	end
	
	local var_21_2 = var_21_1:getChildByName("unit_frame_" .. arg_21_1)
	local var_21_3 = var_21_1:getChildByName("line_" .. arg_21_1)
	
	if not get_cocos_refid(var_21_3) then
		return 
	end
	
	local var_21_4 = var_21_3:getContentSize()
	local var_21_5 = var_21_1:getChildByName("main_unit_frame")
	local var_21_6 = var_21_5:getChildByName("cm_hero_cirfrm1")
	local var_21_7 = var_21_5:getPositionX() + var_21_6:getContentSize().width * var_21_6:getScaleX() / 2
	local var_21_8 = var_21_5:getPositionY() + var_21_6:getContentSize().height * var_21_6:getScaleY() / 2
	local var_21_9, var_21_10 = var_21_2:getPosition()
	local var_21_11 = cc.Node:create()
	local var_21_12 = var_21_4.height * var_21_3:getScaleY()
	local var_21_13 = arg_21_0:addSlotLine(var_21_11, var_21_0, var_21_12)
	local var_21_14 = math.atan2(var_21_8 - var_21_10, var_21_9 - var_21_7) * 180 / math.pi + 90
	
	var_21_11:setRotation(var_21_14)
	var_21_11:setPosition(var_21_7, var_21_8)
	var_21_11:setLocalZOrder(-1)
	var_21_11:setName(arg_21_2 or "new_line_" .. arg_21_1)
	
	return var_21_11, var_21_13
end

function UnitStory.makePopupLine(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_1:getChildByName("n_mine")
	local var_22_1 = arg_22_1:getChildByName("n_target")
	local var_22_2 = var_22_1:getPositionX() - var_22_0:getPositionX()
	local var_22_3 = cc.Node:create()
	
	var_22_3:setRotation(-90)
	var_22_3:setLocalZOrder(-1)
	arg_22_0:addSlotLine(var_22_3, arg_22_2, var_22_2)
	var_22_1:addChild(var_22_3)
	
	return var_22_3
end

function UnitStory.addSlotLine(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = 0
	local var_23_1 = 0
	
	repeat
		local var_23_2 = arg_23_0:getLineFileName(arg_23_2)
		local var_23_3 = cc.Sprite:create(var_23_2)
		
		var_23_3:setAnchorPoint(1, 0.5)
		var_23_3:setRotation(90)
		var_23_3:setPosition(0, var_23_0)
		
		var_23_1 = var_23_3:getContentSize().height
		var_23_0 = var_23_0 + var_23_3:getContentSize().width
		
		arg_23_1:addChild(var_23_3)
	until arg_23_3 < var_23_0
	
	return {
		width = var_23_1,
		height = var_23_0
	}
end

function UnitStory.onSlotTouch(arg_24_0, arg_24_1)
	if arg_24_1 ~= 2 then
		return 
	end
	
	local var_24_0 = string.split(arg_24_0:getName(), "slot_")[2]
	local var_24_1 = UnitStory.vars.slot_info[var_24_0]
	
	if var_24_1.slot_type == "fix" then
		if UIAction:Find("block") then
			return 
		end
		
		if var_24_1.locked then
			UnitStory:showUnlockInfoText(var_24_1)
		else
			UnitStory:showDetailPopup(var_24_1, UnitStory.vars.released_slot[var_24_0], var_24_0)
		end
	else
		balloon_message_with_sound("cant_relation")
	end
end

function UnitStory.changeDetailPopup_Info(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = SceneManager:getRunningNativeScene():getChildByName("hero_story_fix_detail")
	local var_25_1 = SceneManager:getCurrentSceneName()
	
	if not var_25_0 and var_25_1 == "lobby" then
		var_25_0 = SceneManager:getRunningPopupScene():getChildByName("hero_story_fix_detail")
	end
	
	if not var_25_0 or not get_cocos_refid(var_25_0) then
		return 
	end
	
	local var_25_2 = arg_25_1
	
	if var_25_1 == "lobby" or var_25_1 == "collection" then
		CollectionNewHero:showDetailPopup(CollectionNewHero.vars.slot_info[arg_25_1], CollectionNewHero.vars.released_slot[var_25_2], var_25_2, true)
	elseif not arg_25_0.vars then
		UnitDetailStory:showDetailPopup(UnitDetailStory.vars.slot_info[arg_25_1], UnitDetailStory.vars.released_slot[var_25_2], var_25_2, true)
	else
		UnitStory:showDetailPopup(arg_25_0.vars.slot_info[arg_25_1], arg_25_0.vars.released_slot[var_25_2], var_25_2, true)
	end
end

function UnitStory.setRelations(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6)
	local var_26_0, var_26_1 = DB("character", arg_26_2, {
		"name",
		"face_id"
	})
	
	if var_26_1 == nil then
		Log.e("잘못된 데이터(character_relationship.db)", "character_id값 : ", arg_26_2, "face_id값", var_26_1)
		
		var_26_1 = "c1007"
	end
	
	if arg_26_3 == "locked" then
		var_26_1 = "m0000"
	end
	
	if_set_sprite(arg_26_1, "img_face", "face/" .. var_26_1 .. "_s.png")
	if_set(arg_26_1, "chara_name", T(var_26_0))
	
	local var_26_2 = arg_26_1:getChildByName("chara_name")
	
	if var_26_2 then
		var_26_2:enableOutline(cc.c3b(0, 0, 0), 4)
	end
	
	arg_26_5 = tonumber(arg_26_5)
	
	local var_26_3 = arg_26_1:getChildByName("bg_charaface")
	
	if get_cocos_refid(var_26_3) then
		local var_26_4 = var_26_3:getContentSize()
		local var_26_5 = ccui.Button:create()
		
		var_26_5:setTouchEnabled(true)
		var_26_5:ignoreContentAdaptWithSize(false)
		var_26_5:setContentSize(var_26_4.width, var_26_4.height)
		var_26_5:addTouchEventListener(arg_26_0.onSlotTouch)
		var_26_5:setName("btn_slot_" .. arg_26_6)
		arg_26_1:getParent():addChild(var_26_5)
	end
	
	local var_26_6 = false
	
	if (arg_26_0.vars.released_slot or {})[arg_26_5] then
		if_set_visible(arg_26_1, "cm_cool_hero_1", false)
		if_set_visible(arg_26_1, "txt_name_0", false)
		
		var_26_6 = true
	else
		if_set_visible(arg_26_1, "cm_cool_hero_1", true)
		if_set_visible(arg_26_1, "txt_name_0", true)
		
		local var_26_7 = arg_26_0.vars.slot_req_story[arg_26_5]
		local var_26_8 = string.split(var_26_7, "_")
		
		if var_26_8[3] then
			local var_26_9 = tonumber(var_26_8[3]) or 0
			
			if_set(arg_26_1, "txt_name_0", T("cha_story_episode_short", {
				num = var_26_9
			}))
		end
	end
	
	if arg_26_4 == "fix" then
		local var_26_10, var_26_11 = UIUtil:getRelationColorIcon(arg_26_3)
		
		if_set_sprite(arg_26_1, "icon_longing", var_26_11)
		if_set_color(arg_26_1, "cm_hero_cirfrm_lock", var_26_10)
		if_set_color(arg_26_1, "t_relation", var_26_10)
		if_set(arg_26_1, "t_relation", T("rb_fix_" .. arg_26_3 .. "_tl"))
	else
		if_set_visible(arg_26_1, "img_face", false)
		if_set_visible(arg_26_1, "icon_longing", false)
		if_set_color(arg_26_1, "cm_hero_cirfrm_lock", cc.c3b(176, 176, 176))
		
		if not var_26_6 then
			arg_26_1:setScale(arg_26_1:getScale() * 0.7)
		end
	end
end

function UnitStory.onLockSlot(arg_27_0)
end

function UnitStory.onUnlockSlot(arg_28_0)
	local var_28_0 = arg_28_0.vars.unit
	
	for iter_28_0, iter_28_1 in pairs(arg_28_0.vars.open_slots or {}) do
		for iter_28_2 = 1, 16 do
			local var_28_1, var_28_2, var_28_3, var_28_4 = DB("character_relationship", string.format("chre_%s_%d", var_28_0.db.code, iter_28_2), {
				"slot_number",
				"slot_type",
				"relation_function",
				"relation_type"
			})
			
			if not var_28_1 then
				break
			end
			
			local var_28_5 = string.format("chre_%s_%d", var_28_0.db.code, iter_28_2)
			
			if tonumber(var_28_1) == iter_28_1 then
				local var_28_6 = arg_28_0.vars.relation_wnd:getChildByName("target_ui_" .. var_28_1)
				
				if get_cocos_refid(var_28_6) then
					if_set_visible(var_28_6, "cm_cool_hero_1", false)
					if_set_visible(var_28_6, "txt_name_0", false)
				end
				
				if var_28_2 == "fix" then
					arg_28_0:LineAnimation(var_28_1, var_28_4, var_28_5)
					Action:Add(SEQ(COND_LOOP(SEQ(DELAY(10)), function()
						if not UIAction:Find("line.anim") then
							return true
						end
					end), CALL(arg_28_0.showUnlockPopup, arg_28_0, var_28_3, var_28_2, var_28_4)), var_28_6, "relation.scale")
				else
					Action:Add(SEQ(LOG(SCALE_TO(150, var_28_6:getScale() / 0.7))), var_28_6, "relation.scale")
				end
			end
		end
	end
end

function UnitStory.LineAnimation(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	local var_30_0 = {
		longing = "relationship_longing.cfx",
		love = "relationship_love.cfx",
		trust = "relationship_trust.cfx",
		grudge = "relationship_grudge.cfx",
		rival = "relationship_rival.cfx"
	}
	local var_30_1, var_30_2 = arg_30_0:makeLine(arg_30_1, "effect_line_" .. arg_30_1, arg_30_3)
	local var_30_3 = cc.DrawNode:create()
	local var_30_4 = var_30_2.width
	local var_30_5 = 0
	local var_30_6 = {
		cc.p(-var_30_4, -var_30_5),
		cc.p(-var_30_4, var_30_5),
		cc.p(var_30_4, var_30_5),
		cc.p(var_30_4, -var_30_5)
	}
	local var_30_7 = cc.c3b(255, 255, 255)
	
	var_30_3:drawPolygon(var_30_6, 4, var_30_7, 0, var_30_7)
	var_30_3:setPosition(0, 0)
	
	local var_30_8 = cc.ClippingNode:create()
	
	var_30_8:setStencil(var_30_3)
	var_30_8:addChild(var_30_1)
	var_30_8:setAnchorPoint(var_30_1:getAnchorPoint().x, var_30_1:getAnchorPoint().y)
	var_30_1:setAnchorPoint(0.5, 0.5)
	var_30_8:setPosition(var_30_1:getPositionX(), var_30_1:getPositionY())
	var_30_1:setPosition(0, 0)
	var_30_8:setRotation(var_30_1:getRotation())
	var_30_1:setRotation(0)
	var_30_8:setLocalZOrder(var_30_1:getLocalZOrder())
	arg_30_0.vars.relation_wnd:addChild(var_30_8)
	
	local var_30_9 = 0
	local var_30_10 = arg_30_0.vars.relation_wnd:getChildByName("target_ui_" .. arg_30_1)
	local var_30_11 = CACHE:getEffect(var_30_0[arg_30_2])
	
	var_30_11:setRotation(var_30_8:getRotation() + 180)
	var_30_10:addChild(var_30_11)
	var_30_11:setPosition(var_30_10:getContentSize().width / 2, var_30_10:getContentSize().height / 2)
	
	local var_30_12 = var_30_11:getDuration()
	
	local function var_30_13()
		if not get_cocos_refid(arg_30_0.vars.relation_wnd) then
			return 
		end
		
		local var_31_0 = arg_30_0.vars.relation_wnd:getChildByName("new_line_" .. arg_30_1)
		
		if not get_cocos_refid(var_31_0) then
			return 
		end
		
		for iter_31_0, iter_31_1 in pairs(var_31_0:getChildren()) do
			iter_31_1:setOpacity(255)
		end
	end
	
	SoundEngine:play("event:/effect/unitstory/line_ani")
	UIAction:Add(SEQ(COND_LOOP(SEQ(DELAY(10)), function()
		local var_32_0 = cc.DrawNode:create()
		local var_32_1 = var_30_2.width
		local var_32_2 = var_30_9
		local var_32_3 = {
			cc.p(-var_32_1, -var_32_2),
			cc.p(-var_32_1, var_32_2),
			cc.p(var_32_1, var_32_2),
			cc.p(var_32_1, -var_32_2)
		}
		local var_32_4 = cc.c3b(255, 255, 255)
		
		var_32_0:drawPolygon(var_32_3, 4, var_32_4, 0, var_32_4)
		var_32_0:setPosition(0, 0)
		var_30_8:setStencil(var_32_0)
		
		var_30_9 = var_30_9 + 8
		
		if var_30_9 >= var_30_2.height then
			return true
		end
	end), CALL(var_30_11.start, var_30_11), CALL(SoundEngine.play, SoundEngine, "event:/effect/unitstory/effect"), DELAY(3000), CALL(var_30_13), REMOVE()), var_30_8, "line.anim")
end

function UnitStory.showUnlockPopup(arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	local var_33_0 = load_dlg("hero_story_clear", true, "wnd")
	
	SceneManager:getRunningNativeScene():addChild(var_33_0)
	
	local var_33_1 = arg_33_0:getSimpleFace(arg_33_1, arg_33_3)
	local var_33_2 = arg_33_0:getSimpleFace(arg_33_0.vars.unit.db.code)
	
	arg_33_0:makePopupLine(var_33_0, arg_33_3)
	
	if var_33_1 then
		var_33_0:getChildByName("n_target"):addChild(var_33_1)
	end
	
	if var_33_2 then
		var_33_0:getChildByName("n_mine"):addChild(var_33_2)
	end
	
	local var_33_3 = arg_33_0:getSlotStatDesc(arg_33_2, arg_33_3)
	
	SoundEngine:play("event:/ui/popup/tap")
	if_set(var_33_0, "txt_name", var_33_3)
end

function UnitStory.getSlotStatDesc(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0, var_34_1 = DB("character_relationship_bonus", "rb_" .. arg_34_1 .. "_" .. arg_34_2, {
		"bonus_type",
		"stat"
	})
	local var_34_2 = ""
	local var_34_3 = DB("skill", var_34_0, "sk_description")
	
	if not var_34_3 then
		if tonumber(var_34_1) then
			var_34_2 = getStatName(var_34_0) .. " +" .. to_var_str(var_34_1, var_34_0)
		else
			var_34_2 = T("collection_hero_lua_637")
		end
	else
		var_34_2 = T(var_34_3)
	end
	
	return var_34_2
end

function UnitStory.getSimpleFace(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = cc.CSLoader:createNode("wnd/wnd_story_target.csb")
	
	var_35_0:setAnchorPoint(0.5, 0.5)
	
	local var_35_1, var_35_2 = DB("character", arg_35_1, {
		"name",
		"face_id"
	})
	
	if var_35_2 == nil then
		Log.e("잘못된 데이터(character_relationship.db)", "character_id값 : ", arg_35_1, "face_id값", var_35_2)
		
		var_35_2 = "c1007"
	end
	
	if_set_sprite(var_35_0, "img_face", "face/" .. var_35_2 .. "_s.png")
	if_set(var_35_0, "chara_name", T(var_35_1))
	
	if arg_35_2 then
		local var_35_3, var_35_4 = UIUtil:getRelationColorIcon(arg_35_2)
		
		if_set_sprite(var_35_0, "icon_longing", var_35_4)
		if_set_color(var_35_0, "cm_hero_cirfrm_lock", var_35_3)
	else
		if_set_visible(var_35_0, "icon_longing", false)
	end
	
	if_set_visible(var_35_0, "cm_cool_hero_1", false)
	if_set_visible(var_35_0, "icon_locked", false)
	if_set_visible(var_35_0, "txt_name_0", false)
	
	return var_35_0
end

function UnitStory.getPlayableStoryCount(arg_36_0, arg_36_1)
	local var_36_0 = 0
	local var_36_1 = arg_36_1:getZodiacGrade()
	local var_36_2 = arg_36_1.db.code
	
	for iter_36_0 = 1, 5 do
		local var_36_3 = ""
		local var_36_4 = string.format("chsl_%s_%02d", var_36_2, iter_36_0)
		local var_36_5, var_36_6, var_36_7 = DB("character_story_list", var_36_4, {
			"id",
			"req_zodiac",
			"pre_story"
		})
		
		if var_36_5 then
			local var_36_8 = Account:getRelationUnit(var_36_2).fx or {}
			
			if not (var_36_1 >= (var_36_6 or 0)) or var_36_7 and not var_36_8[var_36_7] then
			elseif not var_36_8[var_36_4] then
				var_36_0 = var_36_0 + 1
			end
		end
	end
	
	return var_36_0
end

function UnitStory.update(arg_37_0)
end

function UnitStory.onStartBattle(arg_38_0, arg_38_1)
	Dialog:closeAll()
	
	local var_38_0 = arg_38_1.team.leader_idx
	
	arg_38_1.team.leader_idx = nil
	
	local var_38_1 = arg_38_1.team
	
	arg_38_0:setTeamInfo(var_38_1)
	query("story_enter", {
		map = arg_38_1.enter_id
	})
	BattleReady:hide()
end

function UnitStory.setTeamInfo(arg_39_0, arg_39_1)
	arg_39_0.team = Team:makeTeamData(arg_39_1)
end

function UnitStory.getTeamInfo(arg_40_0)
	return arg_40_0.team
end

function MsgHandler.story_enter(arg_41_0)
	Action:RemoveAll()
	
	local var_41_0 = UnitStory:getTeamInfo()
	local var_41_1 = BattleLogic:makeLogic(arg_41_0.battle, var_41_0)
	local var_41_2 = {
		target = UnitStory.vars.unit:getUID(),
		story_id = UnitStory.vars.item.id,
		story_title = UnitStory.vars.item.db.story_title
	}
	
	PreLoad:beforeEnterBattle(var_41_1)
	SceneManager:nextScene("battle", {
		logic = var_41_1,
		story_data = var_41_2
	})
end

function MsgHandler.clear_relation_story(arg_42_0)
	Account:setRelationUnit(arg_42_0.code, arg_42_0.relation)
	
	local function var_42_0()
		UnitStory:updateSlotInfo(UnitStory.vars.unit)
		UnitStory:makeScrollView()
		UnitStory:onUnlockSlot()
	end
	
	Action:Add(SEQ(COND_LOOP(SEQ(DELAY(1000)), function()
		if not is_playing_story() then
			return true
		end
	end), CALL(var_42_0)), UnitStory, "relation.clear")
end

function MsgHandler.reset_relation_story(arg_45_0)
	local var_45_0 = arg_45_0.code
	
	Account:setRelationUnit(var_45_0)
	UnitStory:makeScrollView()
	
	if UnitStory.vars then
		UnitStory.vars.open_slots = {}
	end
end

function UnitStory.onReturnCurrentPage(arg_46_0)
	Action:Add(SEQ(CALL(SceneManager.nextScene, SceneManager, "unit_ui", {
		mode = "Story",
		skip_ani = true,
		unit = Account:getUnit(887)
	}), COND_LOOP(SEQ(DELAY(10)), function()
		if UnitMain.vars then
			return true
		end
	end), CALL(TopBarNew.setTitleName, TopBarNew, T(Account.units[1].db.name))), UnitStory, "test")
end

function UnitStory.reset(arg_48_0)
	query("reset_relation_story", {
		target = arg_48_0.vars.unit:getUID()
	})
end

function UnitStory.showPopup(arg_49_0, arg_49_1)
	local var_49_0 = load_dlg("hero_story_go", true, "wnd")
	
	SceneManager:getRunningNativeScene():addChild(var_49_0)
	
	arg_49_0.vars.popup = var_49_0 or {}
	arg_49_0.vars.popup.item = arg_49_1
	
	if_set(var_49_0, "txt_title", T(arg_49_1.db.story_title))
	
	if arg_49_1.state == "lock" then
		if_set(var_49_0, "txt_guide", T("ch_story_limit_zodiac_grade"))
		if_set_enabled(var_49_0, "btn_go", false)
	elseif arg_49_1.state == "require" then
		if_set(var_49_0, "txt_guide", T("ch_story_pre_story"))
	elseif arg_49_1.state == "already" then
		if_set(var_49_0, "txt_guide", T("ch_story_clear"))
	elseif arg_49_1.db.story_type == "battle" then
		if_set(var_49_0, "txt_guide", T("ch_story_battle_type"))
	else
		if_set(var_49_0, "txt_guide", T("ch_story_story_type"))
	end
	
	local var_49_1 = var_49_0:getChildByName("icon_storyguide")
	
	if get_cocos_refid(var_49_1) then
		local var_49_2 = var_49_1:getContentSize()
		local var_49_3 = "img/cm_icon_etcchatting.png"
		
		if arg_49_1.db.story_type == "battle" then
			var_49_3 = "img/cm_icon_etcbp.png"
		end
		
		if_set_sprite(var_49_0, "icon_storyguide", var_49_3)
		
		local var_49_4 = var_49_1:getContentSize()
		
		var_49_1:setScaleX(var_49_2.width / var_49_4.width * var_49_1:getScaleX())
		var_49_1:setScaleY(var_49_2.height / var_49_4.height * var_49_1:getScaleY())
	end
	
	SoundEngine:play("event:/ui/popup/tap")
end

function UnitStory.playStory(arg_50_0, arg_50_1)
	local var_50_0 = arg_50_0.vars.item
	
	if var_50_0.state == "lock" or var_50_0.state == "require" then
		return 
	end
	
	if var_50_0.db.story_type == "battle" then
		local var_50_1 = {}
		local var_50_2
		
		var_50_2.leader_idx, var_50_2 = 1, TutorialBattle:getStoryUnits(var_50_0.db.party_preset, arg_50_0.vars.unit)
		
		BattleReady:show({
			hide_hpbar = true,
			skip_intro = false,
			is_story = true,
			callback = arg_50_0,
			enter_id = var_50_0.db.story_id,
			preset = var_50_0.db.party_preset,
			team = var_50_2
		})
	elseif var_50_0.db.story_type == "story" then
		local var_50_3 = SceneManager:getRunningNativeScene()
		
		start_new_story(var_50_3, var_50_0.db.story_id, {
			force = true
		})
		query("clear_relation_story", {
			code = arg_50_0.vars.unit.db.code,
			story_id = var_50_0.id
		})
	end
end

function UnitStory.hidePopup(arg_51_0, arg_51_1)
	if arg_51_0.vars and get_cocos_refid(arg_51_0.vars.popup) then
		arg_51_0.vars.popup:removeFromParent()
	end
end

function UnitStory.showDetailPopup(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4)
	if not arg_52_1 or not arg_52_3 then
		return 
	end
	
	local var_52_0 = false
	
	if SceneManager:getRunningNativeScene():getChildByName("hero_story_fix_detail") ~= nil then
		local var_52_1 = SceneManager:getRunningNativeScene():getChildByName("hero_story_fix_detail")
		
		if get_cocos_refid(var_52_1) then
			var_52_1:removeFromParent()
			
			var_52_0 = true
		end
	end
	
	local var_52_2 = load_dlg("hero_story_fix_detail", true, "wnd")
	
	if_set_visible(var_52_2, "btn_next", false)
	if_set_visible(var_52_2, "btn_pre", false)
	if_set_visible(var_52_2, "btn_move2", true)
	
	if arg_52_1.relation_count >= 2 then
		local var_52_3 = string.split(arg_52_3, "_")
		local var_52_4 = arg_52_3
		
		if not arg_52_4 then
			for iter_52_0 = 1, arg_52_1.relation_count do
				local var_52_5 = string.format("%s_%s_%d_%d", var_52_3[1], var_52_3[2], var_52_3[3], iter_52_0)
				
				if arg_52_0.vars.slot_info[var_52_5] and arg_52_0.vars.slot_info[var_52_5].locked == false then
					var_52_4 = var_52_5
					arg_52_1 = arg_52_0.vars.slot_info[var_52_4]
				end
			end
		end
		
		local var_52_6 = string.split(var_52_4, "_")
		
		if #var_52_6 < 4 then
			local var_52_7 = string.format("%s_%s_%d_%d", var_52_6[1], var_52_6[2], var_52_6[3], "1")
			
			if arg_52_0.vars.slot_info[var_52_7] then
				var_52_2:getChildByName("btn_next").code = var_52_7
				
				if_set_visible(var_52_2, "btn_pre", false)
				
				if not arg_52_0.vars.slot_info[var_52_7].locked then
					if_set_visible(var_52_2, "btn_next", true)
				end
			end
		else
			if_set_visible(var_52_2, "btn_pre", true)
			
			if tonumber(var_52_6[4]) == 1 then
				var_52_2:getChildByName("btn_pre").code = string.format("%s_%s_%d", var_52_6[1], var_52_6[2], var_52_6[3])
			else
				var_52_2:getChildByName("btn_pre").code = string.format("%s_%s_%d_%d", var_52_6[1], var_52_6[2], var_52_6[3], tonumber(var_52_6[4] - 1))
			end
			
			if_set_visible(var_52_2, "btn_next", false)
			
			local var_52_8 = tonumber(var_52_6[4]) + 1
			local var_52_9 = string.format("%s_%s_%d_%d", var_52_6[1], var_52_6[2], var_52_6[3], var_52_8)
			
			if arg_52_0.vars.slot_info[var_52_9] then
				var_52_2:getChildByName("btn_next").code = var_52_9
				
				if not arg_52_0.vars.slot_info[var_52_9].locked then
					if_set_visible(var_52_2, "btn_next", true)
				end
			end
		end
	end
	
	local function var_52_10()
		var_52_2:removeFromParent()
		BackButtonManager:pop("hero_story_fix_detail")
	end
	
	BackButtonManager:push({
		check_id = "hero_story_fix_detail",
		back_func = var_52_10
	})
	SceneManager:getRunningNativeScene():addChild(var_52_2)
	
	local var_52_11 = arg_52_1.relation_function
	local var_52_12 = arg_52_1.relation_type
	local var_52_13 = ccui.Button:create()
	
	var_52_13:setTouchEnabled(true)
	var_52_13:ignoreContentAdaptWithSize(false)
	var_52_13:setContentSize(VIEW_WIDTH, VIEW_HEIGHT)
	var_52_13:setPosition(VIEW_BASE_LEFT, 0)
	var_52_13:setAnchorPoint(0, 0)
	var_52_13:setLocalZOrder(-1)
	var_52_13:addTouchEventListener(function(arg_54_0, arg_54_1)
		if arg_54_1 ~= 2 then
			return 
		end
		
		var_52_10()
	end)
	var_52_13:setName("btn_close")
	var_52_2:addChild(var_52_13)
	
	local var_52_14 = arg_52_0:getSimpleFace(var_52_11, var_52_12)
	local var_52_15 = DB("character", var_52_11, "name")
	
	if_set(var_52_2, "chara_name", T(var_52_15))
	
	local var_52_16, var_52_17 = UIUtil:getRelationColorIcon(var_52_12)
	
	if_set_visible(var_52_14, "chara_name", false)
	if_set_visible(var_52_14, "icon_longing", false)
	if_set_visible(var_52_14, "t_relation", false)
	if_set(var_52_2, "t_relation", T("rb_fix_" .. var_52_12 .. "_tl"))
	if_set_color(var_52_2, "t_relation", var_52_16)
	if_set_sprite(var_52_2, "icon_longing", var_52_17)
	var_52_14:setScale(var_52_14:getScale() * 0.7)
	if_set_visible(var_52_14, "icon_locked", not arg_52_2)
	
	if not arg_52_2 then
		local var_52_18 = arg_52_1.slot_number
		local var_52_19 = arg_52_0.vars.slot_req_story[var_52_18]
		
		if var_52_19 then
			local var_52_20 = string.split(var_52_19, "_")
			
			if_set(var_52_2, "deactive_desc", T("cha_story_episode_long", {
				num = var_52_20[3]
			}))
		else
			if_set_visible(var_52_2, "active", true)
			if_set_visible(var_52_2, "deactive", false)
		end
	end
	
	var_52_2:getChildByName("face_node"):addChild(var_52_14)
	if_set(var_52_2, "active_desc", T(arg_52_1.relation_text or ""))
	
	local var_52_21 = var_52_2:getChildByName("LEFT")
	
	if var_52_0 == false then
		var_52_21:setPositionX(-400)
		UIAction:Add(LOG(MOVE_TO(250, VIEW_BASE_LEFT)), var_52_21, "block")
	else
		var_52_21:setPositionX(VIEW_BASE_LEFT)
	end
	
	var_52_2:getChildByName("btn_move2").code = var_52_11
	
	SoundEngine:play("event:/ui/popup/tap")
end

function UnitStory.onHeroListEventForFormationEditor(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	local var_55_0 = HeroBelt:getInst("UnitMain")
	
	if arg_55_1 == "change" then
		local var_55_1 = var_55_0:getControl(arg_55_2)
		local var_55_2 = var_55_0:getControl(arg_55_3)
		
		if var_55_1 then
			var_55_1:getChildByName("add"):setVisible(false)
		end
		
		if var_55_2 then
			var_55_2:getChildByName("add"):setVisible(true)
		end
	end
	
	if arg_55_1 == "add" then
		arg_55_0:onAddUnit(arg_55_2)
	end
end

function UnitStory.showUnlockInfoText(arg_56_0, arg_56_1)
	local var_56_0 = arg_56_1 or {}
	local var_56_1 = 100
	local var_56_2
	local var_56_3 = var_56_0.unlock_enter or var_56_0.unlock_mltheater
	
	if not var_56_3 then
		return 
	end
	
	local var_56_4, var_56_5, var_56_6 = DB("level_enter", var_56_3, {
		"id",
		"episode",
		"name"
	})
	
	if not var_56_4 then
		return 
	end
	
	if var_56_5 then
		var_56_1 = string.sub(var_56_5, -1, -1)
	end
	
	if var_56_6 then
		var_56_2 = T(var_56_6)
	end
	
	local var_56_7 = T("ep_select_num" .. var_56_1)
	
	balloon_message_with_sound("msg_relation_not_open", {
		episode = var_56_7,
		map = var_56_2
	})
end

function UnitStory.onAddUnit(arg_57_0, arg_57_1)
end
