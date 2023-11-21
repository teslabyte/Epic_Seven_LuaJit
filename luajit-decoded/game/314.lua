GachaEffect = {}
GachaEffect.EFFECT_LIST = {
	seq1_special = "gacha_effect_2_yellow.cfx",
	seq1_moonlight_moonlight = "gacha_effect_2_violet_violet.cfx",
	seq1_normal_special = "gacha_effect_2_blue_yellow.cfx",
	intro_normal = "gacha_effect_1_blue.cfx",
	seq1_moonlight = "gacha_effect_2_violet.cfx",
	seq1_normal_moonlight = "gacha_effect_2_blue_violet.cfx",
	seq1_base_moonlight = "gacha_effect_2_b_violet.cfx",
	seq2_base = "gacha_effect_3_b.cfx",
	seq1_base_special = "gacha_effect_2_b_yellow.cfx",
	seq1_normal = "gacha_effect_2_blue.cfx",
	seq1_class = "gacha_effect_2_class.cfx",
	intro_special_eff = "gacha_effect_1_yellow2.cfx",
	seq2_whitecover = "gacha_effect_3_f.cfx",
	seq2_bone_artifact = "gacha_effect_3_artifact_bone.cfx",
	seq1_base_normal = "gacha_effect_2_b_blue.cfx",
	seq1_special_special = "gacha_effect_2_yellow_yellow.cfx",
	seq2_bone1 = "gacha_effect_3_character_bone.cfx",
	seq2_bone2 = "gacha_effect_3_portrait_bone.cfx",
	intro_moonlight = "gacha_effect_1_violet1.cfx",
	seq1_moonlight_particle = "gacha_effect_2_violet_pat.cfx",
	seq1_special_particle = "gacha_effect_2_yellow_pat.cfx",
	intro_moonlight_eff = "gacha_effect_1_violet2.cfx",
	intro_special = "gacha_effect_1_yellow1.cfx",
	seq1_special_moonlight = "gacha_effect_2_yellow_violet.cfx"
}
GachaEffect.SOUND_LIST = {
	intro_start_moonlight_4 = "gocha_effect_01_rare_moonlight",
	intro_start_special_4 = "gocha_effect_01_rare",
	seq1_start = "gocha_effect_03",
	seq1_end_fake_special_5 = "gocha_effect_04_fake_special2",
	seq1_end_fake_special_4 = "gocha_effect_04_fake_rare",
	seq1_end_special_5 = "gocha_effect_04_special",
	seq1_end_special_4 = "gocha_effect_04_rare",
	intro_end_normal = "gocha_effect_02",
	intro_end_normal_moonlight = "gocha_effect_02_moonlight",
	intro_start_normal = "gocha_effect_01_normal",
	intro_start_moonlight_5 = "gocha_effect_01_special_moonlight",
	intro_start_special_5 = "gocha_effect_01_special",
	seq1_end_normal = "gocha_effect_04_normal",
	seq2_start = "gocha_effect_05"
}

function GachaEffect.PlaySound(arg_1_0, arg_1_1)
	local var_1_0 = GachaEffect.SOUND_LIST[arg_1_1]
	
	if var_1_0 then
		print("sound_name?", var_1_0)
		
		return SoundEngine:play("event:/ui/gacha_new/" .. var_1_0)
	else
		print("GachaEffect.PlaySound: sound not found. type = " .. arg_1_1)
	end
end

function GachaEffect.PlaySoundByGrade(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = arg_2_1
	
	if arg_2_1 == "intro_start" then
		if arg_2_2 == 4 then
			if arg_2_3 then
				var_2_0 = "intro_start_moonlight_4"
			else
				var_2_0 = "intro_start_special_4"
			end
		elseif arg_2_2 == 5 then
			if arg_2_3 then
				var_2_0 = "intro_start_moonlight_5"
			else
				var_2_0 = "intro_start_special_5"
			end
		else
			var_2_0 = "intro_start_normal"
		end
	elseif arg_2_1 == "intro_end" then
		if arg_2_3 then
			var_2_0 = "intro_end_normal_moonlight"
		else
			var_2_0 = "intro_end_normal"
		end
	elseif arg_2_1 == "seq1_start" then
		var_2_0 = "seq1_start"
	elseif arg_2_1 == "seq1_end" then
		if arg_2_4 == 5 then
			if arg_2_2 ~= arg_2_4 then
				var_2_0 = "seq1_end_fake_special_5"
			else
				var_2_0 = "seq1_end_special_5"
			end
		elseif arg_2_4 == 4 then
			if arg_2_2 ~= arg_2_4 then
				var_2_0 = "seq1_end_fake_special_4"
			else
				var_2_0 = "seq1_end_special_4"
			end
		else
			var_2_0 = "seq1_end_normal"
		end
	elseif arg_2_1 == "seq2_start" then
		var_2_0 = "seq2_start"
	end
	
	return arg_2_0:PlaySound(var_2_0)
end

function GachaEffect.GetEffect(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = GachaEffect.EFFECT_LIST[arg_3_2]
	
	if not var_3_0 then
		print("not exist type : ", arg_3_2)
	end
	
	print("eff_name?", var_3_0)
	
	local var_3_1 = EffectManager:Play({
		fn = var_3_0,
		layer = arg_3_1
	})
	
	var_3_1:setPosition(VIEW_WIDTH / 2 + VIEW_BASE_LEFT, VIEW_HEIGHT / 2)
	
	return var_3_1
end

local function var_0_0(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = ""
	
	if arg_4_1 == 3 then
		var_4_0 = arg_4_0 .. "_normal"
	elseif arg_4_2 and (arg_4_1 == 4 or arg_4_1 == 5) then
		var_4_0 = arg_4_0 .. "_moonlight"
	elseif arg_4_1 == 4 or arg_4_1 == 5 then
		var_4_0 = arg_4_0 .. "_special"
	end
	
	if arg_4_1 == 5 and not arg_4_3 then
		var_4_0 = var_4_0 .. "_eff"
	end
	
	return var_4_0
end

function GachaEffect.GetEffectByGrade(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8)
	local var_5_0 = var_0_0(arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	
	if arg_5_6 and arg_5_8 and (arg_5_3 ~= arg_5_6 or arg_5_4 ~= arg_5_7) then
		var_5_0 = var_0_0(var_5_0, arg_5_6, arg_5_7, arg_5_5)
	end
	
	return arg_5_0:GetEffect(arg_5_1, var_5_0)
end

function GachaEffect.CreateBG(arg_6_0, arg_6_1)
	arg_6_0:GetEffect(arg_6_1, "seq2_base"):setLocalZOrder(50)
end

function GachaEffect.CreateSeq(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = {}
	
	copy_functions(GachaEffect, var_7_0)
	var_7_0:init(arg_7_1, arg_7_2)
	
	return var_7_0
end

function GachaEffect.init(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	arg_8_0.grandparent = arg_8_1
	arg_8_0.callbacks = arg_8_2
	arg_8_0.seq_start_tm = 0
	
	arg_8_0:recreateParent()
end

function GachaEffect.recreateParent(arg_9_0)
	arg_9_0.parent = cc.Node:create()
	
	arg_9_0.parent:setLocalZOrder(50)
	arg_9_0.grandparent:addChild(arg_9_0.parent)
end

function GachaEffect.setup(arg_10_0, arg_10_1)
	arg_10_0.code = arg_10_1
	
	if DB("character", arg_10_1, "id") ~= nil then
		local var_10_0, var_10_1, var_10_2 = DB("character", arg_10_0.code, {
			"grade",
			"moonlight",
			"role"
		})
		
		arg_10_0.original_grade = var_10_0
		arg_10_0.original_moonlight = var_10_1 == "y"
		arg_10_0.show_grade = arg_10_0.original_grade
		arg_10_0.show_moonlight = arg_10_0.original_moonlight
		arg_10_0.is_unit = true
		arg_10_0.role = var_10_2
	else
		local var_10_3 = DB("equip_item", arg_10_0.code, "artifact_grade")
		
		arg_10_0.original_grade = var_10_3
		arg_10_0.show_grade = var_10_3
		arg_10_0.show_moonlight = false
		arg_10_0.original_moonlight = false
		arg_10_0.is_unit = false
		arg_10_0.role = "artifact"
	end
end

function GachaEffect.getSkipableTm(arg_11_0)
	if arg_11_0.is_intro then
		return 1500
	end
	
	if arg_11_0.original_grade == 3 and not arg_11_0.is_new then
		return 0
	end
	
	if arg_11_0.show_grade ~= arg_11_0.original_grade or arg_11_0.show_moonlight ~= arg_11_0.original_moonlight then
		return 4000
	end
	
	return 3000
end

function GachaEffect.getSeqStartAfterTm(arg_12_0)
	return uitick() - arg_12_0.seq_start_tm
end

function GachaEffect.isSkipable(arg_13_0)
	return arg_13_0:getSeqStartAfterTm() > arg_13_0:getSkipableTm()
end

function GachaEffect.begin(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0.seq_start_tm = 0
	
	if arg_14_2 ~= nil and arg_14_2 ~= "intro" then
		arg_14_0.is_intro = false
	else
		arg_14_0.is_intro = true
	end
	
	arg_14_0.is_seq1 = false
	arg_14_0.is_seq2 = false
	
	arg_14_0:setup(arg_14_1)
	
	if not arg_14_2 then
		arg_14_0:intro()
		SoundEngine:playBGM("event:/bgm/summon_efx")
	else
		arg_14_0[arg_14_2](arg_14_0)
	end
end

function GachaEffect.removeAll(arg_15_0)
	if not arg_15_0.parent or not get_cocos_refid(arg_15_0.parent) then
		return 
	end
	
	arg_15_0.parent:removeFromParent()
	Scheduler:removeByName("GachaEffectTexture")
end

function GachaEffect.isSeq1(arg_16_0)
	return arg_16_0.is_seq1
end

function GachaEffect.removeCurSound(arg_17_0)
	if arg_17_0.cur_sound and get_cocos_refid(arg_17_0.cur_sound) then
		arg_17_0.cur_sound:setVolume(0)
	end
end

function GachaEffect.requestSkip(arg_18_0, arg_18_1)
	if arg_18_0.is_seq2 == true then
		return 
	end
	
	Action:Remove("gacha_effect")
	arg_18_0:removeCurSound()
	
	if get_cocos_refid(arg_18_0.parent) then
		arg_18_0.parent:removeAllChildren()
	else
		arg_18_0:recreateParent()
	end
	
	if arg_18_0.is_intro and not arg_18_0.is_seq2 and not arg_18_1 then
		arg_18_0:seq1()
	else
		arg_18_0:seq2()
	end
end

function GachaEffect.isValid(arg_19_0)
	return arg_19_0.parent ~= nil and get_cocos_refid(arg_19_0.parent) ~= nil
end

function GachaEffect.intro(arg_20_0)
	arg_20_0.is_intro = true
	arg_20_0.seq_start_tm = uitick()
	
	if arg_20_0.callbacks.onGetFakeIntro then
		local var_20_0 = arg_20_0.callbacks.onGetFakeIntro()
		
		arg_20_0.show_grade = var_20_0.show_grade or arg_20_0.original_grade
		
		if var_20_0.show_moonlight == false then
			arg_20_0.show_moonlight = false
		else
			arg_20_0.show_moonlight = var_20_0.show_moonlight or arg_20_0.original_moonlight
		end
	end
	
	arg_20_0.cur_sound = arg_20_0:PlaySoundByGrade("intro_start", arg_20_0.show_grade, arg_20_0.show_moonlight)
	
	local var_20_1 = arg_20_0:GetEffectByGrade(arg_20_0.parent, "intro", arg_20_0.show_grade, arg_20_0.show_moonlight):getDuration()
	local var_20_2 = 1000
	
	Action:Add(SEQ(DELAY(var_20_2), CALL(function()
		arg_20_0.cur_sound = arg_20_0:PlaySoundByGrade("intro_end", arg_20_0.show_grade, arg_20_0.show_moonlight)
	end), DELAY(var_20_1 * 1000 - var_20_2), CALL(GachaEffect.seq1, arg_20_0)), arg_20_0.parent, "gacha_effect")
	
	if arg_20_0.callbacks and arg_20_0.callbacks.onIntro then
		arg_20_0.callbacks:onIntro(arg_20_0, arg_20_0.parent)
	end
end

function GachaEffect.CreateBiblika(arg_22_0)
	local var_22_0 = ur.Model:create("spani/biblika_node.scsp", "spani/biblika_node.atlas", 1)
	
	var_22_0:setPosition(1000, 720)
	var_22_0:setVisible(true)
	var_22_0:setAnimation(0, "45star", false)
	var_22_0:setTimeScale(0.8)
	var_22_0:update(math.random())
	
	local var_22_1 = var_22_0:getBoneNode("node")
	
	var_22_1:setInheritScale(true)
	var_22_1:setInheritRotation(true)
	
	local var_22_2 = ur.Model:create("portrait/npc1026.scsp", "portrait/npc1026.atlas", 1)
	
	var_22_2:setPosition(0, 0)
	var_22_2:setScale(1.2)
	var_22_2:setAnimation(0, "action_00", true)
	var_22_2:update(math.random())
	var_22_1:attach(var_22_2)
	
	local var_22_3 = UIUtil:playNPCSound("gacha_special_1")
	local var_22_4 = UIUtil:showTalkBalloon(T(var_22_3), {
		reverse_y = true,
		offset_y = -3,
		auto_height = true,
		y = 350,
		reverse = false,
		x = 100,
		layer = var_22_2
	})
	
	return var_22_0, var_22_2, var_22_4
end

function GachaEffect.popBiblika(arg_23_0, arg_23_1)
	local var_23_0, var_23_1, var_23_2 = arg_23_0:CreateBiblika()
	
	arg_23_0.biblika_node = var_23_0
	arg_23_0.biblika = var_23_1
	arg_23_0.biblika_talk_balloon = var_23_2
	
	arg_23_1:addChild(var_23_0, 99999)
end

function GachaEffect.CreateBiblio(arg_24_0)
	local var_24_0 = ur.Model:create("spani/biblio_node.scsp", "spani/biblio_node.atlas", 1)
	
	var_24_0:setPosition(280, 720)
	var_24_0:setVisible(true)
	var_24_0:setAnimation(0, "45star", false)
	var_24_0:setTimeScale(0.8)
	var_24_0:update(math.random())
	
	local var_24_1 = var_24_0:getBoneNode("node")
	
	var_24_1:setInheritScale(true)
	var_24_1:setInheritRotation(true)
	
	local var_24_2 = ur.Model:create("portrait/npc1027.scsp", "portrait/npc1027.atlas", 1)
	
	var_24_2:setPosition(0, 0)
	var_24_2:setScale(1.2)
	var_24_2:setAnimation(0, "action_00", true)
	var_24_2:update(math.random())
	var_24_1:attach(var_24_2)
	
	local var_24_3 = UIUtil:playNPCSound("gacha_special_2")
	local var_24_4 = UIUtil:showTalkBalloon(T(var_24_3), {
		reverse_y = true,
		offset_y = -3,
		auto_height = true,
		y = 350,
		reverse = true,
		x = -150,
		layer = var_24_2
	})
	
	return var_24_0, var_24_2, var_24_4
end

function GachaEffect.popBiblio(arg_25_0, arg_25_1)
	local var_25_0, var_25_1, var_25_2 = arg_25_0:CreateBiblio()
	
	arg_25_0.biblio_node = var_25_0
	arg_25_0.biblio = var_25_1
	arg_25_0.biblika_talk_balloon = var_25_2
	
	arg_25_1:addChild(var_25_0, 99999)
end

function GachaEffect.seq1(arg_26_0)
	arg_26_0.is_intro = false
	arg_26_0.is_seq1 = true
	arg_26_0.seq_start_tm = uitick()
	
	if arg_26_0.callbacks.onGetFakeEffect then
		local var_26_0 = arg_26_0.callbacks.onGetFakeEffect() or {}
		
		arg_26_0.show_grade = var_26_0.show_grade or arg_26_0.original_grade
		
		if var_26_0.show_moonlight == false then
			arg_26_0.show_moonlight = false
		else
			arg_26_0.show_moonlight = var_26_0.show_moonlight or arg_26_0.original_moonlight
		end
	end
	
	if arg_26_0.callbacks.onGetIsNew then
		arg_26_0.is_new = arg_26_0.callbacks:onGetIsNew()
	end
	
	local var_26_1 = cc.Node:create()
	
	var_26_1:setName("seq1")
	
	arg_26_0.cur_sound = arg_26_0:PlaySoundByGrade("seq1_start", arg_26_0.show_grade, arg_26_0.show_moonlight)
	
	arg_26_0:GetEffectByGrade(var_26_1, "seq1_base", arg_26_0.show_grade, arg_26_0.show_moonlight, true, arg_26_0.original_grade, arg_26_0.original_moonlight)
	
	local var_26_2 = arg_26_0:GetEffect(var_26_1, "seq1_class"):getPrimitiveNode("gacha_eff_2_figure")
	
	tolua.cast(var_26_2, "sp.SkeletonAnimation"):setAnimation(0, arg_26_0.role, false)
	
	local var_26_3 = arg_26_0:GetEffectByGrade(var_26_1, "seq1", arg_26_0.show_grade, arg_26_0.show_moonlight, true, arg_26_0.original_grade, arg_26_0.original_moonlight, true)
	
	if arg_26_0.skip_btn_visible_req then
		local var_26_4 = load_dlg("gacha_skip_btn", true, "wnd")
		
		var_26_1:addChild(var_26_4)
	end
	
	arg_26_0.parent:addChild(var_26_1)
	
	local var_26_5 = arg_26_0.show_grade ~= arg_26_0.original_grade or arg_26_0.show_moonlight ~= arg_26_0.original_moonlight
	local var_26_6 = 2400
	
	Action:Add(SEQ(DELAY(var_26_6), CALL(function()
		arg_26_0.cur_sound = arg_26_0:PlaySoundByGrade("seq1_end", arg_26_0.show_grade, arg_26_0.show_moonlight, arg_26_0.original_grade)
	end)), arg_26_0.parent, "gacha_effect")
	
	if var_26_5 then
		var_26_6 = 3200
	end
	
	if arg_26_0.original_grade == 5 then
		local var_26_7 = 0
		local var_26_8 = var_26_6 - var_26_7
		
		local function var_26_9()
			if arg_26_0.is_unit then
				arg_26_0:popBiblio(var_26_1)
			else
				arg_26_0:popBiblika(var_26_1)
			end
		end
		
		if arg_26_0.original_moonlight then
			Action:Add(SEQ(DELAY(var_26_8), CALL(var_26_9), DELAY(var_26_7), CALL(function()
				arg_26_0:GetEffect(var_26_1, "seq1_moonlight_particle")
			end)), arg_26_0.parent, "gacha_effect")
		else
			Action:Add(SEQ(DELAY(var_26_8), CALL(var_26_9), DELAY(var_26_7), CALL(function()
				arg_26_0:GetEffect(var_26_1, "seq1_special_particle")
			end)), arg_26_0.parent, "gacha_effect")
		end
	end
	
	local var_26_10 = 3800
	local var_26_11 = TARGET(var_26_1, REMOVE())
	
	if var_26_5 then
		var_26_10 = 4766
		var_26_11 = DELAY(0)
	end
	
	Action:Add(SEQ(DELAY(var_26_10), var_26_11, CALL(GachaEffect.seq2, arg_26_0)), arg_26_0.parent, "gacha_effect")
	
	if arg_26_0.callbacks and arg_26_0.callbacks.onSeq1 then
		arg_26_0.callbacks:onSeq1(arg_26_0, arg_26_0.parent)
	end
end

function GachaEffect.createShadow(arg_31_0, arg_31_1)
	local var_31_0 = 512
	local var_31_1 = 512
	local var_31_2 = cc.Node:create()
	local var_31_3 = CACHE:getModel(arg_31_1.db)
	
	var_31_3:setRotation(-180)
	var_31_3:setScale(2)
	var_31_3:setScaleX(var_31_3:getScale() * -1)
	var_31_3:setPosition(var_31_0 / 2, var_31_1 / 2)
	setBlendColor2(var_31_3, "def", cc.c4f(-1, -1, -1, 1), 1)
	var_31_2:addChild(var_31_3)
	var_31_2:setVisible(false)
	arg_31_0.parent:addChild(var_31_2)
	
	local var_31_4 = cc.RenderTexture:create(var_31_0, var_31_1, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	
	var_31_4:clear(0, 0, 0, 0)
	Scheduler:add(arg_31_0.parent, function()
		if not get_cocos_refid(var_31_4) or not get_cocos_refid(var_31_3) then
			return 
		end
		
		var_31_4:beginWithClear(0, 0, 0, 0)
		var_31_3:visit()
		var_31_4:endToLua()
	end):setName("GachaEffectTexture")
	var_31_4:getSprite():setOpacity(153)
	
	return var_31_4
end

function GachaEffect.setSkipButtonVisibleRequire(arg_33_0, arg_33_1)
	arg_33_0.skip_btn_visible_req = arg_33_1
end

function GachaEffect.settingSeq2CharacterBone(arg_34_0, arg_34_1, arg_34_2, arg_34_3)
	local var_34_0 = arg_34_0:GetEffect(arg_34_1, "seq2_bone1"):getPrimitiveNode("gacha_eff_3_character_bone")
	local var_34_1 = tolua.cast(var_34_0, "sp.SkeletonAnimation"):getBoneNode("character_small")
	
	var_34_1:attach(arg_34_2)
	
	if arg_34_3 then
		var_34_1:attach(arg_34_0:createShadow(arg_34_3))
	end
	
	var_34_1:setInheritScale(true)
	var_34_1:setInheritRotation(true)
end

function GachaEffect.settingSeq2PortraitBone(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0:GetEffect(arg_35_1, "seq2_bone2"):getPrimitiveNode("gacha_eff_3_portrait_bone")
	local var_35_1 = tolua.cast(var_35_0, "sp.SkeletonAnimation"):getBoneNode("character_big")
	
	var_35_1:setInheritScale(true)
	var_35_1:setInheritRotation(true)
	var_35_1:attach(arg_35_2)
end

function GachaEffect.settingSeq2ArtifactBone(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_0:GetEffect(arg_36_1, "seq2_bone_artifact"):getPrimitiveNode("gacha_eff_3_artifact_bone")
	local var_36_1 = tolua.cast(var_36_0, "sp.SkeletonAnimation"):getBoneNode("portrait")
	
	var_36_1:setInheritScale(true)
	var_36_1:setInheritRotation(true)
	var_36_1:attach(arg_36_2)
end

function GachaEffect.seq2(arg_37_0)
	arg_37_0.seq_start_tm = uitick()
	arg_37_0.is_intro = false
	arg_37_0.is_seq1 = false
	arg_37_0.is_seq2 = true
	
	local var_37_0 = cc.Node:create()
	
	var_37_0:setName("seq2_base")
	arg_37_0:GetEffect(var_37_0, "seq2_base")
	
	if arg_37_0.is_unit then
		local var_37_1 = UNIT:create({
			code = arg_37_0.code
		})
		local var_37_2 = CACHE:getModel(var_37_1.db)
		
		arg_37_0:settingSeq2CharacterBone(var_37_0, var_37_2, var_37_1)
		
		local var_37_3 = UIUtil:getPortraitAni(var_37_1)
		
		var_37_3:setScale(2.8)
		UIUtil:setPortraitPositionByFaceBone(var_37_3)
		arg_37_0:settingSeq2PortraitBone(var_37_0, var_37_3)
	else
		local var_37_4 = load_control("wnd/artifact_card.csb")
		local var_37_5 = {
			wnd = var_37_4,
			equip = EQUIP:createByInfo({
				code = arg_37_0.code
			})
		}
		
		var_37_5.no_resize = true
		var_37_5.no_resize_name = true
		var_37_5.txt_name = var_37_5.wnd:getChildByName("txt_name")
		
		ItemTooltip:updateItemInformation(var_37_5)
		var_37_4:setAnchorPoint(0.5, 0.5)
		var_37_4:setScale(2.2)
		var_37_4:setPositionY(0)
		arg_37_0:settingSeq2ArtifactBone(var_37_0, var_37_4)
	end
	
	arg_37_0:GetEffect(var_37_0, "seq2_whitecover")
	arg_37_0.parent:addChild(var_37_0)
	
	if arg_37_0.callbacks and arg_37_0.callbacks.onSeq2 then
		arg_37_0.callbacks:onSeq2(arg_37_0, arg_37_0.parent)
	end
end
