function HANDLER.clan_heritage_hero(arg_1_0, arg_1_1)
	if arg_1_1 == "btn_registration_hero" then
		if LotaRegistrationUI:isRegiExist() then
			return 
		end
		
		if LotaRegistrationUI:isAvailableEnter() then
			HeroBelt:destroy()
			LotaHeroInformationUI:setSkillVisible(false)
			LotaHeroInformationUI:resetPortrait()
			LotaRegistrationUI:open(LotaSystem:getUIPopupLayer(), {
				register_list = LotaUserData:getRegistrationList(),
				close_callback = function()
					if #LotaUserData:getRegistrationList() > 0 then
						HeroBelt:destroy()
						LotaHeroInformationUI:setSkillVisible(true)
						LotaHeroInformationUI:setupUI()
					else
						LotaHeroInformationUI:onPushBackButton()
					end
				end
			})
		else
			LotaRegistrationUI:sendWarningMessage()
		end
	elseif arg_1_1 == "btn_stats_info" then
		if LotaRegistrationUI:isLayerExist() then
			return 
		end
		
		LotaRegistrationUI:openInfoPopup()
	end
end

LotaHeroInformationUI = {}

function LotaHeroInformationUI.open(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = LotaUtil:getLotaUnits()
	
	arg_3_2 = arg_3_2 or {}
	
	if table.empty(var_3_0) then
		balloon_message_with_sound("msg_clan_heritage_no_regist")
		
		return false
	end
	
	arg_3_0.vars = {}
	arg_3_0.vars.dlg = LotaUtil:getUIDlg("clan_heritage_hero")
	
	arg_3_0.vars.dlg:setLocalZOrder(1000000)
	
	arg_3_0.vars.close_callback = arg_3_2.close_callback
	
	local var_3_1 = ccui.Button:create()
	
	var_3_1:setName("_btn_blocker")
	var_3_1:setAnchorPoint(0.5, 0.5)
	var_3_1:ignoreContentAdaptWithSize(false)
	var_3_1:setContentSize(VIEW_WIDTH * 2, VIEW_HEIGHT * 2)
	var_3_1:setLocalZOrder(-99999)
	arg_3_0.vars.dlg:addChild(var_3_1)
	TopBarNew:createFromPopup(T("ui_clanheritage_hero_title"), arg_3_0.vars.dlg, function()
		arg_3_0:onPushBackButton()
	end)
	TopBarNew:setCurrencies({
		"clanheritage",
		"clanheritagecoin"
	})
	TopBarNew:checkhelpbuttonID("heritagehero")
	TopBarNew:setDisableTopRight()
	arg_3_1:addChild(arg_3_0.vars.dlg)
	Scheduler:add(arg_3_0.vars.dlg, arg_3_0.onSchedulerUpdate, arg_3_0)
	arg_3_0:setupUI(arg_3_2)
	
	return true
end

function LotaHeroInformationUI.isShow(arg_5_0)
	if arg_5_0.vars and get_cocos_refid(arg_5_0.vars.dlg) then
		return true
	else
		return false
	end
end

function LotaHeroInformationUI.onPushBackButton(arg_6_0)
	if not arg_6_0.vars then
		return 
	end
	
	arg_6_0.vars.dlg:removeFromParent()
	
	if arg_6_0.vars.close_callback then
		arg_6_0.vars.close_callback()
	end
	
	arg_6_0.vars = nil
	
	TopBarNew:pop()
	BackButtonManager:pop("영웅 상태창!")
end

function LotaHeroInformationUI.onSchedulerUpdate(arg_7_0)
	if not arg_7_0.vars then
		return 
	end
	
	if arg_7_0.vars.changed_unit and uitick() - arg_7_0.vars.changed_tm > 500 then
		arg_7_0:onSelectUnit(arg_7_0.vars.changed_unit)
		
		arg_7_0.vars.changed_unit = nil
		arg_7_0.vars.changed_tm = nil
	end
	
	if not LotaUserData:isUsableUnit(arg_7_0.vars.unit) then
		local var_7_0 = arg_7_0.vars.dlg:findChildByName("n_time_info")
		local var_7_1 = os.time()
		local var_7_2, var_7_3, var_7_4 = Account:serverTimeDayLocalDetail()
		local var_7_5 = var_7_4 - var_7_1
		local var_7_6 = math.floor(var_7_5 / 60 / 60)
		local var_7_7 = math.floor(var_7_5 / 60 % 60)
		
		if_set(var_7_0, "t_time", T("ui_clanheritage_hero_penalty_time", {
			hour = var_7_6,
			min = var_7_7
		}))
	end
end

function LotaHeroInformationUI.setupUI(arg_8_0, arg_8_1)
	arg_8_1 = arg_8_1 or {}
	
	arg_8_0:setupHeroBelt()
	LotaUtil:setJobLevelUI(arg_8_0.vars.dlg)
	
	local var_8_0 = HeroBelt:getItems()
	local var_8_1 = var_8_0[1]
	
	if arg_8_1.code then
		local var_8_2 = arg_8_1.code
		
		for iter_8_0, iter_8_1 in pairs(var_8_0) do
			if iter_8_1.inst.code == var_8_2 then
				var_8_1 = iter_8_1
				
				break
			end
		end
		
		arg_8_0.vars.unit_dock:scrollToUnit(var_8_1, 0)
	end
	
	if var_8_1 then
		arg_8_0:onSelectUnit(var_8_1)
	end
	
	arg_8_0:updateUI(arg_8_0)
end

function LotaHeroInformationUI.setSkillVisible(arg_9_0, arg_9_1)
	if not arg_9_0.vars then
		return 
	end
	
	if_set_visible(arg_9_0.vars.dlg, "n_skills", arg_9_1)
end

function LotaHeroInformationUI.onHeroListEvent(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_1 == "select" then
		arg_10_0:onSelectUnit(arg_10_2, arg_10_3)
	end
	
	if arg_10_1 == "change" then
		arg_10_0:onChangeUnit(arg_10_3)
	end
end

function LotaHeroInformationUI.onChangeUnit(arg_11_0, arg_11_1)
	if arg_11_0.vars then
		arg_11_0.vars.changed_unit = arg_11_1
		arg_11_0.vars.changed_tm = uitick()
	end
end

function LotaHeroInformationUI.onSelectUnit(arg_12_0, arg_12_1)
	if not arg_12_0.vars then
		return 
	end
	
	if arg_12_0.vars.unit == arg_12_1 then
		return 
	end
	
	arg_12_0.vars.unit = arg_12_1
	
	arg_12_0:setupPortrait(arg_12_1)
	arg_12_0:setupUnitInformation(arg_12_1)
end

function LotaHeroInformationUI.getPortraitPosition(arg_13_0, arg_13_1)
	local var_13_0
	
	return (arg_13_0.vars.dlg:getChildByName("port_pos"):getPositionX())
end

function LotaHeroInformationUI.setPortraitEmotion(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	arg_14_3 = arg_14_3 or arg_14_1:getFaceID()
	
	if arg_14_3 and arg_14_2 and arg_14_2.setSkin then
		arg_14_2:setSkin(arg_14_3)
	end
end

function LotaHeroInformationUI.setupUnitInformation(arg_15_0)
	local var_15_0 = arg_15_0.vars.unit:clone()
	
	var_15_0:addContentEnhance()
	
	var_15_0.ui_vars.lota_mode = true
	
	var_15_0:calc()
	
	local var_15_1 = arg_15_0.vars.dlg:getChildByName("txt_name")
	
	var_15_1:setString(T(var_15_0.db.name))
	UIUserData:proc(var_15_1)
	if_call(arg_15_0.vars.dlg, "star1", "setPositionX", 10 + var_15_1:getContentSize().width * var_15_1:getScaleX() + var_15_1:getPositionX())
	UIUtil:setUnitSkillInfo(arg_15_0.vars.dlg, var_15_0, {
		delay = 0,
		style = "scale",
		tooltip_opts = {
			show_effs = "right"
		}
	})
	UIUtil:setUnitAllInfo(arg_15_0.vars.dlg, var_15_0)
	UIUtil:setLevelDetail(arg_15_0.vars.dlg, var_15_0:getLv(), var_15_0:getMaxLevel())
	
	local var_15_2 = arg_15_0.vars.dlg:getChildByName("txt_story")
	
	if var_15_2 then
		UIAction:Remove(var_15_2)
		var_15_2:setString("")
		UIAction:Add(SEQ(SOUND_TEXT(T(DB("character", var_15_0.db.code, "2line"), "text"), true, 20, nil, 60)), var_15_2)
	end
	
	local var_15_3 = LotaUserData:isUsableUnit(arg_15_0.vars.unit)
	
	if_set_visible(arg_15_0.vars.dlg, "n_time_info", not var_15_3)
	
	local var_15_4 = arg_15_0.vars.dlg:findChildByName("n_art")
	
	if_set_visible(var_15_4, nil, true)
	
	local var_15_5 = var_15_4:findChildByName("n_item_art")
	local var_15_6 = var_15_0:getEquipByPos("artifact")
	
	if_set_visible(var_15_5, nil, var_15_6 ~= nil)
	
	if var_15_6 then
		local var_15_7 = UIUtil:getRewardIcon("equip", var_15_6.code, {
			scale = 1,
			tooltip_delay = 120,
			parent = var_15_5,
			equip = var_15_6
		})
	end
	
	local var_15_8 = 1
	local var_15_9 = arg_15_0.vars.dlg
	
	if_set_visible(var_15_9, "n_set", true)
	var_15_0:eachSetItemApply(function(arg_16_0)
		SpriteCache:resetSprite(var_15_9:getChildByName("icon_set" .. var_15_8), EQUIP:getSetItemIconPath(arg_16_0))
		if_set(var_15_9, "txt_set" .. var_15_8, T(DB("item_set", arg_16_0, "name")))
		if_set_opacity(var_15_9, "txt_set" .. var_15_8, 255)
		if_set_opacity(var_15_9, "icon_set" .. var_15_8, 255)
		
		var_15_8 = var_15_8 + 1
	end)
	
	for iter_15_0 = var_15_8, 3 do
		SpriteCache:resetSprite(var_15_9:getChildByName("icon_set" .. iter_15_0), "img/cm_icon_etcbp.png")
		if_set(var_15_9, "txt_set" .. iter_15_0, T("no_set"))
		if_set_opacity(var_15_9, "txt_set" .. iter_15_0, 100)
		if_set_opacity(var_15_9, "icon_set" .. iter_15_0, 100)
	end
end

function LotaHeroInformationUI.setupPortrait(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0.vars.portrait
	
	if var_17_0 then
		if arg_17_1 == var_17_0.unit then
			return 
		end
		
		if var_17_0.is_model then
			UIAction:Add(SEQ(SPAWN(RLOG(SCALE(250, 0.8, 0), 300), RLOG(MOVE_BY(250, 600), 300), FADE_OUT(250)), REMOVE()), var_17_0)
		else
			UIAction:Add(SEQ(SPAWN(RLOG(SCALE(250, 0.8, 0), 300), RLOG(MOVE_BY(250, 600), 300), FADE_OUT(250)), REMOVE_SPRITE()), var_17_0)
		end
	end
	
	local var_17_1 = UIUtil:getPortraitAni(arg_17_1.db.face_id, {
		parent_pos_y = arg_17_0.vars.dlg:getChildByName("port_pos"):getPositionY()
	})
	
	arg_17_0:setPortraitEmotion(arg_17_1, var_17_1)
	var_17_1:setAnchorPoint(0.5, 0)
	var_17_1:setLocalZOrder(1)
	var_17_1:setPositionX(arg_17_0:getPortraitPosition())
	var_17_1:setOpacity(0)
	UIAction:Add(SEQ(SPAWN(LOG(SCALE(250, 0, 0.8), 300), LOG(SLIDE_IN(250, 1600, false), 300), FADE_IN(250))), var_17_1)
	arg_17_0.vars.dlg:getChildByName("port_pos"):addChild(var_17_1)
	
	arg_17_0.vars.portrait = var_17_1
	arg_17_0.vars.portrait.unit = arg_17_1
end

function LotaHeroInformationUI.resetPortrait(arg_18_0)
	if not arg_18_0.vars or not arg_18_0.vars.portrait then
		return 
	end
	
	arg_18_0.vars.portrait:removeFromParent()
	
	arg_18_0.vars.portrait = nil
	arg_18_0.vars.unit = nil
end

function LotaHeroInformationUI.setupHeroBelt(arg_19_0)
	arg_19_0.vars.unit_dock = HeroBelt:create()
	
	local var_19_0 = arg_19_0.vars.unit_dock:getWindow()
	
	arg_19_0.vars.dlg:getChildByName("n_herolist"):addChild(var_19_0)
	
	local var_19_1 = arg_19_0.vars.dlg:findChildByName("n_sorting_f")
	
	HeroBelt:changeSorterParent(var_19_1, true)
	arg_19_0.vars.unit_dock:setEventHandler(arg_19_0.onHeroListEvent, arg_19_0)
	
	local var_19_2 = LotaUtil:getLotaUnits()
	
	HeroBelt:resetData(var_19_2, "LotaInformation", nil, true)
	HeroBelt:showSortButton(true)
	HeroBelt:showAddInvenButton(false)
	if_set(arg_19_0.vars.dlg, "t_hero_count", T("ui_clanheritage_hero_regi", {
		number = #var_19_2
	}))
	var_19_0:setPosition(640, 333)
	resetPosForNotch(var_19_0:getChildByName("RIGHT"), nil, {
		origin_x = DESIGN_WIDTH
	})
end

function LotaHeroInformationUI.updateUI(arg_20_0)
	local var_20_0 = LotaUtil:getMyUserInfo()
	local var_20_1 = arg_20_0.vars.dlg:findChildByName("n_registration_count")
	local var_20_2 = table.count(var_20_0.hero_register_list)
	local var_20_3 = LotaUtil:getMaxHeroCount(var_20_0.exp)
	local var_20_4 = arg_20_0.vars.dlg:findChildByName("btn_registration_hero"):findChildByName("noti_count")
	
	if_set(var_20_4, "count_hero", var_20_3 - var_20_2)
	if_set_visible(var_20_4, nil, var_20_2 < var_20_3)
end
