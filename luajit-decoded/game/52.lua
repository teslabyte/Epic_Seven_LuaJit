FIELD_NEW.filter_invisible_after_complete = {
	item_crystal = true,
	obstacle = true
}

function FIELD_NEW.getVisibleStateAfterComplete(arg_1_0, arg_1_1)
	if arg_1_1 and arg_1_0 and FIELD_NEW.filter_invisible_after_complete[arg_1_0] then
		return false
	end
	
	return true
end

FIELD_NEW.objectConstruct = {}

function FIELD_NEW.objectConstruct.hp_heal(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = {}
	
	var_2_0.model_id = "model/godess.scsp"
	var_2_0.anim_name = "green"
	var_2_0.parts_list = {
		{
			z = 2,
			name = "godess_orb_green.particle",
			bone_name = "eff_orb",
			ani_type = "particle"
		},
		{
			z = 1,
			name = "godess_necklight.scsp",
			ani_type = "spine",
			anim_name = "green",
			scale = 2,
			bone_name = "eff_neck"
		},
		{
			z = -1,
			name = "godess_backlight.scsp",
			ani_type = "spine",
			anim_name = "green",
			scale = 2,
			bone_name = "eff_back"
		},
		{
			z = 3,
			name = "godess_aura_green.particle",
			bone_name = "eff_aura",
			ani_type = "particle"
		}
	}
	var_2_0.touchfx_list = {
		{
			bone_name = "eff_orb",
			name = "godess_active_green.cfx"
		}
	}
	
	function var_2_0.afterTouch(arg_3_0)
		SoundEngine:play("event:/battle/obj_statue_heal")
	end
	
	return var_2_0
end

function FIELD_NEW.objectConstruct.sp_heal(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = {}
	
	var_4_0.model_id = "model/godess.scsp"
	var_4_0.anim_name = "blue"
	var_4_0.parts_list = {
		{
			z = 2,
			name = "godess_orb_blue.particle",
			bone_name = "eff_orb",
			ani_type = "particle"
		},
		{
			z = 1,
			name = "godess_necklight.scsp",
			ani_type = "spine",
			anim_name = "blue",
			scale = 2,
			bone_name = "eff_neck"
		},
		{
			z = -1,
			name = "godess_backlight.scsp",
			ani_type = "spine",
			anim_name = "blue",
			scale = 2,
			bone_name = "eff_back"
		},
		{
			z = 3,
			name = "godess_aura_blue.particle",
			bone_name = "eff_aura",
			ani_type = "particle"
		}
	}
	var_4_0.touchfx_list = {
		{
			bone_name = "eff_orb",
			name = "godess_active_blue.cfx"
		}
	}
	
	function var_4_0.afterTouch(arg_5_0)
		SoundEngine:play("event:/battle/obj_statue_heal")
	end
	
	return var_4_0
end

function FIELD_NEW.objectConstruct.soul_heal(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = {}
	
	var_6_0.model_id = "model/godess.scsp"
	var_6_0.anim_name = "blue"
	var_6_0.parts_list = {
		{
			z = 2,
			name = "godess_orb_blue.particle",
			bone_name = "eff_orb",
			ani_type = "particle"
		},
		{
			z = 1,
			name = "godess_necklight.scsp",
			ani_type = "spine",
			anim_name = "blue",
			scale = 2,
			bone_name = "eff_neck"
		},
		{
			z = -1,
			name = "godess_backlight.scsp",
			ani_type = "spine",
			anim_name = "blue",
			scale = 2,
			bone_name = "eff_back"
		},
		{
			z = 3,
			name = "godess_aura_blue.particle",
			bone_name = "eff_aura",
			ani_type = "particle"
		}
	}
	var_6_0.touchfx_list = {
		{
			bone_name = "eff_orb",
			name = "godess_active_blue.cfx"
		}
	}
	
	function var_6_0.afterTouch(arg_7_0)
		SoundEngine:play("event:/battle/obj_statue_heal")
	end
	
	return var_6_0
end

function FIELD_NEW.objectConstruct.gate_chaos(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = {}
	
	var_8_0.model_id = "model/chaosgate.scsp"
	var_8_0.anim_name = "idle"
	var_8_0.offset_y = DESIGN_HEIGHT * 0.2
	var_8_0.parts_list = {
		{
			retain = true,
			name = "chaosgate_part_01.particle",
			ani_type = "particle",
			scale = 0.8,
			z = 2,
			bone_name = "root"
		},
		{
			retain = true,
			name = "chaosgate_eff_01.scsp",
			ani_type = "spine",
			anim_name = "idle",
			z = 1,
			bone_name = "root"
		},
		{
			retain = true,
			name = "chaosgate_eff_02.scsp",
			ani_type = "spine",
			anim_name = "idle",
			z = -1,
			camera_flags = 3,
			bone_name = "root"
		}
	}
	
	function var_8_0.destroy(arg_9_0)
		SoundEngine:play("event:/battle/obj_gate_destroy1")
		Action:Add(SEQ(DMOTION("destroy"), SHOW(false)), arg_9_0, "field.object")
	end
	
	return var_8_0
end

function FIELD_NEW.objectConstruct.gate_cross(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = {}
	
	var_10_0.model_id = "effect/noimage_up.scsp"
	var_10_0.anim_name = "idle"
	var_10_0.offset_y = DESIGN_HEIGHT * 0.2
	var_10_0.parts_list = {}
	
	local var_10_1 = DB("level_stage_1_info", arg_10_1.value, "map_layer")
	
	if var_10_1 and var_10_1 < 0 then
		var_10_0.model_id = "effect/noimage_down.scsp"
		var_10_0.offset_y = var_10_0.offset_y - 300
		var_10_0.isUI = true
		var_10_0.offset_z = 999999
	end
	
	return var_10_0
end

function FIELD_NEW.objectConstruct.gate_portal(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = {}
	
	var_11_0.model_id = "effect/noimage_up.scsp"
	var_11_0.anim_name = "idle"
	var_11_0.offset_y = DESIGN_HEIGHT * 0.2
	var_11_0.parts_list = {}
	
	local var_11_1 = string.split(arg_11_1.value, "_")
	local var_11_2 = ""
	
	if #var_11_1 > 1 then
		for iter_11_0 = 1, #var_11_1 - 1 do
			if string.len(var_11_2) > 0 then
				var_11_2 = var_11_2 .. "_" .. var_11_1[iter_11_0]
			else
				var_11_2 = var_11_1[iter_11_0]
			end
		end
	else
		var_11_2 = ""
	end
	
	local var_11_3 = Battle.logic:getWayDataByPrepend(var_11_2)
	local var_11_4 = Battle.logic:getWayDataByPrepend()
	
	if (DB("level_stage_1_info", var_11_3.map, "map_layer") or 0) <= (DB("level_stage_1_info", var_11_4.map, "map_layer") or 0) then
		var_11_0.model_id = "effect/noimage_down.scsp"
		var_11_0.offset_y = var_11_0.offset_y - 300
		var_11_0.isUI = true
		var_11_0.offset_z = 999999
	end
	
	return var_11_0
end

function FIELD_NEW.objectConstruct.gate_treasure(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = {}
	
	var_12_0.model_id = "model/goblin_gate.scsp"
	var_12_0.anim_name = "idle"
	var_12_0.offset_y = -DESIGN_HEIGHT * 0.1
	var_12_0.parts_list = {}
	
	function var_12_0.destroy(arg_13_0)
		SoundEngine:play("event:/battle/obj_gate_destroy2")
		Action:Add(SEQ(DMOTION("destroy"), SHOW(false)), arg_13_0, "field.object")
	end
	
	return var_12_0
end

function FIELD_NEW.objectConstruct.goblin_return(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = {}
	
	var_14_0.model_id = "model/goblin_gate.scsp"
	var_14_0.anim_name = "create"
	var_14_0.visible = false
	var_14_0.offset_x = -55
	var_14_0.offset_y = 160
	
	function var_14_0.appear(arg_15_0)
		Action:Add(SEQ(SHOW(false), DELAY(500), SHOW(true), DMOTION("create"), MOTION("idle", true)), arg_15_0, "field.object")
	end
	
	return var_14_0
end

function FIELD_NEW.objectConstruct.item_crystal(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = {}
	
	var_16_0.model_id = "model/crystal.scsp"
	var_16_0.anim_name = "idle"
	var_16_0.parts_list = {
		{
			z = 1,
			name = "crystal_idle.particle",
			bone_name = "eff_pos",
			ani_type = "particle"
		},
		{
			z = -1,
			name = "crystal_back.particle",
			bone_name = "eff_pos",
			ani_type = "particle"
		}
	}
	var_16_0.touchfx_list = {
		{
			bone_name = "eff_pos",
			name = "crystal_active.cfx"
		}
	}
	
	function var_16_0.afterTouch(arg_17_0)
		arg_17_0:setCascadeOpacityEnabled(true)
		SoundEngine:play("event:/battle/obj_crystal_destroy")
		Action:Add(SEQ(DELAY(250), OPACITY(400, 1, 0), DELAY(1800), SHOW(false)), arg_17_0, "field.object")
	end
	
	return var_16_0
end

function FIELD_NEW.objectConstruct.box_normal(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = {}
	
	var_18_0.model_id = "model/box_normal.scsp"
	var_18_0.anim_name = arg_18_2.completed and "box_idle_open" or "box_idle"
	var_18_0.flip_x = true
	var_18_0.offScale = 1.1765
	var_18_0.touchfx_list = {
		{
			bone_name = "root",
			name = "electricshock.cfx"
		}
	}
	
	function var_18_0.afterTouch(arg_19_0)
	end
	
	var_18_0.makeShadow = true
	
	return var_18_0
end

function FIELD_NEW.objectConstruct.box_rare(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = {}
	
	var_20_0.model_id = "model/box_gold.scsp"
	var_20_0.anim_name = arg_20_2.completed and "box_idle_open" or "box_idle"
	var_20_0.offScale = 1.3
	var_20_0.flip_x = true
	var_20_0.touchfx_list = {
		{
			bone_name = "root",
			name = "electricshock.cfx"
		}
	}
	var_20_0.makeShadow = true
	
	function var_20_0.visibleAct(arg_21_0, arg_21_1)
		if arg_21_1 then
			EffectManager:Play({
				pivot_x = 60,
				fn = "ui_reward_popup_eff.cfx",
				pivot_y = 130,
				pivot_z = 99998,
				layer = arg_21_0
			})
		end
	end
	
	return var_20_0
end

function FIELD_NEW.objectConstruct.box_rarefix(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = {}
	
	var_22_0.model_id = "model/box_gold.scsp"
	var_22_0.anim_name = arg_22_2.completed and "box_idle_open" or "box_idle"
	var_22_0.offScale = 1.3
	var_22_0.flip_x = true
	var_22_0.touchfx_list = {
		{
			bone_name = "root",
			name = "electricshock.cfx"
		}
	}
	var_22_0.makeShadow = true
	
	function var_22_0.visibleAct(arg_23_0, arg_23_1)
		if arg_23_1 then
			EffectManager:Play({
				pivot_x = 60,
				fn = "ui_reward_popup_eff.cfx",
				pivot_y = 130,
				pivot_z = 99998,
				layer = arg_23_0
			})
		end
	end
	
	return var_22_0
end

function FIELD_NEW.objectConstruct.box_normal_gold(arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = {}
	
	var_24_0.model_id = "model/box_gold.scsp"
	var_24_0.anim_name = "box_idle"
	var_24_0.flip_x = true
	var_24_0.offScale = 1.3
	var_24_0.touchfx_list = {
		{
			bone_name = "root",
			name = "electricshock.cfx"
		}
	}
	var_24_0.makeShadow = true
	
	return var_24_0
end

function FIELD_NEW.objectConstruct.box_monster(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = {}
	
	var_25_0.model_id = "model/mimic.scsp"
	var_25_0.skin = "light"
	var_25_0.anim_name = "box_idle"
	var_25_0.flip_x = true
	var_25_0.offScale = 1.1765
	var_25_0.touchfx_list = {
		{
			bone_name = "root",
			name = "electricshock.cfx"
		}
	}
	var_25_0.makeShadow = true
	
	return var_25_0
end

function FIELD_NEW.objectConstruct.trap(arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = {}
	
	var_26_0.model_id = "model/trap.scsp"
	var_26_0.skin = "skin1"
	var_26_0.anim_name = "idle"
	var_26_0.offset_y = -DESIGN_HEIGHT * 0.3
	
	return var_26_0
end

function FIELD_NEW.objectConstruct.npc(arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = {}
	local var_27_1 = DBT("level_npc", arg_27_2.npc_id, {
		"id",
		"mission_id",
		"model_id",
		"animation",
		"name",
		"face_id",
		"balloon_reverse",
		"balloon_key_before",
		"balloon_key_after",
		"shop_id",
		"shop_count",
		"story_id_before",
		"story_id_after",
		"drop",
		"flag_on",
		"msg_flag_on",
		"skin",
		"offset_x",
		"offset_y"
	})
	
	if not var_27_1 then
		print("#### FIELD_NEW.objectConstruct[ npc ] create failure", arg_27_2.npc_id)
	end
	
	var_27_1.dir = arg_27_2.npc_dir
	var_27_0.model_id = var_27_1.model_id
	var_27_0.skin = var_27_1.skin
	var_27_0.anim_name = var_27_1.animation or "idle"
	var_27_0.offScale = MODEL_SCALE_FACTOR
	var_27_0.makeShadow = true
	var_27_0.offset_x = (var_27_1.offset_x or 0) * var_27_1.dir
	var_27_0.offset_y = var_27_1.offset_y or 0
	var_27_0.info = var_27_1
	
	local function var_27_2()
		local var_28_0 = ""
		local var_28_1 = var_27_1.id
		
		if ((Battle.logic:getRoadEventResults(arg_27_1.event_id) or {})[var_28_1] or 0) < 1 then
			var_28_0 = var_27_1.balloon_key_before or ""
		else
			var_28_0 = var_27_1.balloon_key_after or ""
		end
		
		if var_28_0 == "" then
			return var_28_0
		elseif not DB("text", var_28_0, "text") then
			local var_28_2 = {}
			local var_28_3 = 1
			
			for iter_28_0 = 1, 10 do
				local var_28_4 = var_28_0 .. "_" .. iter_28_0
				
				if DB("text", var_28_4, "text") then
					table.insert(var_28_2, var_28_4)
					
					var_28_3 = iter_28_0
				end
			end
			
			var_28_0 = var_28_2[math.random(1, var_28_3)]
		end
		
		return var_28_0
	end
	
	local function var_27_3(arg_29_0)
		if not get_cocos_refid(arg_29_0) then
			return 
		end
		
		if not get_cocos_refid(arg_29_0:getParent()) then
			return 
		end
		
		UIAction:Remove(arg_29_0)
		
		local var_29_0 = arg_29_0:getParent():getChildByName(get_cocos_refid(arg_29_0))
		
		if get_cocos_refid(var_29_0) then
			var_29_0:removeFromParent()
		end
		
		local var_29_1 = arg_29_0.info
		local var_29_2, var_29_3 = arg_29_0:getBonePosition("top")
		local var_29_4 = var_29_1.balloon_reverse == "y"
		local var_29_5 = var_27_2()
		local var_29_6 = {
			skip_action = true,
			no_fade_out = true,
			width = 315,
			auto_height = true,
			x = arg_29_0:getPositionX(),
			y = arg_29_0:getPositionY() + var_29_3 * BASE_SCALE,
			layer = arg_29_0:getParent(),
			name = T(var_29_1.name),
			face_id = var_29_1.face_id,
			reverse = var_29_4,
			hide_balloon = var_29_5 == "",
			touch_callback = function(arg_30_0, arg_30_1)
				if arg_30_1 ~= 2 then
					return 
				end
				
				Battle:procTouchFieldModel(arg_29_0)
			end
		}
		local var_29_7 = UIUtil:showTalkBalloon2(T(var_29_5), var_29_6)
		
		var_29_7:setName(get_cocos_refid(arg_29_0))
		var_29_7:setVisible(false)
		var_29_7:getChildByName("txt"):setString("")
		
		local var_29_8 = 3000 + utf8len(T(var_29_5)) * 20
		
		UIAction:Add(SEQ(DELAY(500), TARGET(var_29_7, SEQ(SHOW(true), LOG(SCALE(150, 0, 1.1)), DELAY(50), RLOG(SCALE(80, 1.1, 1)), TARGET(var_29_7:getChildByName("txt"), TEXT(T(var_29_5), true)))), DELAY(var_29_8), TARGET(var_29_7, SHOW(false)), TARGET(var_29_7:getChildByName("txt"), TEXT("")), DELAY(1000), CALL(arg_29_0.showBalloon, arg_29_0)), arg_29_0, "npc.balloon" .. get_cocos_refid(arg_29_0))
	end
	
	function var_27_0.appear(arg_31_0)
		arg_31_0.showBalloon = var_27_3
		
		var_27_3(arg_31_0)
	end
	
	return var_27_0
end

function FIELD_NEW.objectConstruct.clear(arg_32_0, arg_32_1, arg_32_2)
	local var_32_0 = {}
	
	var_32_0.model_id = "effect/eff_portal_lobby.scsp"
	var_32_0.anim_name = "loop"
	var_32_0.visible = false
	var_32_0.offset_x = DESIGN_WIDTH * 0
	var_32_0.offset_y = -DESIGN_HEIGHT * 0.2
	var_32_0.offset_z = 999
	var_32_0.offScaleX = 0.65
	var_32_0.offScaleY = 1.1
	
	function var_32_0.appear(arg_33_0)
		local var_33_0, var_33_1 = arg_33_0:getBonePosition("root")
		local var_33_2 = EffectManager:Play({
			x = 30,
			y = 30,
			fn = "obj_portal_lobby_pati.cfx",
			layer = arg_33_0
		})
		
		var_33_2:setScaleX(1.538)
		var_33_2:setScaleY(0.9)
		var_33_2:setScaleFactor(1)
		Action:Add(SEQ(SHOW(false), DELAY(500), SHOW(true), DMOTION("intro"), MOTION("loop", true)), arg_33_0, "field.object")
	end
	
	return var_32_0
end

function FIELD_NEW.objectConstruct.warp(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = {}
	
	var_34_0.model_id = "effect/eff_portal_battle.scsp"
	var_34_0.anim_name = "loop"
	var_34_0.visible = false
	var_34_0.offset_x = DESIGN_WIDTH * 0
	var_34_0.offset_y = -DESIGN_HEIGHT * 0.2
	var_34_0.offset_z = 999
	var_34_0.offScaleX = 0.65
	var_34_0.offScaleY = 1.1
	
	function var_34_0.appear(arg_35_0)
		local var_35_0, var_35_1 = arg_35_0:getBonePosition("root")
		local var_35_2 = EffectManager:Play({
			z = 1,
			fn = "obj_portal_battle_pati1.cfx",
			y = 30,
			x = 30,
			layer = arg_35_0
		})
		
		var_35_2:setScaleX(1.538)
		var_35_2:setScaleY(0.9)
		var_35_2:setScaleFactor(1)
		
		local var_35_3 = EffectManager:Play({
			z = -1,
			fn = "obj_portal_battle_pati2.cfx",
			y = 30,
			x = 30,
			layer = arg_35_0
		})
		
		var_35_3:setScaleX(1.538)
		var_35_3:setScaleY(0.9)
		var_35_3:setScaleFactor(1)
		Action:Add(SEQ(SHOW(false), DELAY(500), SHOW(true), DMOTION("intro"), MOTION("loop", true)), arg_35_0, "field.object")
	end
	
	return var_34_0
end

function FIELD_NEW.objectConstruct.npc_shop(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = {}
	
	if not arg_36_1.value then
		arg_36_1.value = {}
	end
	
	var_36_0.model_id = arg_36_1.value.model_id or "npc_golfim"
	var_36_0.skin = arg_36_1.value.skin
	var_36_0.anim_name = arg_36_1.value.animation or "idle"
	var_36_0.offScale = MODEL_SCALE_FACTOR
	var_36_0.makeShadow = true
	
	function var_36_0.appear(arg_37_0)
	end
	
	return var_36_0
end

function FIELD_NEW.objectConstruct.switch(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = {}
	
	var_38_0.model_id = "model/switch.scsp"
	var_38_0.anim_name = arg_38_2.completed and "finish" or "idle"
	
	function var_38_0.lockTouch(arg_39_0)
		Action:Add(SEQ(MOTION("idle_lock", true)), arg_39_0, "field.object")
	end
	
	return var_38_0
end

function FIELD_NEW.objectConstruct.switch_mel(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = {}
	
	var_40_0.model_id = "effect/switch_mel.scsp"
	var_40_0.anim_name = arg_40_2.completed and "fire_b" or "fire_s"
	var_40_0.touchfx_list = {
		{
			bone_name = "root",
			name = "switch_mel_pati.cfx"
		}
	}
	
	function var_40_0.lockTouch(arg_41_0)
	end
	
	return var_40_0
end

function FIELD_NEW.objectConstruct.obstacle(arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = {}
	
	var_42_0.model_id = "model/obstacle.scsp"
	var_42_0.anim_name = arg_42_2.completed and "Finish" or "idle"
	var_42_0.offset_y = -DESIGN_HEIGHT * 0.2
	
	function var_42_0.lockTouch(arg_43_0)
		Action:Add(SEQ(MOTION("idle", true)), arg_43_0, "field.object")
	end
	
	return var_42_0
end

function FIELD_NEW.getRoadEventModelData(arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = FIELD_NEW.objectConstruct[arg_44_1.type]
	
	if not var_44_0 then
		return 
	end
	
	return var_44_0(arg_44_0, arg_44_1, arg_44_2)
end

function FIELD_NEW.createRoadEventModel(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_0:getRoadEventModelData(arg_45_1, arg_45_2)
	local var_45_1 = arg_45_2.position
	local var_45_2 = DESIGN_HEIGHT * 0.4 + (arg_45_2.position_y or 0)
	local var_45_3 = var_45_0.model_id or ""
	local var_45_4 = var_45_0.anim_name or "animation"
	local var_45_5 = var_45_0.skin
	local var_45_6 = var_45_0.atlas
	local var_45_7 = var_45_0.parts_list or {}
	local var_45_8 = var_45_0.touchfx_list or {}
	local var_45_9 = var_45_0.destroy_list or {}
	local var_45_10 = var_45_0.offset_x or 0
	local var_45_11 = var_45_0.offset_y or 0
	local var_45_12 = var_45_0.offset_z or -998
	local var_45_13 = var_45_0.flip_x
	local var_45_14 = var_45_0.offScale or 1
	local var_45_15 = var_45_0.offScaleX
	local var_45_16 = var_45_0.offScaleY
	local var_45_17 = var_45_0.appear
	local var_45_18 = var_45_0.destroy
	local var_45_19 = var_45_0.afterTouch
	local var_45_20 = var_45_0.lockTouch
	local var_45_21 = var_45_0.visibleAct
	local var_45_22 = var_45_0.makeShadow
	
	if not var_45_0.shadow_anc then
		local var_45_23 = {
			x = 0,
			y = 0
		}
	end
	
	local var_45_24 = var_45_0.isUI
	local var_45_25 = var_45_0.info
	local var_45_26 = true
	local var_45_27 = FIELD_NEW.getVisibleStateAfterComplete(arg_45_1.type, arg_45_2.completed)
	
	if var_45_0.visible == false then
		var_45_27 = var_45_0.visible
	end
	
	if not var_45_3 or string.len(var_45_3) < 1 then
		return 
	end
	
	local var_45_28 = CACHE:getModel({
		ignore_timeline = true,
		model_id = var_45_3,
		model_ani = var_45_4,
		skin = var_45_5,
		atlas = var_45_6
	})
	
	var_45_28:setVisible(var_45_27)
	var_45_28:setPosition(var_45_1 + var_45_10, var_45_2 + var_45_11)
	var_45_28:setLocalZOrder(var_45_12)
	
	if var_45_15 and var_45_16 then
		var_45_15 = var_45_15 or var_45_16 or 1
		var_45_16 = var_45_16 or var_45_15 or 1
		
		var_45_28:setScaleX(var_45_28:getScaleX() * var_45_15 * 0.85)
		var_45_28:setScaleY(var_45_28:getScaleY() * var_45_16 * 0.85)
	else
		var_45_28:setScale(var_45_28:getScale() * var_45_14 * 0.85)
	end
	
	if var_45_22 then
		local var_45_29 = var_45_28:createShadow()
		
		if get_cocos_refid(var_45_29) then
			var_45_29:setVisible(true)
		end
	end
	
	if var_45_13 then
		var_45_28:setScaleX(0 - var_45_28:getScaleX())
	end
	
	var_45_28.info = var_45_25
	var_45_28.child_list = {}
	var_45_28.parts_data = var_45_7
	var_45_28.active_data = var_45_8
	var_45_28.destroy_data = var_45_9
	var_45_28.destroy_type = var_45_18 and true
	
	function var_45_28.detachAll(arg_46_0, arg_46_1)
		for iter_46_0, iter_46_1 in pairs(arg_46_0.parts_data) do
			print(iter_46_1.name, iter_46_1.ref, get_cocos_refid(iter_46_1.ref), not iter_46_1.retain or not arg_46_1)
			
			if (not iter_46_1.retain or arg_46_1) and get_cocos_refid(iter_46_1.ref) and not iter_46_1.ref.skip then
				if iter_46_1.ani_type == "particle" then
					iter_46_1.ref:stop()
					
					if iter_46_1.ref:getParent() then
						iter_46_1.ref:removeFromParent()
					else
						iter_46_1.ref:release()
					end
				elseif iter_46_1.ani_type == "spine" then
					Action:Add(SEQ(DELAY(3000), OPACITY(1000, 1, 0), REMOVE()), iter_46_1.ref, "field.object")
				end
			end
		end
	end
	
	function var_45_28.appearAction(arg_47_0)
		if var_45_17 then
			var_45_17(arg_47_0)
		end
	end
	
	function var_45_28.disableAction(arg_48_0)
		arg_48_0:detachAll()
		
		if var_45_19 then
			var_45_19(arg_48_0)
		end
	end
	
	function var_45_28.lockAction(arg_49_0)
		if var_45_20 then
			var_45_20(arg_49_0)
		end
	end
	
	function var_45_28.activeAction(arg_50_0, arg_50_1, arg_50_2)
		if arg_50_2 then
			return 
		end
		
		for iter_50_0, iter_50_1 in pairs(arg_50_0.active_data) do
			local var_50_0, var_50_1 = arg_50_0:getPosition()
			
			if iter_50_1.bone_name then
				local var_50_2 = arg_50_0:getBoneNode(iter_50_1.bone_name)
				local var_50_3 = var_50_0 + var_50_2:getPositionX() * arg_50_0:getScaleX()
				local var_50_4 = var_50_1 + var_50_2:getPositionY() * arg_50_0:getScaleY()
			else
				local var_50_5 = arg_50_0:getPositionX()
				local var_50_6 = arg_50_0:getPositionY()
			end
			
			local var_50_7 = EffectManager:Play({
				extractNodes = false,
				pivot_x = 0,
				pivot_y = 0,
				pivot_z = 0,
				fn = iter_50_1.name,
				layer = arg_50_1
			})
			
			var_50_7:setScaleFactor(1)
			arg_50_0:getBoneNode(iter_50_1.bone_name):attach(var_50_7, iter_50_1.z or 0)
		end
		
		if arg_45_1.type ~= "npc" and arg_45_1.type ~= "warp" then
			play_curtain(arg_50_1, 0, 300, 1500, 400, "field.object", true, -999, 0.7, cc.c3b(0, 0, 0))
		end
		
		arg_50_0:disableAction()
	end
	
	function var_45_28.destroyAction(arg_51_0, arg_51_1)
		arg_51_0:detachAll(true)
		
		for iter_51_0, iter_51_1 in pairs(arg_51_0.destroy_data) do
			local var_51_0, var_51_1 = arg_51_0:getPosition()
			
			if iter_51_1.bone_name then
				local var_51_2 = arg_51_0:getBoneNode(iter_51_1.bone_name)
				local var_51_3 = var_51_0 + var_51_2:getPositionX() * arg_51_0:getScaleX()
				local var_51_4 = var_51_1 + var_51_2:getPositionY() * arg_51_0:getScaleY()
			else
				local var_51_5 = arg_51_0:getPositionX()
				local var_51_6 = arg_51_0:getPositionY()
			end
			
			local var_51_7 = EffectManager:Play({
				extractNodes = false,
				pivot_x = 0,
				pivot_y = 0,
				pivot_z = 0,
				fn = iter_51_1.name,
				layer = arg_51_1
			})
			
			var_51_7:setScaleFactor(1)
			arg_51_0:getBoneNode(iter_51_1.bone_name):attach(var_51_7, iter_51_1.z or 0)
		end
		
		if var_45_18 then
			play_curtain(arg_51_1, 0, 300, 1500, 400, "field.object", true, -999, 0.7, cc.c3b(0, 0, 0))
			var_45_18(arg_51_0)
		end
	end
	
	function var_45_28.visibleAction(arg_52_0, arg_52_1)
		if var_45_21 then
			var_45_21(arg_52_0, arg_52_1)
		end
	end
	
	for iter_45_0, iter_45_1 in pairs(var_45_28.parts_data) do
		local var_45_30 = var_45_28:getBoneNode(iter_45_1.bone_name)
		local var_45_31 = CACHE:getEffect(iter_45_1.name)
		
		if not var_45_31 then
			print("effect make fail : ", iter_45_1.name)
		end
		
		var_45_31:setScaleFactor(1)
		var_45_30:attach(var_45_31, iter_45_1.z)
		
		if iter_45_1.ani_type == "particle" then
			var_45_31:start()
			var_45_31:setAutoRemoveOnFinish(true)
		elseif iter_45_1.ani_type == "spine" then
			if iter_45_1.scale then
				var_45_31:setScale(iter_45_1.scale)
			end
			
			Action:Add(SEQ(SHOW(true), MOTION(iter_45_1.anim_name, true)), var_45_31, "field.object")
		end
		
		var_45_31:setScaleFactor(1)
		var_45_31:setCameraMask(iter_45_1.camera_flags or 1, true)
		
		var_45_31.skip = iter_45_1.skip
		var_45_28.parts_data[iter_45_0].ref = var_45_31
	end
	
	return var_45_28, var_45_24
end

function FIELD_NEW.setVisibleFieldModel(arg_53_0, arg_53_1, arg_53_2)
	for iter_53_0, iter_53_1 in pairs(arg_53_0.road_event_model_tbl) do
		if get_cocos_refid(iter_53_1) then
			iter_53_1:setVisible(arg_53_1)
			
			if arg_53_2 and iter_53_1.visibleAction then
				iter_53_1:visibleAction(arg_53_1)
			end
		end
	end
end

function FIELD_NEW.getRoadEventFieldModelList(arg_54_0)
	local var_54_0 = {}
	
	for iter_54_0, iter_54_1 in pairs(arg_54_0.road_event_object_list) do
		local var_54_1 = arg_54_0.road_event_model_tbl[iter_54_1]
		
		if get_cocos_refid(var_54_1) and var_54_1:getPositionX() > 0 and iter_54_1.type ~= "clear" then
			table.insert(var_54_0, var_54_1)
		end
	end
	
	return var_54_0
end

function FIELD_NEW.getRoadEventObjectList(arg_55_0, arg_55_1)
	return table.shallow_clone(arg_55_0.road_event_object_list)
end

function FIELD_NEW.getRoadEventObjectByModel(arg_56_0, arg_56_1)
	for iter_56_0, iter_56_1 in pairs(arg_56_0.road_event_object_list) do
		if arg_56_1 == arg_56_0.road_event_model_tbl[iter_56_1] then
			return iter_56_1
		end
	end
end

function FIELD_NEW.getRoadEventFieldModel(arg_57_0, arg_57_1)
	if not arg_57_1 then
		return 
	end
	
	return arg_57_0.road_event_model_tbl[arg_57_1]
end

function FIELD_NEW.getRoadEventFieldModelByName(arg_58_0, arg_58_1)
	for iter_58_0, iter_58_1 in pairs(arg_58_0.road_event_object_list) do
		local var_58_0 = arg_58_0.road_event_model_tbl[iter_58_1]
		
		if get_cocos_refid(var_58_0) and var_58_0:getName() == arg_58_1 then
			return var_58_0
		end
	end
end

function FIELD_NEW.makeRoadEventModel(arg_59_0, arg_59_1, arg_59_2)
	if not arg_59_1 then
		error("road_event_object is nil value")
		
		return 
	end
	
	if not arg_59_2 then
		error("field_info is nil value")
		
		return 
	end
	
	local var_59_0
	local var_59_1 = false
	
	if arg_59_1.type then
		var_59_0, var_59_1 = arg_59_0:createRoadEventModel(arg_59_1, arg_59_2)
	end
	
	if var_59_0 then
		table.insert(arg_59_0.road_event_object_list, arg_59_1)
		
		arg_59_0.road_event_model_tbl[arg_59_1] = var_59_0
		
		arg_59_0.main.layer:addFieldObjectModel(var_59_0)
		
		return var_59_0, var_59_1
	end
	
	return nil
end

function FIELD_NEW.setObjectAnchor(arg_60_0)
	local var_60_0 = arg_60_0.data[arg_60_0.main_land.idx]
	
	if var_60_0 then
		local var_60_1 = arg_60_0.main_land.last_move * var_60_0.layer_width
		
		if math.abs(var_60_1) >= var_60_0.pattern_width then
			var_60_1 = var_60_1 / math.abs(var_60_1) * (math.abs(var_60_1) - var_60_0.pattern_width)
		end
		
		if var_60_1 > 1 then
			if var_60_1 - var_60_0.pattern_width < 0 then
				var_60_1 = var_60_1 - var_60_0.pattern_width
			else
				var_60_1 = 0
			end
		end
		
		local var_60_2 = math.abs(var_60_0.pattern_width)
		local var_60_3 = math.abs(var_60_1)
		
		if var_60_2 <= var_60_3 then
			if var_60_2 / var_60_3 > 0.9 then
				var_60_1 = arg_60_0.prev_move or 0
			else
				var_60_1 = var_60_0.pattern_width + var_60_1
			end
		end
		
		if arg_60_0.prev_move then
			for iter_60_0, iter_60_1 in pairs(arg_60_0.road_event_object_list) do
				local var_60_4 = arg_60_0.road_event_model_tbl[iter_60_1]
				
				if var_60_4 then
					local var_60_5 = var_60_4:getPositionX()
					
					var_60_4:setPositionX(var_60_5 + var_60_1)
				end
			end
		end
		
		BattleDropManager:updateDrops(var_60_1)
		
		arg_60_0.prev_move = var_60_1
	end
end
