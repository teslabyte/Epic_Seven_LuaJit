MoonlightDestinyHero = MoonlightDestinyHero or {}
MoonlightDestinyHero.vars = {}

function HANDLER.destiny_moonlight_hero(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_show_stat" then
		SceneManager:cancelReseveResetSceneFlow()
		startSkillPreview(MoonlightDestinyHero:getSelectCode())
		
		return 
	end
	
	if arg_1_1 == "btn_rate" then
		if NetWaiting:isWaiting() == false then
			ReviewPreviewPopup:open(MoonlightDestinyHero:getSelectCode())
		end
		
		return 
	end
	
	if arg_1_1 == "btn_select" then
		MoonlightDestinyMsgBox:open(MoonlightDestinyHero:getSelectCode())
		
		return 
	end
end

function MoonlightDestinyHero.onLoad(arg_2_0)
end

function MoonlightDestinyHero.onUnload(arg_3_0)
end

function MoonlightDestinyHero.onPushBackButton(arg_4_0)
	arg_4_0:close()
	SceneManager:popScene()
	BackButtonManager:pop("TopBarNew." .. T("character_mc_title"))
end

function MoonlightDestinyHero.getSceneState(arg_5_0)
	if not arg_5_0.vars then
		return {}
	end
	
	return {
		code = arg_5_0:getSelectCode()
	}
end

function MoonlightDestinyHero.open(arg_6_0, arg_6_1)
	arg_6_0.vars = {}
	arg_6_0.vars.opts = arg_6_1 or {}
	arg_6_0.vars.wnd = load_dlg("destiny_moonlight_hero", true, "wnd")
	
	if_set_sprite(arg_6_0.vars.wnd, "n_bg", MoonlightDestiny:getBackgroundImagePath())
	arg_6_0:_customSetupForPub()
	SceneManager:getDefaultLayer():addChild(arg_6_0.vars.wnd)
	TopBarNew:create(T("character_mc_title"), arg_6_0.vars.wnd, function()
		arg_6_0:onPushBackButton()
	end)
	arg_6_0:loadCharacterListView()
	arg_6_0:selectItem(arg_6_0.vars.opts.code or arg_6_0:getSelectCode())
	TutorialGuide:ifStartGuide(IS_PUBLISHER_ZLONG and "tuto_destiny_moonlight_zl" or "tuto_destiny_moonlight")
	
	return arg_6_0.vars.wnd
end

function MoonlightDestinyHero._customSetupForPub(arg_8_0)
	if not get_cocos_refid(arg_8_0.vars.wnd) then
		return 
	end
	
	if IS_PUBLISHER_ZLONG then
		if_set_visible(arg_8_0.vars.wnd, "pos_bbs", false)
	end
end

function MoonlightDestinyHero.close(arg_9_0)
	if not get_cocos_refid(arg_9_0.vars.wnd) then
		return 
	end
	
	UIAction:Add(SEQ(LOG(FADE_OUT(200)), REMOVE()), arg_9_0.vars.wnd, "block")
	
	arg_9_0.vars = {}
	
	HeroRecommend:close()
end

function MoonlightDestinyHero.loadCharacterListView(arg_10_0)
	local var_10_0 = arg_10_0.vars.wnd:getChildByName("character_scroll_view")
	
	if not get_cocos_refid(var_10_0) then
		return 
	end
	
	local var_10_1 = load_control("wnd/destiny_moonlight_item.csb")
	
	if var_10_0.STRETCH_INFO then
		resetControlPosAndSize(var_10_1, var_10_0:getContentSize().width, var_10_0.STRETCH_INFO.width_prev)
	end
	
	local var_10_2 = {
		onUpdate = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
			arg_10_0:updateItem(arg_11_1, arg_11_3)
			
			return arg_11_3.id
		end,
		onTouchUp = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
			if arg_12_4.cancelled then
				return false
			end
			
			arg_10_0:selectItem(arg_12_3.id)
			
			return true
		end
	}
	
	arg_10_0.vars.character_list_view = ItemListView_v2:bindControl(var_10_0)
	
	arg_10_0.vars.character_list_view:setVisible(true)
	arg_10_0.vars.character_list_view:setRenderer(var_10_1, var_10_2)
	arg_10_0.vars.character_list_view:removeAllChildren()
	
	local var_10_3 = MoonlightDestiny:getCharactersList()
	
	arg_10_0.vars.character_list_view:setDataSource(var_10_3)
end

local function var_0_0(arg_13_0, arg_13_1)
	local var_13_0 = DBT("character", arg_13_1.id, {
		"face_id",
		"name",
		"ch_attribute",
		"role",
		"grade"
	})
	local var_13_1 = arg_13_0:getChildByName("name")
	
	if get_cocos_refid(var_13_1) then
		UIUserData:call(var_13_1, "SINGLE_WSCALE(174)", {
			origin_scale_x = 0.86
		})
		if_set(var_13_1, nil, T(var_13_0.name))
	end
	
	if_set_sprite(arg_13_0, "face", "face/" .. var_13_0.face_id .. "_l.png")
	if_set_sprite(arg_13_0, "element", "img/cm_icon_prom" .. var_13_0.ch_attribute .. ".png")
	if_set_sprite(arg_13_0, "role", "img/cm_icon_role_" .. var_13_0.role .. ".png")
	
	for iter_13_0 = 1, 6 do
		if_set_visible(arg_13_0, "star" .. iter_13_0, iter_13_0 <= var_13_0.grade)
	end
	
	if_set_visible(arg_13_0, "select", false)
	if_set_visible(arg_13_0, "badge_recom", arg_13_1.recommend == "y")
end

function MoonlightDestinyHero.updateItem(arg_14_0, arg_14_1, arg_14_2)
	arg_14_1.is_init = arg_14_1.is_init or false
	
	if not arg_14_1.is_init then
		arg_14_1.is_init = true
		
		var_0_0(arg_14_1, arg_14_2)
	end
	
	local var_14_0 = arg_14_2.id == arg_14_0:getSelectCode()
	
	if_set_visible(arg_14_1, "select", var_14_0)
end

function MoonlightDestinyHero.getDefaultCharacterCode(arg_15_0)
	local var_15_0 = MoonlightDestiny:getCharactersList()
	
	if table.empty(var_15_0) then
		return 
	end
	
	return var_15_0[1].id
end

function MoonlightDestinyHero.getSelectCode(arg_16_0)
	return arg_16_0.vars.select_code or arg_16_0:getDefaultCharacterCode()
end

function MoonlightDestinyHero.selectItem(arg_17_0, arg_17_1)
	if not arg_17_1 then
		return 
	end
	
	SoundEngine:play("event:/ui/ok")
	
	if arg_17_0.vars.select_code == arg_17_1 then
		return 
	end
	
	arg_17_0.vars.select_code = arg_17_1
	
	arg_17_0:setUnit(arg_17_1)
	arg_17_0.vars.character_list_view:refresh()
end

function MoonlightDestinyHero.changePortrait(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0.vars.wnd:getChildByName("n_portrait")
	
	if not get_cocos_refid(var_18_0) then
		return 
	end
	
	local var_18_1 = 1
	
	if get_cocos_refid(arg_18_0.vars.portrait) and arg_18_0:getSelectCode() then
		UIAction:Add(SEQ(SPAWN(RLOG(SCALE(250, var_18_1, 0), 300), RLOG(MOVE_BY(250, 600), 300), FADE_OUT(250)), REMOVE()), arg_18_0.vars.portrait)
		
		arg_18_0.vars.portrait = nil
	end
	
	local var_18_2 = DB("character", arg_18_1, "face_id") or "no_image"
	local var_18_3 = UIUtil:getPortraitAni(var_18_2, {
		parent_pos_y = var_18_0:getPositionY() + 200
	})
	
	var_18_3.code = arg_18_1
	
	var_18_3:setAnchorPoint(0.5, 0)
	var_18_3:setLocalZOrder(1)
	var_18_3:setOpacity(0)
	UIAction:Add(SEQ(SPAWN(LOG(SCALE(250, 0, var_18_1), 300), LOG(SLIDE_IN(250, 1600, false), 300), FADE_IN(250))), var_18_3)
	var_18_0:addChild(var_18_3)
	
	arg_18_0.vars.portrait = var_18_3
	
	return arg_18_0.vars.portrait
end

local function var_0_1(arg_19_0, arg_19_1)
	if not get_cocos_refid(arg_19_1) then
		return 
	end
	
	local var_19_0 = arg_19_1:getContentSize().width * arg_19_1:getScaleX() + arg_19_1:getPositionX() + 10
	
	if_call(arg_19_0, "star1", "setPositionX", var_19_0)
end

local function var_0_2(arg_20_0, arg_20_1)
	local var_20_0 = arg_20_0:getChildByName("LEFT")
	
	if not get_cocos_refid(var_20_0) then
		return 
	end
	
	if_set_visible(var_20_0, "detail", false)
	
	local var_20_1 = var_20_0:getChildByName("txt_story")
	
	if_set(var_20_1, nil, T(DB("character", arg_20_1, "2line")))
end

function MoonlightDestinyHero.setUnit(arg_21_0, arg_21_1)
	local var_21_0, var_21_1, var_21_2 = DB("character", arg_21_1, {
		"grade",
		"face_id",
		"type"
	})
	local var_21_3 = UNIT:create({
		z = 6,
		awake = 6,
		exp = 0,
		lv = 1,
		code = arg_21_1,
		g = var_21_0
	})
	
	UIUtil:setUnitAllInfo(arg_21_0.vars.wnd, var_21_3, {
		ignore_stat_diff = true,
		use_basic_star = true
	})
	var_0_1(arg_21_0.vars.wnd, arg_21_0.vars.wnd:getChildByName("txt_name"))
	var_0_2(arg_21_0.vars.wnd, arg_21_1)
	UIUtil:setUnitSkillInfo(arg_21_0.vars.wnd, var_21_3, {
		tooltip_opts = {
			show_effs = "right"
		}
	})
	arg_21_0:changePortrait(arg_21_1)
	HeroRecommend:setRecommendTag(arg_21_1, arg_21_0.vars.wnd:getChildByName("n_hero_tag"), "_moonlight")
end
