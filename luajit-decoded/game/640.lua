ArenaNetCard = {}
ArenaNetCardMini = {}

function HANDLER.pvplive_draft_card(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_select" then
		arg_1_0.parent:select()
	end
end

function ArenaNetCard.create(arg_2_0, arg_2_1)
	local var_2_0 = load_control("wnd/pvplive_draft_card.csb")
	
	copy_functions(ArenaNetCard, var_2_0)
	var_2_0:init(arg_2_1)
	
	return var_2_0
end

function ArenaNetCard.init(arg_3_0, arg_3_1)
	arg_3_1 = arg_3_1 or {}
	arg_3_0.slot_id = arg_3_1.slot_id
	arg_3_0.draft_card_id = arg_3_1.draft_card_id
	arg_3_0.callback = arg_3_1.callback
	
	arg_3_0:cache()
	arg_3_0:make_template_unit()
	arg_3_0:updateUI()
	arg_3_0:updateMode(arg_3_1.mode)
end

function ArenaNetCard.cache(arg_4_0)
	arg_4_0.info_node = arg_4_0:getChildByName("n_info")
	arg_4_0.arti_node = arg_4_0:getChildByName("n_item_art")
	arg_4_0.private_node = arg_4_0:getChildByName("n_skill")
	arg_4_0.portrait_node = arg_4_0:getChildByName("n_port")
	arg_4_0.stat_node = arg_4_0:getChildByName("n_stat")
	arg_4_0.talent_node = arg_4_0:getChildByName("n_talent")
	arg_4_0.img_pick = arg_4_0:getChildByName("img_pick")
	arg_4_0:getChildByName("btn_select").parent = arg_4_0
end

function ArenaNetCard.select(arg_5_0)
	if arg_5_0.callback then
		arg_5_0.callback(arg_5_0.slot_id, arg_5_0.draft_card_id)
	end
end

function ArenaNetCard.onSelect(arg_6_0, arg_6_1)
	if arg_6_1 then
		arg_6_0.img_pick:setVisible(false)
		
		if not UIAction:Find("n_selecting" .. tostring(arg_6_0.slot_id)) then
			UIAction:Add(SEQ(LOOP(SEQ(FADE_IN(500), DELAY(200), FADE_OUT(500), DELAY(150)))), arg_6_0.img_pick, "n_selecting" .. tostring(arg_6_0.slot_id))
		end
	else
		arg_6_0.img_pick:setVisible(false)
		UIAction:Remove("n_selecting" .. tostring(arg_6_0.slot_id))
	end
end

function ArenaNetCard.onPick(arg_7_0)
	arg_7_0.img_pick:setVisible(true)
	arg_7_0.img_pick:setOpacity(255)
	UIAction:Remove("n_selecting" .. tostring(arg_7_0.slot_id))
end

function ArenaNetCard.onDiscard(arg_8_0)
	local var_8_0 = arg_8_0.portrait
	local var_8_1 = cc.GLProgramCache:getInstance():getGLProgram("GraySkeletonRenderer")
	
	if var_8_1 and get_cocos_refid(var_8_0) then
		local var_8_2 = cc.GLProgramState:create(var_8_1)
		
		if var_8_2 and var_8_0.body then
			var_8_0.body:setDefaultGLProgramState(var_8_2)
			var_8_0.body:setGLProgramState(var_8_2)
		else
			var_8_0:setDefaultGLProgramState(var_8_2)
			var_8_0:setGLProgramState(var_8_2)
		end
	end
	
	local var_8_3 = cc.RenderTexture:create(arg_8_0:getContentSize().width, arg_8_0:getContentSize().height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	
	var_8_3:clear(0, 0, 0, 0)
	var_8_3:retain()
	arg_8_0.talent_node:ejectFromParent()
	arg_8_0.stat_node:ejectFromParent()
	var_8_3:begin()
	arg_8_0.info_node:visit()
	var_8_3:endToLua()
	var_8_3:setAnchorPoint(0, 0)
	var_8_3:getSprite():setAnchorPoint(0, 0)
	arg_8_0.info_node:setVisible(false)
	arg_8_0:addChild(var_8_3)
	arg_8_0:addChild(arg_8_0.talent_node)
	arg_8_0:addChild(arg_8_0.stat_node)
	arg_8_0.stat_node:setVisible(arg_8_0.mode == "stat")
	arg_8_0.talent_node:setVisible(arg_8_0.mode ~= "stat")
	
	local var_8_4 = cc.GLProgramCache:getInstance():getGLProgram("sprite_grayscale")
	
	if var_8_4 then
		local var_8_5 = cc.GLProgramState:create(var_8_4)
		
		if var_8_5 then
			var_8_5:setUniformFloat("u_ratio", 1)
			var_8_3:getSprite():setDefaultGLProgramState(var_8_5)
			var_8_3:getSprite():setGLProgramState(var_8_5)
		end
	end
	
	var_8_3:setCascadeOpacityEnabled(true)
	
	local var_8_6 = arg_8_0:getChildByName("n_frame")
	
	if get_cocos_refid(var_8_6) then
		local var_8_7 = cc.LayerColor:create(cc.c3b(0, 0, 0))
		
		var_8_7:setOpacity(178.5)
		var_8_7:setContentSize(var_8_6:getContentSize())
		var_8_7:setPosition(var_8_6:getPosition())
		arg_8_0:addChild(var_8_7)
	end
end

function ArenaNetCard.make_template_unit(arg_9_0)
	local var_9_0 = DBT(DRAFT_DB_NAME, tostring(arg_9_0.draft_card_id), {
		"character_id",
		"stat_id",
		"set_op_id",
		"arti_id",
		"exc_id",
		"memory",
		"hero_tag_desc",
		"hero_info_desc"
	})
	local var_9_1 = DBT(DRAFT_DB_STAT, var_9_0.stat_id, {
		"att",
		"max_hp",
		"def",
		"speed",
		"att_rate",
		"max_hp_rate",
		"def_rate",
		"cri",
		"cri_dmg",
		"acc",
		"res"
	})
	local var_9_2 = var_9_0.character_id
	local var_9_3 = make_template_unit(1, arg_9_0.draft_card_id, var_9_2)
	local var_9_4 = {
		set_op_id = string.split(var_9_0.set_op_id, ","),
		arti_id = var_9_0.arti_id,
		exc_id = var_9_0.exc_id,
		memory = var_9_0.memory,
		status = {},
		rate = {},
		hero_tag = var_9_0.hero_tag_desc,
		hero_desc = var_9_0.hero_info_desc
	}
	
	for iter_9_0, iter_9_1 in pairs(var_9_1) do
		if string.sub(iter_9_0, -5, -1) == "_rate" then
			var_9_4.rate[iter_9_0] = iter_9_1
		else
			var_9_4.status[iter_9_0] = iter_9_1
		end
	end
	
	local var_9_5 = UNIT:create({
		code = var_9_2
	})
	
	var_9_3.s[1] = var_9_5:getMaxSkillLevelByIndex(1)
	var_9_3.s[2] = var_9_5:getMaxSkillLevelByIndex(2)
	var_9_3.s[3] = var_9_5:getMaxSkillLevelByIndex(3)
	arg_9_0.template_info = {}
	arg_9_0.template_info.unit = var_9_3
	arg_9_0.template_info.template_status = var_9_4
	arg_9_0.unit = UNIT:create(table.clone(arg_9_0.template_info.unit))
	
	appy_template_status(arg_9_0.unit, arg_9_0.template_info.template_status)
	
	arg_9_0.unit.template_id = arg_9_0.draft_card_id
	
	arg_9_0.unit:setUnitOptionValue("imprint_focus", var_9_0.memory)
	arg_9_0.unit:calc()
end

function ArenaNetCard.updateMode(arg_10_0, arg_10_1)
	if arg_10_0.mode == arg_10_1 then
		return 
	end
	
	arg_10_0.mode = arg_10_1
	
	if arg_10_1 == "stat" then
		arg_10_0.stat_node:setVisible(true)
		arg_10_0.talent_node:setVisible(false)
	else
		arg_10_0.stat_node:setVisible(false)
		arg_10_0.talent_node:setVisible(true)
	end
end

function ArenaNetCard.updateUI(arg_11_0)
	local var_11_0 = arg_11_0.unit:getStat()
	local var_11_1 = arg_11_0.unit:getStatus()
	
	if_set(arg_11_0.info_node, "txt_name", arg_11_0.unit:getName())
	arg_11_0:updateStat(var_11_1)
	arg_11_0:updateEquip()
	arg_11_0:updatePortrait()
	arg_11_0:updateDesc()
end

function ArenaNetCard.updateStat(arg_12_0, arg_12_1)
	local function var_12_0(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
		if FORMULA.isMoreThanStatLimit(arg_13_3, arg_13_2[arg_13_3]) then
			if_set_color(arg_13_0, arg_13_1, arg_12_0.ORANGE)
		else
			if_set_color(arg_13_0, arg_13_1, arg_12_0.WHITE)
		end
	end
	
	local var_12_1 = arg_12_0.info_node:getChildByName("n_stat")
	
	if_set(var_12_1, "txt_att", arg_12_1.att)
	if_set(var_12_1, "txt_def", arg_12_1.def)
	if_set(var_12_1, "txt_maxhp", arg_12_1.max_hp)
	if_set(var_12_1, "txt_spd", arg_12_1.speed)
	if_set(var_12_1, "txt_cri", arg_12_1.cri, false, "ratioExpand")
	if_set(var_12_1, "txt_cridmg", arg_12_1.cri_dmg, false, "ratioExpand")
	if_set(var_12_1, "txt_con", arg_12_1.acc, false, "ratioExpand")
	if_set(var_12_1, "txt_res", arg_12_1.res, false, "ratioExpand")
	if_set(var_12_1, "txt_coop", arg_12_1.coop, false, "ratioExpand")
end

local function var_0_0(arg_14_0, arg_14_1)
	if not arg_14_1 then
		return 
	end
	
	local var_14_0 = string.sub(arg_14_1, -1, -1)
	local var_14_1 = string.sub(arg_14_1, 1, -4)
	local var_14_2 = "ex" .. string.sub(arg_14_1, 4, -4)
	local var_14_3 = DB("skill_equip", arg_14_1, "exc_number")
	local var_14_4 = UIUtil:getSkillIcon(arg_14_0, var_14_3, {
		skill_lv = 0,
		no_tooltip = true,
		notMyUnit = true,
		show_exclusive_target = var_14_0
	})
	
	WidgetUtils:setupTooltip({
		delay = 130,
		control = var_14_4,
		creator = function()
			local var_15_0 = DB("equip_item", var_14_2, "main_stat")
			local var_15_1, var_15_2 = DB("equip_stat", var_15_0 .. "_1", {
				"stat_type",
				"val_max"
			})
			local var_15_3 = {
				var_14_1,
				to_n(var_14_0)
			}
			local var_15_4 = {
				var_15_1,
				var_15_2
			}
			local var_15_5 = EQUIP:createByInfo({
				grade = 5,
				code = var_14_2,
				opts = var_15_3,
				stats = var_15_4,
				op = {
					var_15_4,
					var_15_3
				}
			})
			
			return (ItemTooltip:getItemTooltip({
				equip = var_15_5
			}))
		end
	})
	
	return var_14_4
end

local function var_0_1(arg_16_0)
	if not arg_16_0 then
		return 
	end
	
	local var_16_0 = EQUIP:createByInfo({
		code = arg_16_0
	})
	local var_16_1 = EQUIP:createByInfo({
		dup_pt = 5,
		code = arg_16_0,
		exp = EQUIP.getMaxExp(var_16_0, 5)
	})
	local var_16_2 = UIUtil:getRewardIcon("equip", arg_16_0, {
		scale = 1,
		equip = var_16_1
	})
	
	if_set_visible(var_16_2, "n_up", false)
	
	return var_16_2
end

function ArenaNetCard.updateEquip(arg_17_0)
	local var_17_0 = arg_17_0.template_info.template_status.arti_id
	local var_17_1 = arg_17_0.template_info.template_status.exc_id
	local var_17_2 = arg_17_0.template_info.template_status.set_op_id
	local var_17_3 = arg_17_0.template_info.template_status.memory
	
	SpriteCache:resetSprite(arg_17_0.info_node:getChildByName("n_role"), "img/cm_icon_role_" .. arg_17_0.unit.db.role .. ".png")
	SpriteCache:resetSprite(arg_17_0.info_node:getChildByName("n_color"), UIUtil:getColorIcon(arg_17_0.unit))
	
	for iter_17_0, iter_17_1 in pairs(var_17_2 or {}) do
		SpriteCache:resetSprite(arg_17_0.info_node:getChildByName("n_set_" .. iter_17_0), EQUIP:getSetItemIconPath(iter_17_1))
	end
	
	if var_17_1 then
		local var_17_4 = var_0_0(arg_17_0.unit, var_17_1)
		
		if get_cocos_refid(var_17_4) and get_cocos_refid(arg_17_0.private_node) then
			arg_17_0.private_node:addChild(var_17_4)
		end
	end
	
	if_set_visible(arg_17_0.info_node, "n_private", var_17_1 ~= nil)
	
	if var_17_0 then
		local var_17_5 = var_0_1(var_17_0)
		
		if get_cocos_refid(var_17_5) and get_cocos_refid(arg_17_0.arti_node) then
			arg_17_0.arti_node:addChild(var_17_5)
		end
	end
	
	UIUtil:setDevoteDetail_new(arg_17_0.info_node, arg_17_0.unit, {
		target = "n_dedi"
	})
end

function ArenaNetCard.updatePortrait(arg_18_0)
	local var_18_0 = DB("character", arg_18_0.unit:getDisplayCode(), "face_id")
	
	if var_18_0 then
		local var_18_1, var_18_2 = UIUtil:getPortraitAni(var_18_0)
		
		if var_18_1 then
			UIUtil:setPortraitPositionByFaceBone(var_18_1)
			arg_18_0.portrait_node:removeAllChildren()
			arg_18_0.portrait_node:addChild(var_18_1)
			
			if not var_18_2 then
				arg_18_0.portrait_node:setScale(0.8)
				arg_18_0.portrait_node:setPositionY(550)
			end
		end
		
		arg_18_0.portrait = var_18_1
	end
end

function ArenaNetCard.updateDesc(arg_19_0)
	local var_19_0 = arg_19_0.template_info.template_status.hero_tag
	local var_19_1 = arg_19_0.template_info.template_status.hero_desc
	
	if_set(arg_19_0.talent_node, "n_title", T(var_19_0 or "AAA"))
	if_set(arg_19_0.talent_node, "txt_disc", T(var_19_1 or "BBB"))
end

function ArenaNetCard.test(arg_20_0)
	local var_20_0 = ArenaNetCard:create({
		draft_card_id = 1
	})
	
	var_20_0:setVisible(true)
	SceneManager:getRunningPopupScene():addChild(var_20_0)
end

function ArenaNetCardMini.create(arg_21_0, arg_21_1)
	local var_21_0 = load_control("wnd/pvplive_draft_card_s.csb")
	
	copy_functions(ArenaNetCard, var_21_0)
	copy_functions(ArenaNetCardMini, var_21_0)
	var_21_0:init(arg_21_1)
	
	return var_21_0
end

function ArenaNetCardMini.init(arg_22_0, arg_22_1)
	arg_22_1 = arg_22_1 or {}
	arg_22_0.user = arg_22_1.user
	arg_22_0.slot_id = arg_22_1.slot_id
	arg_22_0.draft_card_id = arg_22_1.draft_card_id
	
	arg_22_0:make_template_unit()
	arg_22_0:cache()
	arg_22_0:updateUI()
end

function ArenaNetCardMini.cache(arg_23_0)
	arg_23_0.info_node = arg_23_0:getChildByName("n_info")
	arg_23_0.face_node = arg_23_0:getChildByName("n_su")
	arg_23_0.arti_node = arg_23_0:getChildByName("n_item_art")
	arg_23_0.private_node = arg_23_0:getChildByName("n_skill")
	arg_23_0.img_pick = arg_23_0:getChildByName("img_pick")
end

function ArenaNetCardMini.updateUI(arg_24_0)
	if_set(arg_24_0.info_node, "txt_name", arg_24_0.unit:getName())
	arg_24_0:updateEquip()
	
	local var_24_0 = "face/" .. arg_24_0.unit.inst.code .. "_su.png"
	
	SpriteCache:resetSprite(arg_24_0.face_node, var_24_0)
end

function ArenaNetCardMini.updateEquip(arg_25_0)
	local var_25_0 = arg_25_0.template_info.template_status.arti_id
	local var_25_1 = arg_25_0.template_info.template_status.exc_id
	local var_25_2 = arg_25_0.template_info.template_status.set_op_id
	
	if var_25_1 then
		local var_25_3 = var_0_0(arg_25_0.unit, var_25_1)
		
		if get_cocos_refid(var_25_3) and get_cocos_refid(arg_25_0.private_node) then
			arg_25_0.private_node:addChild(var_25_3)
		end
	end
	
	if_set_visible(arg_25_0.info_node, "n_private", var_25_1 ~= nil)
	
	if var_25_0 then
		local var_25_4 = var_0_1(var_25_0)
		
		if get_cocos_refid(var_25_4) and get_cocos_refid(arg_25_0.arti_node) then
			arg_25_0.arti_node:addChild(var_25_4)
		end
	end
end

function ArenaNetCardMini.onDiscard(arg_26_0)
	local var_26_0 = "face/" .. arg_26_0.unit.inst.code .. "_su.png?grayscale=1"
	
	SpriteCache:resetSprite(arg_26_0.face_node, var_26_0)
	
	local var_26_1 = cc.RenderTexture:create(arg_26_0:getContentSize().width, arg_26_0:getContentSize().height, cc.TEXTURE2_D_PIXEL_FORMAT_RGB_A8888)
	
	var_26_1:clear(0, 0, 0, 0)
	var_26_1:retain()
	var_26_1:begin()
	arg_26_0.info_node:visit()
	var_26_1:endToLua()
	var_26_1:setAnchorPoint(0, 0)
	var_26_1:getSprite():setAnchorPoint(0, 0)
	arg_26_0.info_node:setVisible(false)
	arg_26_0:addChild(var_26_1)
	
	local var_26_2 = cc.GLProgramCache:getInstance():getGLProgram("sprite_grayscale")
	
	if var_26_2 then
		local var_26_3 = cc.GLProgramState:create(var_26_2)
		
		if var_26_3 then
			var_26_3:setUniformFloat("u_ratio", 1)
			var_26_1:getSprite():setDefaultGLProgramState(var_26_3)
			var_26_1:getSprite():setGLProgramState(var_26_3)
		end
	end
	
	var_26_1:setCascadeColorEnabled(true)
	var_26_1:setCascadeOpacityEnabled(true)
end

function ArenaNetCardMini.onSelect(arg_27_0, arg_27_1)
	local var_27_0 = "n_selecting_" .. tostring(arg_27_0.user) .. "_" .. tostring(arg_27_0.slot_id)
	
	if arg_27_1 then
		arg_27_0.img_pick:setVisible(false)
		
		if not UIAction:Find(var_27_0) then
			UIAction:Add(SEQ(LOOP(SEQ(FADE_IN(500), DELAY(200), FADE_OUT(500), DELAY(150)))), arg_27_0.img_pick, var_27_0)
		end
	else
		arg_27_0.img_pick:setVisible(false)
		UIAction:Remove(var_27_0)
	end
end
